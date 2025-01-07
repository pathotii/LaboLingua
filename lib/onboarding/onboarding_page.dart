import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SQFLite/database_helper.dart';
import '../common_widget/onboarding_page.dart';
import 'package:library_app/signup/signup_view.dart'; // Import your SignUpView
import '../../common/colo_extension.dart'; // Adjust the import as needed
import '../home.dart';
import '../teacher_side/teacher_home.dart';
import '../user_details.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();
  bool isLoggedIn = false;
  String? userType;
  

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        selectPage = controller.page?.round() ?? 0;
      });
    });
  }

  // Onboarding pages data
  List<Map<String, String>> pageArr = [
    {
      "title": "Halina't tuklasin ang mga\nsalitang Labo",
      "subtitle":
          "Tuklasin at kilalanin ang mga salitang ginagamit sa iba't ibang lugar.",
      "image": "assets/images/Group 10.png"
    },
    {
      "title": "Matutong alamin ang\ntamang pagbigkas",
      "subtitle":
          "Pag-aralan kung paano gamitin ang mga salita sa tamang konteksto.",
      "image": "assets/images/Group 9.png"
    },
    {
      "title": "Aralin at unawain ang mga\nkahulugan ng mga salita",
      "subtitle":
          "Palawakin ang kaalaman sa mga kahulugan ng salita at kanilang gamit.",
      "image": "assets/images/Group 11 .png"
    },
    {
      "title": "Matukoy ang kategorya ng antas\nng wika sa rehistro ng Labo",
      "subtitle": "Maging bahagi ng pag-unlad ng kaalaman sa salitang Labo.",
      "image": "assets/images/Group 12 .png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/POST.png', // Path to your GIF asset
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: (context, index) {
              var pObj = pageArr[index];
              return OnBoardingPage(pObj: pObj);
            },
          ),
          // Circular Progress Indicator and Next Button
          if (selectPage < 3)
            Positioned(
              bottom: 20,
              right: 2,
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors:
                                TColor.primaryG), // Gradient for the background
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CustomPaint(
                        painter: GradientCircularProgressPainter(
                          (selectPage + 1) / 3,
                          [
                            TColor.primaryColor2,
                            TColor.primaryColor1
                          ], // Your gradient colors
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent, // Optional background
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: TColor.primaryG), // Gradient for the button
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.navigate_next,
                          color: TColor.white,
                        ),
                        onPressed: () {
                          if (selectPage < 3) {
                            selectPage++;
                            controller.animateToPage(selectPage,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeIn);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Proceed to Next Screen Button on the Last Page
          if (selectPage == 3)
            Padding(
              padding: const EdgeInsets.only(top: 650),
              child: Center(
                child: Material(
                  borderRadius: BorderRadius.circular(35),
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(35),
                    onTap: () async {
                      checkUserTypeAndNavigate();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: TColor.primaryG,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 120),
                        child: const Text(
                          'Magpatuloy',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Check if user is logged in and fetch userType
  Future<String?> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Fetch userType from your local database
      String? userType = await getUserTypeFromDatabase();
      print("User is logged in, userType: $userType"); // Debugging statement
      return userType;
    }

    print("User is not logged in"); // Debugging statement
    return null; // Return null if the user is not logged in
  }

  Future<String?> getUserTypeFromDatabase() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<UserDetails> userDetails = await dbHelper.getUserDetails();

    if (userDetails.isNotEmpty) {
      String userType = userDetails.first.userType;
      print("Fetched userType from database: $userType"); // Debugging statement
      return userType;
    }

    print("No user details found in database"); // Debugging statement
    return null; // Return null if no user details are found
  }

  Future<void> checkUserTypeAndNavigate() async {
  final userType = await DatabaseHelper().getUserType(); // Call the modified method

  if (userType == 'Teacher') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TeacherHomeView(category: '',)),
    );
  } else if (userType == 'Student') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeView()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpView()),
    );
  }
}

}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  GradientCircularProgressPainter(this.progress, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintBackground = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(
        size.center(Offset.zero), size.width / 2, paintBackground);

    // Paint progress arc
    Paint paintProgress = Paint()
      ..shader = LinearGradient(colors: colors).createShader(Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    double arcAngle = 2 * 3.141592653589793 * progress; // 2 * pi * progress
    canvas.drawArc(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2),
        -3.141592653589793 / 2,
        arcAngle,
        false,
        paintProgress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
