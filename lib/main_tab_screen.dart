import 'package:flutter/material.dart';
import 'models/emotion.dart';
import 'widgets/simple_mood_selector.dart';
import 'widgets/emotion_achievement_banner.dart';
import 'services/achievements_service.dart';
import 'data/achievements_data.dart';
import 'screens/emotion_story_screen.dart';
import 'screens/breathing_exercise_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;
  Emotion? _selectedEmotion;
  Achievement? _latestAchievement;

  // Sample emotions data - in a real app, this would be loaded from a database
  final List<Emotion> _emotions = [
    const Emotion(
      name: 'Joy',
      color: Color(0xFFFFC107),
      imagePath: 'assets/images/joy.png',
      message: 'You\'re feeling happy and energetic!',
      soundFile: 'sounds/joy.mp3',
      description:
          'Joy is the feeling of happiness and pleasure. It gives you energy and makes you want to play and share your happiness with others.',
      activities: [
        'Tell someone a joke',
        'Draw something happy',
        'Dance to your favorite song',
      ],
      emoji: '😀',
      simpleDescription: 'Happy and excited!',
      achievementName: 'Happiness Hunter',
      storyTitle: 'The Joy Adventure',
      storyPages: [
        'Once upon a time, there was a little cloud named Joy.',
        'Joy loved to see children playing and laughing.',
        'One day, Joy decided to join them and make the day brighter!',
        'The more Joy smiled, the more the world around her smiled.',
        'And so, Joy continued to spread happiness wherever she went!',
      ],
    ),
    const Emotion(
      name: 'Sadness',
      color: Color(0xFF42A5F5),
      imagePath: 'assets/images/sadness.png',
      message: 'It\'s okay to feel sad sometimes.',
      soundFile: 'sounds/sadness.mp3',
      description:
          'Sadness helps us connect with others when we\'re hurt or have lost something important. It\'s okay to feel sad.',
      activities: [
        'Talk to someone you trust',
        'Listen to calm music',
        'Draw how you feel',
      ],
      emoji: '😢',
      simpleDescription: 'Feeling down and quiet',
      achievementName: 'Gentle Tears',
      storyTitle: 'Sadness and the Rainy Day',
      storyPages: [
        'Sadness woke up to a cloudy, rainy morning.',
        'She saw puddles forming and people rushing with umbrellas.',
        'Instead of hiding, Sadness decided to walk slowly through the rain.',
        'As she walked, she noticed a lonely flower drooping by the sidewalk.',
        'She gently covered it with a leaf and whispered, "You’re not alone."',
      ],
    ),
    const Emotion(
      name: 'Anger',
      color: Color(0xFFEF5350),
      imagePath: 'assets/images/anger.png',
      message: 'Take a deep breath when you\'re angry.',
      soundFile: 'sounds/anger.mp3',
      description:
          'Anger tells us when something isn\'t fair. It gives us energy to solve problems, but we need to control it.',
      activities: [
        'Count to 10 slowly',
        'Draw your angry feelings',
        'Find a quiet place to calm down',
      ],
      emoji: '😠',
      simpleDescription: 'Hot and bothered',
      achievementName: 'Calm Controller',
      storyTitle: 'Anger\'s Loud Voice',
      storyPages: [
        'Anger was having a tough day. Nothing felt fair!',
        'He stomped through the playground, growling loudly.',
        'Then he saw his friend crying because he broke his toy.',
        'Anger took a deep breath and sat beside him.',
        '"Let’s fix it together," he said, letting his loud voice soften.',
      ],
    ),
    const Emotion(
      name: 'Fear',
      color: Color(0xFF9C27B0),
      imagePath: 'assets/images/fear.png',
      message: 'Everyone gets scared sometimes.',
      soundFile: 'sounds/fear.mp3',
      description:
          'Fear protects you by warning you about danger. It\'s a natural feeling that helps keep you safe.',
      activities: [
        'Take deep breaths',
        'Name what scares you',
        'Ask for a hug',
      ],
      emoji: '😨',
      simpleDescription: 'Worried and scared',
      achievementName: 'Brave Heart',
      storyTitle: 'Fear and the Dark Room',
      storyPages: [
        'Fear found himself in a big, dark room.',
        'His heart beat fast, and his feet froze in place.',
        'He remembered what his friend said: "Fear can be a flashlight."',
        'He took a deep breath and turned on his small lantern.',
        'Step by step, he walked through the room and discovered it wasn’t so scary after all.',
      ],
    ),
    const Emotion(
      name: 'Disgust',
      color: Color(0xFF66BB6A),
      imagePath: 'assets/images/disgust.png',
      message: 'Your disgust protects you from things that might be harmful.',
      soundFile: 'sounds/disgust.mp3',
      description:
          'Disgust helps protect you from things that might make you sick or that you don\'t like.',
      activities: [
        'Move away from what bothers you',
        'Find something nice to focus on',
        'Tell someone what bothers you',
      ],
      emoji: '🤢',
      simpleDescription: 'Yucky feeling',
      achievementName: 'Taste Detective',
      storyTitle: 'Disgust and the New Food',
      storyPages: [
        'Disgust looked at the strange green blob on her plate.',
        '"Ew! What *is* this?" she said with a frown.',
        'Her friend smiled and said, "It’s called guacamole. Want to try?"',
        'Disgust wrinkled her nose but decided to take a tiny bite.',
        'To her surprise, it wasn’t so bad. "Hmm... maybe I was wrong!"',
      ],
    ),
    const Emotion(
      name: 'Anxiety',
      color: Color(0xFFFF5400),
      imagePath: 'assets/images/anxiety.png',
      message:
          'Hello! I am Anxiety. I help you prepare for what might go wrong!',
      soundFile: 'sounds/anxiety.mp3',
      description:
          'Anxiety helps you stay alert and aware of potential challenges, keeping you cautious. It helps you prepare for the unexpected.',
      activities: [
        'Take deep breaths',
        'Ground yourself (5-4-3-2-1 technique)',
        'Talk to someone you trust',
        'Write down your worries and leave them for later',
      ],
      emoji: '😟',
      simpleDescription: 'Nervous but watchful',
      achievementName: 'Prepared Pathfinder',
      storyTitle: 'Anxiety and the What-If Monster',
      storyPages: [
        'Anxiety kept thinking, "What if I forget my lines in the play?"',
        '"What if everyone laughs at me?" the What-If Monster whispered.',
        'Anxiety sat down, took a deep breath, and practiced slowly.',
        'On the day of the play, the What-If Monster shrank to the size of a pebble.',
        'Anxiety stepped on stage and said, "I’m ready."',
      ],
    ),

    const Emotion(
      name: 'Envy',
      color: Color(0xFF006F61),
      imagePath: 'assets/images/envy.png',
      message:
          'Hello! I am Envy. I help you recognize when you desire something others have!',
      soundFile: 'sounds/envy.mp3',
      description:
          'Envy helps you acknowledge what you desire in life. It can guide you toward self-improvement by recognizing your desires.',
      activities: [
        'Reflect on what you truly want in life',
        'Write about what others have that you wish for',
        'Practice gratitude for what you already have',
        'Set personal goals to achieve your desires',
      ],
      emoji: '😒',
      simpleDescription: 'Longing and reflective',
      achievementName: 'Green-Eyed Grower',
      storyTitle: 'Envy and the Shiny Toy',
      storyPages: [
        'Envy saw his friend with a shiny new robot toy.',
        'He frowned and thought, "Why don’t I have something like that?"',
        'His friend noticed and said, "Want to play with it together?"',
        'They played, laughed, and built a cardboard robot from boxes.',
        'Envy smiled. "It’s not about having, it’s about sharing."',
      ],
    ),

    const Emotion(
      name: 'Embarrassment',
      color: Color(0xFFFFA7A1),
      imagePath: 'assets/images/embarrassment.png',
      message:
          'Hello! I am Embarrassment. I help you recognize when something feels awkward!',
      soundFile: 'sounds/embarrassment.mp3',
      description:
          'Embarrassment helps you understand when you feel self-conscious and guides you toward improving how you express yourself in social situations.',
      activities: [
        'Take a moment to calm yourself',
        'Remind yourself that everyone makes mistakes',
        'Practice self-compassion',
        'Talk about your experience with a trusted person',
      ],
      emoji: '😳',
      simpleDescription: 'Awkward and bashful',
      achievementName: 'Brave Blusher',
      storyTitle: 'Embarrassment’s Oops Moment',
      storyPages: [
        'Embarrassment slipped on a banana peel in front of everyone.',
        'His cheeks turned red and he wanted to disappear.',
        'Then someone clapped and said, "Nice slide!"',
        'Everyone started laughing *with* him, not *at* him.',
        'Embarrassment giggled too and said, "Oops happens!"',
      ],
    ),

    const Emotion(
      name: 'Ennui',
      color: Color(0xFF6E7B8B),
      imagePath: 'assets/images/ennui.png',
      message:
          'Hello! I am Ennui. I help you recognize when you feel bored or disconnected!',
      soundFile: 'sounds/ennui.mp3',
      description:
          'Ennui helps you acknowledge when you feel disconnected from your activities and pushes you to seek meaning or change to reignite your energy.',
      activities: [
        'Try a new hobby or activity',
        'Reflect on what you are passionate about',
        'Set small goals to break the monotony',
        'Take a walk and let your mind wander',
      ],
      emoji: '😑',
      simpleDescription: 'Bored and blah',
      achievementName: 'Motivation Seeker',
      storyTitle: 'Ennui and the Missing Spark',
      storyPages: [
        'Ennui sat on the couch, feeling bored and restless.',
        'Nothing felt fun, and everything seemed dull.',
        'He wandered outside and saw a colorful chalk drawing.',
        '"Want to help?" a kid asked, handing him some chalk.',
        'Together, they filled the sidewalk with bright, happy art.',
      ],
    ),
  ];

  void _selectEmotion(Emotion emotion) async {
    setState(() {
      _selectedEmotion = emotion;
    });

    // Check for achievements
    final newAchievement = await AchievementsData.checkAndAwardAchievement(
      emotion,
      'first_log',
      {'streak': 1}, // Sample stats
    );

    if (newAchievement != null) {
      setState(() {
        _latestAchievement = newAchievement;
      });
    }
  }

  void _dismissAchievement() {
    setState(() {
      _latestAchievement = null;
    });
  }

  void _startBreathingExercise() async {
    if (_selectedEmotion == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BreathingExerciseScreen(emotion: _selectedEmotion!),
      ),
    );

    if (result == true) {
      // Check for achievements
      final newAchievement = await AchievementsData.checkAndAwardAchievement(
        _selectedEmotion!,
        'breathing',
        {}, // Sample stats
      );

      if (newAchievement != null) {
        setState(() {
          _latestAchievement = newAchievement;
        });
      }
    }
  }

  void _openEmotionStory() async {
    if (_selectedEmotion == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmotionStoryScreen(emotion: _selectedEmotion!),
      ),
    );

    // Check for achievements
    final newAchievement = await AchievementsData.checkAndAwardAchievement(
      _selectedEmotion!,
      'story',
      {}, // Sample stats
    );

    if (newAchievement != null) {
      setState(() {
        _latestAchievement = newAchievement;
      });
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mood selector
          SimpleMoodSelector(
            emotions: _emotions,
            onEmotionSelected: _selectEmotion,
            selectedEmotion: _selectedEmotion,
          ),

          const SizedBox(height: 24),

          // Selected emotion card
          if (_selectedEmotion != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedEmotion!.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _selectedEmotion!.color, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _selectedEmotion!.color.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          _selectedEmotion!.imagePath,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedEmotion!.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _selectedEmotion!.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedEmotion!.message,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedEmotion!.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Things that might help:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ActionButton(
                        label: "Breathing",
                        icon: Icons.air,
                        color: _selectedEmotion!.color,
                        onTap: _startBreathingExercise,
                      ),
                      ActionButton(
                        label: "Story",
                        icon: Icons.book,
                        color: _selectedEmotion!.color,
                        onTap: _openEmotionStory,
                      ),
                      ActionButton(
                        label: "Activities",
                        icon: Icons.lightbulb_outline,
                        color: _selectedEmotion!.color,
                        onTap: () {
                          // Show activities dialog
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    "${_selectedEmotion!.name} Activities",
                                    style: TextStyle(
                                      color: _selectedEmotion!.color,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                        _selectedEmotion!.activities
                                            .map(
                                              (activity) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color:
                                                          _selectedEmotion!
                                                              .color,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        activity,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "CLOSE",
                                        style: TextStyle(
                                          color: _selectedEmotion!.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  "How are you feeling today? Select an emotion above!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Daily tip
          Card(
            elevation: 3,
            color: const Color.fromARGB(255, 248, 255, 251),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Tip of the Day",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "All emotions are important and help us understand how we're feeling. There are no 'bad' emotions!",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "(COMING SOON)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Journal tab - track your emotions over time",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "(COMING SOON)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Achievements tab - see your emotional growth journey",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inside Out Emotions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 248, 255, 251),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeTab(),
              _buildJournalTab(),
              _buildAchievementsTab(),
            ],
          ),

          // Achievement notification
          if (_latestAchievement != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: EmotionAchievementBanner(
                achievementText:
                    "${_latestAchievement!.title}: ${_latestAchievement!.description}",
                color:
                    _emotions
                        .firstWhere(
                          (e) => e.name == _latestAchievement!.emotionName,
                          orElse: () => _emotions.first,
                        )
                        .color,
                onClose: _dismissAchievement,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 248, 255, 251),
        selectedItemColor: const Color.fromARGB(255, 62, 168, 156),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Awards',
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
