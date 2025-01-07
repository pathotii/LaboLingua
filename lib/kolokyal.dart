import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/login/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SQFLite/database_helper.dart';
import 'bookmark_provider.dart';
import 'bookmarked_view.dart';
import 'home.dart';
import 'proponents.dart';
import 'view_words.dart';
import 'add_note.dart';

class Kolokyal extends StatefulWidget {
  final String category;

  const Kolokyal({super.key, required this.category});

  @override
  State<Kolokyal> createState() => _KolokyalState();
}

class _KolokyalState extends State<Kolokyal> {
  final List<Map<String, String>> _preSavedItems = [
    {
      'word': 'Abyan',
      'definitionLabo': '',
      'definitionFilipino': 'Katutubong Pilipino, ita o igoy',
      'definitionEnglish': 'native Filipinos',
      'audio': 'assets/audio/Abyan K_20241124_202926.mp3',
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'Armusal',
      'definitionLabo': '',
      'definitionFilipino': 'almusal',
      'definitionEnglish': 'breakfast',
      'audio': 'assets/audio/Armusal K_20241124_202938.mp3',
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'Eskaparate',
      'definitionLabo': '',
      'definitionFilipino': 'lalagyan ng lutong ulam',
      'definitionEnglish': 'container for cooked dishes',
      'audio': 'assets/audio/Eskaparate K_20241124_203240.mp3',
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'yan ta ay!',
      'definitionLabo': '',
      'definitionFilipino': '"Kita mo!"',
      'definitionEnglish': '"You See!"',
      'audio': 'assets/audio/Yan ta ay! K_20241123_202451.mp3',
      'subcategory': 'Expression'
    },
    {
      'word': 'walang kapormalan',
      'definitionLabo': '',
      'definitionFilipino': 'walang wastong asal at ugali',
      'definitionEnglish': 'without proper conduct and behavior',
      'audio': 'assets/audio/Walang kapormalan K_20241124_125850.mp3',
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'gumol',
      'definitionLabo': '',
      'definitionFilipino': 'niyayapos',
      'definitionEnglish': 'embraced',
      'audio': 'assets/audio/Gumol K_20241124_234901.mp3',
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'Kaunin',
      'definitionLabo': '',
      'definitionFilipino': 'sunduin',
      'definitionEnglish': 'to pick up',
      'audio': 'assets/audio/Kaunin K_20241124_235004.mp3',
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'Kabkab',
      'definitionLabo': '',
      'definitionFilipino': 'kagat',
      'definitionEnglish': 'bite',
      'audio': 'assets/audio/Kabkab K_20241124_234953.mp3',
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'Ligwak',
      'definitionLabo': '',
      'definitionFilipino': 'pagbuhos ng sobrang tubig',
      'definitionEnglish': 'pouring excess water',
      'audio': 'assets/audio/Ligwak K_20241124_235042.mp3',
      'subcategory': 'Pandiwa'
    },
  ];

  List<Map<String, dynamic>> _savedWords = [];
  List<String> _bookmarkedWords = [];
  String _searchQuery = '';
  List<Map<String, dynamic>> _approvedWords = [];

  @override
  void initState() {
    super.initState();
    _fetchApprovedWords();
    _loadBookmarkedWords();
    _printAllWords();
  }

  Future<void> _printAllWords() async {
    try {
      final words = await DatabaseHelper().fetchAllWords();
      print('All words in the notes table:');
      for (var word in words) {
        print(word['word']); // Adjust the key if necessary
      }
    } catch (e) {
      print('Failed to fetch words: $e');
    }
  }

  Future<void> _fetchApprovedWords() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('approved_words')
          .where('status', isEqualTo: 'approved') // Only approved words
          .where('category', isEqualTo: 'Kolokyal') // Only Kolokyal category
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No approved Kolokyal words found.");
      }

      // Log the fetched documents to confirm the word is coming through
      for (var doc in querySnapshot.docs) {
        print("Fetched word from Firestore: ${doc.data()}");
      }

      setState(() {
        _approvedWords = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'word': data['word'],
            'definitionLabo': data['definitionLabo'],
            'definitionFilipino': data['definitionFilipino'],
            'definitionEnglish': data['definitionEnglish'],
            'studentName': data['studentName'],
            'audioFilePath': data['audioFilePath'],
            'status': data['status'],
            'category': data['category'],
          };
        }).toList();

        _approvedWords
            .sort((a, b) => (a['word'] ?? '').compareTo(b['word'] ?? ''));
      });
    } catch (e) {
      print('Error fetching approved Kolokyal words: $e');
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _loadBookmarkedWords() async {
    try {
      final bookmarks = await DatabaseHelper().getBookmarkedWords();
      setState(() {
        _bookmarkedWords =
            bookmarks.map((bookmark) => bookmark['word'] as String).toList();
      });
    } catch (e) {
      print('Failed to load bookmarked words: $e');
    }
  }

  Future<void> _loadWordsFromDatabase([String? newWord]) async {
    final words = await DatabaseHelper().fetchWords();
    print('Fetched words from database: $words');

    setState(() {
      _savedWords = words.map((word) {
        return {
          'id': word['id'],
          'word': word['word'],
          'definitionLabo': word['definitionLabo'],
          'definitionFilipino': word['definitionFilipino'],
          'definitionEnglish': word['definitionEnglish'],
          'audioFilePath': word['audioFilePath'],
        };
      }).toList();

      // If there is a new word, append it to the end
      if (newWord != null && newWord.isNotEmpty) {
        _savedWords.add({
          'word': newWord,
          'definitionLabo': '',
          'definitionFilipino': '',
          'definitionEnglish': '',
          'audioFilePath': '',
        });
      }
    });
  }

  Future<void> _bookmarkWord(Map<String, dynamic> word) async {
    final provider = context.read<BookmarkProvider>();

    // Ensure the word key is present
    if (word['word'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word is missing. Cannot bookmark.')),
      );
      return;
    }

    String wordText = word['word']; // Get the word text
    int wordId =
        word['id'] ?? DateTime.now().millisecondsSinceEpoch; // Generate an ID

    // Check if the word is already bookmarked using the provider
    bool isBookmarked = provider.isBookmarked(wordId);

    try {
      if (!isBookmarked) {
        // If not bookmarked, proceed to bookmark
        await DatabaseHelper().insertBookmark({
          'id': wordId,
          'word': wordText,
          'definitionLabo': word['definitionLabo'],
          'definitionFilipino': word['definitionFilipino'],
          'definitionEnglish': word['definitionEnglish'],
        });

        provider.addBookmark({
          'id': wordId,
          'word': wordText,
          'definitionLabo': word['definitionLabo'],
          'definitionFilipino': word['definitionFilipino'],
          'definitionEnglish': word['definitionEnglish'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word bookmarked successfully!')),
        );
      } else {
        // If already bookmarked, proceed to unbookmark
        await DatabaseHelper().removeBookmark(wordId);
        provider.removeBookmark(wordId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word unbookmarked successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allItems = [
      ..._preSavedItems,
      ..._approvedWords,
    ];

    allItems.sort((a, b) {
      final wordA = (a['word'] ?? '').toLowerCase();
      final wordB = (b['word'] ?? '').toLowerCase();
      return wordA.compareTo(wordB);
    });

    final filteredItems = allItems.where((item) {
      final word = item['word']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return word.startsWith(query);
    }).toList();

    String capitalize(String word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    final capitalizedItems = filteredItems.map((item) {
      return {
        ...item,
        'word': capitalize(item['word'] ?? ''),
      };
    }).toList();

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
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
                  child: TextField(
                    onChanged: _updateSearchQuery,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 2.0,
                height: 25,
              ),
              Expanded(
                child: capitalizedItems.isEmpty
                    ? const Center(child: Text('No saved words'))
                    : ListView.builder(
                        itemCount: capitalizedItems.length,
                        itemBuilder: (context, index) {
                          final item = capitalizedItems[index];
                          final isBookmarked =
                              _bookmarkedWords.contains(item['word']);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 8.0),
                            child: Container(
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
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                leading: const Icon(Icons.wb_sunny_outlined),
                                title: Text(
                                  item['word'] ?? 'No word',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                  ),
                                  onPressed: () => _bookmarkWord(item),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewNoteView(
                                        word: item['word'] ?? '',
                                        definitionLabo:
                                            item['definitionLabo'] ?? '',
                                        definitionFilipino:
                                            item['definitionFilipino'] ?? '',
                                        definitionEnglish:
                                            item['definitionEnglish'] ?? '',
                                        category: widget.category,
                                        audioFilePath: item['audio'] ?? '',
                                        meaning: item['subcategory'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
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
                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeView(),
                          ),
                        ).then((newWord) => _loadWordsFromDatabase(newWord));
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddNoteView(),
                          ),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BookmarkedView(category: ''),
                          ),
                        );
                        break;
                      // case 3:
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const BookmarkedView(),
                      //     ),
                      //   );
                      //   break;
                      case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Proponents(),
                          ),
                        );
                        break;
                      case 4:
                        _handleLogout(context);
                        break;
                    }
                  },
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home_max_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNoteView(),
                            ),
                          );
                          _loadWordsFromDatabase();
                        },
                        child: const Icon(Icons.add_box_outlined),
                      ),
                      label: 'Add Note',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark_add_outlined),
                      label: 'Saved',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.account_box_outlined),
                      label: 'Mananaliksik',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.logout_outlined),
                      label: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userType');

    // Clear navigation stack and push LoginView
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => false,
    );
  }
}
