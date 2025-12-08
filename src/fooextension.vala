using Thunarx;
using GLib;
using Gtk; // Necessario per Gtk.Window e MessageDialog

namespace Thunar {

    /*
     * 1. CLASSE IDIOMATICA Vala
     * Eredita da GObject e implementa l'interfaccia Thunarx.MenuProvider.
     */
    public class PluginVala : GLib.Object, Thunarx.MenuProvider {
        
        // Corrisponde a: (GInstanceInitFunc) foo_extension_init
        construct {
            // Logica di inizializzazione dell'istanza
        }

        // Corrisponde a: (GClassInitFunc) foo_extension_class_init
        static construct {
            // Logica di inizializzazione della classe
        }

        /* --- Implementazione di Thunarx.MenuProvider --- */

        public List<Thunarx.MenuItem> get_file_menu_items (Gtk.Window window, List<Thunarx.FileInfo> files) {
            
            if (files.length() == 0) {
                //return null;
            }

            var item = new Thunarx.MenuItem ("Foo::SayHello", "Saluta da Vala Idiomatico", "dialog-information", "");
            
            // Uso di una Closure Vala per gestire l'evento 'activate' (più pulito del C)
            item.activate.connect (() => {
                var first_file = files.data; 
                var dialog = new MessageDialog (window, 
                                                DialogFlags.MODAL, 
                                                MessageType.INFO, 
                                                ButtonsType.OK, 
                                                "File is: %s", first_file.get_name());
                dialog.run ();
                dialog.destroy ();
            });

            var result = new List<Thunarx.MenuItem> ();
            result.append (item);
            
            return result;
        }

        public List<Thunarx.MenuItem> get_folder_menu_items (Gtk.Window window, Thunarx.FileInfo folder) {
            
            if (folder == null) {
                //return null;
            }

            var item = new Thunarx.MenuItem ("Foo::SayHello", "Saluta da Vala Idiomatico", "dialog-information", "");
            
            // Uso di una Closure Vala per gestire l'evento 'activate' (più pulito del C)
            item.activate.connect (() => {
                var dialog = new MessageDialog (window, 
                                                DialogFlags.MODAL, 
                                                MessageType.INFO, 
                                                ButtonsType.OK, 
                                                "Directory is: %s", folder.get_name());
                dialog.run ();
                dialog.destroy ();
            });

            var result = new List<Thunarx.MenuItem> ();
            result.append (item);
            
            return result;
        }
    }
}

/* --- Variabili e Entry Points (Mantenuti per l'ABI di Thunar) --- */

static Type[] type_list;

// Definiamo i callback statici fittizi per l'API manuale, 
// ma il loro contenuto viene gestito dai costruttori della classe.
void module_instance_init (Object object) {}
void module_class_init (ObjectClass klass) {}

[CCode (cname = "thunar_extension_initialize")]
public void thunar_extension_initialize (Thunarx.ProviderPlugin plugin) {
    
    unowned string? mismatch = Thunarx.check_version (
        Thunarx.MAJOR_VERSION, 
        Thunarx.MINOR_VERSION, 
        Thunarx.MICRO_VERSION
    );

    if (mismatch != null) {
        warning ("Version mismatch: %s", mismatch);
        return;
    }

    // Usiamo le query Vala per ottenere le dimensioni strutturali in modo robusto
    GLib.TypeQuery qdata;
    typeof (Thunar.PluginVala).query(out qdata);

    /* * 2. REGISTRAZIONE COMPROMESSO: Usiamo TypeInfo, ma con i dati Vala.
     * Vala ignora i puntatori init/class_init in TypeInfo quando registri una classe Vala.
     * Tuttavia, il VAPI ci FORZA a passare la struct completa.
     */
    var info = TypeInfo () {
        class_size = (ushort) qdata.class_size,
        instance_size = (ushort) qdata.instance_size,
        // Usiamo puntatori fittizi ma corretti per la firma richiesta
        class_init = (ClassInitFunc) module_class_init, 
        instance_init = (InstanceInitFunc) module_instance_init, 
        // Tutti gli altri campi sono a zero/null
    };

    var type = plugin.register_type (
        typeof (GLib.Object), // G_TYPE_OBJECT
        "FooExtension",       // Nome del tipo
        info,                 // La struct TypeInfo riempita
        0                     // Flag
    );
/*
    // CHIAMATA FINALE: Usiamo il binding grezzo e castiamo i tipi GObject
    plugin.add_interface (
        (ulong) type, // Castiamo il GType del nostro tipo (instance_type)
        (ulong) typeof (Thunarx.MenuProvider), // Castiamo il GType dell'interfaccia
        null 
    );
*/
    type_list += type;
}

[CCode (cname = "thunar_extension_shutdown")]
public void thunar_extension_shutdown () {
    // Shutdown
}

[CCode (cname = "thunar_extension_list_types")]
public void thunar_extension_list_types (out Type[] types) {
    types = type_list;
}