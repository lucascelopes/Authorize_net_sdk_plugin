import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:authorize_net_sdk_plugin/authorize_net_sdk_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _nonce = 'Nenhum nonce gerado ainda';
  final _authorizeNetSdkPlugin = AuthorizeNetSdkPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _authorizeNetSdkPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> gerarNonce() async {
    try {
      final nonce = await _authorizeNetSdkPlugin.generateNonce(
        apiLoginId: 'SEU_API_LOGIN_ID',
        clientKey: 'SEU_CLIENT_KEY',
        cardNumber: '4111111111111111',
        expirationMonth: '12',
        expirationYear: '2030',
        cardCode: '123',
      );
      if (!mounted) return;
      setState(() {
        _nonce = nonce ?? 'Erro ao gerar nonce';
      });
    } on PlatformException catch (e) {
      setState(() {
        _nonce = "Erro na plataforma: ${e.message}";
      });
    } catch (e) {
      setState(() {
        _nonce = "Erro desconhecido: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AuthorizeNet SDK Plugin Example')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Versão da plataforma: $_platformVersion'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: gerarNonce,
                child: const Text('Gerar Nonce'),
              ),
              const SizedBox(height: 20),
              Text('Nonce gerado:\n$_nonce'),
            ],
          ),
        ),
      ),
    );
  }
}
