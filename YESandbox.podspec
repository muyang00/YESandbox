Pod::Spec.new do |s|
s.name        = 'YESandbox'
s.version     = '1.0.2'
s.authors     = { 'muyang00' => '280798744@qq.com' }
s.homepage    = 'https://github.com/muyang00/YESandbox'
s.summary     = 'a dropdown menu for ios like save homepage.'
s.source      = { :git => 'https://github.com/muyang00/YESandbox.git',
:tag => s.version.to_s }
s.license     = { :type => "MIT", :file => "LICENSE" }


s.platform = :ios, '8.0'
s.requires_arc = true
s.source_files = 'YESandbox/YESandbox.h'
s.public_header_files = 'YESandbox/YESandbox.h'

s.ios.deployment_target = '8.0'


s.dependency 'SVProgressHUD'

 s.subspec 'Save' do |ss|
   
    ss.source_files = 'YESandbox/Save/**/*.{h,m}'
    ss.public_header_files = 'YESandbox/Save/**/*.h'
    
  end


end
