use v6.c;

use Method::Also;
use NativeCall;

use Cairo;
use GDK::Raw::Types;
use GDK::Raw::Screen;
use GDK::Raw::X11_Screen;

use GLib::Roles::Object;
use GLib::Roles::ListData;
use GLib::Roles::Signals::Generic;

our subset GdkScreenAncestry is export of Mu
  where GdkScreen | GObject;

class GDK::Screen {
  also does GLib::Roles::Object;
  also does GLib::Roles::Signals::Generic;

  has GdkScreen $!screen is implementor;

  submethod BUILD (:$screen) {
    self.setGdkScreen($screen) if $screen;
  }

  method setGdkScreen (GdkScreenAncestry $_) {
    my $to-parent;

    $!screen = do {
      when GdkScreen {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GdkScreen, $_);
      }
    }
    self!setObject($to-parent);
  }

  submethod DESTROY {
    self.disconnect-all($_) for %!signals;
  }

  method GDK::Raw::Definitions::GdkScreen
    is also<
      screen
      GdkScreen
    >
  { $!screen }

  method new (GdkScreen $screen, :$ref = True) {
    return Nil unless $screen;

    my $o = self.bless( :$screen );
    $o.ref if $ref;
    $o;
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓

  # Is originally:
  # GdkScreen, gpointer --> void
  method composited-changed {
    self.connect($!screen, 'composited-changed');
  }

  # Is originally:
  # GdkScreen, gpointer --> void
  method monitors-changed {
    self.connect($!screen, 'monitors-changed');
  }

  # Is originally:
  # GdkScreen, gpointer --> void
  method size-changed {
    self.connect($!screen, 'size-changed');
  }

  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method font_options is rw is also<font-options> {
    Proxy.new(
      FETCH => sub ($) {
        gdk_screen_get_font_options($!screen);
      },
      STORE => sub ($, cairo_font_options_t $options is copy) {
        gdk_screen_set_font_options($!screen, $options);
      }
    );
  }

  method resolution is rw {
    Proxy.new(
      FETCH => sub ($) {
        gdk_screen_get_resolution($!screen);
      },
      STORE => sub ($, Num() $dpi is copy) {
        gdk_screen_set_resolution($!screen, $dpi);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ PROPERTIES ↓↓↓↓
  # ↑↑↑↑ PROPERTIES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method get_active_window (:$raw = False)
    is DEPRECATED
    is also<
      get-active-window
      active_window
      active-window
    >
  {
    my $w = gdk_screen_get_active_window($!screen);

    $w ??
      ( $raw ?? $w !! ::('GDK::Window').new($w, :!ref) )
      !!
      Nil;
  }

  method get_default
    is also<
      get-default
      default
    >
  {
    my $screen = gdk_screen_get_default();

    $screen ?? self.bless(:$screen) !! Nil;
  }

  method get_display (:$raw = False)
    is also<
      get-display
      display
    >
  {
    my $d = gdk_screen_get_display($!screen);

    $d ??
      ( $raw ?? $d !! ::('GDK::Display').new($d, :!ref) )
      !!
      Nil;
  }

  method get_height
    is also<
      get-height
      height
    >
  {
    gdk_screen_get_height($!screen);
  }

  method get_height_mm
    is also<
      get-height-mm
      height_mm
      height-mm
    >
  {
    gdk_screen_get_height_mm($!screen);
  }

  method get_monitor_at_point (Int() $x, Int() $y)
    is also<get-monitor-at-point>
  {
    my ($xx, $yy) = ($x, $y);

    gdk_screen_get_monitor_at_point($!screen, $x, $y);
  }

  method get_monitor_at_window (GdkWindow() $window)
    is also<get-monitor-at-window>
  {
    gdk_screen_get_monitor_at_window($!screen, $window);
  }

  proto method get_monitor_geometry (|)
    is also<get-monitor-geometry>
  { * }

  multi method get_monitor_geometry (Int() $monitor_num) {
    my $d = GdkRectangle.new;

    samewith($monitor_num, $d);
  }
  multi method get_monitor_geometry (Int() $monitor_num, GdkRectangle() $dest) {
    my gint $m = $monitor_num;

    gdk_screen_get_monitor_geometry($!screen, $m, $dest);
    $dest;
  }

  method get_monitor_height_mm (Int() $monitor_num)
    is also<get-monitor-height-mm>
  {
    my gint $m = $monitor_num;

    gdk_screen_get_monitor_height_mm($!screen, $m);
  }

  method get_monitor_plug_name (Int() $monitor_num)
    is also<get-monitor-plug-name>
  {
    my gint $m = $monitor_num;

    gdk_screen_get_monitor_plug_name($!screen, $m);
  }

  method get_monitor_scale_factor (Int() $monitor_num)
    is also<get-monitor-scale-factor>
  {
    my gint $m = $monitor_num;

    gdk_screen_get_monitor_scale_factor($!screen, $m);
  }

  method get_monitor_width_mm (Int() $monitor_num)
    is also<get-monitor-width-mm>
  {
    my gint $m = $monitor_num;

    gdk_screen_get_monitor_width_mm($!screen, $m);
  }

  method get_monitor_workarea (Int() $monitor_num, GdkRectangle() $dest)
    is also<get-monitor-workarea>
  {
    my $mn = $monitor_num;

    gdk_screen_get_monitor_workarea($!screen, $mn, $dest);
  }

  method get_n_monitors
    is also<
      get-n-monitors
      n_monitors
      n-monitors
      elems
    >
  {
    gdk_screen_get_n_monitors($!screen);
  }

  method get_number
    is also<
      get-number
      number
    >
  {
    gdk_screen_get_number($!screen);
  }

  method get_primary_monitor
    is also<
      get-primary-monitor
      primary_monitor
      primary-monitor
    >
  {
    gdk_screen_get_primary_monitor($!screen);
  }

  method get_rgba_visual (:$raw = False)
    is also<
      get-rgba-visual
      rgba_visual
      rgba-visual
    >
  {
    my $v = gdk_screen_get_rgba_visual($!screen);

    $v ??
      ( $raw ?? $v !! ::('GDK::Visual').new($v, :!ref) )
      !!
      Nil;
  }

  method get_root_window (:$raw = False)
    is also<
      get-root-window
      root-window
      root_window
    >
  {
    my $w = gdk_screen_get_root_window($!screen);

    $w ??
      ( $raw ?? $w !! GDK::Window($w) )
      !!
      Nil;
  }

  method get_setting (Str() $name, GValue() $value) is also<get-setting> {
    so gdk_screen_get_setting($!screen, $name, $value);
  }

  method get_size
    is also<
      get-size
      size
    >
  {
    (self.get_width, self.get_height);
  }

  method get_system_visual (:$raw = False) is also<get-system-visual> {
    my $v = gdk_screen_get_system_visual($!screen);

    $v ??
      ( $raw ?? $v !! ::('GDK::Visual').new($v, :!ref) )
      !!
      Nil;
  }

  method get_toplevel_windows (:$glist = False, :$raw = False)
    is also<get-toplevel-windows>
  {
    my $wl = gdk_screen_get_toplevel_windows($!screen);

    return Nil unless $wl;
    return $wl if $glist && $raw;

    $wl = GLib::GList.new($wl) but GList::Roles::ListData[GdkWindow];

    return $wl if $glist;

    $raw ?? $wl.Array !! $wl.Array.map({ ::('GDK::Window').new($_) });
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gdk_screen_get_type, $n, $t );
  }

  method get_width
    is also<
      get-width
      width
    >
  {
    gdk_screen_get_width($!screen);
  }

  method get_width_mm
    is also<
      get-width-mm
      width_mm
      width-mm
    >
  {
    gdk_screen_get_width_mm($!screen);
  }

  method get_window_stack (:$glist = False, :$raw = False)
    is also<
      get-window-stack
      window_stack
      window-stack
    >
  {
    my $sl = gdk_screen_get_window_stack($!screen);

    return Nil unless $sl;
    return $sl if $glist && $raw;

    $sl = GLib::GList.new($sl) but GList::Roles::ListData[GdkWindow];

    return $sl if $glist;

    $raw ?? $sl.Array !! $sl.Array.map({ ::('GDK::Window').new($_, :!ref) });
  }

  method is_composited is also<is-composited> {
    so gdk_screen_is_composited($!screen);
  }

  method list_visuals (:$glist = False, :$raw = False) is also<list-visuals> {
    my $vl = gdk_screen_list_visuals($!screen);

    return Nil unless $vl;
    return $vl if $glist && $raw;

    $vl = GLib::GList.new($vl) but GLib::Roles::ListData[GdkVisual];

    return $vl if $glist;

    $raw ?? $vl.Array !! $vl.Array.map({ ::('GDK::Visual').new($_) });
  }

  method make_display_name is also<make-display-name> {
    gdk_screen_make_display_name($!screen);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

  method x11_get_default_screen is also<x11-get-default-screen> {
    gdk_x11_get_default_screen();
  }

  method x11_get_current_desktop is also<x11-get-current-desktop> {
    gdk_x11_screen_get_current_desktop($!screen);
  }

  method x11_get_monitor_output (Int() $monitor_num)
    is also<x11-get-monitor-output>
  {
    my gint $mn = $monitor_num;

    gdk_x11_screen_get_monitor_output($!screen, $mn);
  }

  method x11_get_number_of_desktops
    is also<
      x11-get-number-of-desktops
      x11_d_elems
      x11-d-elems
    >
  {
    gdk_x11_screen_get_number_of_desktops($!screen);
  }

  method x11_get_screen_number
    is also<x11-get-screen-number>
  {
    gdk_x11_screen_get_screen_number($!screen);
  }

  method x11_get_type is also<x11-get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gdk_x11_screen_get_type, $n, $t );
  }

  method x11_get_window_manager_name
    is also<x11-get-window-manager-name>
  {
    gdk_x11_screen_get_window_manager_name($!screen);
  }

  method x11_get_xscreen is also<x11-get-screen> {
    gdk_x11_screen_get_xscreen($!screen);
  }

  proto method x11_supports_net_wm_hint (|)
    is also<x11-supports-net-wm-hint>
  { * }

  multi method x11_supports_net_wm_hint (Int() $property) {
    my GdkAtom $p = $property;
    samewith($p);
  }
  multi method x11_supports_net_wm_hint (GdkAtom $property) {
    so gdk_x11_screen_supports_net_wm_hint($!screen, $property);
  }

}
