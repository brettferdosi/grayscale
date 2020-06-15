<img src="https://github.com/brettferdosi/grayscale/raw/doc/icon.png" width="150px">

# grayscale

Grayscale is a menu bar app for macOS that allows you to easily toggle the grayscale display filter.

<img src="https://github.com/brettferdosi/grayscale/raw/doc/demo.png">

Graysacle has been tested on macOS 10.15 Catalina but may also work on other versions. 

## Installing grayscale

**Install option 1: run the installer (easiset)**

Download the most recent installer (`GrayscaleInstaller.pkg`) from [releases](https://github.com/brettferdosi/grayscale/releases) and run it (click [here](https://github.com/brettferdosi/grayscale/releases/latest/download/GrayscaleInstaller.pkg) to download directly). You will have to follow Apple's instructions for [opening an app from an unidentified developer](https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unidentified-developer-mh40616/mac) (basically, control-click the installer, click *Open*, then click *Open* again). It will install `grayscale.app` in `/Applications`. If there is already a version of `grayscale.app` on your system, the installer will detect and overwrite it.

**Install option 2: build from source**

Clone this git repository using `git clone --recurse-submodules` and run `xcodebuild -project grayscale.xcodeproj -scheme grayscale -configuration Release -derivedDataPath build`. `grayscale.app` will be placed into `build/Build/Products/Release`.

**Optional: open at login**

Automatically open grayscale at login by following Apple's instructions [here](https://support.apple.com/guide/mac-help/open-items-automatically-when-you-log-in-mh15189/mac) (add grayscale to the list in System Preferences > Users & Groups > Login Items).

## Using grayscale

Left click the menu bar icon to toggle the system grayscale filter. Right click the menu bar icon to access the application's menu. From the menu, select Set Keyboard Shortcut then click on the Record Shortcut button to set a global keyboard shortcut for toggling the filter.

## Troubleshooting

This app uses reverse-engineered private frameworks to toggle the grayscale filter (see `Sources/Bridge.h` for details). If you notice any abnormal behavior, please open an issue with as much information as possible, and I will do my best to fix it. If grayscale toggling via the app stops working, you may be able to get it working again by manually toggling the grayscale filter once in System Preferences > Accessibility > Display > Color Filters.
