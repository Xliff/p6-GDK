use v6.c;

use Method::Also;
use NativeCall;

use GDK::Raw::Types;
use GDK::Raw::Display;
use GDK::Raw::X11_Display;
use GDK::Raw::X11_Types;

use GLib::Roles::Signals::Generic;

use GDK::Screen;

class GDK::Display {
  also does GLib::Roles::Signals::Generic;

  has GdkDisplay $!d is implementor;

  submethod BUILD(:$display) {
    $!d = $display;
  }

  submethod DESTROY {
    self.disconnect-all($_) for %!signals;
  }

  method GDK::Raw::Definitions::GdkDisplay
    is also<
      gdkdisplay
      GdkDisplay
    >
  { $!d }

  multi method new (GdkDisplay $display) {
    $display ?? self.bless( :$display ) !! Nil;
  }
  multi method new (Str() $name) is also<open> {
    my $display = gdk_display_open($name);

    $display ?? self.bless( :$display ) !! Nil;
  }

  method open_default_libgtk_only is also<open-default-libgtk-only> {
    my $display = gdk_display_open_default_libgtk_only();

    $display ?? self.bless( :$display ) !! Nil;
  }

  method get_default is also<get-default> {
    my $display = gdk_display_get_default();

    # cw: The above expression returns NULL, so this is the only other
    #     default as I understand it. This is a KNOWN HACK, and
    #     better solutions would be greatly appreciated.
    $display //= gdk_display_open(':0'); # cw: SRSLY?!?


    $display ?? self.bless( :$display ) !! Nil;
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓

  # Is originally:
  # GdkDisplay, gboolean, gpointer --> void
  method closed {
    self.connect($!d, 'closed');
  }

  # Is originally:
  # GdkDisplay, GdkMonitor, gpointer --> void
  method monitor-added is also<monitor_added> {
    self.connect($!d, 'monitor-added');
  }

  # Is originally:
  # GdkDisplay, GdkMonitor, gpointer --> void
  method monitor-removed is also<monitor_removed> {
    self.connect($!d, 'monitor-removed');
  }

  # Is originally:
  # GdkDisplay, gpointer --> void
  method opened {
    self.connect($!d, 'opened');
  }

  # Is originally:
  # GdkDisplay, GdkSeat, gpointer --> void
  method seat-added is also<seat_added> {
    self.connect($!d, 'seat-added');
  }

  # Is originally:
  # GdkDisplay, GdkSeat, gpointer --> void
  method seat-removed is also<seat_removed> {
    self.connect($!d, 'seat-removed');
  }

  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ PROPERTIES ↓↓↓↓
  # ↑↑↑↑ PROPERTIES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method beep {
    gdk_display_beep($!d);
  }

  method close {
    gdk_display_close($!d);
  }

  # method device_is_grabbed (GdkDevice() $device) is also<device-is-grabbed> {
  #   gdk_display_device_is_grabbed($!d, $device);
  # }

  method flush {
    gdk_display_flush($!d);
  }

  method get_app_launch_context is also<get-app-launch-context> {
    gdk_display_get_app_launch_context($!d);
  }

  method get_default_cursor_size is also<get-default-cursor-size> {
    gdk_display_get_default_cursor_size($!d);
  }

  method get_default_group (:$raw = False) is also<get-default-group> {
    my $gw = gdk_display_get_default_group($!d);

    $gw ??
      ( $raw ?? $gw !! ::('GDK::Window').new($gw) )
      !!
      Nil;
  }

  method get_default_screen (:$raw = False) is also<get-default-screen> {
    my $s = gdk_display_get_default_screen($!d);

    $s ??
      ( $raw ?? $s !! ::('GDK::Screen').new($s) )
      !!
      Nil;
  }

  method get_default_seat (:$raw = False) is also<get-default-seat> {
    my $seat = gdk_display_get_default_seat($!d);

    $seat ??
      ( $raw ?? $seat !! ::('GDK::Seat').new($seat) )
      !!
      Nil;
  }

  # method get_device_manager is also<get-device-manager> {
  #   gdk_display_get_device_manager($!d);
  # }

  method get_event (:$raw = False) is also<get-event> {
    my $e = gdk_display_get_event($!d);

    $e ??
      ( $raw ?? $e !! GDK::Event.new($e) )
      !!
      Nil;
  }

  method get_maximal_cursor_size (Int() $width, Int() $height)
    is also<get-maximal-cursor-size>
  {
    my guint ($w, $h) = ($width, $height);

    gdk_display_get_maximal_cursor_size($!d, $w, $h);
  }

  method get_monitor (Int() $monitor_num, :$raw = False)
    is also<get-monitor>
  {
    my gint $m = $monitor_num;

    my $mon = gdk_display_get_monitor($!d, $m);

    $mon ??
      ( $raw ?? $mon !! ::('GDK::Monitor').new($mon) )
      !!
      Nil;
  }

  method get_monitor_at_point (Int() $x, Int() $y, :$raw = False)
    is also<get-monitor-at-point>
  {
    my gint ($xx, $yy) = ($x, $y);

    my $mon = gdk_display_get_monitor_at_point($!d, $xx, $yy);

    $mon ??
      ( $raw ?? $mon !! ::('GDK::Monitor').new($mon) )
      !!
      Nil;
  }

  method get_monitor_at_window (GdkWindow() $window, :$raw = False)
    is also<get-monitor-at-window>
  {
    my $m = gdk_display_get_monitor_at_window($!d, $window);

    $m ??
      ( $raw ?? $m !! ::('GDK::Monitor').new($m) )
      !!
      Nil;
  }

  method get_n_monitors is also<get-n-monitors> {
    gdk_display_get_n_monitors($!d);
  }

  # method get_n_screens is also<get-n-screens> {
  #   gdk_display_get_n_screens($!d);
  # }

  method get_name is also<get-name> {
    gdk_display_get_name($!d);
  }

  # method get_pointer (
  #   GdkScreen() $screen,
  #   Int() $x,
  #   Int() $y,
  #   Int() $mask
  # )
  #   is also<get-pointer>
  # {
  #   my gint ($xx, $yy) = ($x, $y);
  #   my GdkModifierType $m = $mask;
  #
  #   gdk_display_get_pointer($!d, $screen, $xx, $yy, $m);
  # }

  method get_primary_monitor (:$raw = False) is also<get-primary-monitor> {
    my $m = gdk_display_get_primary_monitor($!d);

    $m ??
      ( $raw ?? $m !! ::('GDK::Monitor').new($m) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gdk_display_get_type, $n, $t);
  }

  # method get_window_at_pointer (Int() $win_x, Int() $win_y)
  #   is also<get-window-at-pointer>
  # {
  #   my gint ($wx, $wy) = ($win_x, $win_y);
  #
  #   gdk_display_get_window_at_pointer($!d, $wx, $wy);
  # }

  method has_pending is also<has-pending> {
    so gdk_display_has_pending($!d);
  }

  method is_closed is also<is-closed> {
    so gdk_display_is_closed($!d);
  }

  # method keyboard_ungrab (Int() $time) is also<keyboard-ungrab> {
  #   my guint32 $t = $time;
  #
  #   gdk_display_keyboard_ungrab($!d, $time);
  # }

  # method list_devices is also<list-devices> {
  #   gdk_display_list_devices($!d);
  # }

  method list_seats (:$glist = False, :$raw = False) is also<list-seats> {
    my $sl = gdk_display_list_seats($!d);

    return Nil unless $sl;
    return $sl if $glist;

    $sl = GLib::GList.new($sl) but GLib::Roles::ListData[GdkSeat];

    $raw ?? $sl.Array !! $sl.Array.map({ ::('GDK::Seat').new($_) });
  }

  method notify_startup_complete (Str() $startup_id)
    is also<notify-startup-complete>
  {
    gdk_display_notify_startup_complete($!d, $startup_id);
  }

  method peek_event (:$raw = False) is also<peek-event> {
    my $e = gdk_display_peek_event($!d);

    $e ??
      ( $raw ?? $e !! ::('GDK::Event').new($e) )
      !!
      Nil;
  }

  method pointer_is_grabbed is also<pointer-is-grabbed> {
    so gdk_display_pointer_is_grabbed($!d);
  }

  # method pointer_ungrab (guint32 $time_) is also<pointer-ungrab> {
  #   gdk_display_pointer_ungrab($!d, $time_);
  # }

  method put_event (GdkEvent() $event) is also<put-event> {
    gdk_display_put_event($!d, $event);
  }

  method request_selection_notification (GdkAtom $selection)
    is also<request-selection-notification>
  {
    gdk_display_request_selection_notification($!d, $selection);
  }

  method set_double_click_distance (Int() $distance)
    is also<set-double-click-distance>
  {
    my guint $d = $distance;

    gdk_display_set_double_click_distance($!d, $d);
  }

  method set_double_click_time (Int() $msec) is also<set-double-click-time> {
    my guint $m = $msec;

    gdk_display_set_double_click_time($!d, $m);
  }

  proto method store_clipboard (|)
    is also<store-clipboard>
  { * }

  multi method store_clipboard (
    GdkWindow() $clipboard_window,
    Int() $time,
    @targets,
  ) {
    samewith(
      $clipboard_window,
      $time,
      ArrayToCArray(GdkAtom, @targets),
      @targets.elems
    );
  }
  multi method store_clipboard (
    GdkWindow() $clipboard_window,
    Int() $time,
    CArray[GdkAtom] $targets,
    Int() $n_targets
  ) {
    my guint $t = $time;
    my gint $n = $n_targets;

    gdk_display_store_clipboard($!d, $clipboard_window, $t, $targets, $n);
  }

  method supports_clipboard_persistence
    is also<supports-clipboard-persistence>
  {
    so gdk_display_supports_clipboard_persistence($!d);
  }

  method supports_composite is also<supports-composite> {
    so gdk_display_supports_composite($!d);
  }

  method supports_cursor_alpha is also<supports-cursor-alpha> {
    so gdk_display_supports_cursor_alpha($!d);
  }

  method supports_cursor_color is also<supports-cursor-color> {
    so gdk_display_supports_cursor_color($!d);
  }

  method supports_input_shapes is also<supports-input-shapes> {
    so gdk_display_supports_input_shapes($!d);
  }

  method supports_selection_notification
    is also<supports-selection-notification>
  {
    so gdk_display_supports_selection_notification($!d);
  }

  method supports_shapes is also<supports-shapes> {
    so gdk_display_supports_shapes($!d);
  }

  method sync {
    gdk_display_sync($!d);
  }

  # method warp_pointer (GdkScreen $screen, gint $x, gint $y)
  #   is also<warp-pointer>
  # {
  #   gdk_display_warp_pointer($!d, $screen, $x, $y);
  # }

  # ↑↑↑↑ METHODS ↑↑↑↑

  method x11_error_trap_pop_ignored is also<x11-error-trap-pop-ignored> {
    gdk_x11_display_error_trap_pop_ignored($!d);
  }

  method x11_error_trap_push is also<x11-error-trap-push> {
    gdk_x11_display_error_trap_push($!d);
  }

  # Static. Returns GDK::Display
  method x11_lookup_xdisplay (GDK::Display:U: X11Display $display)
    is also<x11-lookup-display>
  {
    self.bless( display => gdk_x11_lookup_xdisplay($display) );
  }

  # From x11/gdkx11window.h
  method x11_foreign_new_for_display (
    X11Window $window
  ) {
    ::('GDK::Window').new(
      gdk_x11_window_foreign_new_for_display($!d, $window)
    );
  }

  method x11_register_standard_event_type (
    Int() $event_base,
    Int() $n_events
  )
    is also<x11-register-standard-event-type>
  {
    my gint ($eb, $ne) = ($event_base, $n_events);

    gdk_x11_register_standard_event_type($!d, $eb, $ne);
  }

  # Not display specific. Find it a new home.
  method x11_set_sm_client_id (Str() $client_id)
    is also<x11-set-sm-client-id>
  {
    gdk_x11_set_sm_client_id($client_id);
  }

  method x11_get_type is also<x11-get-type> {
    gdk_x11_display_get_type();
  }

  method x11_get_user_time is also<x11-get-user-time> {
    gdk_x11_display_get_user_time($!d);
  }

  method x11_get_xdisplay is also<x11-get-xdisplay> {
    gdk_x11_display_get_xdisplay($!d);
  }

  method x11_grab is also<x11-grab> {
    gdk_x11_display_grab($!d);
  }

  method x11_set_cursor_theme (Str() $theme, Int() $size)
    is also<x11-set-cursor-theme>
  {
    my gint $s = $size;

    gdk_x11_display_set_cursor_theme($!d, $theme, $size);
  }

  method x11_set_window_scale (Int() $scale)
    is also<x11-set-window-scale>
  {
    my gint $s = $scale;

    gdk_x11_display_set_window_scale($!d, $s);
  }

  method x11_ungrab is also<x11-ungrab> {
    gdk_x11_display_ungrab($!d);
  }

}
