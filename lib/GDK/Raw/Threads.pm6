use v6.c;

use NativeCall;

use GDK::Raw::Types;

unit package GDK::Raw::Threads;

sub gdk_threads_add_idle (
           &function (Pointer --> guint32),
  gpointer $data
)
  returns guint
  is native(gdk)
  is export
{ * }

sub gdk_threads_add_idle_full (
  gint           $priority,
                 &idle-function (Pointer --> guint32),
  gpointer       $data,
                 &function (gpointer)
)
  returns guint
  is native(gdk)
  is export
{ * }

sub gdk_threads_add_timeout (
  guint    $interval,
           &function (Pointer --> guint32),
  gpointer $data
)
  returns guint
  is native(gdk)
  is export
{ * }

sub gdk_threads_add_timeout_full (
  gint     $priority,
  guint    $interval,
           &timeout-function (Pointer --> guint32),
  gpointer $data,
           &function (gpointer)
)
  returns guint
  is native(gdk)
  is export
{ * }

sub gdk_threads_add_timeout_seconds (
  guint    $interval,
           &function (Pointer --> guint32),
  gpointer $data
)
  returns guint
  is native(gdk)
  is export
{ * }

sub gdk_threads_add_timeout_seconds_full (
  gint     $priority,
  guint    $interval,
           &timeout-function (Pointer --> guint32),
  gpointer $data,
           &function (gpointer)
)
  returns guint
  is native(gdk)
  is export
{ * }
