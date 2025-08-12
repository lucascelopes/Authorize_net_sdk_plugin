#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint authorize_net_sdk_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'authorize_net_sdk_plugin'
  s.version          = '0.0.3'
  s.summary          = 'Plugin para gerar nonce para a plataforma Authorize.net usando WDePOS SDK.'
  s.description      = <<-DESC
Plugin Flutter para integrar com o Authorize.net usando o WDePOS SDK no iOS.
  DESC
  s.homepage         = 'https://github.com/lucascelopes/Authorize_net_sdk_plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nagazaki Software' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.platform         = :ios, '12.0'

  # Dependências
  s.dependency 'Flutter'
  s.dependency 'WDePOS/All'

  # Configuração de build
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
  s.swift_version = '5.0'
end
