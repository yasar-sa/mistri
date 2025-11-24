import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mistri/intro_screens/intro_page1.dart';
import 'package:mistri/intro_screens/intro_page2.dart';
import 'package:mistri/intro_screens/intro_page3.dart';
import 'package:mistri/home_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }

  Future<void> _goToHomeReplacement() async {
    await _setOnboardingSeen();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _goNext() {
    if (currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _goToHomeReplacement();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with intro pages. Pass callbacks so child pages never need controller directly.
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              IntroPage1(onNext: _goNext, onSkip: _goToHomeReplacement),
              IntroPage2(onNext: _goNext, onSkip: _goToHomeReplacement),
              IntroPage3(onNext: _goNext, onSkip: _goToHomeReplacement),
            ],
          ),

          // bottom controls (Skip / indicator / Next)
          SafeArea(
            child: Align(
              alignment: const Alignment(0, 0.9),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip -> mark seen and go to home
                    TextButton(
                      onPressed: _goToHomeReplacement,
                      child: const Text("Skip"),
                    ),

                    // SmoothPageIndicator wired to controller
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: const Color(0xFFF1A950),
                        dotColor: Colors.grey.shade300,
                        spacing: 8,
                      ),
                    ),

                    // Next / Done button
                    TextButton(
                      onPressed: _goNext,
                      child: Text(currentPage == 2 ? "Done" : "Next"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
