import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_app/bookmarked_view.dart';

import 'add_note.dart';
import 'home.dart';

class ViewNoteView extends StatefulWidget {
  final String word;
  final String definitionLabo;
  final String definitionFilipino;
  final String definitionEnglish;
  final String? audioFilePath;

  const ViewNoteView({
    super.key,
    required this.word,
    required this.definitionLabo,
    required this.definitionFilipino,
    required this.definitionEnglish,
    this.audioFilePath,
    
  });

  @override
  State<ViewNoteView> createState() => _ViewNoteViewState();
}

class _ViewNoteViewState extends State<ViewNoteView> {
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
        // Remove from bookmarks
        _bookmarkedWords.remove(widget.word);
      } else {
        // Add to bookmarks
        _bookmarkedWords.add(widget.word);
      }
      _isBookmarked = !_isBookmarked; // Toggle the bookmark state
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked
            ? 'Word bookmarked!'
            : 'Word removed from bookmarks!'),
      ),
    );
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
            // Top Container for the images, replacing the AppBar
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
            // Content of the note
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.word,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Pandiwa', style: TextStyle(fontSize: 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.note_add),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.word));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Word copied to clipboard!')),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: _isBookmarked ? Colors.yellow : null,
                        ),
                        onPressed: _toggleBookmark, // Toggle bookmark
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () async {
                          if (widget.audioFilePath != null) {
                            // Play the audio file if it exists
                            await _audioPlayer.play(DeviceFileSource(widget.audioFilePath!));
                          } else {
                            // Optionally, show a message if no audio is available
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'No audio available for this word.')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Depenisyon',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Salitang Labo:\n - ${widget.definitionLabo}\n',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Salitang Filipino:\n - ${widget.definitionFilipino}\n',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Depenisyon sa salitang English:\n - ${widget.definitionEnglish}\n',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
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
          border: Border(
            top: BorderSide(color: Colors.black12),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarkedView(),
                ),
              );
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeView(),
                ),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNoteView(),
                ),
              );
            }
            // Handle other items if needed
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_add_outlined),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_max_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Add Note',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_outlined),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
