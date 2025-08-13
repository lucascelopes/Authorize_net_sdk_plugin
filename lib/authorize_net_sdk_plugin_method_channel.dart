import 'package:flutter/services.dart';
import 'authorize_net_sdk_plugin_platform_interface.dart';

class AuthorizeNetSdkPluginMethodChannel extends AuthorizeNetSdkPluginPlatform {
  // Define o MethodChannel com o mesmo nome usado no código nativo (Kotlin/Swift)
  final MethodChannel _channel = const MethodChannel(
    'authorize_net_sdk_plugin',
  );

  // Método que busca a versão da plataforma via método nativo
  @override
  Future<String?> getPlatformVersion() async {
    final version = await _channel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> isReady() async => true;

  // Método que chama o código nativo para gerar o nonce de pagamento
  @override
  Future<String?> generateNonce({
    required String apiLoginId,
    required String clientKey,
    required String cardNumber,
    required String expirationMonth,
    required String expirationYear,
    required String cardCode,
  }) async {
    final args = {
      'apiLoginId': apiLoginId,
      'clientKey': clientKey,
      'cardNumber': cardNumber,
      'expirationMonth': expirationMonth,
      'expirationYear': expirationYear,
      'cardCode': cardCode,
    };

    final nonce = await _channel.invokeMethod<String>('generateNonce', args);
    return nonce;
  }
}
