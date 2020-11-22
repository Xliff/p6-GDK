use v6.c;

use NativeCall;
use NativeHelper::Blob;

use GDK::Raw::Types;
use GDK::Raw::Pixbuf::Loader;

use GDK::Pixbuf::Animation;
use GDK::Pixbuf::Format;

use GLib::Roles::Object;

our subset GdkPixbufLoaderAncestry is export of Mu
  where GdkPixbufLoader | GObject;

class GDK::Pixbuf::Loader {
  also does GLib::Roles::Object;
  also does GDK::Roles::Signals::Pixbuf::Loader;

  has GdkPixbufLoader $!pl;

  submethod BUILD (:$pixbuf-loader) {
    self.setGdkPixbufLoader($pixbuf-loader) if $pixbuf-loader;
  }

  method setGdkPixbufLoader(GdkPixbufLoaderAncestry $_) {
    my $to-parent;

    $!pl = do {
      when GdkPixbufLoader {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GdkPixbufLoader, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GDK::Raw::Definitions::GdkPixbufLoader
  { $!pl }

  multi method new (GdkPixbufLoaderAncestry $pixbuf-loader, :$ref = True) {
    return Nil unless $pixbuf-loader;

    my $o = self.bless( :$pixbuf-loader );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $pixbuf-loader = gdk_pixbuf_loader_new();

    $pixbuf-loader ?? self.bless(:$pixbuf-loader) !! Nil;
  }

  method new_with_mime_type (
    Str()                   $mime_type,
    CArray[Pointer[GError]] $error      = gerror
  ) {
    clear_error;
    my $pixbuf-loader = gdk_pixbuf_loader_new_with_mime_type(
      $mime_type,
      $error
    );
    set_error($error);

    $pixbuf-loader ?? self.bless(:$pixbuf-loader) !! Nil;
  }

  method new_with_type (
    Str()                   $image_type,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    my $pixbuf-loader = gdk_pixbuf_loader_new_with_type($image_type, $error);
    set_error($error);

    $pixbuf-loader ?? self.bless(:$pixbuf-loader) !! Nil;
  }

  # Is originally:
   # GdkPixbufLoader, gpointer --> void
   method area-prepared {
     self.connect($!pl, 'area-prepared');
   }

   # Is originally:
   # GdkPixbufLoader, gint, gint, gint, gint, gpointer --> void
   method area-updated {
     self.connect-area-updated($!pl);
   }

   # Is originally:
   # GdkPixbufLoader, gpointer --> void
   method closed {
     self.connect($!pl, 'closed');
   }

   # Is originally:
   # GdkPixbufLoader, gint, gint, gpointer --> void
   method size-prepared {
     self.connect-size-prepared($!pl);
   }

  method close (CArray[Pointer[GError]] $error = gerror) {
    clear_error;
    my $rv = so gdk_pixbuf_lader_close($!pl, $error);
    set_error($error);
    $rv;
  }

  method get_animation (:$raw = False) {
    my $a = gdk_pixbuf_loader_get_animation($!pl);

    $a ??
      ( $raw ?? $a !! GDK::Pixbuf::Animation.new($a, :!ref) )
      !!
      Nil;
  }

  method get_format {
    gdk_pixbuf_loader_get_format($!pl);
  }

  method get_pixbuf (:$raw = False) {
    my $p = gdk_pixbuf_loader_get_pixbuf($!pl);

    $p ??
      ( $raw ?? $p !! GDK::Pixbuf.new($p) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &gdk_pixbuf_loader_get_type, $n, $t );
  }

  method set_size (Int() $width, Int() $height) {
    my gint ($w, $h) = ($width, $height);

    gdk_pixbuf_loader_set_size($!pl, $w, $h);
  }

  multi method write (
    Buf                     $buf,
    CArray[Pointer[GError]] $error  = gerror
    Int()                   :$count = $buf.elems
  ) {
    samewith( pointer-to($buf), $count, $error );
  }
  multi method write (
    CArray[uint8]           $buf,
    Int()                   $count,
    CArray[Pointer[GError]] $error = gerror
  ) {
    samewith( pointer-to($buf), $count, $error );
  }
  multi method write (
    Pointer                 $buf,
    Int()                   $count,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gsize $c = $count;

    clear_error;
    my $rv = so gdk_pixbuf_loader_write($!pl, $buf, $c, $error);
    set_error($error);
    $rv;
  }

  method write_bytes (
    GBytes()                $buffer,
    CArray[Pointer[GError]] $error   = gerror
  ) {
    clear_error;
    my $rv = so gdk_pixbuf_loader_write_bytes($!pl, $buffer, $error);
    set_error($error);
    $rv;
  }

}
