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

## 🚀 Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  authorize_net_sdk_plugin: ^0.0.4
```

### Android

Add the WDePOS Maven repository to your `android/build.gradle`:

```gradle
repositories {
    maven { url "https://maven.wdepos.com/repository/maven-public/" }
}
```

### iOS

Include the WDePOS SDK in your `ios/Podfile`:

```ruby
pod 'WDePOS/All'
```


## 🛠️ How to Use
1. Import the plugin:

   ```dart
   import 'package:authorize_net_sdk_plugin/authorize_net_sdk_plugin.dart';
   ```

2. Create an instance of the plugin:

   ```dart
   final authNet = AuthorizeNetSdkPlugin();
   ```

3. Generate a payment nonce:

   Pass the `environment` parameter as `'test'` or `'production'` to select the Authorize.Net environment.

   ```dart
   // Using the test environment
   final nonce = await authNet.generateNonce(
      apiLoginId: 'YOUR_API_LOGIN_ID',
      clientKey: 'YOUR_CLIENT_KEY',
      cardNumber: '4111111111111111',
      expirationMonth: '12',
      expirationYear: '25',
      cardCode: '123',
      environment: 'test', // or 'production'
    );

    print('Generated nonce: $nonce');

    // Send this nonce securely to your backend to complete the payment
    ```

   To use the production environment, set `environment: 'production'`:

   ```dart
   final prodNonce = await authNet.generateNonce(
      apiLoginId: 'YOUR_API_LOGIN_ID',
      clientKey: 'YOUR_CLIENT_KEY',
      cardNumber: '4111111111111111',
      expirationMonth: '12',
      expirationYear: '25',
      cardCode: '123',
      environment: 'production',
    );
   ```

### Web Support

For Flutter Web you must load Authorize.Net's Accept.js library. Add the
following script tag to your application's `web/index.html`:

```html
<script src="packages/authorize_net_sdk_plugin/authorize_net_sdk_plugin.js" defer></script>
```

This helper script injects the official Accept.js script so that
`generateNonce` works in the browser.

Use the plugin in your Dart code exactly as shown above.
