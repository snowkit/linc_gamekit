package gamekit;

@:enum abstract GameKitEventType(Int)
    from Int to Int {

    var LocalPlayerAuthFail         = 0;
    var LocalPlayerAuthOk           = 1;
    var LocalPlayerAuthShow         = 2;
    var AchievementsReportFail      = 3;
    var AchievementsReportOk        = 4;
    var AchievementsResetFail       = 5;
    var AchievementsResetOk         = 6;
    var AchievementsLoadFail        = 7;
    var AchievementsLoadOk          = 8;
    var NotificationBannerComplete  = 9;

    inline function toString() {
        return switch(this) {
            case LocalPlayerAuthFail:           'LocalPlayerAuthFail';
            case LocalPlayerAuthOk:             'LocalPlayerAuthOk';
            case LocalPlayerAuthShow:           'LocalPlayerAuthShow';
            case AchievementsReportFail:        'AchievementsReportFail';
            case AchievementsReportOk:          'AchievementsReportOk';
            case AchievementsResetFail:         'AchievementsResetFail';
            case AchievementsResetOk:           'AchievementsResetOk';
            case AchievementsLoadFail:          'AchievementsLoadFail';
            case AchievementsLoadOk:            'AchievementsLoadOk';
            case NotificationBannerComplete:    'NotificationBannerComplete';
            case _:                             '$this';
        }
    }

} //GameKitEventType

typedef GameKitAch = { ident:String, percent:Float, completed:Bool };

typedef GameKitEvent = {
    var type : GameKitEventType;
    @:optional var error: String;
    @:optional var loaded: Array<GameKitAch>;
}


@:keep
@:include('linc_gamekit.h')
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('gamekit'))
#end
extern class GameKit {


//public API

    static inline function init(func:GameKitEvent->Void) : Void {
        GameKitInternal.init(func);
    }

    @:native('linc::gamekit::authLocalPlayer')
    static function authLocalPlayer() : Void;

    @:native('linc::gamekit::loadAchievements')
    static function loadAchievements() : Void;

    @:native('linc::gamekit::resetAchievements')
    static function resetAchievements() : Void;

    @:native('linc::gamekit::reportAchievement')
    static function reportAchievement(ident:String, percent:Float, showsCompletionBanner:Bool) : Void;

    @:native('linc::gamekit::showBanner')
    private static function _showBanner(title:String, message:String, duration:Float) : Int;
    static inline function showBanner(title:String, message:String, ?duration:Float=0.0) : Int {
        return _showBanner(title, message, duration);
    }

//internal

    @:allow(gamekit.GameKitInternal)
    @:native('linc::gamekit::internal_init')
    private static function internal_init(func:cpp.Callable<Int->String->Array<Dynamic>->Void>) : Bool;

} //GameKit


@:allow(gamekit.GameKit)
private class GameKitInternal {

    static var callback : GameKitEvent->Void;

    static function init(func:GameKitEvent->Void) : Void {

        if(func == null) throw "GameKit callback mustn't be null";
        if(callback != null) throw "GameKit callback already set, are you accidentally calling init twice?";

        callback = func;

        GameKit.internal_init(cpp.Callable.fromStaticFunction(internal_callback));

    } //

    static function internal_callback(event:Int, error:String, loaded:Array<GameKitAch>) {

        callback({
            type: event,
            error: error,
            loaded: loaded
        });

    } //

}

