Pod::Spec.new do |s|
s.name        = 'YESandbox'
s.version     = '1.0.1'
s.authors     = { 'muyang00' => '280798744@qq.com' }
s.homepage    = 'https://github.com/muyang00/YESandbox'
s.summary     = 'a dropdown menu for ios like save homepage.'
s.source      = { :git => 'https://github.com/muyang00/YESandbox.git',
:tag => s.version.to_s }
s.license     = { :type => "MIT", :file => "LICENSE" }


s.platform = :ios, '8.0'
s.requires_arc = true
s.source_files = 'YESandbox/**/*.{h,m}'

s.ios.deployment_target = '8.0'


s.dependency 'SVProgressHUD'

end
