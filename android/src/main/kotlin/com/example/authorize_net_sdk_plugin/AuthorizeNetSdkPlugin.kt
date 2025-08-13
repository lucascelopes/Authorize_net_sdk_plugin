package com.example.authorize_net_sdk_plugin

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.wdepos.sdk.WDePOSService
import com.wdepos.sdk.WDePOSServiceCallback
import com.wdepos.sdk.WDePOSMerchantAuthentication
import com.wdepos.sdk.WDePOSCard
import com.wdepos.sdk.WDePOSEnvironment

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

public class AuthorizeNetSdkPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "authorize_net_sdk_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "isReady") {
            result.success(isSdkAvailable())
        } else if (call.method == "generateNonce") {
            val apiLoginId = call.argument<String>("apiLoginId") ?: ""
            val clientKey = call.argument<String>("clientKey") ?: ""
            val cardNumber = call.argument<String>("cardNumber") ?: ""
            val expirationMonth = call.argument<String>("expirationMonth") ?: ""
            val expirationYear = call.argument<String>("expirationYear") ?: ""
            val cardCode = call.argument<String>("cardCode") ?: ""
            val environmentArg = call.argument<String>("environment") ?: "test"

            if (apiLoginId.isEmpty() || clientKey.isEmpty() || cardNumber.isEmpty() || expirationMonth.isEmpty() || expirationYear.isEmpty() || cardCode.isEmpty()) {
                result.error("INVALID_ARGS", "Parâmetros inválidos ou faltando", null)
                return
            }

            // Configura o ambiente (sandbox/teste ou produção)
            val environment = if (environmentArg == "production") {
                WDePOSEnvironment.PRODUCTION
            } else {
                WDePOSEnvironment.TEST
            }

            // Configura autenticação do comerciante
            val merchantAuth = WDePOSMerchantAuthentication()
            merchantAuth.apiLoginID = apiLoginId
            merchantAuth.clientKey = clientKey

            // Configura dados do cartão
            val card = WDePOSCard()
            card.cardNumber = cardNumber
            card.expirationMonth = expirationMonth
            card.expirationYear = expirationYear
            card.cardCode = cardCode

            // Cria serviço WDePOS
            val wdeposService = WDePOSService(environment, merchantAuth)

            // Chama geração do token (nonce)
            wdeposService.generateToken(card, object : WDePOSServiceCallback {
                override fun onSuccess(token: String) {
                    Handler(Looper.getMainLooper()).post {
                        result.success(token)
                    }
                }

                override fun onFailure(errorMessage: String) {
                    Handler(Looper.getMainLooper()).post {
                        result.error("ERROR", errorMessage, null)
                    }
                }
            })

        } else if (call.method == "getPlatformVersion") {
            result.success(android.os.Build.VERSION.RELEASE)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun isSdkAvailable(): Boolean {
        return try {
            Class.forName("com.wdepos.sdk.WDePOSService")
            true
        } catch (e: Exception) {
            false
        }
    }
}
