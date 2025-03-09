import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonance/resonance.dart';

void main() {
  const MethodChannel channel = MethodChannel('com.astaria.resonance.method');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall call) async {
        return 0.45;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      null,
    );
  });

  test('getCurrentVolumeLevel', () async {
    expect(await Resonance.volumeGetCurrentLevel(), 0.45);
  });
}
