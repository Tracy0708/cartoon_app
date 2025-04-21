import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmotionAchievementBanner extends StatelessWidget {
  final String achievementText;
  final Color color;
  final VoidCallback onClose;

  const EmotionAchievementBanner({
    super.key,
    required this.achievementText,
    required this.color,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/star.png', // Add a star icon to assets
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'New Achievement!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  achievementText,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            color: color,
          ),
        ],
      ).animate().fadeIn(duration: 500.ms).then().shake(duration: 500.ms),
    );
  }
}