source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target ‘SwiftTab’ do
    pod 'SnapKit'
end
target 'SwiftTabTests’ do
    pod 'SnapKit'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = “3.1”
        end
    end
end
