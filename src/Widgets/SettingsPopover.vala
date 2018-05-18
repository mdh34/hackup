public class SettingsPopover : Gtk.Popover {
    public SettingsPopover () {
        var settings_label = new Gtk.Label ("Sort stories by:");
        var top_radio = new Gtk.RadioButton.with_label (null, "Top");
        var best_radio = new Gtk.RadioButton.with_label_from_widget (top_radio, "Best");
        var new_radio = new Gtk.RadioButton.with_label_from_widget (top_radio, "New");

        var settings_box = new Gtk.Box (Gtk.Orientation.VERTICAL,5);
        settings_box.border_width = 10;
        settings_box.pack_start (settings_label);
        settings_box.pack_start (top_radio);
        settings_box.pack_start (best_radio);
        settings_box.pack_start (new_radio);
        settings_box.show_all ();
        add (settings_box);
    }
}