//
//  AppDelegate.swift
//  grayscale
//
//  Created by Brett Gutstein on 5/24/20.
//  Copyright © 2020 Brett Gutstein. All rights reserved.
//

import Cocoa
import Carbon

var statusItem: NSStatusItem!
var statusMenu: NSMenu!

// logging
enum LogLevel: Int {
    case VERBOSE = 0
    case ALWAYS_PRINT
}
let currentLogLevel: LogLevel = .ALWAYS_PRINT
func grayscaleLog(logLevel: LogLevel = .ALWAYS_PRINT, _ format: String,
               file: String = #file, caller: String = #function, args: CVarArg...) {
    if (logLevel.rawValue >= currentLogLevel.rawValue) {
        let fileName = file.components(separatedBy: "/").last ?? ""
        NSLog("\(fileName):\(caller) " + format, args)
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func toggleGrayscale() {
        // console messages will complain that writing the grayscale preference in
        // com.apple.universalaccess was rejected due to missing sandbox privileges
        // despite this app not being sandboxed; this is a bug and grayscale mode
        // will be toggled anyway
        UAGrayscaleSetEnabled(!UAGrayscaleIsEnabled());
    }

    @objc func buttonClick(_ sender: Any) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.leftMouseUp {
            toggleGrayscale()
        } else if event.type == NSEvent.EventType.rightMouseUp {
            // BFG: need a hack to mimic this behavior when .popUpMenu() goes away
            statusItem.popUpMenu(statusMenu)
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusMenu = NSMenu()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let menuButton = statusItem.button else {
            grayscaleLog("couldn't get status item button")
            NSApp.terminate(self)
            return
        }

        menuButton.image = NSImage(named: "MenuBarIcon")
        menuButton.action = #selector(buttonClick(_:))
        menuButton.sendAction(on: [.leftMouseUp, .rightMouseUp])

        statusMenu.addItem(NSMenuItem(title: "About", action: #selector(showAboutPanel(_:)), keyEquivalent: ""))
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(NSMenuItem(title: "Preferences", action: #selector(pref(_:)), keyEquivalent: ""))
                statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quit(_:)), keyEquivalent: ""))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @objc func pref(_ sender: Any) {
        
    }
    
    @objc func quit(_ sender: Any) {
        NSApp.terminate(self)
    }

    @objc func showAboutPanel(_ sender: Any) {
        let github = NSMutableAttributedString(string: "https://github.com/brettferdosi/grayscale")
        github.addAttribute(.link, value: "https://github.com/brettferdosi/grayscale",
                            range: NSRange(location: 0, length: github.length))

        let website = NSMutableAttributedString(string: "https://brett.gutste.in")
        website.addAttribute(.link, value: "https://brett.gutste.in",
                             range: NSRange(location: 0, length: website.length))

        let credits = NSMutableAttributedString(string:"")
        credits.append(github)
        credits.append(NSMutableAttributedString(string: "\n"))
        credits.append(website)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        credits.addAttribute(.paragraphStyle, value: paragraphStyle,
                             range: NSRange(location: 0, length: credits.length))

        // setting the activation policy and calling activate() doesn't
        // make our app visible on the dock or make a blank window appear,
        // but it allows our about panel to display in front of other apps
        NSApp.setActivationPolicy(.accessory)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(options: [ .credits : credits ])
    }
}

