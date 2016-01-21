Pod::Spec.new do |s|
  s.name     = 'DTFLogger'
  s.version  = '1.5.0'
  s.ios.deployment_target   = '8.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'iOS Library that utilizes Realm to store log messages'
  s.homepage = 'https://github.com/darren102/DTFLogger'
  s.author   = { 'Darren Ferguson' => 'darren102@gmail.com' }
  s.requires_arc = true
  s.source   = {
    :git => 'https://github.com/darren102/DTFLogger.git',
    :branch => 'master',
    :tag => s.version.to_s
  }
  s.source_files = 'DTFLogger/*.{h,m}', 'DTFLogger/Model/*.{h,m}'
  s.public_header_files = 'DTFLogger/DTFLoggerMessage.h', 'DTFLogger/DTFLogger.h'

  s.dependency 'Realm', '0.97.0'
end
