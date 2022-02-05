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
    Resonance().addListener((volume) {
      setState(() {
        _volumeLevel = volume;
      });
    });
  }

  @override
  void dispose() {
    Resonance().removeListener();
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
                  var volume = await Resonance.getCurrentVolumeLevel();
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
                      await Resonance.setVolumeLevel(0.5, showVolumeUI: true);
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
                  var volume = await Resonance.setMaxVolumeLevel();
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
                  var volume = await Resonance.setMuteVolumeLevel();
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
                  var volume = await Resonance.getMaxVolumeLevel();
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
            ],
          ),
        ),
      ),
    );
  }
}
