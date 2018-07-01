#include <hxcpp.h>

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#if defined(LINC_GAMEKIT_IOS)
    #import <UIKit/UIKit.h>
#endif

#include "./linc_gamekit.h"
    
namespace linc {
    namespace gamekit {
        void* GKWindow = 0;
    }
}


@interface GCDelegate : NSObject<GKGameCenterControllerDelegate> @end
@implementation GCDelegate

    - (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
    {   
        #if defined(LINC_GAMEKIT_IOS)
            UIWindow* window = (UIWindow*)linc::gamekit::GKWindow;
            UIViewController *vc = window.rootViewController;
            [vc dismissViewControllerAnimated:YES completion:nil];
        #elif defined(LINC_GAMEKIT_MAC)
            //:todo:
            // NSWindow* window = (NSWindow*)linc::gamekit::GKWindow;
            // NSViewController *vc = window.rootViewController;
        #endif
    }

@end

namespace linc {
    namespace gamekit {

        #if defined(LINC_GAMEKIT_IOS)
            UIViewController* GKVC = 0;
        #elif defined(LINC_GAMEKIT_MAC)
            NSViewController* GKVC = 0;
        #endif

        enum GameKitEventType {
            LocalPlayerAuthFail,
            LocalPlayerAuthOk,
            LocalPlayerAuthShow,
            LocalPlayerAuthShowFail,
            AchievementsReportFail,
            AchievementsReportOk,
            AchievementsResetFail,
            AchievementsResetOk,
            AchievementsLoadFail,
            AchievementsLoadOk,
            NotificationBannerComplete
        };

        static NSString* to_NSString(::String str) { return @(str.c_str()); }
        static ::String from_NSString(NSString* str) {
            if(str == nil) return null();
            const char* val = [str UTF8String];
            return ::String(val);
        }

        static InternalGameKitEventFN callback = 0;
        void internal_init(InternalGameKitEventFN fn) {

            callback = fn;

        } //internal_init

        static void emit_event(GameKitEventType type, ::String err, ::Array<Dynamic> loaded) {

            if(callback != null()) {
                callback((int)type, err, loaded);
            }

        } //emit_event

        static void game_center_auth_failed(::String err) {
            NSLog(@"AUTH FAILED ");
            emit_event(LocalPlayerAuthFail, err, null());
        }

        static void game_center_auth_ok(GKLocalPlayer *localPlayer) {
            NSLog(@"AUTH OK");
            emit_event(LocalPlayerAuthOk, null(), null());
        }

        static void game_center_notification_ended(int notification_id) {
            emit_event(NotificationBannerComplete, null(), null());
        }


        void authLocalPlayer() {
        
            GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

            localPlayer.authenticateHandler =
            #if defined(LINC_GAMEKIT_IOS)
                ^(UIViewController *viewController, NSError *error) {
            #elif defined(LINC_GAMEKIT_MAC)
                ^(NSViewController *viewController, NSError *error) {
            #endif
                
                    GKVC = viewController;

                     if (viewController != nil) {
                         emit_event(LocalPlayerAuthShow, null(), null());
                     } else if (localPlayer.isAuthenticated) {
                         game_center_auth_ok(localPlayer);
                     } else {
                         game_center_auth_failed(from_NSString(error.localizedDescription));
                     }
                 }; //authenticateHandler block

         } //auth_local_player

        void showAuthDialog() {

            #if defined(LINC_GAMEKIT_IOS)
                if(GKWindow && GKVC) {
                    UIWindow* window = (UIWindow*)GKWindow;
                    UIViewController *vc = window.rootViewController;
                    [vc presentViewController:GKVC animated:YES completion:nil];
                    GKVC = 0;
                } else {
                    emit_event(LocalPlayerAuthShowFail, ::String("GameKit UIWindow or UIViewController not set"), null());
                }
            #elif defined(LINC_GAMEKIT_MAC)
                if (GKWindow && GKVC) {
                    GKDialogController *presenter = [GKDialogController sharedDialogController];
                    presenter.parentWindow = (NSWindow*)GKWindow;
                    [presenter presentViewController:GKVC];
                    GKVC = 0;
                } else {
                    emit_event(LocalPlayerAuthShowFail, ::String("GameKit NSWindow or NSViewController not set"), null());
                }
            #endif

        } //showAuthDialog

        GCDelegate *gcdelegate;

        void showAchievements() {

            if(GKWindow) {
                #if defined(LINC_GAMEKIT_IOS)

                    UIWindow* window = (UIWindow*)GKWindow;
                    UIViewController *vc = window.rootViewController;

                    if(gcdelegate == nil) {
                        gcdelegate = [[GCDelegate alloc] init];
                    }

                    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
                    
                    if (gameCenterController != nil) {
                       gameCenterController.gameCenterDelegate = gcdelegate;
                       gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
                       [vc presentViewController:gameCenterController animated:YES completion:nil];
                    }
                
                #elif defined(LINC_GAMEKIT_MAC)

                    //:todo:

                #endif

            }

        } //showAchievements

        void reportAchievement(::String ident, float percent, bool showsCompletionBanner) {

            GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: to_NSString(ident)];
            if(achievement) {

                achievement.percentComplete = percent;
                achievement.showsCompletionBanner = showsCompletionBanner;
                
                [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
                    if (error != nil) {                        
                        NSLog(@"Error in reporting achievements: %@", error);
                        emit_event(AchievementsReportFail, from_NSString(error.localizedDescription), null());
                    } else {
                        emit_event(AchievementsReportOk, null(), null());
                    }
                }];
            }
        
        } //reportAchievementIdentifier


        void resetAchievements() {
            
            [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"Could not reset achievements due to %@", error);
                    emit_event(AchievementsResetFail, from_NSString(error.localizedDescription), null());
                } else {
                    emit_event(AchievementsResetOk, null(), null());
                }
            }];

        } //resetAchievements

        void loadAchievements() {

            [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
                
                if (error != nil) {
                    NSLog(@"Error in loading achievements: %@", error);
                    emit_event(AchievementsLoadFail, from_NSString(error.localizedDescription), null());
                } else {
                    NSLog(@"No Error in loading achievements");
                }
                
                Array< Dynamic> loaded_arr = new Array_obj< Dynamic>(0,0);
                if (achievements != nil) {
                    NSLog(@"Achievements found");
                    for (GKAchievement* ach in achievements) {
                        if(ach != nil) {
                            NSLog(@"Achievement: %@ %f", ach.identifier, ach.percentComplete);
                            hx::Anon ach_obj = hx::Anon_obj::Create();
                                ach_obj->Add(HX_CSTRING("ident"), from_NSString(ach.identifier));
                                ach_obj->Add(HX_CSTRING("completed"), (bool)ach.completed);
                                ach_obj->Add(HX_CSTRING("percentComplete"), (float)ach.percentComplete);
                            loaded_arr.Add(ach_obj);
                        }
                    }
                }

                emit_event(AchievementsLoadOk, null(), loaded_arr);

            }]; //loadAchivementsWith...

        } //loadAchievements

        static int nseq = 0;

        int showBanner(::String title, ::String message, double duration) {

            int nid = nseq;

            if(duration > 0) {
                [GKNotificationBanner 
                    showBannerWithTitle: to_NSString(title) 
                    message: to_NSString(message)
                    duration: duration
                    completionHandler:^{
                        game_center_notification_ended(nid);    
                    }];
            } else {
                [GKNotificationBanner 
                    showBannerWithTitle: to_NSString(title) 
                    message: to_NSString(message)
                    completionHandler:^{
                        game_center_notification_ended(nid);    
                    }];
            }

            nseq++;

            return nid;
        
        } //showBanner

    } //gamekit namespace
    
} //linc namespace