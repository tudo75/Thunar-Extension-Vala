using Gtk;
using Thunarx;

/* * Definiamo la classe principale del Plugin.
 * Deve ereditare da GLib.Object e implementare l'interfaccia desiderata 
 * (in questo caso MenuProvider per il tasto destro).
 */
public class MyThunarPlugin : GLib.Object, Thunarx.MenuProvider {

    // Questa funzione viene chiamata quando l'utente fa clic destro su dei file
    public GLib.List<Thunarx.MenuItem> get_file_menu_items (Gtk.Window window, GLib.List<Thunarx.FileInfo> files) {
        var items = new GLib.List<Thunarx.MenuItem> ();

        // Esempio: Mostra l'azione solo se è selezionato un solo file
        if (files.length () == 1) {
            var file = files.data;
            
            // Creiamo la voce di menu
            // Argomenti: nome_univoco, etichetta_visibile, tooltip, icona
            var item = new Thunarx.MenuItem ("MyPlugin::ShowName", "Mostra Nome File (Vala)", "Mostra il nome del file", "dialog-information");
            
            // Connettiamo il segnale 'activate' alla nostra funzione
            item.activate.connect (() => {
                this.on_show_info (window, file);
            });

            items.append (item);
        }

        return items;
    }

    // Questa funzione è per quando si clicca sullo sfondo della cartella (non su un file)
    public GLib.List<Thunarx.MenuItem> get_folder_menu_items (Gtk.Window window, Thunarx.FileInfo folder) {
        return new GLib.List<Thunarx.MenuItem> (); // Lista vuota
    }

    // L'azione che viene eseguita quando si clicca sulla voce di menu
    private void on_show_info (Gtk.Window window, Thunarx.FileInfo file) {
        var dialog = new MessageDialog (
            window, 
            DialogFlags.MODAL, 
            MessageType.INFO, 
            ButtonsType.OK, 
            "Hai selezionato: %s", file.get_name ()
        );
        dialog.run ();
        dialog.destroy ();
    }
}

// Definiamo i callback statici fittizi per l'API manuale, 
// ma il loro contenuto viene gestito dai costruttori della classe.
void module_instance_init (Object object) {}
void module_class_init (ObjectClass klass) {}

/* * PUNTO CRUCIALE: Entry Point del Plugin.
 * Thunar cerca specificamente la funzione C "thunar_extension_initialize".
 * Dobbiamo usare [CCode] per assicurarci che Vala esporti il nome esatto richiesto da C.
 */
[CCode (cname = "thunar_extension_initialize")]
public void thunar_extension_initialize (Thunarx.ProviderPlugin plugin) {
    // Registriamo il nostro tipo all'interno del sistema di estensioni di Thunar
    // Questo sostituisce la macro G_DEFINE_DYNAMIC_TYPE in C

    // Usiamo le query Vala per ottenere le dimensioni strutturali in modo robusto
    GLib.TypeQuery qdata;
    typeof (MyThunarPlugin).query(out qdata);

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

    var type = typeof (MyThunarPlugin);
    plugin.register_type (
        type,
        "MyThunarPlugin",       // Nome del tipo
        info,                 // La struct TypeInfo riempita
        0                     // Flag
    );

    // CHIAMATA FINALE: Usiamo il binding grezzo e castiamo i tipi GObject
    plugin.add_interface (
        (ulong) type, // Castiamo il GType del nostro tipo (instance_type)
        (ulong) typeof (MyThunarPlugin), // Castiamo il GType dell'interfaccia
        GLib.InterfaceInfo () {
            // Puntatore alla funzione di init definita sopra
            interface_init = (GLib.InterfaceInitFunc) module_instance_init,
            
            // Finalize e Data sono quasi sempre null per i plugin standard
            interface_finalize = null, 
            interface_data = null
        }
    );
}

/* * Entry Point per lo spegnimento (opzionale, ma buona norma).
 * Thunar cerca "thunar_extension_shutdown".
 */
[CCode (cname = "thunar_extension_shutdown")]
public void thunar_extension_shutdown (Thunarx.ProviderPlugin plugin) {
    // Di solito vuoto in Vala, la gestione della memoria è automatica
}

/*
 * Entry Point per elencare i tipi (richiesto da Thunarx).
 */
[CCode (cname = "thunar_extension_list_types")]
public void thunar_extension_list_types (Thunarx.ProviderPlugin plugin, ref ulong[] types) {
    // Non strettamente necessario implementarlo manualmente in Vala moderno se si usa register_type sopra,
    // ma per compatibilità con l'API C di Thunar:
    types = new ulong[] { typeof (MyThunarPlugin) };
}