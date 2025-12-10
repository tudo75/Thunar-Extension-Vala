using Thunarx;
using Gtk;
using GLib;

public class HelloPlugin : GLib.Object, Thunarx.MenuProvider {

    // 1. Updated signature: Gtk.Window -> Gtk.Widget
    public GLib.List<Thunarx.MenuItem> get_file_menu_items (Gtk.Widget window, GLib.List<Thunarx.FileInfo> files) {
        var items = new GLib.List<Thunarx.MenuItem> ();

        var item = new Thunarx.MenuItem ("HelloPlugin::say-hello", "Say Hello", "Shows a dialog", "dialog-information");
        
        item.activate.connect (() => {
            var msg = "You selected %u file(s).".printf(files.length());
            
            // 2. We must cast 'window' to 'Gtk.Window' because MessageDialog expects a Window, not a generic Widget
            var parent_window = window as Gtk.Window;
            
            var dialog = new MessageDialog (parent_window, DialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, msg);
            dialog.run ();
            dialog.destroy ();
        });

        items.append (item);
        return items;
    }

    // Updated signature here too
    public GLib.List<Thunarx.MenuItem> get_folder_menu_items (Gtk.Widget window, Thunarx.FileInfo folder) {
        var items = new GLib.List<Thunarx.MenuItem> ();

        var item = new Thunarx.MenuItem ("HelloPlugin::say-hello", "Say Hello", "Shows a dialog", "dialog-information");
        
        item.activate.connect (() => {
            var msg = "You selected %s folder(s).".printf(folder.get_name ());
            
            // 2. We must cast 'window' to 'Gtk.Window' because MessageDialog expects a Window, not a generic Widget
            var parent_window = window as Gtk.Window;
            
            var dialog = new MessageDialog (parent_window, DialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, msg);
            dialog.run ();
            dialog.destroy ();
        });

        items.append (item);
        return items;
    }

    // And here
    public GLib.List<Thunarx.MenuItem> get_dnd_menu_items (Gtk.Widget window, Thunarx.FileInfo folder, GLib.List<Thunarx.FileInfo> files) {
        return new GLib.List<Thunarx.MenuItem> ();
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
