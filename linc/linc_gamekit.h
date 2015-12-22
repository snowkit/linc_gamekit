#ifndef _LINC_GAMEKIT_H_
#define _LINC_GAMEKIT_H_

#include <hxcpp.h>

namespace linc {

    namespace gamekit {
        
        extern void* GKWindow;

        typedef ::cpp::Function < Void(int,::String, ::cpp::ArrayBase) > InternalGameKitEventFN;
        extern void internal_init(InternalGameKitEventFN fn);

        extern void authLocalPlayer();
        extern void showAuthDialog();
        extern void showAchievements();
        extern void loadAchievements();
        extern void resetAchievements();
        extern void reportAchievement(::String ident, float percent, bool showsCompletionBanner);
        extern int showBanner(::String title, ::String message, double duration);

    } //gamekit namespace

} //linc

#endif //_LINC_GAMEKIT_H_
