<img src="https://github.com/brettferdosi/grayscale/raw/doc/icon.png" width="150px">

# grayscale

Grayscale is a menu bar app for macOS that allows you to easily toggle the grayscale display filter.

<img src="https://github.com/brettferdosi/grayscale/raw/doc/demo.png">

Graysacle has been tested on macOS 10.15 Catalina but may also work on other versions. 

## Installing grayscale

**Install option 1: run the installer (easiset)**

Download the most recent installer (`GrayscaleInstaller.pkg`) from [releases](https://github.com/brettferdosi/grayscale/releases) and run it (click [here](https://github.com/brettferdosi/grayscale/releases/latest/download/GrayscaleInstaller.pkg) to download directly). You will have to follow Apple's instructions for [opening an app from an unidentified developer](https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unidentified-developer-mh40616/mac) (basically, control-click the installer, click *Open*, then click *Open* again). It will install `grayscale.app` in `/Applications`. If there is already a version of `grayscale.app` on your system, the installer will detect and overwrite it.

**Install option 2: build from source**

Clone this git repository using `git clone --recurse-submodules` and run `xcodebuild -project grayscale.xcodeproj/ -scheme grayscale -configuration Release -derivedDataPath build`. `grayscale.app` will be placed into `build/Build/Products/Release`.

**Open at login**

Automatically open grayscale at login by following Apple's instructions [here](https://support.apple.com/guide/mac-help/open-items-automatically-when-you-log-in-mh15189/mac) (add grayscale to the list in System Preferences > Users & Groups > Login Items).

## Using grayscale

Left click the menu bar icon to toggle the system grayscale filter. Right click the menu bar icon to access the application's menu. From the menu, select Set Keyboard Shortcut then click on the Record Shortcut button to set a global keyboard shortcut for toggling the filter.

## Known issues

The system reports sandbox-related error messages when the app attempts to update the grayscale key in the `com.apple.universalaccess` preferences file (used by the system to track grayscale filter state), even though the grayscale app is not sandboxed:

```
sandboxd - Sandbox: grayscale(27954) System Policy: deny(1) file-write-data /Users/brett/Library/Preferences/com.apple.universalaccess.plist

cfprefsd - rejecting write of key(s) grayscale in { com.apple.universalaccess, brett, kCFPreferencesAnyHost, no container, managed: 0 } from process 27954 (grayscale) because setting preferences outside an application's container requires user-preference-write or file-write-data sandbox access

grayscale - Couldn't write values for keys ( grayscale ) in CFPrefsPlistSource<0x600002c03880> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No): setting preferences outside an application's container requires user-preference-write or file-write-data sandbox access
```

This seems to be a bug outside of the application, and despite these error messages, the grayscale filter toggles successfully. I have occasionally noticed grayscale toggling get stuck and stop working via the app, usually after significant system uptime. I have not diagnosed the cause of this behavior, but it may be related to sleep, other power events, or night shift. To get toggling working via the app again, simply toggle the grayscale filter manually from the preferences pane by going to System Preferences > Accessibility > Display > Color Filters.
