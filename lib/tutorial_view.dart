import 'package:flutter/material.dart';
import 'package:library_app/home.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';

class TutorialView extends StatefulWidget {

  const TutorialView({super.key});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  final PageController _pageController = PageController(viewportFraction: 0.7, initialPage: 0);

  final List<Map<String, String>> tutorialSlides = [
    {
      "image": "assets/images/tutor1.png", // Replace with your own tutorial images
      "title": "Welcome to the App",
      "subtitle": "Discover how to make the most of the app\nwith this quick tutorial."
    },
    {
      "image": "assets/images/tutor2.png",
      "title": "Track Your Progress",
      "subtitle": "Keep an eye on your achievements and\nmonitor your progress in real-time."
    },
    {
      "image": "assets/images/tutor3.png",
      "title": "Stay Motivated",
      "subtitle": "Set your goals, receive reminders, and\nstay on track with our motivational tips."
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: PageView.builder(
                controller: _pageController,
                itemCount: tutorialSlides.length,
                itemBuilder: (context, index) {
                  final slide = tutorialSlides[index];
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: media.width * 0.02),
                      child: Container(
                        width: media.width * 0.9,
                        height: media.height * 0.6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: TColor.primaryG,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(media.width * 0.05),
                                child: Image.asset(
                                  slide["image"]!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: media.width * 0.05),
                            Text(
                              slide["title"]!,
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              width: media.width * 0.2,
                              height: 1,
                              color: TColor.white,
                            ),
                            SizedBox(height: media.width * 0.02),
                            Padding(
                              padding: EdgeInsets.only(bottom: media.width * 0.05),
                              child: Text(
                                slide["subtitle"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: media.width,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: media.width * 0.09),
                    child: Text(
                      "App Tutorial",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Padding(
                    padding: EdgeInsets.only(bottom: media.width * 0.015),
                    child: Text(
                      "Learn the basics of the app\nand how to use its features",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(height: media.width * 0.05),
                  Padding(
                    padding: EdgeInsets.only(bottom: media.width * 0.07),
                    child: SizedBox(
                      height: media.width * 0.12,
                      child: RoundButton(
                        title: "Proceed",
                        type: RoundButtonType.bgGradient,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                          );
                        },
                      ),
                    ),
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
