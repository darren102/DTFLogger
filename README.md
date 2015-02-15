# DTFLogger

DTFLogger is a Logging Library for iOS. It is built on top of the [Realm](http://www.realm.io) mobile database which is a replacement for Core Data.

DTFLogger has been tested on the 0.90.5 version of [Realm](http://www.realm.io) and has this dependency inside of its 'podspec' if you are using [CocoaPods](http://cocoapods.org) to install the library.

The original version of this logging library utilized Core Data but this library was re-written in [Realm](http://www.realm.io) since [Realm](http://www.realm.io) has a much cleaner interface and requires less setup before use.

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like DTFLogger in your projects.

#### Podfile

```ruby
platform :ios, '7.0'

pod 'DTFLogger', '~> 1.0.0'

```

## Architecture
DTFLogger has been architected to do most of its heavy lifting off of the main thread. When you create a log message it shall be stored in the Realm via a background thread. Similarly if you retrieve or delete messages this is also done on background threads and then a completion handler will be called on the main thread with the information thus trying to avoid blocking the main thread as much as possible.

## Sample Project
There is a sample project that is available with this library and this sample project will show you the basic usage of DTFLogger.

### Maintainers

- [Darren Ferguson](http://github.com/darren102) ([@darren102](https://twitter.com/darren102))
