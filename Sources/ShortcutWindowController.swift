//
//  ShortcutWindowController.swift
//  grayscale
//
//  Created by Brett Gutstein on 6/11/20.
//  Copyright © 2020 Brett Gutstein. All rights reserved.
//

import Cocoa

class ShortcutWindowController: NSWindowController {

    @IBOutlet weak var shortcutView: MASShortcutView!

    var shortcut: MASShortcut?

    override func windowDidLoad() {
        super.windowDidLoad()

        self.shortcutView.associatedUserDefaultsKey = grayscaleShortcutName
        self.shortcutView.shortcutValueChange = { (sender) in
            guard let shortcutValue = self.shortcutView.shortcutValue else {
                MASShortcutMonitor.shared().unregisterShortcut(self.shortcut)
                return
            }
            self.shortcut = shortcutValue
            MASShortcutMonitor.shared().register(self.shortcut, withAction: toggleGrayscale)
        }
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)

        NSApp.activate(ignoringOtherApps: true)

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
    }

    override var windowNibName : String! {
      return "ShortcutWindow"
    }

}
