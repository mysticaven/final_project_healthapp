import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Define Exercise class first
class Exercise {
  final String id;
  final String title;
  final String description;
  final String targetLimb;
  final int difficultyLevel;
  final bool isRecommended;
  final String videoUrl;
  final int Function(double mobilityLevel) calculateReps;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.targetLimb,
    required this.difficultyLevel,
    required this.isRecommended,
    required this.videoUrl,
    required this.calculateReps,
  });
}

void main() => runApp(MaterialApp(home: ExercisePage()));

class ExercisePage extends StatefulWidget {
  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final Color _surfaceColor = Colors.grey[900]!;
  final Color _background = const Color(0xFF171821);
  final Color _cardColor = Colors.white;
  final Color _textColor = Colors.black;

  final List<Exercise> _dummyExercises = [
    Exercise(
      id: 'arm_raises',
      title: "Arm Raises",
      description: "Slowly raise and lower your arms",
      targetLimb: 'Both',
      difficultyLevel: 2,
      isRecommended: true,
      videoUrl: 'https://www.youtube.com/watch?v=Bqvmyni_sKQ',
      calculateReps: (mobility) => (mobility * 2).toInt(),
    ),
    Exercise(
      id: 'finger_stretch',
      title: "Finger Stretch",
      description: "Stretch fingers apart and together",
      targetLimb: 'Both',
      difficultyLevel: 1,
      isRecommended: false,
      videoUrl: 'https://www.youtube.com/watch?v=05H0tjWx8UA',
      calculateReps: (_) => 15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Add build method implementation
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          surface: _surfaceColor,
        ),
        scaffoldBackgroundColor: _background,
        cardTheme: CardTheme(
          color: _cardColor,
          elevation: 6,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: TextTheme(
          titleLarge:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: _textColor, fontSize: 16),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stroke Rehab Exercises'),
          backgroundColor: _surfaceColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _ExerciseList(exercises: _dummyExercises),
      ),
    );
  }
}

class _ExerciseList extends StatelessWidget {
  final List<Exercise> exercises;

  const _ExerciseList({required this.exercises});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) => ExerciseCard(exercise: exercises[index]),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _navigateToVideoPlayer(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      exercise.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  _DifficultyStars(difficulty: exercise.difficultyLevel),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                exercise.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _InfoChip(label: 'Reps: ${exercise.calculateReps(6.5)}'),
                  _InfoChip(label: 'Target: ${exercise.targetLimb}'),
                  if (exercise.isRecommended) _RecommendedChip(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToVideoPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(exercise: exercise),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Exercise exercise;

  const VideoPlayerScreen({super.key, required this.exercise});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  Timer? _cueTimer;
  String _currentCue = '';
  bool _isLoading = true;
  late AnimationController _animationController;
  bool _showPositiveFeedback = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _initializeVideo();
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.network(widget.exercise.videoUrl);
    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      allowedScreenSleep: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue,
        handleColor: Colors.blueAccent,
      ),
      errorBuilder: (context, errorMessage) => Center(
        child: Text(
          'Error loading video: $errorMessage',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    setState(() => _isLoading = false);

    _videoController.addListener(() {
      if (_videoController.value.isPlaying) {
        _startCueSystem();
      }
    });
  }

  void _startCueSystem() {
    int cueCounter = 0;
    _cueTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      cueCounter++;
      final cue = _getCueMessage(cueCounter);

      setState(() {
        _currentCue = cue;
        _showPositiveFeedback = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _showPositiveFeedback = false);
      });

      if (cueCounter >= 5) timer.cancel();
    });
  }

  String _getCueMessage(int counter) {
    return [
      'Prepare to start exercise',
      'Begin movement now 👆',
      'Halfway through ✅',
      'Keep going! 💪',
      'Final few reps 🏁',
      'Exercise complete! 🎉'
    ][counter.clamp(0, 5)];
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    _animationController.dispose();
    _cueTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(widget.exercise.title),
        backgroundColor: Colors.grey[900],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _buildVideoPlayerWithGlow(),
                _buildCueOverlay(),
                _buildPositiveFeedback(),
              ],
            ),
    );
  }

  Widget _buildVideoPlayerWithGlow() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: _showPositiveFeedback
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Chewie(controller: _chewieController),
      ),
    );
  }

  Widget _buildCueOverlay() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _currentCue.isNotEmpty ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _currentCue,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPositiveFeedback() {
    return AnimatedOpacity(
      opacity: _showPositiveFeedback ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animationController,
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _getRandomEncouragement(),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRandomEncouragement() {
    final encouragements = [
      'Great Form!',
      'Perfect!',
      'Excellent!',
      'Well Done!',
      'Awesome!',
      'Keep It Up!'
    ];
    return encouragements[DateTime.now().microsecond % encouragements.length];
  }
}

class _DifficultyStars extends StatelessWidget {
  final int difficulty;

  const _DifficultyStars({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          3,
          (index) => Icon(
                index < difficulty ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              )),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[700]!,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}

class _RecommendedChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: const Text('Recommended'),
      backgroundColor: Colors.green[800]!,
      labelStyle: TextStyle(color: Colors.green[100]!),
      avatar: Icon(Icons.thumb_up, size: 18, color: Colors.green[100]!),
    );
  }
}
