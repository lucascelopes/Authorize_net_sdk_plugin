import Flutter
import UIKit
import AcceptSDK

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

        let handler = AcceptSDKHandler(environment: .ENV_TEST)

        let cardData = AcceptSDKCardData()
        cardData.cardNumber = cardNumber
        cardData.expirationMonth = expirationMonth
        cardData.expirationYear = expirationYear
        cardData.cardCode = cardCode

        let request = AcceptSDKRequest()
        request.merchantAuthentication.name = apiLoginId
        request.merchantAuthentication.clientKey = clientKey
        request.dataDescriptor = "COMMON.ACCEPT.INAPP.PAYMENT"
        request.cardData = cardData

        handler.getTokenWithRequest(request) { (response) in
            if let opaqueData = response?.opaqueData?.dataValue {
                result(opaqueData)
            } else if let error = response?.messages?.message.first?.text {
                result(FlutterError(code: "ERROR", message: error, details: nil))
            } else {
                result(FlutterError(code: "UNKNOWN", message: "Erro desconhecido", details: nil))
            }
        }
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
}
