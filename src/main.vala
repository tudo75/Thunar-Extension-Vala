using Thunarx;
using Gtk;
using GLib;

public class HelloPlugin : GLib.Object, Thunarx.MenuProvider, Thunarx.PropertyPageProvider{

    /**
     * Add menu item to the file menu when you right click on a file or a folder.
     * 
     * @param window The current Thunar window.
     * @raram files The selected files and/or folders when you right click.
     * @return A list of menu items.
     *
     * @since 0.0.1
     */
    // 1. Updated signature: Gtk.Window -> Gtk.Widget
    public GLib.List<Thunarx.MenuItem> get_file_menu_items (Gtk.Widget window, GLib.List<Thunarx.FileInfo> files) {
        var items = new GLib.List<Thunarx.MenuItem> ();

        var item = new Thunarx.MenuItem ("HelloPlugin::say-hello", _("Say Hello"), _("Shows a dialog"), "dialog-information");
        
        item.activate.connect (() => {
            var msg = _("You selected %u file(s)/folder(s).").printf(files.length());
            
            // 2. We must cast 'window' to 'Gtk.Window' because MessageDialog expects a Window, not a generic Widget
            var parent_window = window as Gtk.Window;
            
            var dialog = new MessageDialog (parent_window, DialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, msg);
            dialog.run ();
            dialog.destroy ();
        });

        items.append (item);
        return items;
    }

    /**
     * Add menu item to the file menu when you right click on a blank space of the current open folder panel.
     * 
     * @param window The current Thunar window.
     * @raram folder The current folder where you right click.
     * @return A list of menu items.
     *
     * @since 0.0.1
     */
    // Updated signature here too
    public GLib.List<Thunarx.MenuItem> get_folder_menu_items (Gtk.Widget window, Thunarx.FileInfo folder) {
        var items = new GLib.List<Thunarx.MenuItem> ();

        var item = new Thunarx.MenuItem ("HelloPlugin::say-hello", _("Say Hello"), _("Shows a dialog"), "dialog-information");
        
        item.activate.connect (() => {
            var msg = _("You selected %s folder.").printf(folder.get_name ());
            
            // 2. We must cast 'window' to 'Gtk.Window' because MessageDialog expects a Window, not a generic Widget
            var parent_window = window as Gtk.Window;
            
            var dialog = new MessageDialog (parent_window, DialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, msg);
            dialog.run ();
            dialog.destroy ();
        });

        items.append (item);
        return items;
    }

    /**
     * Add menu item to the file menu when you drag something to the current open folder panel.
     * 
     * @param window The current Thunar window.
     * @raram folder The current folder where you drag something.
     * @raram files The selected files and/or folders that are you dragging.
     * @return A list of menu items.
     *
     * @since 0.0.1
     */
    // And here
    // TODO: doesn't show menu itam. May be a bug on XFCE or Mint, because doen't show neither thunar-archive-plugin menu item
    public GLib.List<Thunarx.MenuItem> get_dnd_menu_items (Gtk.Widget window, Thunarx.FileInfo folder, GLib.List<Thunarx.FileInfo> files) {
        var items = new GLib.List<Thunarx.MenuItem> ();

        var item = new Thunarx.MenuItem ("HelloPlugin::say-hello-dnd", _("Say Hello"), _("Shows a dialog"), "dialog-information");
        
        item.activate.connect (() => {
            var msg = _("You selected %u file(s)/folder(s) to drag into %s folder.").printf(files.length(), folder.get_name ());
            print (msg);
            
            // 2. We must cast 'window' to 'Gtk.Window' because MessageDialog expects a Window, not a generic Widget
            var parent_window = window as Gtk.Window;
            
            var dialog = new MessageDialog (parent_window, DialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, msg);
            dialog.run ();
            dialog.destroy ();
        });

        items.append (item);
        return items;
    }

    /**
     * Add property page to the file property widget.
     * 
     * @raram files The selected files and/or folders on which you right click.
     * @return A list of property pages.
     *
     * @since 0.0.1
     */
    public GLib.List<Thunarx.PropertyPage> get_pages (GLib.List<Thunarx.FileInfo> files) {
        var pages = new GLib.List<Thunarx.PropertyPage> (); 

        var page = new Thunarx.PropertyPage (_("Say Hello"));
        if (files != null) {
            page.set_border_width (8);
            var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            var vscroll = new Gtk.ScrolledWindow (null, null);
            foreach (var item in files) {
                vbox.add ( new Gtk.Label (item.get_name ()));
            }
            vscroll.add (vbox);
            page.add (vscroll);
            page.show_all ();
        }

        pages.append (page);
        return pages;
    }
}

/* --- REGISTRATION BOILERPLATE --- */

[CCode (cname = "thunar_extension_initialize")]
public void extension_initialize (Thunarx.ProviderPlugin plugin) {
    // Force the extension to stay in memory.
    // Thunar often unloads extensions if they don't explicitly say "I am resident".
    plugin.set_resident (true);
}

[CCode (cname = "thunar_extension_shutdown")]
public void extension_shutdown () {
}

[CCode (cname = "thunar_extension_list_types")]
public void extension_list_types (out Type[] types) {
    // FIXED: Changed 'GType' to 'Type'
    types = new Type[] { typeof (HelloPlugin) };
}
