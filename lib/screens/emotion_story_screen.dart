import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/emotion.dart';

class EmotionStoryScreen extends StatefulWidget {
  final Emotion emotion;

  const EmotionStoryScreen({super.key, required this.emotion});

  @override
  State<EmotionStoryScreen> createState() => _EmotionStoryScreenState();
}

class _EmotionStoryScreenState extends State<EmotionStoryScreen> {
  final player = AudioPlayer();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    player.play(AssetSource('sounds/story_bgm.mp3'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyPages = widget.emotion.storyPages;

    return Scaffold(
      backgroundColor: widget.emotion.color.withOpacity(0.1),
      appBar: AppBar(
        title: Text(
          widget.emotion.storyTitle.isEmpty
              ? "${widget.emotion.name}'s Story"
              : widget.emotion.storyTitle,
          style: TextStyle(color: widget.emotion.color),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: widget.emotion.color),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: List.generate(
                  storyPages.length,
                  (index) => Expanded(
                    child: Container(
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _currentPage >= index
                            ? widget.emotion.color
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Story card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: widget.emotion.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                storyPages[_currentPage],
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              )
                                  .animate()
                                  .fadeIn(duration: 300.ms)
                                  .slideY(begin: 0.2, end: 0, duration: 300.ms),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentPage--;
                            });
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("BACK"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: widget.emotion.color,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: widget.emotion.color),
                            ),
                          ),
                        )
                      : const SizedBox(width: 100),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_currentPage < storyPages.length - 1) {
                        setState(() {
                          _currentPage++;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(
                      _currentPage < storyPages.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                    ),
                    label: Text(
                      _currentPage < storyPages.length - 1 ? "NEXT" : "FINISH",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.emotion.color,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
