import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:library_app/teacher_side/pending_view.dart';
import 'package:library_app/teacher_side/teacher_home.dart';
import 'package:library_app/teacher_side/teacher_proponents.dart';

class ApprovedViewNote extends StatefulWidget {
  final String word;
  final String definitionLabo;
  final String definitionFilipino;
  final String definitionEnglish;
  final String? audioFilePath;
  final String studentName;
  final String category;

  const ApprovedViewNote(
      {super.key,
      required this.word,
      required this.definitionLabo,
      required this.definitionFilipino,
      required this.definitionEnglish,
      this.audioFilePath,
      required this.studentName,
      required this.category});

  @override
  State<ApprovedViewNote> createState() => _ApprovedViewNoteState();
}

class _ApprovedViewNoteState extends State<ApprovedViewNote> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _bookmarkedWords = [];
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
      String wordLowerCase = widget.word.toLowerCase();

      await FirebaseFirestore.instance.collection('approved_words').add({
        'word': wordLowerCase,
        'definitionLabo': widget.definitionLabo,
        'definitionFilipino': widget.definitionFilipino,
        'definitionEnglish': widget.definitionEnglish,
        'studentName': widget.studentName,
        'audionFilePath': widget.audioFilePath,
        'status': 'approved',
        'category': widget.category
      });

      // Find the specific document in the teacher_approval collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('approved_words')
          .where('word', isEqualTo: wordLowerCase)
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

  void _deleteWord() async {
    try {
      // Print the word to debug
      print('Trying to delete word: ${widget.word}');

      // Normalize the word (convert it to lowercase) for comparison
      String normalizedWord = widget.word.toLowerCase();

      // Find the specific document in the teacher_approval collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('approved_words')
          .where('word', isEqualTo: normalizedWord) // Search using lowercase
          .get();

      // Debug print to check if the query returned any documents
      print('Query snapshot docs: ${querySnapshot.docs.length}');

      // Delete the document if found
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs[0].reference.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word deleted successfully!')),
        );
        Navigator.pop(context, true); // Optionally, pop the current screen
      } else {
        print('Word not found in the collection');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word not found for deletion!')),
        );
      }
    } catch (e) {
      print('Error deleting word: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting word!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Top Container for the images
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
              // Content of the note
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
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
                            // IconButton(
                            //   icon: const Icon(Icons.check_box),
                            //   onPressed: _approveWord, // Call the approve function
                            // ),
                            IconButton(
                              icon: const Icon(Icons.note_add),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: widget.word));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Word copied to clipboard!')));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () async {
                                if (widget.audioFilePath != null) {
                                  await _audioPlayer.play(
                                      DeviceFileSource(widget.audioFilePath!));
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
                              onPressed: _deleteWord,
                            ),
                          ],
                        ),
                        const SizedBox(
                            width: 450,
                            child: Divider(
                                color: Colors.black,
                                thickness: 2.0,
                                height: 25)),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Depenisyon\n',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // const SizedBox(height: 8),
                        // _buildDefinitionRow('Salitang Bikol:', widget.definitionLabo),
                        const SizedBox(height: 8),
                        _buildDefinitionRow(
                            'Salitang Filipino:', widget.definitionFilipino),
                        const SizedBox(height: 8),
                        _buildDefinitionRow('Depenisyon sa Salitang English:',
                            widget.definitionEnglish),
                        const SizedBox(height: 8),
                        _buildDefinitionRow(
                            'Kategorya:', _capitalizeWords(widget.category)),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                      builder: (context) => const TeacherHomeView(
                            category: '',
                          )));
            }
            if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PendingWordsView()));
            }
            if (index == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeacherProponents()));
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
                icon: Icon(Icons.account_box_outlined), label: 'Mananaliksik'),
          ],
        ),
      ),
    );
  }

  String _capitalizeWords(String text) {
    return text.split(' ').map((word) {
      return word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '';
    }).join(' ');
  }

  Widget _buildDefinitionRow(String title, String definition) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$title\n - $definition\n',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              overflow: TextOverflow.visible, // Allow overflow to wrap
              softWrap: true, // Enable soft wrapping
            ),
          ),
        ],
      ),
    );
  }
}
