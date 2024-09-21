import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_note.dart';
import 'bookmark_provider.dart';
import 'SQFLite/database_helper.dart';
import 'home.dart';
import 'view_words.dart';

class BookmarkedView extends StatefulWidget {
  const BookmarkedView({super.key});

  @override
  State<BookmarkedView> createState() => _BookmarkedViewState();
}

class _BookmarkedViewState extends State<BookmarkedView> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBookmarkedWords();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _loadBookmarkedWords() async {
    final bookmarks = await DatabaseHelper().getBookmarkedWords();
    context.read<BookmarkProvider>().setBookmarkedWords(bookmarks);
  }

  Future<void> _bookmarkWord(Map<String, dynamic> word) async {
    final provider = context.read<BookmarkProvider>();
    int wordId = word['id'];
    bool isBookmarked = provider.isBookmarked(wordId);

    if (!isBookmarked) {
      try {
        await DatabaseHelper().insertBookmark({
          'id': wordId,
          'word': word['word'],
          'definitionLabo': word['definitionLabo'],
          'definitionFilipino': word['definitionFilipino'],
          'definitionEnglish': word['definitionEnglish'],
        });
        provider.addBookmark(word);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word bookmarked successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to bookmark the word: $e')),
        );
      }
    } else {
      try {
        await DatabaseHelper().removeBookmark(wordId);
        provider.removeBookmark(wordId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word unbookmarked successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove bookmark: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookmarkProvider>();
    final bookmarkedWords = provider.bookmarkedWords;

    final filteredWords = bookmarkedWords.where((item) {
      final word = item['word']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return word.startsWith(
          query); // Change this to check if word starts with the query
    }).toList();

    // Function to capitalize the first letter of a word
    String capitalize(String word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    // Map the filtered items to capitalize the first letter of each word
    final capitalizedItems = filteredWords.map((item) {
      return {
        ...item,
        'word': capitalize(item['word'] ?? ''), // Capitalize the first letter
      };
    }).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFBAC08), Color(0xFFFFFAA7), Color(0xFFFFFAA7),  Color(0xFFFBAC08)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            // Positioned images at the top, similar to AppBar
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
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
                  controller: _searchController,
                  onChanged: _updateSearchQuery,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: capitalizedItems.isEmpty
                  ? const Center(child: Text('No bookmarked words'))
                  : ListView.builder(
                      itemCount: capitalizedItems.length,
                      itemBuilder: (context, index) {
                        final item = capitalizedItems[index];
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
                            child: Column(
                              children: [
                                ListTile(
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
                                      provider.isBookmarked(item['id'])
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: Colors.black,
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
                                              
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
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
          ],
        ),
      ),
    );
  }
}
