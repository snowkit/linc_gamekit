#pragma once

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

namespace linc {

    namespace gamekit {
        
        extern void* GKWindow;

        #if (HXCPP_API_LEVEL>=330)
            typedef void LincGamekitVoid;
        #else
            typedef Void LincGamekitVoid;
        #endif

        typedef ::cpp::Function < LincGamekitVoid(int,::String, ::Array<Dynamic>) > InternalGameKitEventFN;
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
