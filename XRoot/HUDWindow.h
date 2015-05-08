//
//  HUDWindow.h
//  XRoot
//
//  Created by တိြတိြ on 8/7/14.
//  Copyright (c) 2014 XWorks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HUDWindow : NSPanel {
    BOOL forceDisplay;
}

- (NSColor *)sizedHUDBackground;
- (void)addCloseWidget;

@end
