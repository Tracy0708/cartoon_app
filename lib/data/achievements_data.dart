import '../models/emotion.dart';
import '../services/achievements_service.dart';

class AchievementsData {
  // Generate achievement for a specific emotion
  static Achievement createEmotionAchievement(Emotion emotion, String actionType) {
    final now = DateTime.now();
    String id;
    String title;
    String description;
    
    switch (actionType) {
      case 'first_log':
        id = 'first_${emotion.name.toLowerCase()}';
        title = "First ${emotion.name}";
        description = "You identified feeling ${emotion.name} for the first time!";
        break;
      case 'breathing':
        id = 'breathing_${emotion.name.toLowerCase()}';
        title = "Calm ${emotion.name}";
        description = "You completed a breathing exercise while feeling ${emotion.name}.";
        break;
      case 'story':
        id = 'story_${emotion.name.toLowerCase()}';
        title = "${emotion.name} Storyteller";
        description = "You read the complete story about ${emotion.name}.";
        break;
      case 'activities':
        id = 'activities_${emotion.name.toLowerCase()}';
        title = "${emotion.name} Explorer";
        description = "You tried an activity to help with ${emotion.name}.";
        break;
      case 'streak':
        id = 'streak_${emotion.name.toLowerCase()}';
        title = "${emotion.name} Friend";
        description = "You logged ${emotion.name} 3 days in a row.";
        break;
      default:
        id = 'interact_${emotion.name.toLowerCase()}';
        title = "Meeting ${emotion.name}";
        description = "You learned about ${emotion.name}.";
    }
    
    return Achievement(
      id: id,
      title: title,
      description: description,
      emotionName: emotion.name,
      dateEarned: now,
    );
  }
  
  // Pre-defined achievements list
  static List<Map<String, String>> getStandardAchievements() {
    return [
      {
        'id': 'first_week',
        'title': 'One Week Journey',
        'description': 'You used the app for 7 days!'
      },
      {
        'id': 'emotion_master',
        'title': 'Emotion Master',
        'description': 'You identified all core emotions at least once.'
      },
      {
        'id': 'breathing_expert',
        'title': 'Breathing Expert',
        'description': 'You completed 10 breathing exercises.'
      },
      {
        'id': 'storyteller',
        'title': 'Storyteller',
        'description': 'You read all emotion stories.'
      },
      {
        'id': 'daily_logger',
        'title': 'Feelings Tracker',
        'description': 'You logged your feelings for 5 days in a row.'
      },
      {
        'id': 'emotion_explorer',
        'title': 'Emotion Explorer',
        'description': 'You tried activities for 3 different emotions.'
      },
    ];
  }
  
  // Method to check and award achievements based on user actions
  static Future<Achievement?> checkAndAwardAchievement(
    Emotion emotion, 
    String actionType,
    Map<String, dynamic> stats, // Pass user stats like streak counts, etc.
  ) async {
    // Create the potential achievement
    final achievement = createEmotionAchievement(emotion, actionType);
    
    // Check if already earned
    final hasAlready = await AchievementsService.hasAchievement(achievement.id);
    if (hasAlready) {
      return null; // Already has this achievement
    }
    
    // Additional logic for achievements that require specific conditions
    if (actionType == 'streak' && (stats['streak'] ?? 0) < 3) {
      return null; // Streak not long enough
    }
    
    // Save the achievement
    await AchievementsService.addAchievement(achievement);
    return achievement;
  }
}