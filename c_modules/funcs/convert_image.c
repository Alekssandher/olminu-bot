#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_write.h"

#include "string.h"
#include <stdlib.h>

int convert_image(const char *input_path, const char *output_path, const char *format)
{
    int x, y, n;

    unsigned char *data = stbi_load(input_path, &x, &y, &n, 0);
    if (!data) {
        return 0;
    }

    int result = 0;

    if (strcmp(format, "JPG") == 0 || strcmp(format, "jpg") == 0) {
        result = stbi_write_jpg(output_path, x, y, n, data, 100);
    }
    else if (strcmp(format, "PNG") == 0 || strcmp(format, "png") == 0) {
        result = stbi_write_png(output_path, x, y, n, data, x * n);
    }
    else if (strcmp(format, "BMP") == 0 || strcmp(format, "bmp") == 0) {
        result = stbi_write_bmp(output_path, x, y, n, data);
    }
    else if (strcmp(format, "HDR") == 0 || strcmp(format, "hdr") == 0) {
        result = stbi_write_hdr(output_path, x, y, n, (float*)data);
    }
    stbi_image_free(data);

    return result;
}