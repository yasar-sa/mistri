import 'package:flutter/material.dart';
import '../widgets/onboard_template.dart';

class IntroPage3 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const IntroPage3({Key? key, required this.onNext, required this.onSkip})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardTemplate(
      // NOTE: using the uploaded file path — your environment/tooling will transform this path as needed.
      image: '/assets/images/onboarding_screen_3.png',
      title: 'Find Verified Workers',
      subtitle:
          'Connect with skilled masons, electricians, painters, and plumbers. All workers are verified and rated by the community.',
      onNext: onNext,
      onSkip: onSkip,
      // You can pass an 'activeDotIndex' if you extend the template for dynamic dots.
    );
  }
}
