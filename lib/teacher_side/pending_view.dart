import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/teacher_side/teacher_home.dart';
import 'teacher_view_words.dart';

class PendingWordsView extends StatefulWidget {
  const PendingWordsView({super.key});

  @override
  State<PendingWordsView> createState() => _PendingWordsViewState();
}

class _PendingWordsViewState extends State<PendingWordsView> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> pendingWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingWords();
  }

  Future<void> _loadPendingWords() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('teacher_approval')
          .where('status', isEqualTo: 'pending')
          .get();

      pendingWords = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Print the fetched data for debugging
      for (var word in pendingWords) {
        print(word);
      }

      setState(() {
        _isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      print('Error fetching pending words: $e');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = pendingWords.where((item) {
      final word = item['word']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return word.startsWith(query);
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
            colors: [
              Color(0xFFFBAC08),
              Color(0xFFFFFAA7),
              Color(0xFFFFFAA7),
              Color(0xFFFBAC08)
            ],
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
              child: _isLoading // Show loading indicator while fetching data
                  ? const Center(child: CircularProgressIndicator())
                  : capitalizedItems.isEmpty
                      ? const Center(child: Text('No pending words'))
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                      leading:
                                          const Icon(Icons.wb_sunny_outlined),
                                      title: Text(
                                        item['word'] ?? 'No word',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onTap: () async {
                                        final shouldRefresh =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TeacherViewNoteView(
                                              word: item['word'] ?? '',
                                              definitionLabo:
                                                  item['definitionLabo'] ?? '',
                                              definitionFilipino:
                                                  item['definitionFilipino'] ??
                                                      '',
                                              definitionEnglish:
                                                  item['definitionEnglish'] ??
                                                      '',
                                              audioFilePath:
                                                  item['audioFilePath'],
                                              studentName:
                                                  item['studentName'] ??
                                                      'Unknown',
                                            ),
                                          ),
                                        );

                                        if (shouldRefresh == true) {
                                          _loadPendingWords(); // Reload the pending words
                                        }
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
                  if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TeacherHomeView()),
                    );
                  }
                  // if (index == 2) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => const AddNoteView()),
                  //   );
                  // }
                  // Handle other items if needed
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pending_outlined),
                    label: 'Pending Notes',
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
