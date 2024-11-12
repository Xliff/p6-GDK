use v6.c;

use Method::Also;
use NativeCall;

use GDK::Raw::Types;
use GDK::Raw::Event;

use GDK::Device;
use GDK::Screen;

class GDK::Event {
  has GdkEventAny $!e is implementor handles<type window send_event>;

  submethod BUILD(:$event) {
    $!e = $event;
  }

  method GDK::Raw::Structs::GdkEvent
    is also<
      GdkEvent
      GtkEvent
    >
  { $!e }
  method GDK::Raw::Structs::GdkEventKey
    is also<GdkEventKey>
  { cast(GdkEventKey, $!e) }

  multi method new (GdkEvents $event) {
    $event ?? self.bless( event => cast(GdkEventAny, $event) ) !! Nil;
  }
  multi method new (Int() $type) {
    my uint32 $t     = $type;
    my        $event = cast( GdkEventAny, gdk_event_new($t) );

    $event ?? self.bless( :$event ) !! Nil;
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓

  # Static/Class method
  method show_events is rw is also<show-events> {
    Proxy.new(
      FETCH => sub ($) {
        gdk_get_show_events()
      },
      STORE => -> $, Int() $val {
        my gboolean $v = (so $val).Int;

        gdk_set_show_events($v);
      }
    );
  }

  method device (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $d = gdk_event_get_device($!e);

        $d ??
          ( $raw ?? $d !! GDK::Device.new($d) )
          !!
          Nil;
      },
      STORE => sub ($, GdkDevice() $device is copy) {
        gdk_event_set_device($!e, $device);
      }
    );
  }

  # GdkDeviceTool
  method device_tool is rw is also<device-tool> {
    Proxy.new(
      FETCH => sub ($) {
        gdk_event_get_device_tool($!e);
      },
      STORE => sub ($, GdkDeviceTool $tool is copy) {
        gdk_event_set_device_tool($!e, $tool);
      }
    );
  }

  method screen ( :$raw = False )is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $s = gdk_event_get_screen($!e);

        $s ??
          ( $raw ?? $s !! GDK::Screen.new($s) )
          !!
          Nil;
      },
      STORE => sub ($, GdkScreen() $screen is copy) {
        gdk_event_set_screen($!e, $screen);
      }
    );
  }

  method source_device ( :$raw = False ) is rw is also<source-device> {
    Proxy.new(
      FETCH => sub ($) {
        my $d = gdk_event_get_source_device($!e);

        $d ??
          ( $raw ?? $d !! GDK::Device.new($d) )
          !!
          Nil;
      },
      STORE => sub ($, GdkDevice() $device is copy) {
        gdk_event_set_source_device($!e, $device);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ PROPERTIES ↓↓↓↓
  # ↑↑↑↑ PROPERTIES ↑↑↑↑

  # Class method.
  method setting_get (Str() $name, GValue() $value) is also<setting-get> {
    gdk_setting_get($name, $value);
  }

  # Custom method.
  method get_typed_event
    is also<
      get-typed-event
      typed_event
      typed-event
    >
  {
    say GdkEventTypeEnum($!e.type);

    cast(
      do given GdkEventTypeEnum($!e.type) {
        when GDK_MOTION_NOTIFY       { GdkEventMotion }
        when GDK_EXPOSE              { GdkEventExpose }
        when GDK_BUTTON_PRESS        |
             GDK_2BUTTON_PRESS       |
             GDK_DOUBLE_BUTTON_PRESS |
             GDK_3BUTTON_PRESS       |
             GDK_TRIPLE_BUTTON_PRESS |
             GDK_BUTTON_RELEASE      { GdkEventButton }
        when GDK_KEY_PRESS           |
             GDK_KEY_RELEASE         { GdkEventKey }
        when GDK_ENTER_NOTIFY        |
             GDK_LEAVE_NOTIFY        { GdkEventCrossing  }
        when GDK_FOCUS_CHANGE        { GdkEventFocus     }
        when GDK_CONFIGURE           { GdkEventConfigure }
        when GDK_MAP                 |
             GDK_UNMAP               |
             GDK_PROPERTY_NOTIFY     { GdkEventProperty }
        when GDK_SELECTION_CLEAR     |
             GDK_SELECTION_REQUEST   |
             GDK_SELECTION_NOTIFY    { GdkEventSelection }
        when GDK_PROXIMITY_IN        |
             GDK_PROXIMITY_OUT       { GdkEventProximity }
        when GDK_DRAG_ENTER          |
             GDK_DRAG_LEAVE          |
             GDK_DRAG_MOTION         |
             GDK_DRAG_STATUS         |
             GDK_DROP_START          |
             GDK_DROP_FINISHED       { GdkEventDND }
        when GDK_SCROLL              { GdkEventScroll }
        when GDK_WINDOW_STATE        { GdkEventWindowState }
        when GDK_SETTING             { GdkEventSetting }
        when GDK_OWNER_CHANGE        { GdkEventOwnerChange }
        when GDK_GRAB_BROKEN         { GdkEventGrabBroken }
      },
      $!e
    );
  }

  # ↓↓↓↓ METHODS ↓↓↓↓
  method copy {
    gdk_event_copy($!e);
  }

  method free {
    gdk_event_free($!e);
  }

  method get_angle (GdkEvent() $event2, Num() $angle is rw)
    is also<get-angle>
  {
    my gdouble $a = $angle;

    gdk_events_get_angle($!e, $event2, $a);
  }

  method get_center (GdkEvent() $event2, Num() $x is rw, Num() $y is rw)
    is also<get-center>
  {
    my gdouble ($xx, $yy) = ($x, $y);

    gdk_events_get_center($!e, $event2, $xx, $yy);
  }

  method get_distance (GdkEvent() $event2, Num() $distance is rw)
    is also<get-distance>
  {
    my gdouble $d = $distance;

    gdk_events_get_distance($!e, $event2, $d);
  }

  method pending (GDK::Event:U) {
    gdk_events_pending();
  }

  method get (GDK::Event:U) {
    gdk_event_get();
  }

  method get_axis (
    Int() $axis_use,              # GdkAxisUse $axis_use,
    Num() $value
  )
    is also<get-axis>
  {
    my guint $au = $axis_use;
    my gdouble $v = $value;

    gdk_event_get_axis($!e, $au, $v);
  }

  proto method get_button (|)
   is also<get-button>
  { * }

  multi method get_button is also<buttom> {
    samewith($);
  }
  multi method get_button ($button is rw) {
    my guint $b = 0;

    gdk_event_get_button($!e, $b);
    $button = $b;
  }

  proto method get_click_count (|)
    is also<get-click-count>
  { * }

  multi method get_click_count is also<click-count> {
    samewith($);
  }
  multi method get_click_count ($click_count is rw)  {
    my guint $cc = 0;

    gdk_event_get_click_count($!e, $cc);
    $click_count = $cc;
  }

  proto method get_coords (|)
    is also<get-coords>
  { * }

  multi method get_coords is also<coords> {
    samewith($, $);
  }
  multi method get_coords ($x_win is rw, $y_win is rw)  {
    my gdouble ($xw, $yw) = ($x_win, $y_win);

    gdk_event_get_coords($!e, $xw, $yw);
    ($x_win, $y_win) = ($xw, $yw)
  }

  method get_event_sequence is also<get-event-sequence> {
    gdk_event_get_event_sequence($!e);
  }

  method get_event_type
    is also<
      get-event-type
      event_type
      event-type
    >
  {
    gdk_event_get_event_type($!e);
  }

  proto method get_keycode (|)
    is also<get-keycode>
  { * }

  multi method get_keycode is also<keycode> {
    samewith($);
  }
  multi method get_keycode ($keycode is rw)  {
    my guint16 $kc = 0;

    gdk_event_get_keycode($!e, $kc);
    $keycode = $kc;
  }

  proto method get_keyval (|)
  { * }

  multi method get_keyval is also<keyval> {
    samewith($);
  }
  multi method get_keyval ($keyval is rw) is also<get-keyval> {
    my guint $kv = 0;

    gdk_event_get_keyval($!e, $kv);
    $keyval = $kv;
  }

  method get_pointer_emulated is also<get-pointer-emulated> {
    gdk_event_get_pointer_emulated($!e);
  }

  proto method get_root_coords (|)
    is also<get-root-coords>
  { * }

  multi method get_root_coords {
    samewith($, $);
  }
  multi method get_root_coords ($x_root is rw, $y_root is rw) {
    my gdouble ($xr, $yr) = 0e0 xx 2;

    gdk_event_get_root_coords($!e, $xr, $yr);
    ($x_root, $y_root) = ($xr, $yr);
  }

  method get_scancode
    is also<
      get-scancode
      scancode
    >
  {
    gdk_event_get_scancode($!e);
  }

  proto method get_scroll_deltas (|)
    is also<get-scroll-deltas>
  { * }

  multi method get_scroll_deltas {
    samewith($, $);
  }
  multi method get_scroll_deltas ($delta_x is rw, $delta_y is rw) {
    my gdouble ($dx, $dy) = 0e0 xx 2;

    gdk_event_get_scroll_deltas($!e, $dx, $dy);
    ($delta_x, $delta_y) = ($dx, $dy);
  }

  proto method get_scroll_direction (|)
  { * }

  multi method get_scroll_direction is also<direction> {
    samewith($);
  }
  multi method get_scroll_direction ($direction is rw)
    is also<get-scroll-direction>
  {
    my GdkScrollDirection $d = 0;

    gdk_event_get_scroll_direction($!e, $d);
    $direction = $d;
  }

  method get_seat
    is also<
      get-seat
      seat
    >
  {
    gdk_event_get_seat($!e);
  }

  proto method get_state (|)
    is also<get-state>
  { * }

  multi method get_state is also<state> {
    samewith($);
  }
  multi method get_state ($state is rw) {
    my GdkModifierType $s = 0;

    gdk_event_get_state($!e, $s);
    $state = $s;
  }

  proto method get_time (|)
    is also<
      get-time
      time
    >
  { * }

  multi method get_time (GDK::Event:U: ) {
    gdk_event_get_time(GdkEvent);
  }
  multi method get_time (GDK::Event:D: ) {
    gdk_event_get_time($!e);
  }

  method get_window ( :$raw = False ) is also<get-window> {
    propReturnObject(
      gdk_event_get_window($!e),
      $raw,
      |::('GDK::Window').getTypePair
    )
  }

  method handler_set (
    &handler,
    gpointer $data = Pointer,
    GDestroyNotify $notify = Pointer
  )
    is also<handler-set>
  {
    gdk_event_handler_set(&handler, $data, $notify);
  }

  method is_scroll_stop_event is also<is-scroll-stop-event> {
    gdk_event_is_scroll_stop_event($!e);
  }

  method peek (GDK::Event:U) {
    gdk_event_peek();
  }

  method put {
    gdk_event_put($!e);
  }

  method request_motions (GDK::Event:U: GdkEventMotion $motion)
    is also<request-motions>
  {
    gdk_event_request_motions($motion);
  }

  method sequence_get_type is also<sequence-get-type> {
    gdk_event_sequence_get_type();
  }

  method triggers_context_menu is also<triggers-context-menu> {
    gdk_event_triggers_context_menu($!e);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
