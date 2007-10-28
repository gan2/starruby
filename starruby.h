#ifndef STARRUBY_H
#define STARRUBY_H

#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <ruby.h>
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>
#ifdef WIN32
#include <windows.h>
#include <shlobj.h>
#ifndef SHGFP_TYPE_CURRENT
#define SHGFP_TYPE_CURRENT (0)
#endif
#endif

#ifdef DEFINE_STARRUBY_EXTERN
#define STARRUBY_EXTERN
#else
#define STARRUBY_EXTERN extern
#endif

typedef struct {
  uint8_t blue, green, red, alpha;
} Color;

typedef union {
  Color color;
  uint32_t value;
} Pixel;

typedef struct {
  uint16_t width, height;
  Pixel* pixels;
} Texture;

typedef struct {
  double a, b, c, d, tx, ty;
} AffineMatrix;

typedef struct {
  int size;
  TTF_Font* sdlFont;
} Font;

#ifndef PI
#define PI (3.1415926535897932384626433832795)
#endif
#define SCREEN_WIDTH (320)
#define SCREEN_HEIGHT (240)

STARRUBY_EXTERN VALUE rb_cColor;
STARRUBY_EXTERN VALUE rb_mGame;
STARRUBY_EXTERN VALUE rb_mStarRuby;
STARRUBY_EXTERN VALUE rb_eStarRubyError;
STARRUBY_EXTERN VALUE rb_cTexture;
STARRUBY_EXTERN VALUE rb_cTone;

#define rb_raise_sdl_error() rb_raise(rb_eStarRubyError, "%s", SDL_GetError())
#define rb_raise_sdl_image_error()\
  rb_raise(rb_eStarRubyError, "%s", IMG_GetError())
#define rb_raise_sdl_ttf_error()\
  rb_raise(rb_eStarRubyError, "%s", TTF_GetError())

#define MAX(x, y) ((x >= y) ? x : y)
#define MIN(x, y) ((x <= y) ? x : y)
#define NORMALIZE(x, min, max) ((x < min) ? min : ((max < x) ? max : x))

void Init_starruby(void);

void InitializeColor(void);
void InitializeGame(SDL_Surface*);
void InitializeFont(void);
void InitializeInput(void);
void InitializeStarRubyError(void);
void InitializeTexture(void);

void AffineMatrix_Concat(AffineMatrix*, AffineMatrix*);
void AffineMatrix_Invert(AffineMatrix*);
bool AffineMatrix_IsRegular(AffineMatrix*);
void AffineMatrix_Transform(AffineMatrix*, double, double, double*, double*);

bool SdlIsQuitted();

#ifdef DEBUG
#include <assert.h>
void AffineMatrix_Test(void);
#endif

#endif
