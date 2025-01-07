import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0; // Track progress percentage

  @override
  void initState() {
    super.initState();
    // Update progress gradually
    Timer.periodic(const Duration(milliseconds: 250), (timer) {
      setState(() {
        _progress += 0.03; // Increment progress
        if (_progress >= 1.0) {
          _progress = 1.0; // Cap progress at 100%
          timer.cancel(); // Stop timer
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingView()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen GIF background
          Positioned.fill(
            child: Image.asset(
              'assets/POST.gif', // Path to your GIF asset
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Stack(
                    children: [
                      // Background for the progress bar (grey track)
                      Container(
                        height: 15, // Height of the progress bar
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Background color
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black, // Stroke color
                            width: 4, // Stroke width
                          ), // Rounded edges
                        ),
                      ),
                      // Foreground progress with gradient
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth *
                                _progress, // Progress width
                            height: 15, // Match height of the background
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFBAC08), // Start color
                                  Color(0xFFFFFAA7),
                                  Color(0xFFFFFAA7),
                                  Color(0xFFFBAC08), // End color
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(5), // Rounded edges
                              border: Border.all(
                                color: Colors.black, // Stroke color
                                width: 4, // Stroke width
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10), // Spacing between bar and text
                // Percentage text
                Text(
                  '${(_progress * 100).toInt()}%', // Convert progress to percentage
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color for visibility
                  ),
                ),
                const SizedBox(height: 40), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}
