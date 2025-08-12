# authorize_net_sdk_plugin 🚀

A Flutter plugin for seamless and secure integration with the Authorize.Net API — enabling credit card, debit card, and other payment methods directly within your Flutter app.

---

## ✨ Key Features

- 🔐 Secure authentication with Authorize.Net API  
- 💳 Create and manage payment transactions  
- 💼 Support for multiple payment methods  
- 🔍 Transaction status and history queries  
- ⚡ Easy-to-use integration for Flutter applications  

---

## How to use

final nonce = await authNet.generateNonce(
  apiLoginId: 'YOUR_API_LOGIN_ID',
  clientKey: 'YOUR_CLIENT_KEY',
  cardNumber: '4111111111111111',
  expirationMonth: '12',
  expirationYear: '25',
  cardCode: '123',
);

print('Generated nonce: $nonce');

// Send this nonce to your backend to complete the payment


## 🚀 Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  authorize_net_sdk_plugin: ^0.0.1
