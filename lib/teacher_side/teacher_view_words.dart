import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter/services.dart';
import 'package:library_app/teacher_side/pending_view.dart';
import 'package:library_app/teacher_side/teacher_home.dart';
import 'package:just_audio/just_audio.dart';
import 'package:library_app/teacher_side/teacher_proponents.dart';

class TeacherViewNoteView extends StatefulWidget {
  final String word;
  final String definitionLabo;
  final String definitionFilipino;
  final String definitionEnglish;
  final String audioFilePath;
  final String studentName;
  final String category;

  const TeacherViewNoteView(
      {super.key,
      required this.word,
      required this.definitionLabo,
      required this.definitionFilipino,
      required this.definitionEnglish,
      required this.audioFilePath,
      required this.studentName,
      required this.category});

  @override
  State<TeacherViewNoteView> createState() => _TeacherViewNoteViewState();
}

class _TeacherViewNoteViewState extends State<TeacherViewNoteView> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String? _currentAudioPath;
  Icon playIcon = const Icon(Icons.volume_up_outlined);

  final List<String> _bookmarkedWords = [];
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

  void _playAudioFromAssets(String audioPath) async {
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
          .collection('teacher_approval')
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
          .collection('teacher_approval')
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

  void _playAudio() async {
    try {
      // Get a reference to the audio file from Firebase Storage
      Reference audioRef =
          FirebaseStorage.instance.ref().child(widget.audioFilePath!);

      // Get the download URL for the audio file
      String audioUrl = await audioRef.getDownloadURL();

      // Convert the audio URL (String) to a Uri
      Uri audioUri = Uri.parse(audioUrl);

      // Check the file extension (mp3 or m4a)
      String fileExtension = audioUrl.split('.').last;

      if (fileExtension == 'mp3' || fileExtension == 'm4a') {
        // Use just_audio's AudioPlayer to set the audio source and play
        await _audioPlayer.setUrl(audioUri.toString());
        await _audioPlayer.play();
      } else {
        // Show an error message if the file format is not supported
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unsupported audio format!')),
        );
      }
    } catch (e) {
      // Handle any errors in the process
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error playing audio file!')),
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
                            IconButton(
                              icon: const Icon(Icons.check_box),
                              onPressed:
                                  _approveWord, // Call the approve function
                            ),
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
                              icon: playIcon,
                              onPressed: () {
                                if (widget.audioFilePath.isNotEmpty) {
                                  _playAudioFromAssets(widget.audioFilePath);
                                } else {
                                  print("Audio path is empty");
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
