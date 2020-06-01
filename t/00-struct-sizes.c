/* Strategy provided by p6-XML-LibXML:author<FROGGS> */
#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT extern
#endif

#include <gdk/gdk.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

#define s(name)     DLLEXPORT int sizeof_ ## name () { return sizeof(name); }

s(GdkEventAny)
s(GdkEventButton)
s(GdkEventConfigure)
s(GdkEventCrossing)
s(GdkEventDND)
s(GdkEventExpose)
s(GdkEventFocus)
s(GdkEventGrabBroken)
s(GdkEventKey)
s(GdkEventMotion)
s(GdkEventOwnerChange)
s(GdkEventPadAxis)
s(GdkEventPadButton)
s(GdkEventPadGroupMode)
s(GdkEventProperty)
s(GdkEventProximity)
s(GdkEventScroll)
s(GdkEventSelection)
s(GdkEventSetting)
s(GdkEventTouch)
s(GdkEventTouchpadPinch)
s(GdkEventTouchpadSwipe)
s(GdkEventVisibility)
s(GdkEventWindowState)
s(GdkGeometry)
s(GdkKeymapKey)
s(GdkPoint)
s(GdkRectangle)
s(GdkRGBA)
s(GdkSeat)
s(GdkTimeCoord)
s(GdkWindowAttr)
s(GdkWindowClass)
