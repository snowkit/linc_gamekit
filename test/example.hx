//All code is based on the GameKit programming guide.
//Read that and understand it first

//:todo: There is a Show event, which gives you a UIViewController/NSViewController
//       that you are meant to use with your app view controller. This isn't implemented
//       fully just yet but for the basic API is secondary

//This must happen very early on in your game
    
        //the function is used for all callback state,
        //and can be any normal haxe function
    gamekit.GameKit.init(function(event:gamekit.GameKit.GameKitEvent) {

            //the type of event GameKitEventType
        trace('GameKit / event / ${event.type}');
            
            //when there is an error around
        if(event.error != null) {
            trace('GameKit / event error / ${event.error}');
        }

            //for AchievementsLoadOk event
        if(event.loaded != null) {
            trace('GameKit / event loaded / ${event.loaded}');
        }

    });

        //Events: LocalPlayerAuthFail, LocalPlayerAuthOk
    gamekit.GameKit.authLocalPlayer();

//These are the other API calls

        //clears all achievements, 
        //Events: AchievementsResetFail, AchievementsResetOk
    gamekit.GameKit.resetAchievements();

        //report progress of an achievement
        //args: achievementID, percentComplete, showsNotificationBanner
        //Events: AchievementsReportOk, AchievementsReportFail
        //note that fake achievements still say OK
    gamekit.GameKit.reportAchievement('achievement_id', 100, true);

        //display a Game Center banner
        //args: title, message, ?duration: Float (seconds)
    gamekit.GameKit.showBanner('Reset Achievements', 'They should be unset now', 0.4);

        //Events: AchievementsLoadOk, AchievementsLoadFail
        //The event .loaded array will be not null, and populated if ok
        //each item should be { ident:String, percent:Float, completed:Bool };
    gamekit.GameKit.loadAchievements();
