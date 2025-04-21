import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/emotion.dart';

class SimpleMoodSelector extends StatelessWidget {
  final List<Emotion> emotions;
  final Function(Emotion) onEmotionSelected;
  final Emotion? selectedEmotion;

  SimpleMoodSelector({
    super.key,
    required this.emotions,
    required this.onEmotionSelected,
    this.selectedEmotion,
  });

  // Initialize the AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Function to play the selected sound
  void _playSound(String soundPath) async {
    await _audioPlayer.play(AssetSource(soundPath));
    // Stop after 3 seconds (3000 ms)
    Future.delayed(const Duration(seconds: 3), () {
      _audioPlayer.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "How do you feel today?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: emotions.length,
              itemBuilder: (context, index) {
                final emotion = emotions[index];
                final isSelected = selectedEmotion?.name == emotion.name;

                return GestureDetector(
                  onTap: () {
                    // Play the sound when an emotion is selected
                    _playSound(emotion.soundFile); // Add this to play sound
                    onEmotionSelected(emotion);
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? emotion.color.withOpacity(0.2)
                              : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected ? emotion.color : Colors.grey.shade200,
                        width: 2,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: emotion.color.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          emotion.imagePath,
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emotion.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color: isSelected ? emotion.color : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
