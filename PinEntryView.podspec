Pod::Spec.new do |s|
  s.name             = 'PinEntryView'
  s.version          = '5.0.0'
  s.screenshot       = 'https://user-images.githubusercontent.com/2835199/36484248-9eb1673e-16e6-11e8-82af-75dc08539b5a.png'
  s.summary          = 'PinEntryView is a customizable view written in Swift that can be used to confirm alphanumeric pins.'
  s.description      = <<-DESC
PinEntryView is a customizable view written in Swift that can be used to confirm alphanumeric pins. Use cases include typing ACCEPT after reviewing Terms of Service and setting or confirming a passcode.

Features:
- Supports AutoLayout and has intrinsic size. Optionally set a height to make the boxes taller or a width to add more inner spacing between boxes.
- Fully configurable in Interface Builder (supports @IBDesignable and @IBInspectable) and code.
- Customizable for many different use cases.
- Example app to demonstrate the various configurations.
                       DESC

  s.homepage         = 'https://github.com/StockX/PinEntryView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeff Burt' => 'jburt1992@gmail.com' }
  s.source           = { :git => 'https://github.com/StockX/PinEntryView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jeffburtjr'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PinEntryView/Classes/**/*'
end
