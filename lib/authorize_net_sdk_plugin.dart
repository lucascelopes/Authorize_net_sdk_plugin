import 'authorize_net_sdk_plugin_platform_interface.dart';
export 'authorize_net_sdk_plugin_web_stub.dart'
    if (dart.library.html) 'authorize_net_sdk_plugin_web.dart';

class AuthorizeNetSdkPlugin {
  /// Gera o nonce/token para pagamento, chamando a implementação nativa via platform interface.
  Future<String?> generateNonce({
    required String apiLoginId,
    required String clientKey,
    required String cardNumber,
    required String expirationMonth,
    required String expirationYear,
    required String cardCode,
    String environment = 'test',
  }) {
    return AuthorizeNetSdkPluginPlatform.instance.generateNonce(
      apiLoginId: apiLoginId,
      clientKey: clientKey,
      cardNumber: cardNumber,
      expirationMonth: expirationMonth,
      expirationYear: expirationYear,
      cardCode: cardCode,
      environment: environment,
    );
  }

  /// Método que você já tinha para pegar a versão da plataforma
  Future<String?> getPlatformVersion() {
    return AuthorizeNetSdkPluginPlatform.instance.getPlatformVersion();
  }
}
