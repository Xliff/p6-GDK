use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GDK::Raw::Definitions;

unit package GDK::Raw::Subs;

sub gdk_atom_name(GdkAtom)
  returns Str
  is native(gdk)
  is export
{ * }

sub gdkMakeAtom($i) is export {
  my gint $ii = $i +& 0x7fff;
  my $c = CArray[int64].new($ii);
  nativecast(GdkAtom, $c);
}

sub isShift (GdkEventKey() $e) is export {
  $e.state +& GDK_MODIFIER_SHIFT_MASK
}

sub isControl (GdkEventKey() $e) is export {
  $e.state +& GDK_MODIFIER_CONTROL_MASK;
}+
sub isCtrl (GdkEventKey() $e) is export {
  isControl($e);
}

sub isAlt (GdkKeyEvent() $e) is export {
  $e.state +& GDK_MODIFIER_ALT_MASK;
}
