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

  /// [BasicMessageChannel] - "A named channel for communicating with platform plugins using asynchronous message passing."
  /// On purpose of plugin, I don't need to use [BasicMessageChannel] yet.

  /// [StreamSubscription]
  /// "A subscription on events from a Stream.
  /// The subscription provides events to the listener, and holds the callbacks used to handle the events.
  /// The subscription can also be used to unsubscribe from the events, or to temporarily pause the events from the stream."
  StreamSubscription<double>? _subscription;

  /// [getCurrentVolumeLevel] - "A method to get the current volume level from device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
  static Future<double> getCurrentVolumeLevel({
    StreamType streamType = StreamType.music,
  }) async {
    final double? volumeLevel = await _methodChannel.invokeMethod(
      'getCurrentVolumeLevel',
      {
        'stream_type': VolumeStream.getType(streamType),
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// [getMaxVolumeLevel] - "A method to get the max volume level from the device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
  static Future<double> getMaxVolumeLevel({
    StreamType streamType = StreamType.music,
  }) async {
    final double? volumeLevel = await _methodChannel.invokeMethod(
      'getMaxVolumeLevel',
      {
        'stream_type': VolumeStream.getType(streamType),
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// [setVolumeLevel] - "A method to set the volume level to the device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
  /// [showVolumeUI] - "A parameter to show system volume UI of the device when volume level changed, currently this feature only work for Android devices, yet the plugin doesn't even work with iOS devices"
  static Future<double> setVolumeLevel(
    double volumeValue, {
    StreamType streamType = StreamType.music,
    bool showVolumeUI = false,
  }) async {
    assert((volumeValue >= 0.0) && (volumeValue <= 1.0),
        '[volumeValue] property must be between 0 and 1');

    final double? volumeLevel = await _methodChannel.invokeMethod(
      'setVolumeLevel',
      {
        'volume_value': volumeValue,
        'stream_type': VolumeStream.getType(streamType),
        'show_volume_ui': showVolumeUI ? 1 : 0,
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// [setMaxVolumeLevel] - "A method to set the maximum volume level to the device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
  /// [showVolumeUI] - "A parameter to show system volume UI of the device when volume level changed, currently this feature only work for Android devices, yet the plugin doesn't even work with iOS devices"
  static Future<double> setMaxVolumeLevel(
      {StreamType streamType = StreamType.music,
      bool showVolumeUI = false}) async {
    final double? volumeLevel = await _methodChannel.invokeMethod(
      'setMaxVolumeLevel',
      {
        'stream_type': VolumeStream.getType(streamType),
        'show_volume_ui': showVolumeUI ? 1 : 0,
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// [setMuteVolumeLevel] - "A method to set the minimum volume level or muting the device"
  /// [StreamType] - "Enum class that used to choose the type of volume stream such as alarm, media/music, notification volume level"
  /// [showVolumeUI] - "A parameter to show system volume UI of the device when volume level changed, currently this feature only work for Android devices, yet the plugin doesn't even work with iOS devices"
  static Future<double> setMuteVolumeLevel({
    StreamType streamType = StreamType.music,
    bool showVolumeUI = false,
  }) async {
    final double? volumeLevel = await _methodChannel.invokeMethod(
      'setMuteVolumeLevel',
      {
        'stream_type': VolumeStream.getType(streamType),
        'show_volume_ui': showVolumeUI ? 1 : 0,
      },
    );

    return volumeLevel ?? -1.0;
  }

  /// [addListener] - "A method to add a function as listener to subscription to handle callback everytime the value change from native code"
  StreamSubscription<double> addListener(Function(double volume) function) {
    return _subscription = _eventChannel
        .receiveBroadcastStream()
        .map((eventValue) => eventValue as double)
        .listen(function, onError: null);
  }

  /// [removeListener] - "A method to cancel subscription to any broadcast stream from native code to avoid memory leaking"
  void removeListener() => _subscription?.cancel();
}
