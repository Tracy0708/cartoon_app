import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

void main() {
  runApp(const InsideOutApp());
}

class InsideOutApp extends StatelessWidget {
  const InsideOutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inside Out Emotions',
      theme: ThemeData(
        fontFamily: 'ComicSans',
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 254, 247, 220), // Calming teal
        scaffoldBackgroundColor: const Color(
          0xFFFFF8E1,
        ), // Pastel yellow for background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8E1), // Match pastel yellow
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'ComicSans',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFB74D), // Soft orange
          ),
          iconTheme: IconThemeData(color: Color(0xFF5D5237)), // Soft brown
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _rotation;
  late Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _color = ColorTween(
      begin: const Color(
        0xFFFFF8E1,
      ), // Light pastel yellow (calming background)
      end: const Color.fromARGB(
        255,
        255,
        201,
        101,
      ), // Coral pink (emotion & warmth)
    ).animate(_controller);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (_, __, ___) => const MainTabScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _color.value,
          body: Center(
            child: Transform.rotate(
              angle: _rotation.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/inside_out_logo.png',
                      width: 300,
                    ).animate().shake(duration: 2000.ms),
                    const SizedBox(height: 30),
                    const Text(
                      'Inside Out Emotions',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(
                          color: Colors.amber,
                          strokeWidth: 6,
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .rotate(duration: 2000.ms),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Main Tab Screen to hold all the tabs
class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                centerTitle: true,
                title: const Text('Inside Out Emotions'),
                titleTextStyle: const TextStyle(
                  fontFamily: 'ComicSans',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFB74D), // Softer orange
                ),
                expandedHeight: 120.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF8E1),
                    ), // Pastel yellow
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicator: const BoxDecoration(),
                  labelColor: const Color.fromARGB(255, 93, 82, 55),
                  unselectedLabelColor: Color.fromARGB(255, 188, 180, 164),
                  labelStyle: const TextStyle(
                    fontFamily: 'ComicSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.emoji_emotions, size: 20),
                      text: 'Emotions',
                    ),
                    Tab(
                      icon: Icon(Icons.calendar_today, size: 20),
                      text: 'Mood Tracker',
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [EmotionHomePage(), MoodTrackerPage()],
          ),
        ),
      ),
    );
  }
}

class Emotion {
  final String name;
  final Color color;
  final String imagePath;
  final String message;
  final String soundFile;
  final String description;
  final List<String> activities;
  final String emoji;

  const Emotion({
    required this.name,
    required this.color,
    required this.imagePath,
    required this.message,
    required this.soundFile,
    required this.description,
    required this.activities,
    required this.emoji,
  });
}

// List of emotions data
final List<Emotion> emotions = const [
  Emotion(
    name: 'Joy',
    color: Color.fromARGB(255, 255, 196, 0),
    imagePath: 'assets/images/joy.png',
    message: 'Hi there! I am Joy, and I love happy memories!',
    soundFile: 'joy.mp3',
    description:
        'Joy is the emotion of happiness and positivity. She helps you appreciate the good things in life and find reasons to smile.',
    activities: [
      'Draw something that makes you happy',
      'Tell someone why they make you smile',
      'Jump up and down for 30 seconds',
      'Think of three things you are grateful for',
    ],
    emoji: '😊',
  ),
  Emotion(
    name: 'Sadness',
    color: Color(0xFF00B4D8),
    imagePath: 'assets/images/sad.png',
    message: 'Hello... I am Sadness. It is okay to feel down sometimes.',
    soundFile: 'sad.mp3',
    description:
        'Sadness helps you process difficult feelings and connect with others through empathy. It is okay to feel sad sometimes.',
    activities: [
      'Write about how you are feeling',
      'Listen to a calming song',
      'Ask for a hug from someone you trust',
      'Take slow, deep breaths',
    ],
    emoji: '😢',
  ),
  Emotion(
    name: 'Fear',
    color: Color(0xFF9D4EDD),
    imagePath: 'assets/images/fear.png',
    message: 'Hey! I am Fear. I help keep you safe!',
    soundFile: 'fear.mp3',
    description:
        'Fear helps protect you from danger. It makes you cautious when you need to be and helps you prepare for challenges.',
    activities: [
      'Name what you are afraid of',
      'Think of a time you overcame a fear',
      'Practice being brave for 1 minute',
      'Create a safety plan for what scares you',
    ],
    emoji: '😨',
  ),
  Emotion(
    name: 'Disgust',
    color: Color(0xFF38B000),
    imagePath: 'assets/images/disgusting.png',
    message: 'Hi! I am Disgust. I help you avoid things that are bad for you!',
    soundFile: 'disgusting.mp3',
    description:
        'Disgust helps you avoid things that might harm you or make you uncomfortable. She helps protect your physical and social well-being.',
    activities: [
      'Sort things you like and do not like',
      'Try a tiny bite of a new food',
      'Clean up something messy',
      'Make a "yuck" face in the mirror',
    ],
    emoji: '🤢',
  ),
  Emotion(
    name: 'Anger',
    color: Color.fromARGB(255, 255, 0, 0),
    imagePath: 'assets/images/angry.png',
    message: 'Hello! I am Anger. I help you stand up for yourself!',
    soundFile: 'angry.mp3',
    description:
        'Anger helps you recognize when something is not fair and gives you energy to solve problems. It helps you set boundaries.',
    activities: [
      'Squeeze a stress ball',
      'Count to 10 slowly',
      'Draw how your anger feels',
      'Say "I feel angry when..."',
    ],
    emoji: '😠',
  ),
  Emotion(
    name: 'Anxiety',
    color: Color(0xFFFF5400),
    imagePath: 'assets/images/anxiety.png',
    message: 'Hello! I am Anxiety. I help you prepare for what might go wrong!',
    soundFile: 'anxiety.mp3',
    description:
        'Anxiety helps you stay alert and aware of potential challenges, keeping you cautious. It helps you prepare for the unexpected.',
    activities: [
      'Take deep breaths',
      'Ground yourself (5-4-3-2-1 technique)',
      'Talk to someone you trust',
      'Write down your worries and leave them for later',
    ],
    emoji: '😟',
  ),
  Emotion(
    name: 'Envy',
    color: Color(0xFF006F61),
    imagePath: 'assets/images/envy.png',
    message:
        'Hello! I am Envy. I help you recognize when you desire something others have!',
    soundFile: 'envy.mp3',
    description:
        'Envy helps you acknowledge what you desire in life. It can guide you toward self-improvement by recognizing your desires.',
    activities: [
      'Reflect on what you truly want in life',
      'Write about what others have that you wish for',
      'Practice gratitude for what you already have',
      'Set personal goals to achieve your desires',
    ],
    emoji: '😒',
  ),
  Emotion(
    name: 'Embarrassment',
    color: Color(0xFFFFA7A1),
    imagePath: 'assets/images/embarrassment.png',
    message:
        'Hello! I am Embarrassment. I help you recognize when something feels awkward!',
    soundFile: 'embarrassment.mp3',
    description:
        'Embarrassment helps you understand when you feel self-conscious and guides you toward improving how you express yourself in social situations.',
    activities: [
      'Take a moment to calm yourself',
      'Remind yourself that everyone makes mistakes',
      'Practice self-compassion',
      'Talk about your experience with a trusted person',
    ],
    emoji: '😳',
  ),
  Emotion(
    name: 'Ennui',
    color: Color(0xFF6E7B8B),
    imagePath: 'assets/images/ennui.png',
    message:
        'Hello! I am Ennui. I help you recognize when you feel bored or disconnected!',
    soundFile: 'ennui.mp3',
    description:
        'Ennui helps you acknowledge when you feel disconnected from your activities and pushes you to seek meaning or change to reignite your energy.',
    activities: [
      'Try a new hobby or activity',
      'Reflect on what you are passionate about',
      'Set small goals to break the monotony',
      'Take a walk and let your mind wander',
    ],
    emoji: '😑',
  ),
];

class EmotionHomePage extends StatefulWidget {
  const EmotionHomePage({super.key});

  @override
  State<EmotionHomePage> createState() => _EmotionHomePageState();
}

class _EmotionHomePageState extends State<EmotionHomePage> {
  final player = AudioPlayer();
  int hoveredIndex = -1;
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Add scroll listener for AppBar fade effect
    _scrollController.addListener(() {
      final scrollPosition = _scrollController.position.pixels;
      final newOpacity =
          scrollPosition < 150 ? 1.0 - (scrollPosition / 150) : 0.0;
      if (newOpacity != _appBarOpacity) {
        setState(() {
          _appBarOpacity = newOpacity;
        });
      }
    });
  }

  void _playWithFeedback(Emotion emotion) {
    // Play the audio
    player.play(AssetSource('sounds/${emotion.soundFile}'));

    // Set a timer to stop after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      player.stop();
    });

    // Show dialog
    showDialog(
      context: context,
      builder: (context) => _buildEmotionDialog(emotion),
    ).then((_) {
      player.stop();
    });
  }

  Widget _buildEmotionDialog(Emotion emotion) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with image
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: emotion.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      emotion.imagePath,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Emotion name
                  Text(
                    '${emotion.name} ${emotion.emoji}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: emotion.color,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Content area
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Message
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: emotion.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: emotion.color.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            emotion.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),

                        // Description
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            emotion.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),

                        // Activities
                        const Text(
                          'Things to Try:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...emotion.activities.map(
                          (activity) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: emotion.color,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    activity,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Button area with proper spacing
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          player.stop();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: emotion.color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 3,
                        ),
                        child: const Text(
                          'GOT IT!',
                          style: TextStyle(fontSize: 18),
                        ),
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

  void _hoverEffect(int index, bool isHovering) {
    setState(() {
      hoveredIndex = isHovering ? index : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF8F4E3)],
        ),
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // This will catch scroll events from GridView
          return false;
        },
        child: GridView.builder(
          controller: _scrollController, // Add scroll controller here
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: emotions.length,
          itemBuilder: (context, index) {
            // Rest of the method stays the same
            final emotion = emotions[index];
            // Existing code...
            return MouseRegion(
              onEnter: (_) => _hoverEffect(index, true),
              onExit: (_) => _hoverEffect(index, false),
              child: GestureDetector(
                onTap: () => _playWithFeedback(emotion),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform:
                      Matrix4.identity()
                        ..scale(hoveredIndex == index ? 1.05 : 1.0),
                  child: Card(
                    elevation: hoveredIndex == index ? 12 : 4,
                    shadowColor: emotion.color.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color:
                            hoveredIndex == index
                                ? emotion.color
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              hoveredIndex == index
                                  ? Colors.white
                                  : emotion.color.withOpacity(0.7),
                              hoveredIndex == index
                                  ? emotion.color.withOpacity(0.2)
                                  : emotion.color,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                      emotion.imagePath,
                                      fit: BoxFit.contain,
                                    )
                                    .animate(
                                      onPlay:
                                          (controller) =>
                                              controller.repeat(reverse: true),
                                    )
                                    .scale(
                                      duration: const Duration(seconds: 2),
                                      begin: const Offset(0.95, 0.95),
                                      end: const Offset(1.05, 1.05),
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      hoveredIndex == index
                                          ? emotion.color.withOpacity(0.2)
                                          : Colors.black26,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        emotion.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              hoveredIndex == index
                                                  ? emotion.color
                                                  : Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black54,
                                              offset: const Offset(1, 1),
                                              blurRadius:
                                                  hoveredIndex == index ? 0 : 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        emotion.emoji,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }
}

// Mood Tracker Page
class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  // Map to store mood data: date string -> emotion name
  final Map<String, String> _moodData = {};
  DateTime _selectedDate = DateTime.now();
  String? _selectedEmotion;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load some sample data
    final now = DateTime.now();
    _moodData[_formatDate(now)] = 'Joy';
    _moodData[_formatDate(now.subtract(const Duration(days: 1)))] = 'Sadness';
    _moodData[_formatDate(now.subtract(const Duration(days: 2)))] = 'Anger';
    _moodData[_formatDate(now.subtract(const Duration(days: 4)))] = 'Fear';
    _moodData[_formatDate(now.subtract(const Duration(days: 6)))] = 'Joy';
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Color _getEmotionColor(String emotionName) {
    final emotion = emotions.firstWhere(
      (e) => e.name == emotionName,
      orElse: () => emotions[0], // default to Joy if not found
    );
    return emotion.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.amber.shade50],
        ),
      ),
      // Use SafeArea to ensure the content respects system UI elements
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Use a LayoutBuilder to be responsive to different screen sizes
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Calendar section
                        Card(
                          elevation:
                              2, // Reduced elevation for more subtle shadows
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "My Mood Calendar",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildCalendar(),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Current mood section
                        Card(
                          elevation:
                              2, // Reduced elevation for more subtle shadows
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "How are you feeling on ${_selectedDate.day}/${_selectedDate.month}?",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Emotion selector with images
                                Container(
                                  height:
                                      220, // Increased height for better visibility
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SingleChildScrollView(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(8),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            childAspectRatio:
                                                0.8, // Adjusted for image and text
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                          ),
                                      itemCount: emotions.length,
                                      itemBuilder: (context, index) {
                                        final emotion = emotions[index];
                                        final isSelected =
                                            _selectedEmotion == emotion.name;
                                        final formattedDate = _formatDate(
                                          _selectedDate,
                                        );
                                        final isSavedEmotion =
                                            _moodData[formattedDate] ==
                                            emotion.name;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedEmotion = emotion.name;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  (isSelected || isSavedEmotion)
                                                      ? emotion.color
                                                          .withOpacity(0.1)
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    (isSelected ||
                                                            isSavedEmotion)
                                                        ? emotion.color
                                                        : Colors.grey.shade200,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                if (isSelected ||
                                                    isSavedEmotion)
                                                  BoxShadow(
                                                    color: emotion.color
                                                        .withOpacity(0.2),
                                                    blurRadius: 8,
                                                    spreadRadius: 1,
                                                  ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Emotion Image
                                                Image.asset(
                                                  emotion.imagePath,
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.contain,
                                                ),
                                                const SizedBox(height: 4),
                                                // Emotion Name
                                                Text(
                                                  emotion.name,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        (isSelected ||
                                                                isSavedEmotion)
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    color:
                                                        (isSelected ||
                                                                isSavedEmotion)
                                                            ? emotion.color
                                                            : Colors.black87,
                                                  ),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Note TextField with enhanced styling
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: TextField(
                                    controller: _noteController,
                                    decoration: InputDecoration(
                                      hintText: "How are you feeling today?",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color:
                                              _selectedEmotion != null
                                                  ? _getEmotionColor(
                                                    _selectedEmotion!,
                                                  )
                                                  : Colors.grey.shade400,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                    ),
                                    maxLines: 3,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Save button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        _selectedEmotion == null
                                            ? null
                                            : () {
                                              final formattedDate = _formatDate(
                                                _selectedDate,
                                              );
                                              setState(() {
                                                _moodData[formattedDate] =
                                                    _selectedEmotion!;
                                              });

                                              // Show feedback
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Mood saved for ${_selectedDate.month}/${_selectedDate.day}",
                                                  ),
                                                  backgroundColor:
                                                      _getEmotionColor(
                                                        _selectedEmotion!,
                                                      ),
                                                ),
                                              );

                                              // Clear note
                                              _noteController.clear();
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _selectedEmotion != null
                                              ? _getEmotionColor(
                                                _selectedEmotion!,
                                              )
                                              : const Color(
                                                0xFFADADAD,
                                              ), // Softer grey when disabled
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      elevation: 1, // Subtle elevation
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "SAVE MY MOOD",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    );
  }

  Widget _buildCalendar() {
    final daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      1,
    );
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;

    // Build calendar header
    final List<Widget> calendarCells = [
      ...['S', 'M', 'T', 'W', 'T', 'F', 'S'].map(
        (day) => Container(
          alignment: Alignment.center,
          child: Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 12, // Reduced font size
            ),
          ),
        ),
      ),
    ];

    // Add empty cells for days before the first day of month
    for (int i = 0; i < firstWeekdayOfMonth; i++) {
      calendarCells.add(Container());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedDate.year, _selectedDate.month, day);
      final formattedDate = _formatDate(date);
      final emotion = _moodData[formattedDate];
      final isToday =
          date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;
      final isSelected =
          date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;

      // Get emotion color for cell background
      Color? cellColor;
      if (emotion != null) {
        // Find the emotion and get its color
        final emotionObj = emotions.firstWhere((e) => e.name == emotion);
        cellColor = emotionObj.color.withOpacity(
          0.3,
        ); // Use emotion color with transparency
      } else if (isToday) {
        cellColor = Colors.blue.withOpacity(0.1);
      }

      calendarCells.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
              _selectedEmotion = emotion;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border:
                  isSelected ? Border.all(color: Colors.blue, width: 2) : null,
              borderRadius: BorderRadius.circular(8),
              color: cellColor, // Use the emotion color or default
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 12, // Reduced font size
                    fontWeight:
                        isToday || isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        emotion != null && !isSelected
                            ? _getEmotionColor(emotion)
                            : null, // Darker text color for contrast
                  ),
                ),
                if (emotion != null) ...[
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 16, // Smaller size
                    height: 16, // Smaller size
                    child: Image.asset(
                      emotions.firstWhere((e) => e.name == emotion).imagePath,
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                setState(() {
                  _selectedDate = DateTime(
                    _selectedDate.year,
                    _selectedDate.month - 1,
                    1,
                  );
                });
              },
            ),
            Text(
              "${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                setState(() {
                  _selectedDate = DateTime(
                    _selectedDate.year,
                    _selectedDate.month + 1,
                    1,
                  );
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Calendar grid
        AspectRatio(
          aspectRatio: 1.2,
          child: GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4, // Reduced spacing
            crossAxisSpacing: 4, // Reduced spacing
            children: calendarCells,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodStat(String emotionName, Color color) {
    // Count occurrences of this emotion in the current month
    int count = 0;
    for (final entry in _moodData.entries) {
      if (entry.value == emotionName) {
        final parts = entry.key.split('-');
        final month = int.parse(parts[1]);
        if (month == _selectedDate.month) {
          count++;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text('$count', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
