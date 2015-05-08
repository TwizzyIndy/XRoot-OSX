//
//  XROAppDelegate.h
//  XRoot
//
//  Created by Twizzy Indy on 5/29/14.
//  Copyright (c) 2014 XWorks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HUDWindow.h"

@interface XROAppDelegate : NSObject <NSApplicationDelegate> {
    __weak NSTextField *label_mtk;
    __weak NSTextField *label_manufact;
    __weak NSString *getApiVersion;
    __weak NSTextField *label_apiversion;
}

@property (strong) IBOutlet NSTextField *text_log;

@property (weak) IBOutlet NSTextField *label_model;
@property (weak) IBOutlet NSTextField *label_chipset;
@property (weak) IBOutlet NSTextField *label_version;
@property (weak) IBOutlet NSTextField *label_rootstat;
@property (weak) IBOutlet NSTextField *label_mtk;
@property (weak) IBOutlet NSTextField *label_manufact;
@property (weak) IBOutlet NSString *getApiVersion;
@property (weak) IBOutlet NSTextField *label_apiversion;
- (IBAction)btnExit:(NSButton *)sender;
- (IBAction)btnRoot:(NSButton *)sender;
- (IBAction)btnUnroot:(NSButton *)sender;


// Exploits List

- (void) rageagainstcage;

- (void) psneuter;

- (void) zergRush;

- (void) mempodroid;

- (void) pwn; // Motochopper

- (void) exynos;

- (void) getRoot;

- (void) towelroot;




// Device's Usage

- (void) cleanTemp;
- (void) checkInfo;

- (BOOL) checkRoot;

- (void) cleanAdb;

- (void) pushRequiredFiles;

- (void) waitForDevice;

- (void) rebootDevice;

@property (assign) IBOutlet HUDWindow *window;

@end
