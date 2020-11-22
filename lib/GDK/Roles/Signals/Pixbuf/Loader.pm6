use v6.c;

use NativeCall;

use GDK::Raw::Types;

role GDK::Roles::Signals::Pixbuf::Loader {
  has %!signals-pbl;

  # GdkPixbufLoader, gint, gint, gint, gint, gpointer
  method connect-area-updated (
    $obj,
    $signal = 'area-updated',
    &handler?
  ) {
    my $hid;
    %!signals-pbl{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-area-updated($obj, $signal,
        -> $, $g1, $g2, $g3, $g4, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $g1, $g2, $g3, $g5, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-pbl{$signal}[0].tap(&handler) with &handler;
    %!signals-pbl{$signal}[0];
  }

  # GdkPixbufLoader, gint, gint, gpointer
  method connect-size-prepared (
    $obj,
    $signal = 'size-prepared',
    &handler?
  ) {
    my $hid;
    %!signals-pbl{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-size-prepared($obj, $signal,
        -> $, $g1, $g2, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $g1, $g2, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-pbl{$signal}[0].tap(&handler) with &handler;
    %!signals-pbl{$signal}[0];
  }

}

# GdkPixbufLoader, gint, gint, gint, gint, gpointer
sub g-connect-area-updated (
  Pointer $app,
  Str     $name,
          &handler (Pointer, gint, gint, gint, gint, Pointer),
  Pointer $data,
  uint32  $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GdkPixbufLoader, gint, gint, gpointer
sub g-connect-size-prepared (
  Pointer $app,
  Str     $name,
          &handler (Pointer, gint, gint, Pointer),
  Pointer $data,
  uint32  $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
