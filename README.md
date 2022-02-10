# Resonance

Resonance is volume and vibration controller plugin

![](static/resonance.png)

## Download

Get the latest plugin directly from [Pub.dev][1].

## Features

- Get current volume level
- Get max volume level
- Set volume level
- Set max volume level
- Set mute volume level
- Showing volume UI (Android only)
- Volume stream types (music, notification, alarm, etc.)
- Listenable volume level

## Usage

- Get current volume level

```dart
/// [streamType] by the default is set to [StreamType.music]
var crntVol = await Resonance.volumeGetCurrentLevel(streamType: StreamType.alarm);
print(crntVol);
```

- Set volume level

```dart
/// [showVolumeUI] by the default is set to false
var crntVol = await Resonance.volumeSetLevel(0.5, showVolumeUI: true);
print(crntVol);
```

- Add volume listener

```dart
double _volumeLevel = 0;

@override
void initState() {
    /// Add listener inside initState
    Resonance().addVolumeListener((volume) {
        setState(() {
            _volumeLevel = volume;
        });
    });
    super.initState();
}

@override
void dispose() {
    /// Don't forget to use [removeVolumeListener] after
    Resonance().removeVolumeListener();
    super.dispose();
}
```

- Create one-shot vibration by certain duration

```dart
await Resonance.vibrate(duration: const Duration(milliseconds: 1000));
```

- Create vibration pattern

```dart
await Resonance.vibratePattern(
    [0, 400, 1000, 600, 1000, 800],
    amplitude: 255,
    repeat: false,
);
```

- Cancel active vibration pattern

```dart
await Resonance.vibrationCancel();
```

## Status

Version 1.0.2 is under development

## Note

Only work for Android.

## API

Return | Method | Description
--------------- | --- | ---
Future\<double> | volumeGetCurrentLevel(StreamType streamType) | Returns device's current volume level.
Future\<double> | volumeGetMaxLevel(StreamType streamType) | Returns device's maximum volume level.
Future\<double> | volumeSetLevel(double volumeValue, StreamType streamType, bool showVolumeUI) | Set device's volume level to given volumeValue parameter and returns current volume level.
Future\<double> | volumeSetMaxLevel(StreamType streamType, bool showVolumeUI) | Set device's volume level to maximum and returns current volume level.
Future\<double> | volumeSetMuteLevel(StreamType streamType, bool showVolumeUI) | Set device's volume level to minimum or muted and returns current volume level.
StreamSubscription\<double> | addVolumeListener(Function(double volume) function) | Add volume change listener to handle given callback.
void | removeVolumeListener() | Cancel listener from broadcast stream
Future\<bool> | vibrate(Duration? duration) | Create vibration by certain duration, default duration is 400ms and returns boolean status.
Future\<bool> | vibratePattern(List\<int> pattern, int? amplitude, bool repeat,) | create vibration by given custom pattern, amplitude, and repeat.
Future\<bool> | vibrationCancel() | Cancel any active repeated vibration and returns boolean status.

## Developer

```
Tegar Bangun Suganda
```

[@canaryv8][2] (Twitter)\
[@suganda8][3] (Github)

## License

```
MIT License

Copyright (c) 2022 Tegar Bangun Suganda (ASTARIA)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

[1]: https://pub.dev/packages/resonance
[2]: https://twitter.com/canaryv8
[3]: https://github.com/suganda8