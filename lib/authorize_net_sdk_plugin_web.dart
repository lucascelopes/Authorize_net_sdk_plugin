import 'dart:async';
import 'dart:js' as js;
import 'dart:html' as html;

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
    String environment = 'test',
  }) async {
    await _ensureAcceptJs(environment);

    final completer = Completer<String?>();

    if (js.context['Accept'] == null) {
      completer.completeError('Accept.js is not loaded');
      return completer.future;
    }

    if (apiLoginId.isEmpty ||
        clientKey.isEmpty ||
        cardNumber.isEmpty ||
        expirationMonth.isEmpty ||
        expirationYear.isEmpty ||
        cardCode.isEmpty) {
      completer.completeError('Parâmetros inválidos ou faltando');
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
          final messages = response['messages'];
          final messageList = messages is Map
              ? messages['message'] as List?
              : null;
          if (messageList != null && messageList.isNotEmpty) {
            final message = messageList.first;
            completer.completeError(message['text'] ?? 'Accept.js error');
          } else {
            completer.completeError('Accept.js error');
          }
        }
      }),
    ]);

    return completer.future;
  }

  Future<void> _ensureAcceptJs(String environment) {
    final existingEnv = js.context['__acceptJsEnv'] as String?;
    if (js.context['Accept'] != null && existingEnv == environment) {
      return Future.value();
    }

    final completer = Completer<void>();
    final script = html.ScriptElement();
    final url = environment == 'test'
        ? 'https://jstest.authorize.net/v1/Accept.js'
        : 'https://js.authorize.net/v1/Accept.js';
    script.src = url;
    script.type = 'text/javascript';
    script.onLoad.listen((_) {
      js.context['__acceptJsEnv'] = environment;
      completer.complete();
    });
    script.onError.listen((_) {
      completer.completeError('Failed to load Accept.js');
    });
    html.document.head!.append(script);
    return completer.future;
  }
}
