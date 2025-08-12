package com.seu.pacote.authorize_net_sdk_plugin

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.authorize.net.acceptsdk.AcceptSDKApiClient
import com.authorize.net.acceptsdk.datamodel.transaction.EncryptTransactionObject
import com.authorize.net.acceptsdk.datamodel.transaction.EncryptTransactionResponse
import com.authorize.net.acceptsdk.datamodel.transaction.TransactionObject
import com.authorize.net.acceptsdk.datamodel.transaction.TransactionType
import com.authorize.net.acceptsdk.datamodel.transaction.CardData
import com.authorize.net.acceptsdk.datamodel.transaction.CardType
import com.authorize.net.acceptsdk.datamodel.transaction.AcceptSDKApiClient.Environment
import com.authorize.net.acceptsdk.AcceptSDKApiClient.EncryptTransactionCallback

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AuthorizeNetSdkPlugin: FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "authorize_net_sdk_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "generateNonce") {
            val apiLoginId = call.argument<String>("apiLoginId") ?: ""
            val clientKey = call.argument<String>("clientKey") ?: ""
            val cardNumber = call.argument<String>("cardNumber") ?: ""
            val expirationMonth = call.argument<String>("expirationMonth") ?: ""
            val expirationYear = call.argument<String>("expirationYear") ?: ""
            val cardCode = call.argument<String>("cardCode") ?: ""

            try {
                val cardData = CardData.Builder(cardNumber, expirationMonth, expirationYear)
                    .cardCode(cardCode)
                    .build()

                val transactionObject = TransactionObject.createTransactionObject(
                    TransactionType.SDK_TRANSACTION_ENCRYPTION
                ) as EncryptTransactionObject

                transactionObject.cardData = cardData
                transactionObject.merchantAuthentication = EncryptTransactionObject
                    .MerchantAuthentication(apiLoginId, clientKey)

                val apiClient = AcceptSDKApiClient.Builder(context, Environment.SANDBOX).build()
                apiClient.getTokenWithRequest(transactionObject, object : EncryptTransactionCallback {
                    override fun onEncryptionFinished(response: EncryptTransactionResponse) {
                        result.success(response.dataValue) // Aqui é o nonce
                    }
                    override fun onError(error: com.authorize.net.acceptsdk.datamodel.transaction.ErrorTransactionResponse) {
                        result.error("ERROR", error.firstErrorMessage.messageText, null)
                    }
                })

            } catch (e: Exception) {
                result.error("EXCEPTION", e.localizedMessage, null)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
