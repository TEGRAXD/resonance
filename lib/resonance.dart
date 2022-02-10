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

  /// Method and Event channel constant name
  static const String _methodChannelName = '$_mainChannel.method';
  static const String _eventChannelName = '$_mainChannel.event';

  /// Method, Event, and BasicMessage are channels that used to communicate between native code and Flutter framework.
  /// [MethodChannel] - "A named channel for communicating with platform plugins using asynchronous method calls."
  static const MethodChannel _methodChannel = MethodChannel(_methodChannelName);

  /// [EventChannel] - "A named channel for communicating with platform plugins using event streams."
  static const EventChannel _eventChannel = EventChannel(_eventChannelName);

  /// [StreamSubscription]
  /// "A subscription on events from a Stream.
  /// The subscription provides events to the listener, and holds the callbacks used to handle the events.
  /// The subscription can also be used to unsubscribe from the events, or to temporarily pause the events from the stream."
  StreamSubscription<double>? _subscription;

  /// [volumeGetCurrentLevel] - "A method to get the current volume level from device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
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

  /// [volumeGetMaxLevel] - "A method to get the max volume level from the device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
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

  /// [volumeSetLevel] - "A method to set the volume level to the device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
  /// [showVolumeUI] - "A parameter to show system volume UI of the device when volume level changed, currently this feature only work for Android devices, yet the plugin doesn't even work with iOS devices"
  static Future<double> volumeSetLevel(
    double volumeValue, {
    StreamType streamType = StreamType.music,
    bool showVolumeUI = false,
  }) async {
    assert((volumeValue >= 0.0) && (volumeValue <= 1.0),
        '[volumeValue] property must be between 0 and 1');

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

  /// [volumeSetMaxLevel] - "A method to set the maximum volume level to the device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
  /// [showVolumeUI] - "A parameter to show system volume UI of the device when volume level changed, currently this feature only work for Android devices, yet the plugin doesn't even work with iOS devices"
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

  /// [volumeSetMuteLevel] - "A method to set the minimum volume level or muting the device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
  /// [showVolumeUI] - "A parameter to show system volume UI of the device when volume level changed, currently this feature only work for Android devices, yet the plugin doesn't even work with iOS devices"
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

  /// [addVolumeListener] - "A method to add a function as listener to subscription to handle callback everytime the value change from native code"
  /// [function] - "A void function parameter to invoke given function when the broadcast stream received"
  StreamSubscription<double> addVolumeListener(
    Function(double volume) function,
  ) {
    return _subscription = _eventChannel
        .receiveBroadcastStream()
        .map((eventValue) => eventValue as double)
        .listen(function, onError: null);
  }

  /// [removeVolumeListener] - "A method to cancel subscription to any broadcast stream from native code to avoid memory leaking"
  void removeVolumeListener() => _subscription?.cancel();

  /// [vibrate] - "A method to create vibration by some duration"
  /// [duration] - "A parameter to define how long the vibration duration. Default duration is 400 milliseconds"
  /// [status] - "A returned variable by invoking method. It returns either true or false value. True implying success and False implying an error occured"
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

  /// [vibratePattern] - "A method to create vibration by given custom pattern and amplitude"
  /// [pattern] - "A list of integers parameter to create custom vibration. Pattern must not given an empty list"
  ///
  /// Pattern example : [0, 400, 1000, 600, 1000, 800]
  /// 0 (0 millisecond delay)
  /// 400 (400 milliseconds vibration)
  /// 1000 (1 second delay)
  /// 600 (600 milliseconds vibration)
  /// 1000 (1 second delay)
  /// 800 (800 milliseconds vibration)
  ///
  /// Odd index: Vibration duration
  /// Even index: Delay / pause duration

  /// [amplitude] - "An integer parameter to custom amplitude vibration. The value given must be an integer between 1-255"
  /// [repeat] - "A boolean parameter to define vibration pattern repeat. Calling [vibrationCancel] method will stop any active repeated vibration"
  /// [status] - "A returned variable by invoking method. It returns either true or false value. True implying success and False implying an error occured"
  static Future<bool> vibratePattern(
    List<int> pattern, {
    int? amplitude,
    bool repeat = false,
  }) async {
    assert(pattern.isNotEmpty,
        '[pattern] parameter must not given an empty list.');

    if (amplitude != null) {
      assert((amplitude >= 1) && (amplitude <= 255),
          '[amplitude] parameter must be an integer between 1-255.');
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

  /// [vibrationCancel] - "A method to stop any active repeated vibration. [vibrate] method will not canceled because it's already defined to stop at certain duration."
  /// [status] - "A returned variable by invoking method. It returns either true or false value. True implying success and False implying an error occured"
  static Future<bool> vibrationCancel() async {
    final bool? status = await _methodChannel.invokeMethod('vibrationCancel');

    return status ?? false;
  }
}
