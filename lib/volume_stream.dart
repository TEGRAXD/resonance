import 'package:resonance/stream_type.dart';

class VolumeStream {
  static int getType(StreamType streamType) {
    switch (streamType) {
      case StreamType.alarm:
        return 4;
      case StreamType.dtmf:
        return 8;
      case StreamType.music:
        return 3;
      case StreamType.notification:
        return 5;
      case StreamType.ring:
        return 2;
      case StreamType.system:
        return 1;
      case StreamType.voiceCall:
        return 0;
    }
  }
}
