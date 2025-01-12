import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

final _firebase = FirebaseAuth.instance;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  Timer? _resetTimer;
  @override
  void initState() {
    super.initState();
    _requestPermission();
     _scheduleDailyReset();
  }

  void _requestPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
      // Permission granted
    } else {
      // Permission denied
      // You can show a dialog or a message to the user explaining why the permission is needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text(
                'Activity recognition permission is required to count steps. Please enable it in the app settings.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
   void _scheduleDailyReset() {
    final now = DateTime.now();
    final resetTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final durationUntilReset = resetTime.difference(now);

    _resetTimer = Timer(durationUntilReset, _resetStepCount);

    // Schedule the next reset for the following day
    Timer.periodic(Duration(days: 1), (timer) {
      _resetStepCount();
    });
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps;
    });
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
  }
  void _resetStepCount() {
    setState(() {
      _steps = 0;
    });
  }
  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitSensei'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _firebase.signOut();
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: Stack(alignment: Alignment.center, children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(
                                value: _steps / 10000,
                                backgroundColor: Colors.black,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                                semanticsLabel: 'Steps Counter',
                                strokeWidth: 15.0,
                              ),
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.directions_walk,
                                  size: 30,
                                ),
                                Text('79%'),
                              ],
                            )
                          ]),
                        ),
                        Text('$_steps')
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
