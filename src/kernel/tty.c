#include <kernel/tty.h>

static const unsigned char VGA_WIDTH = 80;
static const unsigned char VGA_HEIGHT = 25;

static unsigned char tty_color;

void initialize_tty() { 
    tty_color = VGA_COLOR_WHITE | VGA_COLOR_LIGHT_CYAN << 4;

    unsigned char* buffer = (unsigned char*) 0xB8000;

    for (unsigned char i = 0; i < VGA_HEIGHT; i+=2) {
        buffer[i] = ' ';
        buffer[i + 1] = tty_color;
    }
}

