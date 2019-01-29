Pod::Spec.new do |s|
  s.name             = 'TrxPopup'
  s.version          = '0.1.0'
  s.summary          = 'Modally show any view or ViewController'

  s.description      = <<-DESC
A popup Controller to modally show any view or ViewController
                       DESC

  s.homepage         = 'https://github.com/yaro812/TrxPopup'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yaroslav' => 'thorax@me.com' }
  s.source           = { :git => 'https://github.com/yaro812/TrxPopup.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'
  s.source_files = 'TrxPopup/Classes/**/*.{swift}'
end
