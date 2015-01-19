Pod::Spec.new do |s|
  s.name = 'Hook'
  s.version = '0.2.0'
  s.license = 'MIT'
  s.summary = 'Swift client for hook'
  s.homepage = 'https://github.com/doubleleft/hook-swift'
  s.authors = { 'Endel Dreyer' => 'endel.dreyer@gmail.com' }
  s.source = { :git => 'https://github.com/doubleleft/hook-swift.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.dependency 'Alamofire', '~> 1.1'
  s.dependency 'SwiftyJSON', '~> 2.1'

  s.source_files = 'Hook/Source/*.swift'

  s.requires_arc = true
end
