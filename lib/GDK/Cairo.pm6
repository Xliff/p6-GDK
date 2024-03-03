use v6.c;

use Cairo;
use Method::Also;
use NativeCall;

use GDK::Raw::Types;
use GDK::Raw::Cairo;

use GDK::RGBA;

use GLib::Roles::StaticClass;

class GDK::Cairo {
  use GLib::Roles::StaticClass;

  method create (GdkWindow() $window, :$raw = False) {
    propReturnObject(
      gdk_cairo_create($window),
      $raw,
      Cairo::cairo_t,
      Cairo::Context
    );
  }

  method region_create_from_surface (Cairo::cairo_surface_t $surface)
    is also<region-create-from-surface>
  {
    gdk_cairo_region_create_from_surface($surface);
  }

# method set_source_color (Cairo::cairo_t $cr, GdkColor $color) {
  #   gdk_cairo_set_source_color($cr, $color);
  # }

  method surface_create_from_pixbuf (
    GdkPixbuf() $pixbuf,
    Int() $scale,
    GdkWindow() $for_window
  )
    is also<surface-create-from-pixbuf>
  {
    my gint $s = $scale;

    gdk_cairo_surface_create_from_pixbuf($pixbuf, $s, $for_window);
  }

}

role GDK::Additions::Cairo::Context {

  # cw: Add a multi...
  method draw_from_gl (
    GdkWindow() $window,
    Int()       $source,
    Int()       $source_type,
    Int()       $buffer_scale,
    Int()       $x,
    Int()       $y,
    Int()       $width,
    Int()       $height
  )
    is also<draw-from-gl>
  {
    my gint ($s, $st, $bs, $xx, $yy, $w, $h) =
      ($source, $source_type, $buffer_scale, $x, $y, $width, $height);

    gdk_cairo_draw_from_gl(self.context, $window, $s, $st, $bs, $xx, $yy, $w, $h);
  }

  method get_clip_rectangle (GdkRectangle() $rect)
    is also<get-clip-rectangle>
  {
    gdk_cairo_get_clip_rectangle(self.context, $rect);
  }

  method get_drawing_context
    is also<get-drawing-context>
  {
    gdk_cairo_get_drawing_context(self.context);
  }

  method rectangle (GdkRectangle() $rectangle) {
    gdk_cairo_rectangle(self.context, $rectangle);
  }

  method region (cairo_region_t() $region) {
    gdk_cairo_region(self.context, $region);
  }

  proto method set_source_pixbuf (|)
  { * }

  multi method set_source_pixbuf (
    GdkPixbuf()  $pixbuf,
    Num()       :x(:pixbuf-x(:$pixbuf_x)) = 0e0,
    Num()       :y(:pixbuf-y(:$pixbuf_y)) = 0e0
  ) {
    samewith($pixbuf, $pixbuf_x, $pixbuf_y);
  }
  multi method set_source_pixbuf (
    GdkPixbuf() $pixbuf,
    Num()       $pixbuf_x,
    Num()       $pixbuf_y
  )
    is also<set-source-pixbuf>
  {
    my gdouble ($px, $py) = ($pixbuf_x, $pixbuf_y);

    gdk_cairo_set_source_pixbuf(self.context, $pixbuf, $px, $py);
  }

  method set_source_rgba (GdkRGBA() $rgba)
    is also<set-source-rgba>
  {
    gdk_cairo_set_source_rgba(self.context, $rgba);
  }

  proto method set_source_window (|)
  { * }

  multi method set_source_window (
    GdkWindow()  $window,
    Num()       :$x       = 0e0,
    Num()       :$y       = 0e0
  ) {
    samewith($window, $x, $y);
  }
  multi method set_source_window (
    GdkWindow() $window,
    Num()       $x,
    Num()       $y
  )
    is also<set-source-window>
  {
    my gdouble ($xx, $yy) = ($x, $y);

    gdk_cairo_set_source_window(self.context, $window, $xx, $yy);
  }

}

constant GdkCairoContextAdditions is export = GDK::Additions::Cairo::Context;
