import Flutter
import UIKit
import WDePOS

public class AuthorizeNetSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "authorize_net_sdk_plugin", binaryMessenger: registrar.messenger())
    let instance = AuthorizeNetSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "generateNonce" {
      guard let args = call.arguments as? [String: Any],
            let apiLoginId = args["apiLoginId"] as? String,
            let clientKey = args["clientKey"] as? String,
            let cardNumber = args["cardNumber"] as? String,
            let expirationMonth = args["expirationMonth"] as? String,
            let expirationYear = args["expirationYear"] as? String,
            let cardCode = args["cardCode"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Parâmetros inválidos", details: nil))
        return
      }

      let environmentArg = args["environment"] as? String ?? "test"

      // Configuração do ambiente (teste ou produção)
      let environment: WDEPOSEnvironment = (environmentArg == "production") ? .production : .test
      
      // Configuração da autenticação do comerciante
      let merchantAuthentication = WDEPOSMerchantAuthentication()
      merchantAuthentication.apiLoginID = apiLoginId
      merchantAuthentication.clientKey = clientKey
      
      // Dados do cartão
      let card = WDEPOSCard()
      card.cardNumber = cardNumber
      card.expirationMonth = expirationMonth
      card.expirationYear = expirationYear
      card.cardCode = cardCode
      
      // Criando o serviço do WDePOS
      let wdeposService = WDEPOSService(environment: environment, merchantAuthentication: merchantAuthentication)
      
      // Solicitar o token de pagamento (nonce)
      wdeposService.generateToken(with: card) { (token, error) in
        if let token = token {
          result(token)
        } else if let error = error {
          result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
        } else {
          result(FlutterError(code: "UNKNOWN", message: "Erro desconhecido", details: nil))
        }
      }
    } else if call.method == "isReady" {
      let ready = (NSClassFromString("WDEPOSService") != nil)
      result(ready)
    } else if call.method == "getPlatformVersion" {
      result(UIDevice.current.systemVersion)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
