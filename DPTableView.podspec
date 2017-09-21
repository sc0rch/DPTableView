#
# Be sure to run `pod lib lint DPTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DPTableView'
  s.version          = '0.1.2'
  s.summary          = 'UITableView + RxSwift + DZNEmpyDataSet'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ximximik/DPTableView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ximximik' => 'ximximik@yandex.ru' }
  s.source           = { :git => 'https://github.com/ximximik/DPTableView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'DPTableView/Classes/**/*'

  s.frameworks = 'UIKit'
  s.dependency 'RxSwift', '4.0.0-beta.0'
  s.dependency 'RxCocoa', '4.0.0-beta.0'
  s.dependency 'DZNEmptyDataSet', '~> 1.8.1'
  s.dependency 'RxDataSources', '2.0.2'
end
