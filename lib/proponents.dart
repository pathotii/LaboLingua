import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:library_app/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_note.dart';
import 'bookmarked_view.dart';
import 'login/login_view.dart';

class Proponents extends StatefulWidget {
  const Proponents({super.key});

  @override
  _ProponentsState createState() => _ProponentsState();
}

class _ProponentsState extends State<Proponents> {
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
              // The FlipCard widget
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: _buildFlipCard(),
              ),
              // Container with the name "Rozel A. Genova, PhD"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Rozel A. Genova, PhD',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tagapayo',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Spacer to push BottomNavigationBar to the bottom
              const Spacer(),
              // BottomNavigationBar at the bottom of the screen
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
                        );
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
                            builder: (context) => const BookmarkedView(
                              category: '',
                            ),
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

  // FlipCard widget implementation
  Widget _buildFlipCard() {
    return FlipCard(
      front: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 350,
          child: Column(
            children: [
              // Front image: Randy
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/randy.png', // Image for the front
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 200, // Adjust this based on your image size
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Villanueva, John Randy R.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mananaliksik',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      back: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 350,
          child: Column(
            children: [
              // Back image: Kagrupo
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/kagrupo.png', // Image for the back
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200, // Adjust this based on your image size
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ilan, Jhon Harold C.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mananaliksik',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
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
