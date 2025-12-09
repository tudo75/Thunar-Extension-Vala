// file: sample-thunarx.vala
// compila con qualcosa tipo:
// valac --pkg gio-2.0 --pkg gmodule-2.0 --pkg thunarx-2 \
//       -X -shared -X -fPIC -X -Wl,-soname,libsample-thunarx.so \
//       -o libsample-thunarx.so sample-thunarx.vala

using GLib;
using Thunarx;

// Classe principale del plugin che fornisce un menu contestuale
public class SampleMenuProvider : Object, Thunarx.MenuProvider {

    public SampleMenuProvider () {
    }

    // Metodo richiesto da Thunarx.MenuProvider:
    // viene chiamato per costruire le voci di menu sul click destro
    public GLib.List<Thunarx.MenuItem> get_file_menu_items (Gtk.Window window, GLib.List<Thunarx.FileInfo> files) {
        var items = new List<Thunarx.MenuItem> ();

        // Semplice esempio: se c’è almeno un file, aggiungi una voce di menu
        if (files != null && files.length () > 0) {
            var item = new Thunarx.MenuItem ("MyPlugin::ShowName", "Mostra Nome File (Vala)", "Mostra il nome del file", "dialog-information");
            item.activate.connect (() => {
                // Qui fai qualcosa con i file selezionati
                foreach (var info in files) {
                    message ("Selected: %s", info.get_name ());
                }
            });
            items.append (item);
        }

        return items;
    }

    // Per completezza, ma spesso puoi lasciarlo vuoto
    public GLib.List<Thunarx.MenuItem> get_folder_menu_items (Gtk.Window window, Thunarx.FileInfo folder) {
        return new List<Thunarx.MenuItem> ();
    }
}

// lista globale di tipi esportati
// private static Type[] type_list = new Type[1];

// Definiamo i callback statici fittizi per l'API manuale, 
// ma il loro contenuto viene gestito dai costruttori della classe.
void module_instance_init (Object object) {}
void module_class_init (ObjectClass klass) {}

// registra il tipo come provider Thunarx
private static void sample_extension_register_type (Thunarx.ProviderPlugin plugin) {
    // Usiamo le query Vala per ottenere le dimensioni strutturali in modo robusto
    GLib.TypeQuery qdata;
    typeof (SampleMenuProvider).query(out qdata);

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

    var type = typeof (SampleMenuProvider);
    // registra SampleMenuProvider come provider basato su GObject
    plugin.register_type (
        type,
        "SampleMenuProvider",       // Nome del tipo
        info,                 // La struct TypeInfo riempita
        0                     // Flag
    );
}

// funzione di utilità (equivalente a foo_extension_get_type in C)
private static Type sample_extension_get_type () {
    return typeof (SampleMenuProvider);
}

// Funzioni esportate richieste da Thunarx

[CCode (cname = "thunar_extension_initialize")]
public static void thunar_extension_initialize (Thunarx.ProviderPlugin plugin) {
    // controlla compatibilità versione
    string? mismatch = Thunarx.check_version (
        Thunarx.MAJOR_VERSION,
        Thunarx.MINOR_VERSION,
        Thunarx.MICRO_VERSION
    );

    if (mismatch != null) {
        warning ("Thunarx version mismatch: %s", mismatch);
        return;
    }

    // registra i tipi del plugin
    sample_extension_register_type (plugin);
}

[CCode (cname = "thunar_extension_shutdown")]
public static void thunar_extension_shutdown () {
    // eventuale cleanup specifico del plugin
}

/*
 * Entry Point per elencare i tipi (richiesto da Thunarx).
 */
[CCode (cname = "thunar_extension_list_types")]
public void thunar_extension_list_types (Thunarx.ProviderPlugin plugin, ref ulong[] types) {
    // Non strettamente necessario implementarlo manualmente in Vala moderno se si usa register_type sopra,
    // ma per compatibilità con l'API C di Thunar:
    types = new ulong[] { typeof (SampleMenuProvider) };
}

