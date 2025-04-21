import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String emotionName;
  final DateTime dateEarned;
  
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emotionName,
    required this.dateEarned,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'emotionName': emotionName,
      'dateEarned': dateEarned.toIso8601String(),
    };
  }
  
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      emotionName: json['emotionName'],
      dateEarned: DateTime.parse(json['dateEarned']),
    );
  }
}

class AchievementsService {
  static const String _storageKey = 'user_achievements';
  
  // Save a new achievement
  static Future<void> addAchievement(Achievement achievement) async {
    final prefs = await SharedPreferences.getInstance();
    final achievements = await getAchievements();
    
    // Check if already earned
    if (achievements.any((a) => a.id == achievement.id)) {
      return; // Already earned, don't duplicate
    }
    
    achievements.add(achievement);
    await prefs.setString(
      _storageKey, 
      jsonEncode(achievements.map((a) => a.toJson()).toList()),
    );
  }
  
  // Get all earned achievements
  static Future<List<Achievement>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString(_storageKey);
    
    if (achievementsJson == null) {
      return [];
    }
    
    final List<dynamic> decodedList = jsonDecode(achievementsJson);
    return decodedList
        .map((json) => Achievement.fromJson(json as Map<String, dynamic>))
        .toList();
  }
  
  // Check if achievement exists
  static Future<bool> hasAchievement(String achievementId) async {
    final achievements = await getAchievements();
    return achievements.any((a) => a.id == achievementId);
  }
  
  // Get achievement count
  static Future<int> getAchievementCount() async {
    final achievements = await getAchievements();
    return achievements.length;
  }
  
  // Get achievements for a specific emotion
  static Future<List<Achievement>> getAchievementsForEmotion(String emotionName) async {
    final achievements = await getAchievements();
    return achievements.where((a) => a.emotionName == emotionName).toList();
  }
  
  // Clear achievements (for testing/reset purposes)
  static Future<void> clearAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}