import 'package:flutter/material.dart';

class OnboardTemplate extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  const OnboardTemplate({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onNext,
    this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4D8), // beige background from your UI
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top-right Skip (child will receive onSkip from parent)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: onSkip,
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Metropolis",
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Rounded image container
              Container(
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.hardEdge,
                child: _buildImageWidget(image),
              ),

              const SizedBox(height: 40),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Metropolis",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 14),

              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: "Metropolis",
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Dots row: NOTE: the parent PageView + SmoothPageIndicator already shows dots,
              // this static row is optional if you prefer the custom look inside each page.
              // (In this implementation the main indicator is handled by the parent.)
              // SizedBox for spacing and the Next button below
              const SizedBox(height: 8),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1A950),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next",
                        style: TextStyle(
                          fontFamily: "Metropolis",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Build image — tries to use Image.asset if path looks like an asset, otherwise Image.file/Network etc.
  Widget _buildImageWidget(String path) {
    // The environment/tooling may transform the '/mnt/data/...' path into an accessible asset/URL.
    // Try to detect common cases. If you prefer always using an asset, pass assets/images/... instead.
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(path, fit: BoxFit.cover);
    } else if (path.startsWith('/')) {
      // Local absolute file path — in some tooling this will be converted to a URL for preview.
      // Use Image.asset if you have placed the file into assets and updated pubspec.yaml.
      // For safety, attempt to load as asset first, then fallback to file.
      try {
        return Image.asset(path, fit: BoxFit.cover);
      } catch (_) {
        // fallback: show placeholder if asset not found (caller should update path)
        return Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
        );
      }
    } else {
      // assume asset path like 'assets/images/onboard1.png'
      return Image.asset(path, fit: BoxFit.cover);
    }
  }
}
