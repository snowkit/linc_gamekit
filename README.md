# linc/GameKit
Haxe/hxcpp @:native bindings for [GameKit](https://developer.apple.com/game-center/).

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

See test/example.hx for now