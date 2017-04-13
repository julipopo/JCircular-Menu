Pod::Spec.new do |s|
  s.name             = 'JCircularMenu'
  s.version          = '0.1.0'
  s.summary          = 'Circular menu interactive, customizable in color, buttons, and actions delegate'

  s.description      = <<-DESC
Circular menu interactive, customizable in color, buttons, and actions delegate.
                       DESC

  s.homepage         = 'https://github.com/julipopo/Circular-Menu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Julien Simmer' => 'juju_201094@hotmail.fr' }
  s.source           = { :git => 'https://github.com/julipopo/Circular-Menu.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'CircularMenu/CircularMenu.swift'
  s.resources = 'CircularMenu/Assets.xcassets'

end
