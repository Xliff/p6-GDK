gcc -DGDK_PIXBUF_ENABLE_BACKEND -pthread -I/usr/local/include/pango-1.0 -I/usr/include/gtk-3.0 -I/usr/include/gio-unix-2.0 -I/usr/include/cairo -I/usr/include/fribidi -I/usr/include/harfbuzz -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/cairo -I/usr/include/pixman-1 -I/usr/include/uuid -I/usr/include/freetype2 -I/usr/include/libpng16 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include 00-struct-sizes.c -fPIC -shared -L/usr/local/lib/x86_64-linux-gnu -lgdk-3 -lpangocairo-1.0 -lpango-1.0 -lharfbuzz -lgdk_pixbuf-2.0 -lcairo-gobject -lcairo -lgobject-2.0 -lglib-2.0 -o 00-struct-sizes.so