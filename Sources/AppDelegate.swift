//
//  AppDelegate.swift
//  grayscale
//
//  Created by Brett Gutstein on 5/24/20.
//  Copyright © 2020 Brett Gutstein. All rights reserved.
//

import Cocoa
import Carbon

// user defaults keys
let grayscaleShortcutName = "grayscale_shortcut"
let perAppGrayscaleEnabledDictName = "grayscale_dict"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // application state management

    var currentApplication: NSRunningApplication!
    var defaultGrayscaleEnabled: Bool = false
    var perAppGrayscaleEnabledDict: [String: Bool] = [:]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        grayscaleLog("")

        defaultGrayscaleEnabled = grayscaleEnabled()
        currentApplication = NSWorkspace.shared.frontmostApplication!
        perAppGrayscaleEnabledDict = UserDefaults.standard.dictionary(forKey: perAppGrayscaleEnabledDictName) as? [String: Bool] ?? [:]

        createUI()
        updateUI()

        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: grayscaleShortcutName, toAction: toggleDefaultGrayscale)

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleApplicationChange(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleDisplayChange(_:)), name: NSWorkspace.accessibilityDisplayOptionsDidChangeNotification, object: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        grayscaleLog("")

        setGrayscale(defaultGrayscaleEnabled)

        MASShortcutMonitor.shared().unregisterAllShortcuts()
    }

    @objc func handleDisplayChange(_ aNotification: Notification) {
        // if the new grayscale value doesn't match our application state, it was changed
        // from somewhere outside this application (e.g. the settings pane). for now we don't do
        // anything special in this case - just let the grayscale filter stay out of sync
        // with the application state until the user does something that brings it back in
        // line, like switching active apps.
    }

    @objc func handleApplicationChange(_ aNotification: Notification) {
        currentApplication = (aNotification.userInfo!["NSWorkspaceApplicationKey"] as! NSRunningApplication)
        grayscaleLog("\(currentApplication.localizedName!) got focus")
        updateUI()
    }

    @objc func appSpecificMenuClick(_ sender: Any) {
        let senderObject = sender as! NSObject
        if senderObject == appSpecificSubMenuItemGrayscaleDefault {
            grayscaleLog("default")
            perAppGrayscaleEnabledDict.removeValue(forKey: currentApplication.bundleIdentifier!)
        }

        if senderObject == appSpecificSubMenuItemGrayscaleEnabled {
            grayscaleLog("enabled")
            perAppGrayscaleEnabledDict[currentApplication.bundleIdentifier!] = true
        }

        if senderObject == appSpecificSubMenuItemGrayscaleDisabled {
            grayscaleLog("disabled")
            perAppGrayscaleEnabledDict[currentApplication.bundleIdentifier!] = false
        }

        UserDefaults.standard.setValue(perAppGrayscaleEnabledDict, forKey: perAppGrayscaleEnabledDictName)

        updateUI()
    }

    func toggleDefaultGrayscale() {
        grayscaleLog("toggling default from \(defaultGrayscaleEnabled)")
        defaultGrayscaleEnabled = !defaultGrayscaleEnabled
        updateUI()
    }

    @objc func statusBarButtonClick(_ sender: Any) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.leftMouseUp {
            toggleDefaultGrayscale()
        } else if event.type == NSEvent.EventType.rightMouseUp {
            statusItem.popUpMenu(statusMenu)
        }
    }

    @objc func quit(_ sender: Any) {
        NSApp.terminate(self)
    }

    // user interface

    func updateUI() {
        defaultGrayscaleMenuItem.title = defaultGrayscaleEnabled ? "Grayscale Default: Enabled" : "Grayscale Default: Disabled"
        appSpecificMenuItem.title = currentApplication.localizedName!

        if let appSpecificEnableGrayscale = perAppGrayscaleEnabledDict[currentApplication.bundleIdentifier!] {
            if appSpecificEnableGrayscale {
                // grayscale is enabled for this app
                updateAppSpecificSubMenu(.ENABLED)
                setGrayscale(true)
            } else {
                // grayscale is disabled for this app
                updateAppSpecificSubMenu(.DISABLED)
                setGrayscale(false)
            }
        } else {
            // no app-specific behavior - use the default grayscale value
            updateAppSpecificSubMenu(.DEFAULT)
            setGrayscale(defaultGrayscaleEnabled)
        }
    }

    var statusItem: NSStatusItem!
    var statusMenu: NSMenu!
    var defaultGrayscaleMenuItem: NSMenuItem!
    var appSpecificMenuItem: NSMenuItem!
    var appSpecificSubMenuItemGrayscaleDefault: NSMenuItem!
    var appSpecificSubMenuItemGrayscaleDisabled: NSMenuItem!
    var appSpecificSubMenuItemGrayscaleEnabled: NSMenuItem!
    var shortcutWindowController: ShortcutWindowController!

    func createUI() {
        shortcutWindowController = ShortcutWindowController(toggleDefaultGrayscale)

        statusMenu = NSMenu()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let menuButton = statusItem.button else {
            grayscaleLog("couldn't get status item button")
            NSApp.terminate(self)
            return
        }

        menuButton.image = NSImage(named: "MenuBarIcon")
        menuButton.action = #selector(statusBarButtonClick(_:))
        menuButton.sendAction(on: [.leftMouseUp, .rightMouseUp])

        defaultGrayscaleMenuItem = NSMenuItem(title: "Grayscale Default", action: nil, keyEquivalent: "")
        statusMenu.addItem(defaultGrayscaleMenuItem)

        appSpecificMenuItem = NSMenuItem(title: "App Name", action: nil, keyEquivalent: "")
        appSpecificSubMenuItemGrayscaleDefault = NSMenuItem(title: "Default",  action: #selector(appSpecificMenuClick(_:)), keyEquivalent: "")
        appSpecificSubMenuItemGrayscaleEnabled = NSMenuItem(title: "Enable Grayscale", action: #selector(appSpecificMenuClick(_:)), keyEquivalent: "")
        appSpecificSubMenuItemGrayscaleDisabled = NSMenuItem(title: "Disable Grayscale", action: #selector(appSpecificMenuClick(_:)), keyEquivalent: "")
        appSpecificMenuItem.submenu = NSMenu()
        appSpecificMenuItem.submenu!.addItem(appSpecificSubMenuItemGrayscaleDefault)
        appSpecificMenuItem.submenu!.addItem(appSpecificSubMenuItemGrayscaleEnabled)
        appSpecificMenuItem.submenu!.addItem(appSpecificSubMenuItemGrayscaleDisabled)

        statusMenu.addItem(appSpecificMenuItem)
        statusMenu.addItem(NSMenuItem.separator())

        statusMenu.addItem(NSMenuItem(title: "Default Toggle Shortcut", action: #selector(showShortcutWindow(_:)), keyEquivalent: ""))
        statusMenu.addItem(NSMenuItem.separator())

        statusMenu.addItem(NSMenuItem(title: "About", action: #selector(showAboutPanel(_:)), keyEquivalent: ""))
        statusMenu.addItem(NSMenuItem.separator())

        statusMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quit(_:)), keyEquivalent: ""))
    }

    @objc func showShortcutWindow(_ sender: Any) {
        grayscaleLog("")
        shortcutWindowController.showWindow(sender)
    }

    enum AppSpecificGrayscaleStatus: Int {
        case DEFAULT = 0
        case ENABLED
        case DISABLED
    }

    func updateAppSpecificSubMenu(_ grayscaleStatus: AppSpecificGrayscaleStatus) {
        switch grayscaleStatus {
        case .DEFAULT:
            appSpecificSubMenuItemGrayscaleDefault.state = .on
            appSpecificSubMenuItemGrayscaleEnabled.state = .off
            appSpecificSubMenuItemGrayscaleDisabled.state = .off
        case .ENABLED:
            appSpecificSubMenuItemGrayscaleDefault.state = .off
            appSpecificSubMenuItemGrayscaleEnabled.state = .on
            appSpecificSubMenuItemGrayscaleDisabled.state = .off
        case .DISABLED:
            appSpecificSubMenuItemGrayscaleDefault.state = .off
            appSpecificSubMenuItemGrayscaleEnabled.state = .off
            appSpecificSubMenuItemGrayscaleDisabled.state = .on
        }
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

        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(options: [ .credits : credits ])
    }
}
