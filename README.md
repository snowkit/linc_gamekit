# linc/GameKit
Haxe/hxcpp @:native bindings for [GameKit](https://developer.apple.com/game-center/). Please note this library is a work in progress and has rough edges.

This is a [linc](http://snowkit.github.io/linc/) library.

---

This library works with the Haxe cpp target only.

---
### Install

`haxelib git linc_gamekit https://github.com/snowkit/linc_gamekit.git`

### Endpoints

Currently, the following GameKit API's are bound and available:

- Achievements (import gamekit.GameKit)
    - authLocalPlayer
    - loadAchievements
    - resetAchievements
    - reportAchievement
    - showBanner

### Example usage

Be familiar with [GameKit](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/GameKit_Guide/GameCenterOverview/GameCenterOverview.html#//apple_ref/doc/uid/TP40008304-CH5-SW7)

See test/example.hx for now
