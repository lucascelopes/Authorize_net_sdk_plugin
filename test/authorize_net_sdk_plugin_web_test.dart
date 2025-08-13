@TestOn('browser')
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter_test/flutter_test.dart';
import 'package:authorize_net_sdk_plugin/authorize_net_sdk_plugin_web.dart';

void main() {
  group('AuthorizeNetSdkPluginWeb', () {
    late AuthorizeNetSdkPluginWeb plugin;

    setUp(() {
      plugin = AuthorizeNetSdkPluginWeb();
      js.context['Accept'] = null;
    });

    test('isReady returns false when Accept is missing', () async {
      final ready = await plugin.isReady();
      expect(ready, false);
    });

    test('generateNonce throws when Accept is missing', () async {
      await expectLater(
        plugin.generateNonce(
          apiLoginId: 'apiLoginId',
          clientKey: 'clientKey',
          cardNumber: '4111111111111111',
          expirationMonth: '12',
          expirationYear: '25',
          cardCode: '123',
        ),
        throwsA(isA<String>()),
      );
    });

    test('generateNonce throws when response has no messages', () async {
      js.context['Accept'] = js.JsObject.jsify({
        'dispatchData': js.allowInterop((secureData, callback) {
          callback(
            js.JsObject.jsify({
              'opaqueData': js.JsObject.jsify({'dataValue': 'nonce'}),
            }),
          );
        }),
      });

      await expectLater(
        plugin.generateNonce(
          apiLoginId: 'apiLoginId',
          clientKey: 'clientKey',
          cardNumber: '4111111111111111',
          expirationMonth: '12',
          expirationYear: '25',
          cardCode: '123',
        ),
        throwsA(isA<Error>()),
      );
    });
  });
}
