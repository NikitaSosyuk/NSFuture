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
  
  s.source_files = "Sources/**/*"

  s.test_spec "Tests" do |test_spec|
    test_spec.requires_app_host = true
    test_spec.source_files = [
    "**/*Tests.swift"
    ]
  end
end
