//
//  Bridge.h
//  grayscale
//
//  Created by Brett Gutstein on 5/24/20.
//  Copyright © 2020 Brett Gutstein. All rights reserved.
//

#ifndef Bridge_h
#define Bridge_h

#import <MASShortcut/Shortcut.h>

// notes on how macOS sets grayscale filters

// --

// these functions don't require a private framework. the filter they enable
// is not the same one used by the current system (it seems a little darker),
// and calling these does not make the change persist through sleep.

extern _Bool CGDisplayUsesForceToGray(void);
extern void CGDisplayForceToGray(_Bool enable);

// --

// these functions are exported by /System/Library/PrivateFrameworks/UniversalAccess.framework.
// they used to set the preferences that enable the grayscale filter, but
// that functionality has now moved to the Media Accessibility framework (discussed below).
// they are located in:
// /System/Library/PrivateFrameworks/UniversalAccess.framework/Versions/A/Frameworks/UniversalAccessCore.framework/Versions/A/UniversalAccessCore

// calls CGDisplayForceToGray(enable) then calls Media Accessibility functions to first enable the system
// display filter and then to set it to grayscale. updates the grayscale key in Universal Access preferences
// to reflect the change.
extern void UAGrayscaleSetEnabled(_Bool enable);
// checks whether grayscale is enabled using Media Accessibility functions.
extern _Bool UAGrayscaleIsEnabled();
// checks whether grayscale is enabled using Media Accessibility functions and updates the grayscale key
// in Universal Access preferences accordingly.
extern void UAGrayscaleSynchronizeLegacyPref();

// --

// these functions are exported by /System/Library/Frameworks/MediaAccessibility.framework/.
// they set the preferences that enable the grayscale filter. they are located in:
// /System/Library/Frameworks/MediaAccessibility.framework/Versions/A/MediaAccessibility

// category enabled == whether or not the filter of the selected type is active
extern _Bool MADisplayFilterPrefGetCategoryEnabled(int filter);
extern void  MADisplayFilterPrefSetCategoryEnabled(int filter, _Bool enable);
extern int MADisplayFilterPrefGetType(int filter);
extern void MADisplayFilterPrefSetType(int filter, int type);

int SYSTEM_FILTER = 0x1;
int GRAYSCALE_TYPE = 0x1;

// --

// the way things currently work is that the MediaAccessibility functions will set
// preferences in com.apple.mediaaccessibility (relevant to this app are __Color__-MADisplayFilterCategoryEnabled
// and __Color__-MADisplayFilterType) and post the event com.apple.mediaaccessibility.displayFilterSettingsChanged
// in the darwin notification center

// the universalaccessd daemon (/usr/sbin/universalaccessd) listens for the MediaAccessibility preference change
// event. it actually toggles the grayscale filter. it also updates the legacy UniversalAccess preferences that used
// to be used (grayscale and grayscaleMigrated in com.apple.universalaccess - the corresponding event was
// com.apple.universalaccess.screenGrayscaleDidChange in the default distributed notificaiton center, which all apps
// still listen for and so the daemon does post it after toggling grayscale).

// the daemon is not always running or listening for these changes, so we use the following function from
// /usr/lib/libUniversalAccess.dylib to kick it awake after making the changes. (it seems to check and respond to the
// preferences when it is first woken up; wake it up after the changes to avoid potential races)

extern void _UniversalAccessDStart(int magic);

int UNIVERSALACCESSD_MAGIC = 0x8;

// --

// the preferences pane binary that normally toggles grayscale preferences is located at:
// /System/Library/PreferencePanes/UniversalAccessPref.prefPane/Contents/MacOS/UniversalAccessPref

#endif /* Bridge_h */
