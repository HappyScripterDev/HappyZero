#!/usr/bin/env python3
"""
Happy Zero Welcome App
First-run application for Happy Zero Linux distribution
GTK4 + libadwaita
"""

import sys
import gi

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, Adw


class HappyZeroWelcomeApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="org.happyzero.Welcome")
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        window = Adw.ApplicationWindow(application=app)
        window.set_title("Welcome to Happy Zero")
        window.set_default_size(800, 600)
        
        # Main content
        header = Adw.HeaderBar()
        view_stack = Adw.ViewStack()
        
        # Simple welcome page
        page = Adw.StatusPage(
            title="Welcome to Happy Zero",
            description="Your system is ready to use. Get started below.",
            icon_name="start-here-symbolic"
        )
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.append(header)
        box.append(page)
        
        window.set_content(box)
        window.present()


def main():
    app = HappyZeroWelcomeApp()
    return app.run(sys.argv)


if __name__ == "__main__":
    main()
