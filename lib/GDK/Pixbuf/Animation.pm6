use v6.c;

use Method::Also;

use NativeCall;

use GDK::Raw::Types;
use GDK::Pixbuf::Raw::Animation;

use GDK::Pixbuf::Animation::Iter;

class GDK::Pixbuf::Animation {
  has GdkPixbufAnimation $!pa is implementor;

  submethod BUILD (:$pixbuf-anim) {
    $!pa = $pixbuf-anim;
  }

  method GDK::Raw::Definitions::GdkPixbufAnimation
    is also<GdkPixbufAnimation>
  { $!pa }

  method new (GdkPixbufAnimation $pixbuf-anim) {
    $pixbuf-anim ?? self.bless( :$pixbuf-anim ) !! Nil;
  }

  method new_from_file (
    Str() $filename,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-file>
  {
    clear_error;
    my $pixbuf-anim = gdk_pixbuf_animation_new_from_file($filename, $error);
    set_error($error);

    $pixbuf-anim ?? self.bless( :$pixbuf-anim ) !! Nil;
  }

  method new_from_file_utf8 (
    Str() $filename,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-file-utf8>
  {
    clear_error;
    my $pixbuf-anim = gdk_pixbuf_animation_new_from_file_utf8(
      $filename,
      $error
    );
    set_error($error);

    $pixbuf-anim ?? self.bless( :$pixbuf-anim ) !! Nil;
  }

  method new_from_resource (
    Str() $path,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-resource>
  {
    clear_error;
    my $pixbuf-anim = gdk_pixbuf_animation_new_from_resource($path, $error);
    set_error($error);

    $pixbuf-anim ?? self.bless( :$pixbuf-anim ) !! Nil;
  }

  method new_from_stream (
    GInputStream() $stream,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-stream>
  {
    clear_error;
    my $pixbuf-anim = gdk_pixbuf_animation_new_from_stream(
      $stream,
      $cancellable,
      $error
    );
    set_error($error);

    $pixbuf-anim ?? self.bless( :$pixbuf-anim ) !! Nil;
  }

  proto method new_from_stream_async (|)
    is also<new-from-stream-async>
  { * }

  multi method new_from_stream_async (
    GInputStream() $stream,
    GAsyncReadyCallback $callback,
    gpointer $user_data = gpointer
  ) {
    samewith($stream, GCancellable, $callback, $user_data);
  }
  multi method new_from_stream_async (
    GInputStream() $stream,
    GCancellable() $cancellable,
    GAsyncReadyCallback $callback,
    gpointer $user_data = gpointer
  ) {
    gdk_pixbuf_animation_new_from_stream_async(
      $stream,
      $cancellable,
      $callback,
      $user_data
    );
  }

  method new_from_stream_finish (
    GAsyncResult() $async_result,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-stream-finish>
  {
    clear_error;
    my $pixbuf-anim = gdk_pixbuf_animation_new_from_stream_finish(
      $async_result,
      $error
    );
    set_error($error);

    $pixbuf-anim ?? self.bless( :$pixbuf-anim ) !! Nil;
  }

  # method gdk_pixbuf_non_anim_get_type {
  #   gdk_pixbuf_non_anim_get_type();
  # }
  #
  # method gdk_pixbuf_non_anim_new {
  #   gdk_pixbuf_non_anim_new();
  # }

  method get_height
    is also<
      get-height
      height
    >
  {
    gdk_pixbuf_animation_get_height($!pa);
  }

  method get_iter (GTimeVal $start_time, :$raw = False) is also<get-iter> {
    my $pai = gdk_pixbuf_animation_get_iter($!pa, $start_time);

    $pai ??
      ( $raw ?? $pai !! GDK::Pixbuf::Animation::Iter.new($pai) )
      !!
      Nil
  }

  method get_static_image (:$raw = False)
    is also<
      get-static-image
      static_image
      static-image
    >
  {
    my $p = gdk_pixbuf_animation_get_static_image($!pa);

    $p ??
      ( $raw ?? $p !! GDK::Pixbuf.new($p) )
      !!
      Nil;
  }

  method get_size
    is also<
      get-size
      size
    >
  {
    (self.get_width, self.get_height);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gdk_pixbuf_animation_get_type, $n, $t );
  }

  method get_width
    is also<
      get-width
      width
    >
  {
    gdk_pixbuf_animation_get_width($!pa);
  }

  method is_static_image is also<is-static-image> {
    so gdk_pixbuf_animation_is_static_image($!pa);
  }

}
