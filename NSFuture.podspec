#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  
  s.name         = "NSFuture"
  
  s.version      = "1.0.0"
  
  s.summary      = "Работа с Promise концепцией в языке Swift."
  
  s.swift_version = '5.5'
  
  s.homepage     = "git@github.com:NikitaSosyuk/NSFuture"
  
  s.license = {
    :type => "Custom",
    :text => <<-LICENSE,
    Copyright 2022
    Permission is granted to Nikita Sosyuk
    LICENSE
  }
  
  s.author       = { "Nikita Sosyuk" => "@gazprombank.ru" }
  
  s.platform     = :ios, "9.0"
  
  s.source       = { :git => "git@github.com:NikitaSosyuk/NSFuture", :tag => "#{s.version}" }
  
  s.source_files = "Source/**/*"

  s.script_phases = [
  {
    :name => 'SwiftGen',
    :execution_position => :before_compile,
    :script => "if test -d \"/opt/homebrew/bin/\"; then\n  PATH=\"/opt/homebrew/bin/:${PATH}\"\n  export PATH\nfi\nswiftgen config run --config \"$PODS_TARGET_SRCROOT/Resources/swiftgen.yml\""
  }
  ]

  s.test_spec "Tests" do |test_spec|
    test_spec.requires_app_host = true
    test_spec.source_files = [
    "**/*Tests.swift"
    ]
  end
end
