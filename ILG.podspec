Pod::Spec.new do |s|

s.name         = "ILG"

s.version      = "0.1.0"

s.summary      = "A simplified line graph with Robinhood-esque interaction. Because there aren't enough iOS graph libraries on Github."

s.platform = :ios, "11.0"

s.homepage = "https://github.com/joeynelson42/ILG"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Joey" => "joeynelson42@gmail.com" }

s.source = { :git => "https://github.com/joeynelson42/ILG.git", :tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "InteractiveLineGraph/Sources/**/*.{swift}"

s.requires_arc = true

s.swift_version = "4.2"

end
