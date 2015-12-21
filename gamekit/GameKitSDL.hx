package gamekit;

import sdl.SDL;
import sdl.Window;

@:keep
@:include('linc_gamekit.h')
#if !display
@:build(linc.Linc.touch())
#end
extern class GameKitSDL {
    
    static inline function setWindow(window:Window) : Void {
        SDL.getWindowID(window);
        untyped __cpp__('
            SDL_SysWMinfo info;
            SDL_VERSION(&info.version);
            SDL_GetWindowWMInfo({0},&info);
            linc::gamekit::GKWindow = (void*)info.info.uikit.window;
            printf("GKWindow %p\\n", linc::gamekit::GKWindow)
        ', window.ptr);
    }

}