import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:authorize_net_sdk_plugin/authorize_net_sdk_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('authorize_net_sdk_plugin');
  final plugin = AuthorizeNetSdkPluginMethodChannel();

  setUp(() {
    channel.setMockMethodCallHandler(null);
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isReady returns true', () async {
    final ready = await plugin.isReady();
    expect(ready, true);
  });

  test('getPlatformVersion returns correct version', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getPlatformVersion') {
        return '42';
      }
      return null;
    });

    final version = await plugin.getPlatformVersion();
    expect(version, '42');
  });

  test('generateNonce returns nonce string', () async {
    const fakeNonce = 'fake_nonce_123';

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'generateNonce') {
        // Você pode checar args aqui se quiser
        return fakeNonce;
      }
      return null;
    });

    final nonce = await plugin.generateNonce(
      apiLoginId: 'apiLoginId',
      clientKey: 'clientKey',
      cardNumber: '4111111111111111',
      expirationMonth: '12',
      expirationYear: '25',
      cardCode: '123',
    );

    expect(nonce, fakeNonce);
  });
}
