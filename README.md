<img src="https://github.com/brettferdosi/grayscale/raw/doc/icon.png" width="150px">

# grayscale

`grayscale` is a macOS status bar app for managing the system grayscale display filter. It allows you to toggle grayscale mode easily by clicking the status bar icon or using a keyboard shortcut, and it also supports enabling or disabling grayscale based on which application is currently active.

Using the grayscale filter can be effective in reducing screen time. For more information, check out the following links:

- https://www.nytimes.com/2018/01/12/technology/grayscale-phone.html
- https://blog.mozilla.org/internetcitizen/2018/02/13/grayscale/

<img src="https://github.com/brettferdosi/grayscale/raw/doc/demo.png">

`grayscale` has been tested on macOS 11 Big Sur but may also work on other versions. 

## Using grayscale

`grayscale` enables or disables grayscale mode based on the active application. It stores a a default grayscale value, which determines whether grayscale mode should be on or off for all applications that have not overridden it. To toggle the default value, you can left click the status bar icon or use a keyboard shortcut. Right-clicking the icon brings up a menu, which allows you to view the default value, override it for the active application, and configure the keyboard shortcut.

`grayscale` is designed to make using grayscale mode practical. It's not realistic to keep your screen in grayscale all the time, and automatic transitions reduce the burden of manually turing it on and off. I recommend enabling grayscale by default and disabling it for specific applications that benefit from colors but don't use them to capture your attention, like a text editor with syntax highlighting. Potentially addictive applications that sometimes need color, like web browsers, can then be used with the default setting (i.e. with grayscale enabled), and you can use the keyboard shortcut to toggle grayscale as necessary.

## Installing grayscale

**Install option 1: run the installer (easiset)**

Download the most recent installer (`GrayscaleInstaller.pkg`) from [releases](https://github.com/brettferdosi/grayscale/releases) and run it (click [here](https://github.com/brettferdosi/grayscale/releases/latest/download/GrayscaleInstaller.pkg) to download directly). You will have to follow Apple's instructions for [opening an app from an unidentified developer](https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unidentified-developer-mh40616/mac) (basically, control-click the installer, click *Open*, then click *Open* again). It will install `grayscale.app` in `/Applications`. If there is already a version of `grayscale.app` on your system, the installer will detect and overwrite it.

**Install option 2: build from source**

Clone this git repository using `git clone --recurse-submodules` and run `xcodebuild -project grayscale.xcodeproj -scheme grayscale -configuration Release -derivedDataPath build`. `grayscale.app` will be placed into `build/Build/Products/Release`.

**Optional: open at login**

Automatically open grayscale at login by following Apple's instructions [here](https://support.apple.com/guide/mac-help/open-items-automatically-when-you-log-in-mh15189/mac) (add grayscale to the list in System Preferences > Users & Groups > Login Items).
