import 'package:flutter_test/flutter_test.dart';
import 'package:authorize_net_sdk_plugin/authorize_net_sdk_plugin.dart';
import 'package:authorize_net_sdk_plugin/authorize_net_sdk_plugin_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAuthorizeNetSdkPluginPlatform
    with MockPlatformInterfaceMixin
    implements AuthorizeNetSdkPluginPlatform {
  bool ready = true;
  @override
  Future<String?> getPlatformVersion() async => '42';

  @override
  Future<bool> isReady() async => ready;

  @override
  Future<String?> generateNonce({
    required String apiLoginId,
    required String clientKey,
    required String cardNumber,
    required String expirationMonth,
    required String expirationYear,
    required String cardCode,
    String environment = 'test',
  }) async {
    if (!ready) {
      throw StateError('Plugin not ready');
    }
    final params = [
      apiLoginId,
      clientKey,
      cardNumber,
      expirationMonth,
      expirationYear,
      cardCode,
    ];
    if (params.any((p) => p.isEmpty)) {
      throw ArgumentError('Missing parameter');
    }
    return 'mocked_nonce_123';
  }
}

void main() {
  late AuthorizeNetSdkPlugin plugin;
  late MockAuthorizeNetSdkPluginPlatform mockPlatform;

  setUp(() {
    plugin = AuthorizeNetSdkPlugin();
    mockPlatform = MockAuthorizeNetSdkPluginPlatform();
    AuthorizeNetSdkPluginPlatform.instance = mockPlatform;
  });

  test('isReady returns true', () async {
    final ready = await plugin.isReady();
    expect(ready, true);
  });

  test('isReady returns false', () async {
    mockPlatform.ready = false;
    final ready = await plugin.isReady();
    expect(ready, false);
  });

  test('getPlatformVersion returns mocked version', () async {
    final version = await plugin.getPlatformVersion();
    expect(version, '42');
  });

  test('generateNonce returns mocked nonce', () async {
    final nonce = await plugin.generateNonce(
      apiLoginId: 'dummyApiLoginId',
      clientKey: 'dummyClientKey',
      cardNumber: '4111111111111111',
      expirationMonth: '12',
      expirationYear: '25',
      cardCode: '123',
      environment: 'test',
    );
    expect(nonce, 'mocked_nonce_123');
  });

  test('generateNonce throws when plugin not ready', () {
    mockPlatform.ready = false;
    expect(
      () => plugin.generateNonce(
        apiLoginId: 'dummyApiLoginId',
        clientKey: 'dummyClientKey',
        cardNumber: '4111111111111111',
        expirationMonth: '12',
        expirationYear: '25',
        cardCode: '123',
        environment: 'test',
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('generateNonce throws when required parameter is empty', () {
    expect(
      () => plugin.generateNonce(
        apiLoginId: '',
        clientKey: 'dummyClientKey',
        cardNumber: '4111111111111111',
        expirationMonth: '12',
        expirationYear: '25',
        cardCode: '123',
        environment: 'test',
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}
