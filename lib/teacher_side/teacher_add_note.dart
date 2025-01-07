import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sqflite/sqflite.dart';
import '../SQFLite/database_helper.dart';
import 'dart:async';

import 'approved_notes.dart';
import 'teacher_home.dart';

class TeacherAddNoteView extends StatefulWidget {
  const TeacherAddNoteView({super.key});

  @override
  _TeacherAddNoteViewState createState() => _TeacherAddNoteViewState();
}

class _TeacherAddNoteViewState extends State<TeacherAddNoteView> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _definitionLaboController =
      TextEditingController();
  final TextEditingController _definitionFilipinoController =
      TextEditingController();
  final TextEditingController _definitionEnglishController =
      TextEditingController();

  String? _filePath;
  String? _selectedCategory;

  final List<String> _categories = [
    'Balbal',
    'Kolokyal',
    'Lalawiganin',
    'Pambansa',
    'Pampanitikan',
  ];

  @override
  void initState() {
    super.initState();
  }

  // Select an MP3 file
  Future<void> _selectAndUploadAudioFile() async {
    try {
      // Step 1: Allow user to pick a file (.mp3 or .m4a)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a'],
      );

      if (result != null) {
        // Step 2: If file is selected, get its path
        String filePath = result.files.single.path!; // Get the local file path

        // Step 3: Store the file path for upload
        setState(() {
          _filePath = filePath;
        });

        // Debugging the file path
        print("Selected file path: $filePath");

        // Step 4: Check file extension and upload it
        String fileExtension = filePath.split('.').last;

        if (fileExtension == 'mp3' || fileExtension == 'm4a') {
          // Step 5: Upload file to Firebase Storage
          FirebaseStorage storage = FirebaseStorage.instance;
          String fileName =
              "${DateTime.now().millisecondsSinceEpoch}.$fileExtension"; // Create unique file name
          Reference ref = storage.ref().child('audio_files/$fileName');

          // Upload the file to Firebase Storage
          await ref.putFile(File(filePath));

          // Step 6: Get the download URL after successful upload
          String downloadUrl = await ref.getDownloadURL();
          print('File uploaded! Download URL: $downloadUrl');

          // Here you could save the download URL to Firestore or use it as needed.
        } else {
          print('Unsupported file type. Please select an MP3 or M4A file.');
        }
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error selecting or uploading file: $e');
    }
  }

  // Save note to Firestore and SQLite
  Future<void> _saveNote() async {
    final studentName = await DatabaseHelper().fetchStudentName();
    String normalizedWord = _wordController.text.toLowerCase();
    try {
      String downloadUrl = '';
      if (_filePath != null && _filePath!.isNotEmpty) {
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileExtension = _filePath!.split('.').last;
        String fileName =
            "${DateTime.now().millisecondsSinceEpoch}.$fileExtension"; // Create unique file name
        Reference ref = storage.ref().child('audio_files/$fileName');

        // Upload the file to Firebase Storage
        await ref.putFile(File(_filePath!));

        // Step 2: After upload is successful, get the download URL
        downloadUrl = await ref.getDownloadURL();
        print('Audio file uploaded! Download URL: $downloadUrl');
      } else {
        print('No audio file selected. Proceeding without an audio file.');
      }

      final note = {
        'studentName': 'Teacher',
        'word': normalizedWord,
        'definitionLabo': _definitionLaboController.text,
        'definitionFilipino': _definitionFilipinoController.text,
        'definitionEnglish': _definitionEnglishController.text,
        'audioFilePath':
            downloadUrl, // Store the download URL or empty string in Firestore
        'category': _selectedCategory,
        'status': 'pending', // Default status is pending
      };

      // Save the note in Firestore for teacher approval
      await FirebaseFirestore.instance.collection('teacher_approval').add(note);
      print('Note saved in Firestore for approval');

      // Clear text fields and reset the state
      _wordController.clear();
      _definitionLaboController.clear();
      _definitionFilipinoController.clear();
      _definitionEnglishController.clear();

      setState(() {
        _filePath = null; // Reset the audio file path after saving
        _selectedCategory = null;
      });

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The word has been saved for approval.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Optionally, print table contents for debugging purposes
      await _printTableContents();

      // Optionally, navigate back
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error uploading file or saving note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload or save note.')),
      );
    }
  }

  Future<void> _addCategoryColumn(Database db) async {
    // Check if the 'category' column exists in the 'Notes' table
    var result = await db.rawQuery('PRAGMA table_info(Notes)');
    bool columnExists = false;

    for (var column in result) {
      if (column['name'] == 'category') {
        columnExists = true;
        break;
      }
    }

    // If 'category' column doesn't exist, add it
    if (!columnExists) {
      await db.execute('ALTER TABLE Notes ADD COLUMN category TEXT');
    }
  }

  // Get existing table names from SQLite
  Future<List<String>> getUserDetailsColumns() async {
    final db = await DatabaseHelper().database;

    // Use PRAGMA to get the column info of user_details
    final List<Map<String, dynamic>> result =
        await db.rawQuery("PRAGMA table_info(notes)");

    // Extract column names from the result
    List<String> columns = [];
    for (var row in result) {
      columns.add(row['name'] as String);
    }

    // Print the list of columns
    print('Columns in notes: $columns');
    return columns;
  }

  // Print all notes in the SQLite database
  Future<void> _printTableContents() async {
    final notes = await DatabaseHelper().fetchWords();
    for (var note in notes) {
      print('ID: ${note['id']}');
      print('Word: ${note['word']}');
      print('Definition (Labo): ${note['definitionLabo']}');
      print('Definition (Filipino): ${note['definitionFilipino']}');
      print('Definition (English): ${note['definitionEnglish']}');
      print('Audio File Path: ${note['audioFilePath']}');
      print('Student Name: ${note['studentName']}');
      print('Category: ${note['category']}');
      print('---');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/POST.png', // Path to your GIF asset
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/LOGO.png',
                          height: 75, fit: BoxFit.contain),
                      const SizedBox(width: 50),
                      Image.asset('assets/images/TITLE.png',
                          height: 50, fit: BoxFit.contain),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                              _wordController, 'Salita', Icons.wb_sunny),
                          _buildTextField(_definitionLaboController,
                              'Depinisyon sa salitang Labo', Icons.book),
                          _buildTextField(_definitionFilipinoController,
                              'Depinisyon sa wikang Filipino', Icons.bookmark),
                          _buildTextField(_definitionEnglishController,
                              'Depinisyon sa wikang Ingles', Icons.language),
                          _buildDropdown(),
                          _buildFilePicker(),
                          _buildAddNoteButton(),
                          // _buildCheckTablesButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12))),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black54,
                  onTap: (index) {
                    switch (index) {
                      case 1:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TeacherHomeView(
                                      category: '',
                                    )));
                        break;
                      case 2:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ApprovedWordsView()));
                        break;
                    }
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_box_outlined), label: 'Add Note'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_max_outlined), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.account_box_outlined),
                        label: 'Account'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData prefixIcon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon, size: 20, color: Colors.blue),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        onChanged: (newValue) {
          setState(() {
            _selectedCategory = newValue;
          });
        },
        decoration: const InputDecoration(
          labelText: 'Piliin ang Kategorya',
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.category, size: 20, color: Colors.blue),
          ),
          border: InputBorder.none,
        ),
        icon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Icon(Icons.arrow_drop_down, size: 30, color: Colors.blue),
        ),
        items: _categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilePicker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: _selectAndUploadAudioFile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          side: const BorderSide(color: Colors.grey),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.upload_file, color: Colors.blue),
            SizedBox(width: 10),
            Text('Pumili ng MP3 File (optional)',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNoteButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: _saveNote,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          side: const BorderSide(color: Colors.grey),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.check, color: Colors.blue),
            SizedBox(width: 10),
            Text('Idagdag ang salita sa diksyunaryo',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckTablesButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () async {
          List<String> tables = await getUserDetailsColumns();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Existing tables: $tables'),
                duration: const Duration(seconds: 3)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          side: const BorderSide(color: Colors.grey),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.table_chart, color: Colors.blue),
            SizedBox(width: 10),
            Text('Check Existing Tables',
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
