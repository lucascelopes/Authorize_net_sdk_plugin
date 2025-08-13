import 'dart:async';
import 'dart:js' as js;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'authorize_net_sdk_plugin_platform_interface.dart';

/// Web implementation of [AuthorizeNetSdkPlugin] that uses Accept.js
/// to tokenize payment information and generate a nonce.
class AuthorizeNetSdkPluginWeb extends AuthorizeNetSdkPluginPlatform {
  /// Registers this class as the default instance of
  /// [AuthorizeNetSdkPluginPlatform] for web.
  static void registerWith(Registrar registrar) {
    AuthorizeNetSdkPluginPlatform.instance = AuthorizeNetSdkPluginWeb();
  }

  @override
  Future<String?> getPlatformVersion() async => 'web';

  @override
  Future<bool> isReady() async => js.context['Accept'] != null;

  @override
  Future<String?> generateNonce({
    required String apiLoginId,
    required String clientKey,
    required String cardNumber,
    required String expirationMonth,
    required String expirationYear,
    required String cardCode,
  }) {
    final completer = Completer<String?>();

    if (js.context['Accept'] == null) {
      completer.completeError('Accept.js is not loaded');
      return completer.future;
    }

    final authData = js.JsObject.jsify({
      'clientKey': clientKey,
      'apiLoginID': apiLoginId,
    });

    final cardData = js.JsObject.jsify({
      'cardNumber': cardNumber,
      'month': expirationMonth,
      'year': expirationYear,
      'cardCode': cardCode,
    });

    final secureData = js.JsObject.jsify({
      'authData': authData,
      'cardData': cardData,
    });

    js.context.callMethod('Accept.dispatchData', [
      secureData,
      js.allowInterop((response) {
        final resultCode = response['messages']['resultCode'] as String?;
        if (resultCode == 'Ok') {
          final dataValue = response['opaqueData']['dataValue'] as String?;
          completer.complete(dataValue);
        } else {
          final message = (response['messages']['message'] as List).first;
          completer.completeError(message['text'] ?? 'Accept.js error');
        }
      }),
    ]);

    return completer.future;
  }
}
