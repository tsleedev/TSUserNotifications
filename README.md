# TSUserNotifications

[![CI Status](https://img.shields.io/travis/taesu/TSUserNotifications.svg?style=flat)](https://travis-ci.org/taesu/TSUserNotifications)
[![Version](https://img.shields.io/cocoapods/v/TSUserNotifications.svg?style=flat)](https://cocoapods.org/pods/TSUserNotifications)
[![License](https://img.shields.io/cocoapods/l/TSUserNotifications.svg?style=flat)](https://cocoapods.org/pods/TSUserNotifications)
[![Platform](https://img.shields.io/cocoapods/p/TSUserNotifications.svg?style=flat)](https://cocoapods.org/pods/TSUserNotifications)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TSUserNotifications is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TSUserNotifications'
```

## Usage

Specific date
```
TSUserNotificationCenter.set(identifier: "test",
                             date: Date(),
                             repeatType: .none,
                             title: "test",
                             subtitle: nil,
                             body: "It's test.",
                             badge: nil,
                             sound: nil,
                             userInfo: nil,
                             threadIdentifier: nil)
```

Weekly repeat
```
TSUserNotificationCenter.setDayOfTheWeek(identifier: "WEEK",
                                         hour: 14,
                                         miniute: 30,
                                         dayOfTheWeeks: [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday],
                                         title: "weekly repeat test",
                                         subtitle: nil,
                                         body: "It's weekly repeat test.",
                                         badge: nil,
                                         sound: nil,
                                         userInfo: nil,
                                         threadIdentifier: nil)
```

Automatic calculation
```
let usernofitications = [
    TSUserNofitication(identifier: "task1",
                       date: "2020-01-01".date!,
                       repeatType: .none,
                       title: "2020-01-01 none"),
    TSUserNofitication(identifier: "task2",
                       date: "2025-12-24".date!,
                       repeatType: .none,
                       title: "2025-12-24 none"),
    TSUserNofitication(identifier: "task3",
                       date: "2021-01-01".date!,
                       repeatType: .day,
                       title: "2021-01-01 day"),
    TSUserNofitication(identifier: "task4",
                       date: "2021-01-01".date!,
                       repeatType: .week,
                       title: "2020-01-01(Fri) week")
    ]
    
TSUserNotificationCenter.removeContain(identifier: Identifier.task)
TSUserNotificationCenter.set(nofitications: usernofitications, max: 2)
```

## Author

taesu, tslee.dev@gmail.com

## License

TSUserNotifications is available under the MIT license. See the LICENSE file for more info.
