import 'package:flutter_test/flutter_test.dart';
import 'package:authorize_net_sdk_plugin/authorize_net_sdk_plugin.dart';
import 'package:authorize_net_sdk_plugin/authorize_net_sdk_plugin_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAuthorizeNetSdkPluginPlatform
    with MockPlatformInterfaceMixin
    implements AuthorizeNetSdkPluginPlatform {
  @override
  Future<String?> getPlatformVersion() async => '42';

  @override
  Future<String?> generateNonce({
    required String apiLoginId,
    required String clientKey,
    required String cardNumber,
    required String expirationMonth,
    required String expirationYear,
    required String cardCode,
    String environment = 'test',
  }) async => 'mocked_nonce_123';
}

void main() {
  late AuthorizeNetSdkPlugin plugin;
  late MockAuthorizeNetSdkPluginPlatform mockPlatform;

  setUp(() {
    plugin = AuthorizeNetSdkPlugin();
    mockPlatform = MockAuthorizeNetSdkPluginPlatform();
    AuthorizeNetSdkPluginPlatform.instance = mockPlatform;
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
}
