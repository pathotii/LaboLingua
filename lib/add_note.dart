import 'package:flutter/material.dart';
import 'package:library_app/home.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'SQFLite/database_helper.dart';
import 'bookmarked_view.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  _AddNoteViewState createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _definitionLaboController =
      TextEditingController();
  final TextEditingController _definitionFilipinoController =
      TextEditingController();
  final TextEditingController _definitionEnglishController =
      TextEditingController();

  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectAudioFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom, // Change to custom
    allowedExtensions: ['mp3'], // Specify allowed extensions
  );

  if (result != null) {
    setState(() {
      _audioFilePath = result.files.single.path; // Store the file path
    });
  }
}


  Future<void> _saveNote() async {
    final note = {
      'word': _wordController.text,
      'definitionLabo': _definitionLaboController.text,
      'definitionFilipino': _definitionFilipinoController.text,
      'definitionEnglish': _definitionEnglishController.text,
      'audioFilePath': _audioFilePath, // Can be null if no recording
    };

    // Insert the note into the database
    final id = await DatabaseHelper().insertNote(note);
    print('Note saved with id: $id');

    // Print the contents of the table
    _printTableContents();

    // Check if mounted before navigating to avoid issues
    if (mounted) {
      Navigator.pop(context as BuildContext);
    }
  }

  Future<void> _printTableContents() async {
    final notes = await DatabaseHelper().fetchWords();
    for (var note in notes) {
      print('ID: ${note['id']}');
      print('Word: ${note['word']}');
      print('Definition (Labo): ${note['definitionLabo']}');
      print('Definition (Filipino): ${note['definitionFilipino']}');
      print('Definition (English): ${note['definitionEnglish']}');
      print('Audio File Path: ${note['audioFilePath']}');
      print('---');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent resizing when the keyboard appears
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFBAC08),
              Color(0xFFFFFAA7),
              Color(0xFFFFFAA7),
              Color(0xFFFBAC08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Top Container for the images
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/LOGO.png',
                      height: 75,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 80),
                    Image.asset(
                      'assets/images/TITLE.png',
                      height: 65,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            // Input Fields
            Expanded(
              // Use Expanded to take up available space
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  // Wrap the input fields in SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Word TextField
                      _buildTextField(
                          _wordController, 'Salita', Icons.wb_sunny),
                      // Definition Labo TextField
                      _buildTextField(_definitionLaboController,
                          'Depinisyon sa salitang Labo', Icons.book),
                      // Definition Filipino TextField
                      _buildTextField(_definitionFilipinoController,
                          'Depinisyon sa wikang Filipino', Icons.bookmark),
                      // Definition English TextField
                      _buildTextField(_definitionEnglishController,
                          'Depinisyon sa wikang Ingles', Icons.language),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Pumili ng MP3 File (optional)'),
                        onPressed: _selectAudioFile,
                      ),
                      if (_audioFilePath != null) ...[
                        const SizedBox(height: 8),
                        Text('Selected File: $_audioFilePath',
                            style: const TextStyle(fontSize: 14)),
                      ],

                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Magdagdag ng mga salita'),
                        onPressed: () async {
                          await _saveNote();
                          _printTableContents();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Navigation Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black12)),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black54,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: (index) {
                  switch (index) {
                    // case 0:
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const AddNoteView(),
                    //     ),
                    //   );
                    //   break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
                        ),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookmarkedView(),
                        ),
                      );
                      break;
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_box_outlined),
                    label: 'Add Note',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_max_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_add_outlined),
                    label: 'Saved',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_box_outlined),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ],
        ),
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
