#include "starruby.h"

static VALUE Color_alloc(VALUE klass)
{
  Color* color = ALLOC(Color);
  return Data_Wrap_Struct(klass, 0, -1, color);
}

static VALUE Color_initialize(int argc, VALUE* argv, VALUE self)
{
  VALUE rbRed, rbGreen, rbBlue, rbAlpha;
  rb_scan_args(argc, argv, "31",
               &rbRed, &rbGreen, &rbBlue, &rbAlpha);

  Color* color;
  Data_Get_Struct(self, Color, color);
  color->red   = NORMALIZE(NUM2INT(rbRed),   0, 255);
  color->green = NORMALIZE(NUM2INT(rbGreen), 0, 255);
  color->blue  = NORMALIZE(NUM2INT(rbBlue),  0, 255);
  color->alpha = !NIL_P(rbAlpha) ?
    NORMALIZE(NUM2INT(rbAlpha), 0, 255) : 255;
  return Qnil;
}

static VALUE Color_alpha(VALUE self)
{
  Color* color;
  Data_Get_Struct(self, Color, color);
  return INT2NUM(color->alpha);
}

static VALUE Color_blue(VALUE self)
{
  Color* color;
  Data_Get_Struct(self, Color, color);
  return INT2NUM(color->blue);
}

static VALUE Color_eq(VALUE self, VALUE rbOther)
{
  if (!rb_obj_is_kind_of(rbOther, rb_cColor))
    return Qfalse;

  Color* color1;
  Data_Get_Struct(self, Color, color1);

  Color* color2;
  Data_Get_Struct(rbOther, Color, color2);

  return (color1->red   == color2->red &&
          color1->green == color2->green &&
          color1->blue  == color2->blue &&
          color1->alpha == color2->alpha) ? Qtrue : Qfalse;
}

static VALUE Color_green(VALUE self)
{
  Color* color;
  Data_Get_Struct(self, Color, color);
  return INT2NUM(color->green);
}

static VALUE Color_hash(VALUE self)
{
  Color* color;
  Data_Get_Struct(self, Color, color);
  return INT2NUM((color->red << 2) ^ color->green ^
                 (color->blue << 2 ) ^ color->alpha);
}

static VALUE Color_red(VALUE self)
{
  Color* color;
  Data_Get_Struct(self, Color, color);
  return INT2NUM(color->red);
}

static VALUE Color_to_s(VALUE self)
{
  Color* color;
  Data_Get_Struct(self, Color, color);
  
  char str[256];
  snprintf(str, sizeof(str),
           "#<StarRuby::Color alpha=%d, red=%d, green=%d, blue=%d>",
           color->alpha, color->red, color->green, color->blue);
  return rb_str_new2(str);
}

void InitializeColor(void)
{
  rb_cColor = rb_define_class_under(rb_mStarRuby, "Color", rb_cObject);
  rb_define_alloc_func(rb_cColor, Color_alloc);
  rb_define_private_method(rb_cColor, "initialize", Color_initialize, -1);
  rb_define_method(rb_cColor, "alpha", Color_alpha, 0);
  rb_define_method(rb_cColor, "blue",  Color_blue,  0);
  rb_define_method(rb_cColor, "==",    Color_eq,    1);
  rb_define_method(rb_cColor, "eql?",  Color_eq,    1);
  rb_define_method(rb_cColor, "green", Color_green, 0);
  rb_define_method(rb_cColor, "hash",  Color_hash,  0);
  rb_define_method(rb_cColor, "red",   Color_red,   0);
  rb_define_method(rb_cColor, "to_s",  Color_to_s,  0);
}
