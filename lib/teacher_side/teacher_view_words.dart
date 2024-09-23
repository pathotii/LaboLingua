import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:library_app/teacher_side/pending_view.dart';
import 'package:library_app/teacher_side/teacher_home.dart';

class TeacherViewNoteView extends StatefulWidget {
  final String word;
  final String definitionLabo;
  final String definitionFilipino;
  final String definitionEnglish;
  final String? audioFilePath;
  final String studentName; // Add student name parameter

  const TeacherViewNoteView({
    super.key,
    required this.word,
    required this.definitionLabo,
    required this.definitionFilipino,
    required this.definitionEnglish,
    this.audioFilePath,
    required this.studentName, // Add student name parameter
  });

  @override
  State<TeacherViewNoteView> createState() => _TeacherViewNoteViewState();
}

class _TeacherViewNoteViewState extends State<TeacherViewNoteView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _bookmarkedWords = [];
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    // Check if the current word is already bookmarked
    _isBookmarked = _bookmarkedWords.contains(widget.word);
  }

  void _toggleBookmark() {
    setState(() {
      if (_isBookmarked) {
        _bookmarkedWords.remove(widget.word);
      } else {
        _bookmarkedWords.add(widget.word);
      }
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked
            ? 'Word bookmarked!'
            : 'Word removed from bookmarks!'),
      ),
    );
  }

  void _approveWord() async {
  try {
    // Move word to approved_words collection
    await FirebaseFirestore.instance.collection('approved_words').add({
      'word': widget.word,
      'definitionLabo': widget.definitionLabo,
      'definitionFilipino': widget.definitionFilipino,
      'definitionEnglish': widget.definitionEnglish,
      'studentName': widget.studentName,
      'audionFilePath': widget.audioFilePath,
      'status': 'approved'
    });

    // Find the specific document in the teacher_approval collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teacher_approval')
        .where('word', isEqualTo: widget.word)
        .get();

    // Delete only the approved word's document
    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs[0].reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Word approved and moved to approved words!')),
    );

    Navigator.pop(context, true);
  } catch (e) {
    print('Error approving word: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error approving word!')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Image.asset('assets/images/LOGO.png',
                        height: 75, fit: BoxFit.contain),
                    const SizedBox(width: 80),
                    Image.asset('assets/images/TITLE.png',
                        height: 65, fit: BoxFit.contain),
                  ],
                ),
              ),
            ),
            // Content of the note
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.word,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('From: ${widget.studentName}',
                      style: const TextStyle(
                          fontSize: 18)), // Display student name
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_box),
                        onPressed: _approveWord, // Call the approve function
                      ),
                      IconButton(
                        icon: const Icon(Icons.note_add),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.word));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Word copied to clipboard!')));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () async {
                          if (widget.audioFilePath != null) {
                            await _audioPlayer
                                .play(DeviceFileSource(widget.audioFilePath!));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'No audio available for this word.')));
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {}, // Handle delete if needed
                      ),
                    ],
                  ),
                  const SizedBox(
                      width: 450,
                      child: Divider(
                          color: Colors.black, thickness: 2.0, height: 25)),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Depenisyon\n',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Salitang Labo:\n - ${widget.definitionLabo}\n',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          'Salitang Filipino:\n - ${widget.definitionFilipino}\n',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          'Depenisyon sa salitang English:\n - ${widget.definitionEnglish}\n',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
            // if (index == 0) {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const BookmarkedView()));
            // }
            if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeacherHomeView()));
            }
            if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PendingWordsView()));
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_add_outlined), label: 'Saved'),
            BottomNavigationBarItem(
                icon: Icon(Icons.home_max_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pending_outlined), label: 'Pending Notes'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box_outlined), label: 'Account'),
          ],
        ),
      ),
    );
  }
}
