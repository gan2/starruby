#ifndef STARRUBY_H
#define STARRUBY_H

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <ruby.h>
#include <SDL.h>
#include <SDL_image.h>

#ifdef DEFINE_STARRUBY_EXTERN
#define STARRUBY_EXTERN
#else
#define STARRUBY_EXTERN extern
#endif

STARRUBY_EXTERN VALUE rb_cColor;
STARRUBY_EXTERN VALUE rb_mGame;
STARRUBY_EXTERN VALUE rb_mScreen;
STARRUBY_EXTERN VALUE rb_mStarRuby;
STARRUBY_EXTERN VALUE rb_eStarRubyError;
STARRUBY_EXTERN VALUE rb_cTexture;
STARRUBY_EXTERN VALUE rb_cTone;

#define SCREEN_WIDTH (320)
#define SCREEN_HEIGHT (240)

void Init_starruby(void);

void InitializeColor(void);
void InitializeGame(SDL_Surface*);
void InitializeScreen(void);
void InitializeStarRubyError(void);
void InitializeTexture(void);
void InitializeTone(void);

void UpdateScreen(SDL_Surface*);

#define rb_raise_sdl_error() rb_raise(rb_eStarRubyError, SDL_GetError())

#define MAX(x, y) ((x >= y) ? x : y)
#define MIN(x, y) ((x <= y) ? x : y)
#define NORMALIZE(x, min, max) ((x < min) ? min : ((max < x) ? max : x))

struct Color {
  uint8_t blue;
  uint8_t green;
  uint8_t red;
  uint8_t alpha;
};

#define AMASK (0xff000000)
#define RMASK (0x00ff0000)
#define GMASK (0x0000ff00)
#define BMASK (0x000000ff)

struct Tone {
  int16_t red;
  int16_t green;
  int16_t blue;
  uint8_t saturation;
};

union Pixel {
  struct Color color;
  uint32_t value;
};

struct Texture {
  uint16_t width;
  uint16_t height;
  union Pixel* pixels;
};

#endif
