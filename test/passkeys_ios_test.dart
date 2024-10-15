import 'package:flutter_test/flutter_test.dart';
import 'package:passkeys_ios/passkeys_ios.dart';
import 'package:passkeys_platform_interface/passkeys_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PasskeysIOS', () {
    test('can be registered', () {
      PasskeysIOS.registerWith();
      expect(PasskeysPlatform.instance, isA<PasskeysIOS>());
    });
  });
}
