use v6.c;

unit package GDK::Raw::Exports;

our @gdk-exports is export;

BEGIN {
  @gdk-exports = <
    Cairo
    GDK::Raw::Definitions
    GDK::Raw::Enums
    GDK::Raw::Structs
    GDK::Raw::Subs
  >;
}
