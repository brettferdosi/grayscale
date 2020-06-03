//
//  Bridge.h
//  grayscale
//
//  Created by Brett Gutstein on 5/24/20.
//  Copyright © 2020 Brett Gutstein. All rights reserved.
//

#ifndef Bridge_h
#define Bridge_h

// these don't require a private framework, but the setting isn't used
// by system preferences and doesn't persist, e.g. through sleep.
// it's also a slightly different grayscale filter, grays are darker
//extern _Bool CGDisplayUsesForceToGray(void);
//extern void CGDisplayForceToGray(_Bool grayscale);

// same functions used by system preferences, changes sync with the preference
// pane checkbox and persist; they require linking against this private framework:
// /System/Library/PrivateFrameworks/UniversalAccess.framework
extern void UAGrayscaleSetEnabled(_Bool isEnabled);
extern _Bool UAGrayscaleIsEnabled();

#endif /* Bridge_h */
