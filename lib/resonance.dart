import 'dart:async';
import 'package:flutter/services.dart';
import 'package:resonance/stream_type.dart';
import 'package:resonance/volume_stream.dart';

class Resonance {
  /// Singleton instance
  static Resonance? _instance;

  /// Singleton constructor
  Resonance._();

  /// Singleton factory
  factory Resonance() {
    _instance ??= Resonance._();
    return _instance!;
  }

  /// Main channel constant
  static const String _mainChannel = 'com.astaria.resonance';

  /// Method channel constant name
  static const String _methodChannelName = '$_mainChannel.method';

  /// Event channel constant name
  static const String _eventChannelName = '$_mainChannel.event';

  /// Method, Event, and BasicMessage are channels that used to communicate between native code and Flutter framework.
  ///
  /// Channel for communicating with platform plugins using asynchronous method calls.
  static const MethodChannel _methodChannel = MethodChannel(_methodChannelName);

  /// Method, Event, and BasicMessage are channels that used to communicate between native code and Flutter framework.
  ///
  /// Channel for communicating with platform plugins using event streams.
  static const EventChannel _eventChannel = EventChannel(_eventChannelName);

  /// [StreamSubscription]
  /// A subscription on events from a Stream.
  /// The subscription provides events to the listener, and holds the callbacks used to handle the events.
  /// The subscription can also be used to unsubscribe from the events, or to temporarily pause the events from the stream."
  StreamSubscription<double>? _subscription;

  /// A method to get the current volume level from device.
  ///
  /// [streamType] - Type of volume stream such as alarm, media/music, notification volume level.
  static Future<double> volumeGetCurrentLevel({
    StreamType streamType = StreamType.music,
  }) async {
    final double? volumeLevel = await _methodChannel.invokeMethod(
      'volumeGetCurrentLevel',
      {
        'stream_type': VolumeStream.getType(streamType),
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// A method to get the max volume level from the device.
  ///
  /// [streamType] - Type of volume stream such as alarm, media/music, notification volume level.
  static Future<double> volumeGetMaxLevel({
    StreamType streamType = StreamType.music,
  }) async {
    final double? volumeLevel = await _methodChannel.invokeMethod(
      'volumeGetMaxLevel',
      {
        'stream_type': VolumeStream.getType(streamType),
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// Set the volume level to the device.
  ///
  /// [volumeValue] - Volume value. (Must be between 0 and 1)
  ///
  /// [streamType] - Type of volume stream such as alarm, media/music, notification volume level.
  ///
  /// [showVolumeUI] - Show system volume UI of the device when volume level changed. (For Android only)
  static Future<double> volumeSetLevel(
    double volumeValue, {
    StreamType streamType = StreamType.music,
    bool showVolumeUI = false,
  }) async {
    assert((volumeValue >= 0.0) && (volumeValue <= 1.0),
        'volumeValue property must be between 0 and 1');

    final double? volumeLevel = await _methodChannel.invokeMethod(
      'volumeSetLevel',
      {
        'volume_value': volumeValue,
        'stream_type': VolumeStream.getType(streamType),
        'show_volume_ui': showVolumeUI ? 1 : 0,
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// Set the maximum volume level to the device.
  ///
  /// [streamType] - Type of volume stream such as alarm, media/music, notification volume level.
  ///
  /// [showVolumeUI] - Show system volume UI of the device when volume level changed. (For Android only)
  static Future<double> volumeSetMaxLevel({
    StreamType streamType = StreamType.music,
    bool showVolumeUI = false,
  }) async {
    final double? volumeLevel = await _methodChannel.invokeMethod(
      'volumeSetMaxLevel',
      {
        'stream_type': VolumeStream.getType(streamType),
        'show_volume_ui': showVolumeUI ? 1 : 0,
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// Set the minimum volume level or muting the device.
  ///
  /// [streamType] - Type of volume stream such as alarm, media/music, notification volume level.
  ///
  /// [showVolumeUI] - Show system volume UI of the device when volume level changed. (For Android only)
  static Future<double> volumeSetMuteLevel({
    StreamType streamType = StreamType.music,
    bool showVolumeUI = false,
  }) async {
    final double? volumeLevel = await _methodChannel.invokeMethod(
      'volumeSetMuteLevel',
      {
        'stream_type': VolumeStream.getType(streamType),
        'show_volume_ui': showVolumeUI ? 1 : 0,
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// Add volume listener to subscription to handle callback.
  ///
  /// [function] - Callback function to invoke when the broadcast stream received.
  StreamSubscription<double> addVolumeListener(
    Function(double volume) function,
  ) {
    return _subscription = _eventChannel
        .receiveBroadcastStream()
        .map((eventValue) => eventValue as double)
        .listen(function, onError: null);
  }

  /// Remove and cancel subscription to any broadcast stream from native code to avoid memory leak.
  void removeVolumeListener() => _subscription?.cancel();

  /// Create standalone vibration by some duration.
  ///
  /// [duration] - Define how long the vibration duration in millisecond. (Default: 400ms)
  static Future<bool> vibrate({
    Duration? duration,
  }) async {
    final bool? status = await _methodChannel.invokeMethod(
      'vibrate',
      {
        'vibration_duration': duration?.inMilliseconds,
      },
    );

    return status ?? false;
  }

  /// Create custombizable pattern and amplitude vibration.
  ///
  /// [pattern] - List of integers parameter to create custom vibration. Pattern must not given an empty list.
  ///
  /// [amplitude] - Amplitude vibration. (The value given must be an integer between 1-255)
  ///
  /// [repeat] - Define vibration pattern repeat. Calling [vibrationCancel] method will stop any active repeated vibration.
  static Future<bool> vibratePattern(
    List<int> pattern, {
    int? amplitude,
    bool repeat = false,
  }) async {
    assert(pattern.isNotEmpty, 'pattern property must not given an empty list.');

    if (amplitude != null) {
      assert((amplitude >= 1) && (amplitude <= 255),
          'amplitude property must be an integer between 1-255.');
    }

    final bool? status = await _methodChannel.invokeMethod(
      'vibratePattern',
      {
        'vibration_pattern': pattern,
        'vibration_amplitude': amplitude,
        'vibration_repeat': repeat ? 0 : -1,
      },
    );

    return status ?? false;
  }

  /// Stop active vibration.
  static Future<bool> vibrationCancel() async {
    final bool? status = await _methodChannel.invokeMethod('vibrationCancel');

    return status ?? false;
  }
}
