Pod::Spec.new do |s|
  s.name             = 'Emojimap'
  s.version          = '0.1.2'
  s.summary          = 'Lightweight library to map Strings to Emojis.'

  s.description      = <<-DESC
This fantastic library allow you to map strings to emojis, similar to the iOS keyboard prediction. Currently support English, Spanish, German and French.
                       DESC

  s.homepage         = 'https://github.com/matiasvillaverde/emojimap'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Matias' => 'contact@matiasvillaverde.com' }
  s.source           = { :git => 'https://github.com/matiasvillaverde/emojimap.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'Emojimap/EmojiMap/*{swift}'
  s.resource_bundles = {
    'Emojimap' => ['Emojimap/EmojiMap/EmojiMap.bundle/*{json}']
  }

end
