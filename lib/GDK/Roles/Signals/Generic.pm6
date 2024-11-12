use v6.c;

use NativeCall;

use GLib::Object::Supplyish;
use GDK::Raw::Types;

role GDK::Roles::Signals::Generic {
  has %!signals-gdk-generic;

  # GObject, GdkWindow
  method connect-gdkwindow (
    $obj,
    $signal,
    &handler?,
    :$raw      = False
  ) {
    my $hid;
    %!signals-gdk-generic{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-gdkwindow(
        $obj.p,
        $signal,
        -> $, $w is copy {
          CATCH {
            default {
              $*ERR.say( .message );
              $s.quit($_)
            }
          }

          $w = ::('GDK::Window').new($w) unless $raw;
          $s.emit( [self, $w] );
        },
        Pointer, 0
      );
      [ self.create-signal-supply($signal, $s), $obj, $hid ];
    };
    %!signals-gdk-generic{$signal}[0].tap(&handler) with &handler;
    %!signals-gdk-generic{$signal}[0];
  }

}

# GObject, GdkWindow
sub g-connect-gdkwindow (
  Pointer $app,
  Str     $name,
          &handler (Pointer, GdkWindow),
  Pointer $data,
  uint32  $flags
)
  returns uint64
  is      native('gobject-2.0')
  is      symbol('g_signal_connect_object')
{ * }
