import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../models/emotion.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final Emotion emotion;

  const BreathingExerciseScreen({super.key, required this.emotion});

  @override
  State<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _statusText = "Ready?";
  int _secondsRemaining = 5;
  bool _isBreathingActive = false;
  int _breathCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // smoother animation
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        _startBreathingExercise();
      }
    });
  }

  void _startBreathingExercise() async {
    setState(() {
      _isBreathingActive = true;
      _statusText = "Breathe in...";
    });

    // Animate forward (expand) smoothly
    await _controller.forward();

    // Add a slight delay to allow the bubble to reach its maximum size
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _statusText = "Hold...";
    });

    // Hold at max size for a brief moment
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _statusText = "Breathe out..."; // Breathe out starts
    });

    // Animate reverse (shrink) smoothly
    await _controller.reverse();

    setState(() {
      _breathCount++;
    });

    if (_breathCount < 5) {
      _startBreathingExercise();
    } else {
      setState(() {
        _statusText = "Great job!";
        _isBreathingActive = false;
      });

      await Future.delayed(const Duration(seconds: 3));
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.emotion.color.withOpacity(0.1),
      appBar: AppBar(
        title: Text(
          "Calm Breathing",
          style: TextStyle(color: widget.emotion.color),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: widget.emotion.color),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isBreathingActive
                  ? "Breath ${_breathCount + 1} of 5"
                  : "Starting in $_secondsRemaining",
              style: TextStyle(fontSize: 18, color: widget.emotion.color),
            ),
            const SizedBox(height: 20),
            Center(
              child: Builder(
                builder: (context) {
                  double animationValue = 0.5;

                  // Adjust animation value based on breathing phase
                  if (_isBreathingActive) {
                    if (_statusText == "Breathe in...") {
                      animationValue =
                          _controller.value; // 0 to 1 during inhale
                    } else if (_statusText == "Breathe out...") {
                      animationValue =
                          _controller.value; // 1 to 0 during exhale
                    } else if (_statusText == "Hold...") {
                      animationValue = 1; // Stay at max size during hold
                    }
                  }

                  // To prevent the bubble from becoming smaller during "Hold" phase
                  return Container(
                    width:
                        200 +
                        (100 * animationValue), // Larger bubble during hold
                    height: 200 + (100 * animationValue),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.emotion.color.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                          color: widget.emotion.color.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        widget.emotion.imagePath,
                        width:
                            160 +
                            (80 *
                                animationValue), // Lock the size to avoid drop
                        height: 160 + (80 * animationValue),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _statusText,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.emotion.color,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _isBreathingActive
                    ? _statusText == "Breathe in..."
                        ? "Expand the bubble by breathing in slowly"
                        : _statusText == "Hold..."
                        ? "Hold your breath gently"
                        : "Shrink the bubble by breathing out slowly"
                    : "Get ready to follow the breathing bubble",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
