# DPTableView

[![CI Status](http://img.shields.io/travis/ximximik/DPTableView.svg?style=flat)](https://travis-ci.org/ximximik/DPTableView)
[![Version](https://img.shields.io/cocoapods/v/DPTableView.svg?style=flat)](http://cocoapods.org/pods/DPTableView)
[![License](https://img.shields.io/cocoapods/l/DPTableView.svg?style=flat)](http://cocoapods.org/pods/DPTableView)
[![Platform](https://img.shields.io/cocoapods/p/DPTableView.svg?style=flat)](http://cocoapods.org/pods/DPTableView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DPTableView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DPTableView', :git => 'https://github.com/ximximik/DPTableView.git', :tag => '0.1.2'
```

## Using
Firstly, needed specify type of Table View in outlet and xib/storyboard
```swift
@IBOutlet private weak var tableView: DPTableView!

```

##### Basic using
1. Impelement in your cell DPTableViewElementCellProtocol:
```swift
public class MyElementCell: UITableViewCell, DPTableViewElementCellProtocol {
    
    public static let estimatedHeight: CGFloat = 100
    
    public func set(viewModel: MyElementCellViewModel) {
        ...
    }
}
```
2. Declare somewhere observable of array of cells viewModel's:
```swift
var elementsObservable: Observable<[MyElementCellViewModel]>
```
3. Bind it!
```swift
tableView.setup(cellType: MyElementCell.self, viewModels: elementsObservable)
```
It's work if cells prototype designed in storyboard inside table view. Reuse identifier should equal cell class name. For cells prototype designed in xib file, use function parameter `isLoadFromNib`
```swift
tableView.setup(cellType: MyElementCell.self, viewModels: elementsObservable, isLoadFromNib: true)
```

##### Sections
TODO

##### No items text
At this moment is possibly set only simple string text
```swift
tableView.noItemsText = "Data not yet loaded"
```

##### Custom actions with cells after dequeued
For perform additional setups for cell (delegate setup and etc.), use additional parameter `customCellSetup`:
```swift
tableView.setup(cellType: MyElementCell.self, viewModels: elementsObservable, isLoadFromNib: true) { [weak self] cell, index in
    cell.delegate = self
}
```

## Author

ximximik, pestov.d@kkoi.ru

## License

DPTableView is available under the MIT license. See the LICENSE file for more info.
