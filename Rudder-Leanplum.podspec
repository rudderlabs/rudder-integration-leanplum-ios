Pod::Spec.new do |s|
  s.name             = 'Rudder-Leanplum'
  s.version          = '0.1.0-beta.4'
  s.summary          = 'Privacy and Security focused Segment-alternative. Leanplum Native SDK integration support.'

  s.description      = <<-DESC
Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
                       DESC

  s.homepage         = 'https://github.com/rudderlabs/rudder-integration-leanplum-ios'
  s.license          = { :type => "Apache", :file => "LICENSE" }
  s.author           = { 'RudderStack' => 'arnab@rudderlabs.com' }
  s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-leanplum-ios.git' }
  s.platform         = :ios, "9.0"

  s.ios.deployment_target = '8.0'

  s.source_files = 'Rudder-Leanplum/Classes/**/*'

  s.dependency 'Rudder', '1.0.1-beta.4'
  s.dependency 'Leanplum-iOS-SDK', '2.6.4'
end
