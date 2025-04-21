import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this dependency
import '../main_tab_screen.dart'; // You'll need to move MainTabScreen to its own file

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Welcome to Inside Out Emotions!',
      'description':
          'Learn about your feelings and how to understand them better.',
      'image': 'assets/images/onboarding_1.png',
      'color': const Color(0xFFFFB74D),
    },
    {
      'title': 'Meet Your Emotions',
      'description':
          'Joy, Sadness, Fear, Anger and more - they\'re all important!',
      'image': 'assets/images/onboarding_2.png',
      'color': const Color(0xFF00B4D8),
    },
    {
      'title': 'Track How You Feel',
      'description':
          'Keep track of your feelings day by day and learn from them.',
      'image': 'assets/images/onboarding_3.jpg',
      'color': const Color(0xFF38B000),
    },
    {
      'title': 'Let\'s Begin!',
      'description': 'Tap the button below to start your emotional journey!',
      'image': 'assets/images/onboarding_4.jpg',
      'color': const Color(0xFFFF5400),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    // Save that onboarding is complete
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);

    if (!mounted) return;

    // Navigate to main app
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (_, __, ___) => const MainTabScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color that changes with page
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _pages[_currentPage]['color'].withOpacity(0.3),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Page content
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Image
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Image.asset(
                              _pages[index]['image'],
                              fit: BoxFit.contain,
                            )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 500.ms,
                            ),
                      ),
                    ),

                    // Text content
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                                  _pages[index]['title'],
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: _pages[index]['color'],
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                .animate()
                                .fadeIn(delay: 200.ms)
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  delay: 200.ms,
                                  duration: 400.ms,
                                ),
                            const SizedBox(height: 10),
                            Text(
                                  _pages[index]['description'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                .animate()
                                .fadeIn(delay: 400.ms)
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  delay: 400.ms,
                                  duration: 400.ms,
                                ),
                          ],
                        ),
                      ),
                    ),

                    // Last page has a different button
                    if (index == _pages.length - 1)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                              onPressed: _completeOnboarding,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _pages[index]['color'],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'START NOW',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              delay: 600.ms,
                              duration: 400.ms,
                            ),
                      ),
                  ],
                ),
              );
            },
          ),

          // Page indicator dots
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 20 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? _pages[_currentPage]['color']
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),

          // Skip button
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: _pages[_currentPage]['color'],
                    fontSize: 16,
                  ),
                ),
              ),
            ),

          // Back button (except on first page)
          if (_currentPage > 0)
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: _pages[_currentPage]['color'],
                ),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),

          // Next button (except on last page)
          if (_currentPage < _pages.length - 1)
            Positioned(
              bottom: 80,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: _pages[_currentPage]['color'],
                child: const Icon(Icons.arrow_forward),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
