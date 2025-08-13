import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'authorize_net_sdk_plugin_method_channel.dart';

abstract class AuthorizeNetSdkPluginPlatform extends PlatformInterface {
  AuthorizeNetSdkPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AuthorizeNetSdkPluginPlatform _instance =
      AuthorizeNetSdkPluginMethodChannel();

  static AuthorizeNetSdkPluginPlatform get instance => _instance;

  static set instance(AuthorizeNetSdkPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<String?> generateNonce({
    required String apiLoginId,
    required String clientKey,
    required String cardNumber,
    required String expirationMonth,
    required String expirationYear,
    required String cardCode,
    String environment = 'test',
  }) {
    throw UnimplementedError('generateNonce() has not been implemented.');
  }
}
