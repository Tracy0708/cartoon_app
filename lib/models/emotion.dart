import 'package:flutter/material.dart';

class Emotion {
  final String name;
  final Color color;
  final String imagePath;
  final String message;
  final String soundFile;
  final String description;
  final List<String> activities;
  final String emoji;
  final String simpleDescription;
  final String achievementName;
  final String storyTitle;
  final List<String> storyPages;

  const Emotion({
    required this.name,
    required this.color,
    required this.imagePath,
    required this.message,
    required this.soundFile,
    required this.description,
    required this.activities,
    required this.emoji,
    required this.simpleDescription,
    required this.achievementName,
    required this.storyTitle,
    required this.storyPages,
  });
}
