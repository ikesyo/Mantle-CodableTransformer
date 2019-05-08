Pod::Spec.new do |s|
  s.name         = 'Mantle-CodableTransformer'
  s.version      = '0.1.0'
  s.summary      = 'A ValueTransformer implementation for Mantle and Codable combination'
  s.description  = <<-DESC
                   A ValueTransformer implementation for Mantle and Codable combination, which is useful for migration from Mantle to Codable.
                   DESC
  s.homepage     = 'https://github.com/ikesyo/Mantle-CodableTransformer'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = 'Sho Ikeda'
  s.source       = { :git => 'https://github.com/ikesyo/Mantle-CodableTransformer.git', :tag => "#{s.version}" }
  s.source_files = 'CodableTransformer.swift'
  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '3.0'

  s.dependency 'Mantle', '~> 2.1'
  s.dependency 'ObjectEncoder', '~> 0.2'
  
  s.module_name = 'MantleCodableTransformer'

  s.cocoapods_version = '>= 1.4.0'
  s.swift_version = '5.0'
end
