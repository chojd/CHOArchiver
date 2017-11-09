#
# Be sure to run `pod lib lint CHOArchiver.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHOArchiver'
  s.version          = '0.1.0'
  s.summary          = 'Easy Archiver.'

  s.description      = <<-DESC
        Easy Archiver.
                       DESC

  s.homepage         = 'https://github.com/chojd/CHOArchiver'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chojd' => 'jingda.cao@gmail' }
  s.source           = { :git => 'https://github.com/chojd/CHOArchiver.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/JingdaCao'

  s.ios.deployment_target = '6.0'

  s.source_files = 'Sources/*'

end
