import 'package:flutter/material.dart';
import 'package:resonance/resonance.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _volumeLevel = 0;
  double _getMaxVolumeLevel = 0;

  @override
  void initState() {
    super.initState();
    Resonance().addVolumeListener((volume) {
      setState(() {
        _volumeLevel = volume;
      });
    });
  }

  @override
  void dispose() {
    Resonance().removeVolumeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Resonance'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Try to change volume by pressing hardware button\n'),
              Text('Current volume on: ${_volumeLevel.toStringAsFixed(2)}\n'),
              ElevatedButton(
                onPressed: () async {
                  var volume = await Resonance.volumeGetCurrentLevel();
                  setState(() {
                    _volumeLevel = volume;
                  });
                },
                child: const Text(
                  'Get Current Volume',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var volume =
                      await Resonance.volumeSetLevel(0.5, showVolumeUI: true);
                  setState(() {
                    _volumeLevel = volume;
                  });
                },
                child: const Text(
                  'Set Volume to 0.5',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var volume = await Resonance.volumeSetMaxLevel();
                  setState(() {
                    _volumeLevel = volume;
                  });
                },
                child: const Text(
                  'Set Max Volume',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var volume = await Resonance.volumeSetMuteLevel();
                  setState(() {
                    _volumeLevel = volume;
                  });
                },
                child: const Text(
                  'Set Mute Volume',
                ),
              ),
              Text('\nMax Volume : $_getMaxVolumeLevel\n'),
              ElevatedButton(
                onPressed: () async {
                  var volume = await Resonance.volumeGetMaxLevel();
                  setState(() {
                    _getMaxVolumeLevel = volume;
                  });
                },
                child: const Text(
                  'Get Max Volume',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _volumeLevel = 0;
                    _getMaxVolumeLevel = 0;
                  });
                },
                child: const Text(
                  'Reset',
                ),
              ),
              const Divider(
                thickness: 1.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Resonance.vibrate(
                      duration: const Duration(milliseconds: 2000));
                },
                child: const Text(
                  'Vibrate',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Resonance.vibratePattern(
                    [0, 400, 1000, 600, 1000, 800],
                    amplitude: 100,
                    repeat: true,
                  );
                },
                child: const Text(
                  'Patterned Vibrate',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Resonance.vibrationCancel();
                },
                child: const Text(
                  'Cancel Vibrate',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
