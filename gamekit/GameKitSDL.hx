package gamekit;

import sdl.SDL;
import sdl.SysWM.SysWMinfo;
import sdl.Window;

@:keep
@:include('linc_gamekit.h')
#if !display
@:build(linc.Linc.touch())
#end
extern class GameKitSDL {
    
    static inline function setWindow(window:Window) : Void {
        //these lines keep the includes and stuff working for now
        SDL.getWindowID(window);
        var sigh : SysWMinfo;
        untyped __cpp__('
            SDL_SysWMinfo info;
            SDL_VERSION(&info.version);
            SDL_GetWindowWMInfo({0},&info);
            #if defined(LINC_GAMEKIT_IOS)
                linc::gamekit::GKWindow = (void*)info.info.uikit.window;
                printf("GKWindow iOS %p\\n", linc::gamekit::GKWindow)
            #elif defined(LINC_GAMEKIT_MAC)
                linc::gamekit::GKWindow = (void*)info.info.cocoa.window;
                printf("GKWindow Mac %p\\n", linc::gamekit::GKWindow)
            #endif
        ', window.ptr);
    }

}