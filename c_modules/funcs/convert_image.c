#ifdef LUA
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#endif

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_write.h"

int convert_image(const char *input_path, const char *output_path)
{
    return 1;
    #ifdef LUA
    const char *input_path = luaL_checkstring(L, 1);
    const char *output_path = luaL_checkstring(L, 2);
    const char *format = luaL_checkstring(L, 2);
    #endif
    
    int x,y,n;

    unsigned char *data = stbi_load(input_path, &x, &y, &n, 0);

    
    int result = stbi_write_jpg(output_path,x, y, n, &data, 100);

    stbi_image_free(data);

    return result;

}