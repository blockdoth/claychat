// Must be defined in one file, _before_ #include "clay.h"
#define CLAY_IMPLEMENTATION
#include "clay.h"
#include <raylib.h>
#include "renderers/raylib/clay_renderer_raylib.c"
#include "stdio.h"
#include "stdlib.h"

int main(void){
	Clay_Raylib_Initialize(100, 100, "test", FLAG_WINDOW_RESIZABLE);

	uint64_t memSize = Clay_MinMemorySize();
	Clay_Arena mem = (Clay_Arena) {
		.memory = malloc(memSize),
		.capacity = memSize
	};


	Clay_Initialize(mem, (Clay_Dimensions){
		.width = GetScreenWidth(),	
		.height = GetScreenHeight(),	
	}, (Clay_ErrorHandler) { });

	while(!WindowShouldClose()){
		Clay_BeginLayout();

		CLAY({
        .backgroundColor = { 255, 0, 0, 0 },
			}
		){};
		
		Clay_RenderCommandArray renderCommands = Clay_EndLayout();

		BeginDrawing();
		Clay_Raylib_Render(renderCommands,(Font*){});
		EndDrawing();
	}
}
