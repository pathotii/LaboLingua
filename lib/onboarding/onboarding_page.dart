import 'package:library_app/signup/signup_view.dart';
import '../common_widget/onboarding_page.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      selectPage = controller.page?.round() ?? 0;

      setState(() {});
    });
  }

  List pageArr = [
    {
      "title": "Alamin iba't ibang salita\nmula sa ibang bayan",
      "subtitle":
          "Tuklasin at kilalanin ang mga salitang ginagamit sa iba't ibang lugar.",
      "image": "assets/images/Group 10.png"
    },
    {
      "title": "Matutong gamitin sa\nwastong pangungusap",
      "subtitle":
          "Pag-aralan kung paano gamitin ang mga salita sa tamang konteksto.",
      "image": "assets/images/Group 9.png"
    },
    {
      "title": "Aralin at alamin ang mga kahulugan ng mga salita",
      "subtitle":
          "Palawakin ang kaalaman sa mga kahulugan ng salita at kanilang gamit.",
      "image": "assets/images/Group 11 .png"
    },
    {
      "title": "Mag ambag pa ng ibang\nmga kaalaman",
      "subtitle": "Maging bahagi ng pag-unlad ng kaalaman sa ating wika.",
      "image": "assets/images/Group 12 .png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: (context, index) {
              var pObj = pageArr[index] as Map? ?? {};
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
                            selectPage = selectPage + 1;
                            controller.animateToPage(selectPage,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.bounceInOut);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Proceed to Tutorial Button on the Last Page
          // ElevatedButton(
          //   onPressed: () async {
          //     await DatabaseHelper().createUserDetailsTable();
          //     // Optionally show a message or navigate to another view
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('User details table created!')),
          //     );
          //   },
          //   child: const Text('Create User Details Table'),
          // ),
          if (selectPage == 3)
            Padding(
              padding: const EdgeInsets.only(top: 700),
              child: Center(
                child: Material(
                  borderRadius: BorderRadius.circular(35),
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(35),
                    onTap: () {
                      // Open Welcome Screen
                      print("Proceed to Tutorial");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpView(
                            userEmail: '',
                          ),
                        ),
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
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
}

class GradientCircularProgressPainter extends CustomPainter {
  final double value;
  final List<Color> gradientColors;

  GradientCircularProgressPainter(this.value, this.gradientColors);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background circle
    Paint backgroundPaint = Paint()
      ..color = Colors.transparent // Optional
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
        size.center(Offset.zero), size.width / 2, backgroundPaint);

    // Draw the gradient arc
    Paint gradientPaint = Paint()
      ..shader = LinearGradient(colors: gradientColors).createShader(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    double startAngle = -90 * (3.14159 / 180); // Start from the top
    double sweepAngle = value * 2 * 3.14159; // Convert percentage to radians

    canvas.drawArc(
      Offset.zero & size,
      startAngle,
      sweepAngle,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
