
Pod::Spec.new do |s|

  s.name         = "NGSRouter"
  s.version      = "0.5.0"
  s.summary      = "Light weight router for iOS projects"

  s.description  = <<-DESC

This is a Swift project of powerfull router (coordinator) for using in iOS projects.
                   DESC

  s.homepage     = "https://github.com/Standret/NGSRouter"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  s.author       = { "Peter Standret" => "pstandret@gmail.com" }

  s.platform     = :ios, "11.0"
  s.swift_version = "5.0"

  s.source       = { :git => "https://github.com/Standret/NGSRouter.git", :tag => "#{s.version}" }
  s.source_files = "NGSRouter/LightRoute/*.swift", "NGSRouter/Sources/*.swift"
end
