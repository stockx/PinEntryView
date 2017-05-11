![PinEntryView Logo](https://cloud.githubusercontent.com/assets/2835199/25503255/aa050598-2b67-11e7-89f7-b0fbc6da31ba.png)

![Swift3.1](https://img.shields.io/badge/Swift-3.1-orange.svg?style=flat")
[![Platform](https://img.shields.io/cocoapods/p/PinEntryView.svg?style=flat)](http://cocoapods.org/pods/PinEntryView)
[![Version](https://img.shields.io/cocoapods/v/PinEntryView.svg?style=flat)](http://cocoapods.org/pods/PinEntryView)
[![License](https://img.shields.io/cocoapods/l/PinEntryView.svg?style=flat)](http://cocoapods.org/pods/PinEntryView)

Description
--------------

`PinEntryView` is a customizable view written in Swift that can be used to confirm alphanumeric pins. Use cases include typing `ACCEPT` after reviewing Terms of Service and setting or confirming a passcode.

<img width="303" alt="screen shot 2017-04-27 at 5 01 21 pm" src="https://cloud.githubusercontent.com/assets/2835199/25504253/2f457ec4-2b6b-11e7-8dce-309c858443cb.png">

# Contents
1. [Features](#features)
3. [Installation](#installation)
4. [Supported OS & SDK versions](#supported-versions)
5. [Usage](#usage)
6. [License](#license)
7. [Contact](#contact)

<a name="features"> Features </a>

- [x] Supports AutoLayout and has intrinsic size. Optionally set a height to make the boxes taller or a width to add more inner spacing between boxes.
- [x] Fully configurable in Interface Builder (supports @IBDesignable and @IBInspectable) and code.
- [x] Customizable for many different use cases.
- [x] Example app to demonstrate the various configurations.

![Example Project Screenshot](https://cloud.githubusercontent.com/assets/2835199/25539360/d8ca88be-2c14-11e7-809d-5ef620524d1a.png)

<a name="installation"> Installation </a>
--------------

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate `PinEntryView` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'PinEntryView'
```

Then, run the following command:

```bash
$ pod install
```

In case Xcode complains (<i>"Cannot load underlying module for PinEntryView"</i>) go to Product and choose Clean (or simply press <kbd>⇧</kbd><kbd>⌘</kbd><kbd>K</kbd>).

### Manually

If you prefer not to use CocoaPods, you can integrate `PinEntryView` into your project manually.

<a name="supported-versions"> Supported OS & SDK Versions </a>
-----------------------------

* Supported build target - iOS 8.0+ (Xcode 8.3.2+)

<a name="usage"> Usage </a>
--------------

`PinEntryView` is state based. To configure the view, simply update the state value with whatever values you'd like, and re-set the state:

1) First you should set up the `PinEntryView` and provide an initial state:

```swift
var pinEntryView = PinEntryView()
pinEntryView.state = PinEntryView.State(pin: "ACCEPT",
                                        allowsBackspace: true,
                                        showsPlaceholder: true,
                                        allowsAllCharacters: false,
                                        completedBorderColor: .green)
```

2) Once set, you can optionally adjust individual parameters in the state:

Reassigning one var can be done in line:
```swift
pinEntryView.state?.pin = "CONFIRM"
```

***or***

Group up reassigning multiple vars that way only one update (`PinEntryView.update()`) cycle is made:
```swift
var state = pinEntryView.state
state?.pin = "CONFIRM"
state?.showsPlaceholder = false
pinEntryView.state = state
```

<a name="license"> License </a>
--------------

`PinEntryView` is developed by [Jeff Burt](https://www.linkedin.com/in/jeffaburt) at [StockX](https://stockx.com) and is released under the MIT license. See the `LICENSE` file for details.

<a name="contact"> Contact </a>
--------------

Feel free to follow me on [my personal Twitter account](https://twitter.com/jeffburtjr). If you find any problems with the project or have ideas to enhance it, feel free to open a GitHub issue and/or create a pull request.
