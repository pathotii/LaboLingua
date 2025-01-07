import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:library_app/bookmarked_view.dart';

import 'add_note.dart';
import 'home.dart';

class ViewNoteView extends StatefulWidget {
  final String word;
  final String definitionLabo;
  final String definitionFilipino;
  final String definitionEnglish;
  final String audioFilePath;
  final String category;
  final String meaning;

  const ViewNoteView({
    super.key,
    required this.word,
    required this.definitionLabo,
    required this.definitionFilipino,
    required this.definitionEnglish,
    required this.audioFilePath,
    required this.category,
    required this.meaning,
  });

  @override
  State<ViewNoteView> createState() => _ViewNoteViewState();
}

class _ViewNoteViewState extends State<ViewNoteView> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String? _currentAudioPath;
  Icon playIcon = const Icon(Icons.volume_up_outlined);

  List<String> _bookmarkedWords = [];
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen to audio player state changes
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          playIcon = const Icon(Icons.volume_up_outlined);
          _currentAudioPath = ''; // Reset the audio path when done
        });
      }
    });
    _isBookmarked = _bookmarkedWords.contains(widget.word);
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Always dispose the player when done
    super.dispose();
  }

  void _playAudio(String audioPath) async {
    try {
      if (_currentAudioPath != audioPath) {
        // If the new audio path is different from the current one, reset and load the new file
        await _audioPlayer.setAsset(audioPath);
        setState(() {
          _currentAudioPath = audioPath;
        });
      }

      // Play audio if it's not already playing
      if (!_isPlaying) {
        await _audioPlayer.play();
        setState(() {
          _isPlaying = true;
          playIcon = const Icon(Icons.volume_up_outlined);
        });
      } else {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
          playIcon = const Icon(Icons.volume_up_outlined);
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
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
              // Top Container for the images, replacing the AppBar
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/LOGO.png',
                        height: 75,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 50),
                      Image.asset(
                        'assets/images/TITLE.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              // Content of the note
              Expanded(
                child: SingleChildScrollView(
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
                      Text(
                        widget.meaning,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.note_add),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: widget.word));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Word copied to clipboard!')),
                              );
                            },
                          ),
                          IconButton(
                            icon: playIcon,
                            onPressed: () {
                              if (widget.audioFilePath.isNotEmpty) {
                                _playAudio(widget.audioFilePath);
                              } else {
                                print("Audio path is empty");
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 450, // Set the desired width
                        child: Divider(
                          color: Colors.black,
                          thickness: 2.0,
                          height: 25,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Depenisyon\n',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDefinitionRow(
                          'Salitang Filipino:', widget.definitionFilipino),
                      const SizedBox(height: 8),
                      _buildDefinitionRow('Depenisyon sa Salitang English:',
                          widget.definitionEnglish),
                      const SizedBox(height: 8),
                      _buildDefinitionRow('Kategorya:', widget.category),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: double.infinity, // Or a specific width
                  height: 100, // Or a specific height
                  child: Stack(
                    children: [
                      Positioned(
                        top: 30,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 45,
                          ),
                          onPressed: () {
                            Navigator.pop(
                                context); // Go back to the previous screen
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
                  builder: (context) =>
                      BookmarkedView(category: widget.category),
                ),
              );
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(),
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
