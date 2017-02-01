Pod::Spec.new do |s|
    s.name         = 'CZSecurityTouchID'
    s.version      = '1.0.1'
    s.summary      = 'Library with two screens for configuration and validation by pin and fingerprint'
    s.author =
    {
        'Edwin Peña' => ''
    }
    s.platform = :ios
    s.source  = {
        :git => "https://github.com/edwinps/CZSecurityTouchID.git", :tag => "1.0.1"
    }
    
    s.source_files = 'src/**/*.{h,m}'
    s.resources = ["res/img/*.{png}", "src/xibs/*.{xib}"]
    s.ios.deployment_target = '8.0'
    s.homepage     = "https://github.com/edwinps/CZSecurityTouchID"
    s.license = { :type => 'MIT', :file => 'LICENSE.md'
end