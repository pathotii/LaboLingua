import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_view.dart';
import 'approved_notes.dart';
import 'pending_view.dart';
import 'teacher_add_note.dart';
import 'teacher_kolokyal.dart';
import 'teacher_lalawiganin.dart';
import 'teacher_pambansa.dart';
import 'teacher_pampanitikan.dart';
import 'teacher_proponents.dart';
import 'teacherside_balbal.dart';

class TeacherHomeView extends StatefulWidget {
  final String category;

  const TeacherHomeView({super.key, required this.category});

  @override
  _TeacherHomeViewState createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<TeacherHomeView> {
  List<Map<String, String>> capitalizedItems = [
    {
      'category': 'pambansa',
    },
    {
      'category': 'balbal',
    },
    {
      'category': 'lalawiganin',
    },
    {
      'category': 'kolokyal',
    },
    {
      'category': 'pampanitikan',
    },
  ];

  Map<String, String> categoryToSentence = {
    'pambansa':
        'Ito ang wikang ginagamit sa pamahalaan, edukasyon, at opisyal na komunikasyon. Karaniwang nauunawaan ito ng nakararami sa isang bansa. Halimbawa nito ang wikang Filipino.',
    'balbal':
        'Ang antas na ito ay ginagamit sa malikhaing sulatin, gaya ng tula, nobela, at iba pang akdang pampanitikan. Puno ito ng talinghaga, matalinghagang pagpapahayag, at masining na salita.',
    'lalawiganin':
        'Tumutukoy ito sa wikang ginagamit sa pang-araw-araw na usapan. Karaniwan itong pinaikli at may bahagyang pagbabago sa anyo.',
    'kolokyal':
        'Ang wikang ginagamit sa partikular na lugar o rehiyon. Ang bokabularyo at kahulugan ay limitado sa mga taong nakatira sa lugar na iyon.',
    'pampanitikan':
        'Ito ang pinakamababang antas ng wika na karaniwang ginagamit ng mga kabataan. Madalas itong slang at nagbabago sa paglipas ng panahon.',
  };

  // To handle search input
  String searchQuery = '';

  // Function to handle the search query change
  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  // Function to capitalize the first letter of each word in the category
  String capitalizeCategory(String category) {
    return category.split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Sorting items alphabetically by category
  List<Map<String, String>> get sortedItems {
    final filteredItems = capitalizedItems
        .where((item) =>
            item['category']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    filteredItems.sort((a, b) => a['category']!.compareTo(b['category']!));

    return filteredItems;
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
                child: sortedItems.isEmpty
                    ? const Center(child: Text('No saved words'))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Default to 2 columns
                          crossAxisSpacing:
                              5.0, // Horizontal space between items
                          mainAxisSpacing: 5.0, // Vertical space between items
                          mainAxisExtent: 80,
                          childAspectRatio:
                              2.0, // Adjust the aspect ratio to decrease box height
                        ),
                        itemCount: sortedItems.length,
                        itemBuilder: (context, index) {
                          final item = sortedItems[index];

                          // Get the category from sortedItems
                          final category = item['category']?.trim() ?? '';

                          // Fetch the corresponding sentence using the category as the key from the map
                          final sentence = categoryToSentence[category] ??
                              'No sentence available';

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
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon and Category beside each other
                                  const Icon(Icons.wb_sunny_outlined,
                                      size: 24.0),
                                  const SizedBox(
                                      width:
                                          10.0), // Space between icon and text
                                  Text(
                                    capitalizeCategory(
                                        category), // Capitalize the category name
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                // Show a dialog first (blocking the navigation)
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(capitalizeCategory(category)),
                                      content: Text(
                                        sentence,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ), // Display the sentence here
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Close the dialog
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // After the dialog is closed, navigate to the corresponding page
                                if (category == 'balbal') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherSideBalbal(category: category),
                                    ),
                                  );
                                } else if (category == 'lalawiganin') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeacherLalawiganin(
                                          category: category),
                                    ),
                                  );
                                } else if (category == 'kolokyal') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherKolokyal(category: category),
                                    ),
                                  );
                                } else if (category == 'pambansa') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherPambansa(category: category),
                                    ),
                                  );
                                } else if (category == 'pampanitikan') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeacherPampanitikan(
                                          category: category),
                                    ),
                                  );
                                }
                              },
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
                      // case 0:
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const HomeView(),
                      //     ),
                      //   ).then((newWord) => _loadWordsFromDatabase(newWord));
                      //   break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PendingWordsView(),
                          ),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherAddNoteView(),
                          ),
                        );
                        break;
                      case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApprovedWordsView(),
                          ),
                        );
                        break;
                      case 4:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherProponents(),
                          ),
                        );
                        break;
                      case 5:
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
                              builder: (context) => const PendingWordsView(),
                            ),
                          );
                        },
                        child: const Icon(Icons.pending_outlined),
                      ),
                      label: 'Pending',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.add_box_outlined),
                      label: 'Add Note',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.approval_outlined),
                      label: 'Approved',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.person_2_outlined),
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
