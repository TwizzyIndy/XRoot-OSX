//
//  XROAppDelegate.m
//  XRoot
//
//  Created by Twizzy Indy on 5/29/14.
//  Copyright (c) 2014 XWorks. All rights reserved.
//

#import "XROAppDelegate.h"
#import "HUDWindow.h"

@implementation XROAppDelegate
@synthesize label_mtk;
@synthesize label_manufact;
@synthesize getApiVersion;
@synthesize label_apiversion;
bool _rooted;
bool _isHuawei;

- (BOOL) checkRoot
{
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adbPath  = [ myBundle pathForResource:@"adb" ofType:nil];
    // Root Check
    
    NSTask *task_state = [ [NSTask alloc] init];
    [task_state setLaunchPath:adbPath];
    
    NSArray *state_array = [ NSArray arrayWithObjects:@"shell",@"su", @"-c", @"\"echo", @"Rooted\"" , nil];
    [ task_state setArguments:state_array];
    
    
    NSPipe  *state_pipe = [NSPipe pipe];
    [task_state setStandardOutput:state_pipe];
    
    NSFileHandle *state_file = [ state_pipe fileHandleForReading];
    
    [task_state launch];
    [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"Checking Root...."   ]];
    
    NSData *data_state = [ state_file readDataToEndOfFile ];
    NSString *strState = [[ NSString alloc] initWithData:data_state encoding:NSASCIIStringEncoding];
    NSString *endcoded_State= [[ NSString alloc] initWithBytes:strState.UTF8String length:6 encoding:NSASCIIStringEncoding];
    
    if ( [endcoded_State rangeOfString:@"Rooted"].location != NSNotFound  ) {
        
        _rooted = YES;
        
    }
    else{
        [ _label_rootstat setStringValue:@"Not Rooted!"];
        [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"\nLet's get start to root..."   ]];
        _rooted = NO;
    }

    return _rooted;
}

- (void) pushRequiredFiles{
    
}

- (void) waitForDevice{
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adbPath  = [ myBundle pathForResource:@"adb" ofType:nil];
    NSTask *task_waitdevice=[[NSTask alloc]init];
    [task_waitdevice setLaunchPath:adbPath];

    NSArray *ar_wait = [NSArray arrayWithObjects:@"wait-for-device", nil];
    [task_waitdevice setArguments:ar_wait];
    
    [task_waitdevice launch];
    [task_waitdevice waitUntilExit];

    
}

-(void) cleanAdb {
    
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adbPath  = [ myBundle pathForResource:@"adb" ofType:nil];
    NSTask *task_clean=[[NSTask alloc]init];
    [task_clean setLaunchPath:adbPath];
    
    NSArray *ar_clean = [NSArray arrayWithObjects:@"kill-server", nil];
    [task_clean setArguments:ar_clean];
    [task_clean launch];
    
}

- (void) rebootDevice{
    
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adb = [ myBundle pathForResource:@"adb" ofType:nil];
    NSTask *task_reboot = [[NSTask alloc] init];
    [task_reboot setLaunchPath:adb];
    NSArray *ar_reboot = [NSArray arrayWithObjects:@"reboot", nil];
    [task_reboot setArguments:ar_reboot];
    [task_reboot launch];
    [task_reboot waitUntilExit];
    
}

- (void) checkInfo {
    
    
    NSString *strCheck = [ _label_rootstat stringValue ];
    NSLog(@"%@", strCheck );
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adbPath = [ myBundle pathForResource:@"adb" ofType:nil];
    
    //[self waitForDevice];
    
    // get Android API Level
    
    NSTask *task_getAPI = [[NSTask alloc] init];
    [ task_getAPI setLaunchPath:adbPath];
    [ task_getAPI setArguments:[NSArray arrayWithObjects:@"shell", @"getprop", @"ro.build.version.sdk", nil]];
    
    NSPipe *pipe_getAPI = [ NSPipe pipe];
    [ task_getAPI setStandardOutput: pipe_getAPI];
    NSFileHandle *file_getAPI = [ pipe_getAPI fileHandleForReading];
    [ task_getAPI launch];
    
    NSData *data_api = [file_getAPI readDataToEndOfFile];
    NSString *strAPI = [ [NSString alloc] initWithData:data_api encoding:NSUTF8StringEncoding];
    NSString *getAPI = [[ NSString alloc] initWithBytes:strAPI.UTF8String length:2 encoding:NSASCIIStringEncoding];
    self.getApiVersion = getAPI;
    [ self.label_apiversion setStringValue:getAPI];
    
    // get manu
    NSTask *task_manufac = [[NSTask alloc]init];
    [ task_manufac setLaunchPath:adbPath];
    NSArray *manufac;
    manufac = [NSArray arrayWithObjects: @"shell", @"getprop ro.product.manufacturer", nil];
    [task_manufac setArguments: manufac];
    
    NSPipe *getManufac_pipe;
    getManufac_pipe = [NSPipe pipe];
    [task_manufac setStandardOutput: getManufac_pipe];
    
    NSFileHandle *file_manufac;
    file_manufac = [getManufac_pipe fileHandleForReading];
    
    
    [task_manufac launch];
    NSData *data_manu;
    data_manu   = [file_manufac readDataToEndOfFile];
    
    NSString *str_manu;
    str_manu = [[NSString alloc] initWithData: data_manu encoding: NSUTF8StringEncoding];
    NSString *getManufacturer = [[ NSString alloc] initWithBytes:str_manu.UTF8String length:8 encoding:NSASCIIStringEncoding ];
    [ self.label_manufact setStringValue:getManufacturer];
    
    if ( [ getManufacturer isEqual:@"HUAWEI"])
    {
        _isHuawei = YES;
    }
    
    
    // get model
    NSTask *task_model;
    task_model = [[NSTask alloc] init];
    [task_model setLaunchPath:adbPath];
    
    NSArray *model;
    model = [NSArray arrayWithObjects: @"shell", @"getprop", @"ro.product.model", nil];
    [task_model setArguments: model];
    
    NSPipe *getModel_pipe;
    getModel_pipe = [NSPipe pipe];
    [task_model setStandardOutput: getModel_pipe];
    
    NSFileHandle *file_model;
    file_model = [getModel_pipe fileHandleForReading];
    
    [task_model launch];
    [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"\n\nGetting device's model number..."   ]];
    
    NSData *data_model;
    data_model = [file_model readDataToEndOfFile];
    
    NSString *str_model;
    str_model = [[NSString alloc] initWithData: data_model encoding: NSASCIIStringEncoding];
    [_label_model setStringValue:str_model];
    
    NSTask *task_version;
    task_version = [[NSTask alloc] init];
    [task_version setLaunchPath:adbPath]; //@"/Users/Apps/adt-bundle-mac-x86_64-20140321/sdk/platform-tools/adb"];
    
    NSArray *version;
    version = [NSArray arrayWithObjects: @"shell", @"getprop", @"ro.build.version.release", nil];
    [task_version setArguments: version];
    
    NSPipe *getVersion_pipe;
    getVersion_pipe = [NSPipe pipe];
    [task_version setStandardOutput: getVersion_pipe];
    
    NSFileHandle *file_version;
    file_version = [getVersion_pipe fileHandleForReading];
    
    [task_version launch];
    [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"\nGetting ROM version....."   ]];
    
    NSData *data_version;
    data_version = [file_version readDataToEndOfFile];
    
    
    NSString *str_version;
    str_version = [[NSString alloc] initWithData: data_version encoding: NSASCIIStringEncoding];
    [_label_version setStringValue:str_version];
    
    
    // Get Chipset
    NSTask *task_board;
    task_board = [[NSTask alloc] init];
    [task_board setLaunchPath:adbPath]; //@"/Users/Apps/adt-bundle-mac-x86_64-20140321/sdk/platform-tools/adb"];
    
    NSArray *board;
    board = [NSArray arrayWithObjects: @"shell", @"getprop", @"ro.board.platform", nil];
    [task_board setArguments: board];
    
    NSPipe *getBoard_pipe;
    getBoard_pipe = [NSPipe pipe];
    [task_board setStandardOutput: getBoard_pipe];
    
    NSFileHandle *file_board;
    file_board = [getBoard_pipe fileHandleForReading];
    
    [task_board launch];
    
    NSData *data_board;
    data_board = [file_board readDataToEndOfFile];
    
    
    NSString *str_board;
    str_board = [[NSString alloc] initWithData: data_board encoding: NSASCIIStringEncoding];
    [_label_chipset setStringValue:str_board];
    
    
    // It's MTK?
    NSTask *task_mtk = [[NSTask alloc]init];
    [task_mtk setLaunchPath:adbPath];
    [task_mtk setArguments:[ NSArray arrayWithObjects:@"shell", @"getprop", @"ro.mediatek.platform", nil] ];
    
    NSPipe *mtk_pipe =  [ NSPipe pipe];
    [task_mtk setStandardOutput:mtk_pipe];
    [task_mtk launch];
    
    NSFileHandle *file_mtk = [mtk_pipe fileHandleForReading];
    NSData *data_mtk = [ file_mtk readDataOfLength:4   ];
    NSString *str_mtk = [[ NSString alloc] initWithData:data_mtk encoding: NSASCIIStringEncoding ];
    NSString *mtk = [[ NSString alloc] initWithBytes:str_mtk.UTF8String length:6 encoding:NSASCIIStringEncoding];
    
    [self.label_mtk setStringValue:mtk];
    
        
    // Root Check
    
    NSTask *task_state = [ [NSTask alloc] init];
    [task_state setLaunchPath:adbPath];
    
    NSArray *state_array = [ NSArray arrayWithObjects:@"shell",@"su", @"-c", @"\"echo", @"Rooted\"" , nil];
    [ task_state setArguments:state_array];
    
    
    NSPipe  *state_pipe = [NSPipe pipe];
    [task_state setStandardOutput:state_pipe];
    
    NSFileHandle *state_file = [ state_pipe fileHandleForReading];
    
    [task_state launch];
    [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"\nChecking Root...."   ]];
    
    NSData *data_state = [ state_file readDataToEndOfFile ];
    NSString *strState = [[ NSString alloc] initWithData:data_state encoding:NSASCIIStringEncoding];
    NSString *endcoded_State= [[ NSString alloc] initWithBytes:strState.UTF8String length:6 encoding:NSASCIIStringEncoding];
    
    
    if ( [endcoded_State rangeOfString:@"Rooted"].location != NSNotFound  ) {
        
        [ _label_rootstat setStringValue:@"Rooted"];
        [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"\nIts Already Rooted..."   ]];
        
    }
    else{
        [ _label_rootstat setStringValue:@"Not Rooted!"];
        [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"\nLet's get start to root..."   ]];
    }

    [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@", _text_log.stringValue, @"\nDone!" ]];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //[ self cleanAdb ];
    //[ self waitForDevice];
    [ self checkInfo];
    
}

- (IBAction)btnExit:(NSButton *)sender {
    exit(1);
}

- (IBAction)btnRoot:(NSButton *)sender {
    
    
    [self cleanTemp];
    
    // get API Version from label
    
    NSString *getAPI = [[ NSString alloc] initWithBytes:self.label_apiversion.stringValue.UTF8String length:2 encoding:NSUTF8StringEncoding];
    
    
    // get chipset from label
    
    NSString *getChipset = [ [ NSString alloc] initWithBytes:_label_chipset.stringValue.UTF8String length:7 encoding:NSUTF8StringEncoding];
    NSString *getMSM = [[ NSString alloc] initWithBytes:_label_chipset.stringValue.UTF8String length:3 encoding:NSUTF8StringEncoding];

    // Get Android version from Label
    NSString *getAndroidVersion = [[NSString alloc] initWithBytes:_label_version.stringValue.UTF8String length:5 encoding:NSUTF8StringEncoding];
    NSString *four = [ [ NSString alloc] initWithBytes:getAndroidVersion.UTF8String length:3 encoding:NSUTF8StringEncoding];
    
    // Check For MTK6589
    
    NSString *getMTK6589 = [[ NSString alloc ] initWithBytes:self.label_mtk.stringValue.UTF8String length:6 encoding:NSUTF8StringEncoding];
    
    // ****YOU HAVE TO ADD CHECK FOR msm CHIPSET ***** ///////
    
    
    if ( [getChipset isEqual:@"exynos4" ] ) {
        
        [ self exynos];
    
    
    }
    
    else if ([ getMSM rangeOfString:@"msm" ].location != NSNotFound)
    
    {
        [self getRoot];
    
    }
    
    else if ([ four isEqual:@"1.0" ] || [four isEqual:@"1.1"] ) {
        
        
        [ self rageagainstcage ];
        
        [ self checkRoot ];
        
        if (!_rooted) {
            
            [ self psneuter ];
            
        }
    }
    
    else if ( [ getAPI isEqual:@"3"] || [ getAPI isEqual:@"4"] || [getAPI isEqual:@"5"] || [getAPI isEqual:@"6"] || [getAPI isEqual:@"7"] || [getAPI isEqual:@"8"])
    {
        [ self psneuter];
        
    }
    
    else if ( [getMTK6589 isEqual:@"MT6589"] ) {
        
        [ self pwn ];
    }
    
    else if ( [four  isEqual: @"4.3"] || [getAndroidVersion isEqual:@"4.4.2"]) {
        
        [self towelroot];
        
        
    } else if ( [getAndroidVersion isEqual:@"4.0"] || [getAndroidVersion isEqual:@"4.1"] || [getAndroidVersion isEqual:@"4.0.1"] || [getAndroidVersion isEqual:@"4.0.2"] || [getAndroidVersion isEqual:@"4.0.3"] || [getAndroidVersion isEqual:@"4.0.4"] ||[getAndroidVersion isEqual:@"4.1.1"] || [getAndroidVersion isEqual:@"4.1.2"] || [getAndroidVersion isEqual:@"4.2"] || [getAndroidVersion isEqual:@"4.2.1"] || [getAndroidVersion isEqual:@"4.2.2"] )
    {
        [self getRoot];
    }
    
}

- (void) getRoot {
    
    NSLog(@"\n\ngetroot method \n");
    NSString *name = @"getRoot";
    NSLog(@"%@",name);
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adbPath  = [ myBundle pathForResource:@"adb" ofType:nil];
    NSString *getRoot   = [ myBundle pathForResource:@"getroot" ofType:nil];
    NSString *superuser= [ myBundle pathForResource:@"SuperUser" ofType:@"apk"];
    NSString *installsh   = [ myBundle pathForResource:@"install-recovery" ofType:@"sh"];
    NSString *unroot   = [ myBundle pathForResource:@"unroot" ofType:nil];
    NSString *su       = [ myBundle pathForResource:@"su" ofType:nil];
    NSString *busybox  = [ myBundle pathForResource:@"busybox" ofType:nil];
    
    NSTask *task_push_getroot = [[NSTask alloc]init];
    [task_push_getroot setLaunchPath:adbPath];
    NSArray *ar_push_exynos = [ NSArray arrayWithObjects:@"push", getRoot, @"/data/local/tmp", nil ];
    [task_push_getroot setArguments:ar_push_exynos];
    [task_push_getroot launch];
    [task_push_getroot waitUntilExit];
    
    // push SuperUser
    NSTask *task_push_superuser = [[NSTask alloc] init];
    [task_push_superuser setLaunchPath:adbPath];
    NSArray *ar_push_superuser = [ NSArray arrayWithObjects:@"push", superuser, @"/data/local/tmp", nil];
    [task_push_superuser setArguments:ar_push_superuser];
    [task_push_superuser launch];
    [task_push_superuser waitUntilExit];
    
    // push install-recovery.sh /data/local/tmp/
    NSTask *task_push_installrecoverysh = [[NSTask alloc] init];
    [task_push_installrecoverysh setLaunchPath:adbPath];
    NSArray *ar_push_rootsh = [ NSArray arrayWithObjects:@"push", installsh, @"/data/local/tmp", nil];
    [task_push_installrecoverysh setArguments:ar_push_rootsh];
    [task_push_installrecoverysh launch];
    [task_push_installrecoverysh waitUntilExit];
    
    // push su
    NSTask *task_push_su = [[NSTask alloc] init];
    [task_push_su setLaunchPath:adbPath];
    NSArray *ar_push_su = [ NSArray arrayWithObjects:@"push", su , @"/data/local/tmp" , nil];
    [task_push_su setArguments:ar_push_su];
    [task_push_su launch];
    [task_push_su waitUntilExit];
    
    // push unroot
    NSTask *task_push_unroot = [[NSTask alloc] init];
    [task_push_unroot setLaunchPath:adbPath];
    NSArray *ar_push_unroot = [ NSArray arrayWithObjects:@"push", unroot , @"/data/local/tmp" , nil];
    [task_push_unroot setArguments:ar_push_unroot];
    [task_push_unroot launch];
    [task_push_unroot waitUntilExit];
    
    // push busybox
    NSTask *task_push_busybox = [[NSTask alloc] init];
    [task_push_busybox setLaunchPath:adbPath];
    NSArray *ar_push_busybox = [ NSArray arrayWithObjects:@"push", busybox, @"/data/local/tmp", nil];
    [task_push_busybox setArguments:ar_push_busybox];
    [task_push_busybox launch];
    [task_push_busybox waitUntilExit];
    
    // chmod getroot
    NSTask *task_chmod_getroot = [[NSTask alloc]init];
    [task_chmod_getroot setLaunchPath:adbPath];
    NSArray *ar_chmod_exynos = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/getroot", nil];
    [task_chmod_getroot setArguments:ar_chmod_exynos];
    [task_chmod_getroot launch];
    [task_chmod_getroot waitUntilExit];
    
    // chmod busybox
    NSTask *task_chmod_busy = [[NSTask alloc]init];
    [task_chmod_busy setLaunchPath:adbPath];
    NSArray *ar_chmod_busy = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/busybox", nil];
    [task_chmod_busy setArguments:ar_chmod_busy];
    [task_chmod_busy launch];
    [task_chmod_busy waitUntilExit];
    

    
    // chmod install-recovery.sh
    NSTask *task_chmod_rootsh = [[NSTask alloc] init];
    [task_chmod_rootsh setLaunchPath:adbPath];
    NSArray *ar_chmod_rootsh = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/install-recovery.sh", nil];
    [task_chmod_rootsh setArguments:ar_chmod_rootsh];
    [task_chmod_rootsh launch];
    [task_chmod_rootsh waitUntilExit];
    
    // excute exploit
    NSTask *task_excute = [[NSTask alloc]init];
    [task_excute setLaunchPath:adbPath];
    NSArray *ar_excute = [ NSArray arrayWithObjects:@"shell", @"/data/local/tmp/getroot", nil];
    [task_excute setArguments:ar_excute];
    [task_excute launch];
    [task_excute waitUntilExit];
    
    
    
    [self checkRoot];
    
    if ( _rooted )
    {
        NSAlert *rooted = [[NSAlert alloc] init];
        [rooted addButtonWithTitle:@"OK"];
        [rooted setMessageText:@"Your device is successfully rooted.\nWe'll install SuperUser.apk"];
        [rooted setInformativeText:@"XRoot"];
        [rooted setAlertStyle:NSWarningAlertStyle];
        
        

        if ([rooted runModal] == NSAlertFirstButtonReturn) {
            
            NSTask *task_remount = [[NSTask alloc]init];
            [task_remount setLaunchPath:adbPath];
            NSArray *ar_remount = [ NSArray arrayWithObjects:@"shell", @"su",@"-c", @"\"busybox", @"mount",@"-o", @"remount,rw", @"/system\"", nil];
            [task_remount setArguments:ar_remount];
            [task_remount launch];
            [task_remount waitUntilExit];

            // Copy SuperUser
            NSTask *task_cp_super = [[NSTask alloc] init];
            [task_cp_super setLaunchPath:adbPath];
            NSArray *ar_cp_super = [ NSArray arrayWithObjects:@"shell", @"su", @"-c" , @"\"dd", @"if=/data/local/tmp/SuperUser.apk", @"of=/system/app/SuperUser.apk\"", nil];
            [task_cp_super setArguments:ar_cp_super];
            [task_cp_super launch];
            [task_cp_super waitUntilExit];
        
        
            // chmod SuperUser
            NSTask *task_chmod_super = [[ NSTask alloc] init];
            [task_chmod_super setLaunchPath:adbPath];
            NSArray *ar_chmod_super = [ NSArray arrayWithObjects:@"shell", @"su", @"-c", @"\"chmod", @"644", @"/system/app/SuperUser.apk\"" , nil];
            [task_chmod_super setArguments:ar_chmod_super];
            [task_chmod_super launch];
            [task_chmod_super waitUntilExit];
            
            _rooted = YES;
            
        }
        
        [self rebootDevice];
        
        
    } else{
        
        NSAlert *rooterror = [[NSAlert alloc] init];
        [rooterror addButtonWithTitle:@"OK"];
        [rooterror setMessageText:@"We're sorry, can't root your phone"];
        [rooterror setInformativeText:@"XRoot"];
        [rooterror setAlertStyle:NSWarningAlertStyle];
        [rooterror runModal];
        
        _rooted = NO;
        
    }

    
}

- (void) exynos {
    
    
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adbPath  = [ myBundle pathForResource:@"adb" ofType:nil];
    NSString *exynos   = [ myBundle pathForResource:@"exynos" ofType:nil];
    NSString *superuser= [ myBundle pathForResource:@"SuperUser" ofType:@"apk"];
    NSString *rootsh   = [ myBundle pathForResource:@"root" ofType:@"sh"];
    NSString *root     = [ myBundle pathForResource:@"root" ofType:nil];
    NSString *su       = [ myBundle pathForResource:@"su" ofType:nil];
    NSString *busybox  = [ myBundle pathForResource:@"busybox" ofType:nil];
    
    NSTask *task_push_exynos = [[NSTask alloc]init];
    [task_push_exynos setLaunchPath:adbPath];
    NSArray *ar_push_exynos = [ NSArray arrayWithObjects:@"push", exynos, @"/data/local/tmp", nil ];
    [task_push_exynos setArguments:ar_push_exynos];
    [task_push_exynos launch];
    [task_push_exynos waitUntilExit];
    
    // push
    NSTask *task_push_superuser = [[NSTask alloc] init];
    [task_push_superuser setLaunchPath:adbPath];
    NSArray *ar_push_superuser = [ NSArray arrayWithObjects:@"push", superuser, @"/data/local/tmp", nil];
    [task_push_superuser setArguments:ar_push_superuser];
    [task_push_superuser launch];
    [task_push_superuser waitUntilExit];
    
    // rename superuser
    NSTask *task_rename_superuser = [[NSTask alloc] init];
    [task_rename_superuser setLaunchPath:adbPath];
    NSArray *ar_rename_super = [ NSArray arrayWithObjects:@"shell", @"mv", @"/data/local/tmp/SuperUser.apk", @"/data/local/tmp/superuser.apk", nil];
    [task_rename_superuser setArguments:ar_rename_super];
    [task_rename_superuser launch];
    [task_rename_superuser waitUntilExit];
    
    // Make tmp folder
    NSTask *task_makefolder = [[NSTask alloc] init];
    [task_makefolder setLaunchPath:adbPath];
    NSArray *ar_makefolder = [ NSArray arrayWithObjects:@"shell", @"mkdir", @"/data/local/tmp/roottmp", nil];
    [task_makefolder setArguments:ar_makefolder];
    [task_makefolder launch];
    [task_makefolder waitUntilExit];
    
    // push root.sh /data/local/tmp/roottmp
    NSTask *task_push_rootsh = [[NSTask alloc] init];
    [task_push_rootsh setLaunchPath:adbPath];
    NSArray *ar_push_rootsh = [ NSArray arrayWithObjects:@"push", rootsh, @"/data/local/tmp/roottmp", nil];
    [task_push_rootsh setArguments:ar_push_rootsh];
    [task_push_rootsh launch];
    [task_push_rootsh waitUntilExit];
    
    // push root /data/local/tmp
    NSTask *task_push_root = [[NSTask alloc] init];
    [task_push_root setLaunchPath:adbPath];
    NSArray *ar_push_root = [ NSArray arrayWithObjects:@"push", root, @"/data/local/tmp", nil];
    [task_push_root setArguments:ar_push_root];
    [task_push_root launch];
    [task_push_root waitUntilExit];
    
    // push su
    NSTask *task_push_su = [[NSTask alloc] init];
    [task_push_su setLaunchPath:adbPath];
    NSArray *ar_push_su = [ NSArray arrayWithObjects:@"push", su , @"/data/local/tmp" , nil];
    [task_push_su setArguments:ar_push_su];
    [task_push_su launch];
    [task_push_su waitUntilExit];
    
    // push busybox
    NSTask *task_push_busybox = [[NSTask alloc] init];
    [task_push_busybox setLaunchPath:adbPath];
    NSArray *ar_push_busybox = [ NSArray arrayWithObjects:@"push", busybox, @"/data/local/tmp", nil];
    [task_push_busybox setArguments:ar_push_busybox];
    [task_push_busybox launch];
    [task_push_busybox waitUntilExit];
    
    // chmod exynos
    NSTask *task_chmod_exynos = [[NSTask alloc]init];
    [task_chmod_exynos setLaunchPath:adbPath];
    NSArray *ar_chmod_exynos = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/exynos", nil];
    [task_chmod_exynos setArguments:ar_chmod_exynos];
    [task_chmod_exynos launch];
    [task_chmod_exynos waitUntilExit];
    
    // chmod busybox
    NSTask *task_chmod_busy = [[NSTask alloc]init];
    [task_chmod_busy setLaunchPath:adbPath];
    NSArray *ar_chmod_busy = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/busybox", nil];
    [task_chmod_busy setArguments:ar_chmod_busy];
    [task_chmod_busy launch];
    [task_chmod_busy waitUntilExit];
    
    // chmod root
    NSTask *task_chmod_root = [[NSTask alloc] init];
    [task_chmod_root setLaunchPath:adbPath];
    NSArray *ar_chmod_root = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/root", nil];
    [task_chmod_root setArguments:ar_chmod_root];
    [task_chmod_root launch];
    [task_chmod_root waitUntilExit];
    
    
    // chmod root.sh
    NSTask *task_chmod_rootsh = [[NSTask alloc] init];
    [task_chmod_rootsh setLaunchPath:adbPath];
    NSArray *ar_chmod_rootsh = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/roottmp/root.sh", nil];
    [task_chmod_rootsh setArguments:ar_chmod_rootsh];
    [task_chmod_rootsh launch];
    [task_chmod_rootsh waitUntilExit];
    
    // excute exploit
    NSTask *task_excute = [[NSTask alloc]init];
    [task_excute setLaunchPath:adbPath];
    NSArray *ar_excute = [ NSArray arrayWithObjects:@"shell", @"/data/local/tmp/exynos", nil];
    [task_excute setArguments:ar_excute];
    [task_excute launch];
    [task_excute waitUntilExit];
    [self checkRoot];
    
    if ( _rooted )
    {
        NSAlert *rooted = [[NSAlert alloc] init];
        [rooted addButtonWithTitle:@"OK"];
        [rooted setMessageText:@"Your device is successfully rooted"];
        [rooted setInformativeText:@"XRoot"];
        [rooted setAlertStyle:NSWarningAlertStyle];
        [rooted runModal];
        [self rebootDevice];

        
    } else{
        NSAlert *rooterror = [[NSAlert alloc] init];
        [rooterror addButtonWithTitle:@"OK"];
        [rooterror setMessageText:@"We're sorry, can't root your phone"];
        [rooterror setInformativeText:@"XRoot"];
        [rooterror setAlertStyle:NSWarningAlertStyle];
        [rooterror runModal];

    }
}

- (void) towelroot{
    
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adbPath  = [ myBundle pathForResource:@"adb" ofType:nil];
    NSString *towelroot        = [ myBundle pathForResource:@"towelroot" ofType:@"apk"];         // For Android 4.3-4.4.2
    NSString *busybox  = [ myBundle pathForResource:@"busybox" ofType:nil];
    NSString *superuser= [ myBundle pathForResource:@"SuperUser" ofType:@"apk"];

    

    // Pushing required files
    
    NSTask *task_push_busybox = [[NSTask alloc] init];
    [task_push_busybox setLaunchPath:adbPath];
    
    NSTask *task_install_towelroot= [[NSTask alloc]init];
    [task_install_towelroot setLaunchPath:adbPath];
    
    NSTask *task_push_superuser= [[NSTask alloc]init];
    [task_push_superuser setLaunchPath:adbPath];
    
    // Give Permissions
    
    NSTask *task_chmod_tmp_busy = [[NSTask alloc]init];
    [task_chmod_tmp_busy setLaunchPath:adbPath];
    
    NSTask *task_chmod_busy=[[NSTask alloc]init];
    [task_chmod_busy setLaunchPath:adbPath];
    
    NSTask *task_chmod_super=[[NSTask alloc] init];
    [task_chmod_super setLaunchPath:adbPath];
    
    // Run Towel Root
    NSTask *task_excute=[[NSTask alloc]init];
    [task_excute setLaunchPath:adbPath];
    
    // Wait for device

    // Check Root
    NSTask *task_checkroot=[[NSTask alloc]init];
    [task_checkroot setLaunchPath:adbPath];
    
    // Remount System as RW
    NSTask *task_remount_rw = [[NSTask alloc]init];
    [task_remount_rw setLaunchPath:adbPath];
    
    // Copy SuperUser.apk to /system/app/
    NSTask *task_cp_super = [[NSTask alloc]init];
    [task_cp_super setLaunchPath:adbPath];
    
    // Copy busybox to /system/xbin
    NSTask *task_cp_busybox=[[NSTask alloc]init];
    [task_cp_busybox setLaunchPath:adbPath];
    
    // Remount /system as RO
    NSTask *task_remount_ro=[[NSTask alloc]init];
    [task_remount_ro setLaunchPath:adbPath];
    
    /* =========================================== */
    
    NSArray *ar_pushbusy = [NSArray arrayWithObjects:@"push", busybox,@"/data/local/tmp", nil];
    [task_push_busybox setArguments:ar_pushbusy];
    [task_push_busybox launch];
    [task_push_busybox waitUntilExit];
    
    NSArray *ar_pushsuperuser = [NSArray arrayWithObjects:@"push", superuser,@"/data/local/tmp", nil];
    [task_push_superuser setArguments:ar_pushsuperuser];
    [task_push_superuser launch];
    [task_push_superuser waitUntilExit];
    
    NSArray *ar_pushtowel = [NSArray arrayWithObjects:@"install",towelroot, nil];
    [task_install_towelroot setArguments:ar_pushtowel];
    [task_install_towelroot launch];
    [task_install_towelroot waitUntilExit];
    
    // Give Permissions
    NSArray *ar_chmod_tmp_busy = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/busybox", nil];
    [task_chmod_tmp_busy setArguments:ar_chmod_tmp_busy];
    [task_chmod_tmp_busy launch];
    [task_chmod_tmp_busy waitUntilExit];
    

    
    
    
    // Execute Exploit
    
    NSArray *ar_excute = [NSArray arrayWithObjects:@"shell", @"am",@"start", @"-n", @"com.geohot.towelroot/com.geohot.towelroot.TowelRoot", nil];
    [task_excute setArguments:ar_excute];
    [ task_excute launch];
    [task_excute waitUntilExit];
    
    
    // Wait for device
    NSAlert *wait_towel = [[NSAlert alloc] init];
    [wait_towel addButtonWithTitle:@"OK"];
    [wait_towel setMessageText:@"After TowelRoot apk made your device REBOOT,\nClick OK button to continue  rooting process .... "];
    [wait_towel setInformativeText:@"XRoot"];
    [wait_towel setAlertStyle:NSWarningAlertStyle];
    
    if([wait_towel runModal] == NSAlertFirstButtonReturn)
    {
        [self waitForDevice];
        
        // Remount RW
    
        NSArray *ar_remount_rw = [ NSArray arrayWithObjects:@"shell", @"su", @"-c" , @"\"/data/local/tmp/busybox", @"mount", @"-o", @"remount,rw", @"/system\"" , nil];
        [ task_remount_rw setArguments:ar_remount_rw ];
        
        NSString *log = [ [NSString alloc ] init];
        log = [ ar_remount_rw objectAtIndex:6];
        NSLog(@"%@", log);
        [ task_remount_rw launch];
        [ task_remount_rw waitUntilExit];
        
        
        // Move superuser.apk
        
        NSArray *ar_cp_superuser = [ NSArray arrayWithObjects:@"shell", @"su",@"-c", @"\"cp", @"/data/local/tmp/SuperUser.apk", @"/system/app\"" , nil];
        [ task_cp_super setArguments:ar_cp_superuser];
        [ task_cp_super launch];
        [ task_cp_super waitUntilExit];
        
        // Copy Busybox to /system/xbin
        
        NSArray *ar_cp_busy = [ NSArray arrayWithObjects:@"shell", @"su", @"-c", @"\"cp", @"/data/local/tmp/busybox", @"/system/xbin\"" ,nil];
        [ task_cp_busybox setArguments:ar_cp_busy];
        [ task_cp_busybox launch];
        [ task_cp_busybox waitUntilExit];
        
        // Give system permissions
        
        NSArray *ar_chmod_busy = [NSArray arrayWithObjects:@"shell",@"su", @"-c" , @"\"chmod", @"777", @"/system/xbin/busybox\"", nil];
        [task_chmod_busy setArguments:ar_chmod_busy];
        [task_chmod_busy launch];
        [task_chmod_busy waitUntilExit];
        
        NSArray *ar_chmod_super=[NSArray arrayWithObjects:@"shell", @"su", @"-c", @"\"chmod", @"644",@"/system/app/SuperUser.apk\"" , nil];
        [task_chmod_super setArguments:ar_chmod_super];
        [task_chmod_super launch];
        [task_chmod_super waitUntilExit];
        
        // Remount RO
        
        NSArray *ar_remount_ro  = [NSArray arrayWithObjects:@"shell", @"su", @"-c", @"\"/data/local/tmp/busybox", @"mount", @"-o", @"remount,ro", @"/system\"" , nil];
        [ task_remount_ro setArguments:ar_remount_ro];
        [task_remount_ro launch];
        [task_remount_ro waitUntilExit];
        
        //[ self rebootDevice ];
        [ self checkInfo ];
        
        
        [self checkRoot];
        
        if ( _rooted )
        {
            NSAlert *rooted = [[NSAlert alloc] init];
            [rooted addButtonWithTitle:@"OK"];
            [rooted setMessageText:@"Your device is successfully rooted"];
            [rooted setInformativeText:@"XRoot"];
            [rooted setAlertStyle:NSWarningAlertStyle];
            [rooted runModal];
            [self rebootDevice];
            
            
            
        } else{
            NSAlert *rooterror = [[NSAlert alloc] init];
            [rooterror addButtonWithTitle:@"OK"];
            [rooterror setMessageText:@"We're sorry, can't root your phone"];
            [rooterror setInformativeText:@"XRoot"];
            [rooterror setAlertStyle:NSWarningAlertStyle];
            [rooterror runModal];
            
        }
        
        //[self rebootDevice];
        

    }
    
}

- (void) rageagainstcage
{
    
    NSBundle *myBundle = [ NSBundle mainBundle ];
    NSString *adb = [ myBundle pathForResource:@"adb" ofType:nil];
    NSString *rageagainstcage = [ myBundle pathForResource:@"rageagainstcage" ofType:nil];
    NSString *su = [ myBundle pathForResource:@"su" ofType:nil];
    NSString *superuser = [ myBundle pathForResource:@"SuperUser" ofType:@"apk"];
    NSString *busybox = [ myBundle pathForResource:@"busybox" ofType:nil];
    
    
    NSTask *push_rage = [[ NSTask alloc] init];
    [ push_rage setLaunchPath:adb ];
    [ push_rage setArguments:[ NSArray arrayWithObjects:@"push", rageagainstcage, @"/data/local/tmp" , nil]];
    [ push_rage launch ];
    [ push_rage waitUntilExit];
    

    // chmod
    NSTask *chmod_rage = [[NSTask alloc] init];
    [ chmod_rage setLaunchPath:adb];
    [ chmod_rage setArguments:[ NSArray arrayWithObjects:@"shell", @"chmod", @"755", @"/data/local/tmp/rageagainstcage", nil]];
    [ chmod_rage launch];
    [ chmod_rage waitUntilExit];
    
    // Executing
    
    NSTask *execute = [[NSTask alloc] init];
    [ execute setLaunchPath:adb];
    [ execute setArguments:[ NSArray arrayWithObjects:@"shell", @"/data/local/tmp/rageagainstcage", nil]];
    
    // refresh
    NSTask *refresh = [[NSTask alloc]init];
    [ refresh setLaunchPath:adb];
    [ refresh setArguments:[ NSArray arrayWithObjects:@"devices", nil]];
    
    // push to system
    NSTask *push_su = [[NSTask alloc] init];
    [ push_su setLaunchPath:adb];
    [ push_su setArguments:[ NSArray arrayWithObjects:@"push", su, @"/system/bin", nil]];
    [ push_su launch ];
    [ push_su waitUntilExit];
    
    NSTask *push_super = [[NSTask alloc] init];
    [ push_super setLaunchPath:adb];
    [ push_super setArguments:[ NSArray arrayWithObjects:@"push", superuser, @"/system/app", nil]];
    [ push_super launch];
    [ push_super waitUntilExit];
    
    NSTask *push_busy = [[NSTask alloc] init];
    [ push_busy setLaunchPath:adb];
    [ push_busy setArguments:[ NSArray arrayWithObjects:@"push", busybox, @"/system/bin", nil]];
    [ push_busy launch];
    [ push_busy waitUntilExit];
    
    // chmod system
    NSTask *chmod_super = [[NSTask alloc]init];
    [ chmod_super setLaunchPath:adb];
    [ chmod_super setArguments:[ NSArray arrayWithObjects: @"shell" ,@"chmod", @"0644" , @"/system/app/SuperUser.apk", nil]];
    [ chmod_super launch];
    [ chmod_super waitUntilExit];
    
    NSTask *chmod_su = [[NSTask alloc] init];
    [ chmod_su setLaunchPath:adb];
    [ chmod_su setArguments:[ NSArray arrayWithObjects:@"shell", @"chmod", @"4755", @"/system/bin/su", nil]];
    [ chmod_su launch];
    [ chmod_su waitUntilExit];
    
    NSTask *chmod_busybox = [[NSTask alloc] init];
    [ chmod_busybox setLaunchPath:adb];
    [ chmod_busybox setArguments:[ NSArray arrayWithObjects:@"shell", @"chmod", @"4755", @"/system/bin/busybox", nil]];
    [ chmod_busybox launch];
    [ chmod_busybox waitUntilExit];
    
    [ self checkRoot ];
    
    if ( _rooted )
    {
        NSAlert *rooted = [[NSAlert alloc] init];
        [rooted addButtonWithTitle:@"OK"];
        [rooted setMessageText:@"Your device is successfully rooted"];
        [rooted setInformativeText:@"XRoot"];
        [rooted setAlertStyle:NSWarningAlertStyle];
        [rooted runModal];
        
        [self rebootDevice];
        
        
        
    } else{
        NSAlert *rooterror = [[NSAlert alloc] init];
        [rooterror addButtonWithTitle:@"OK"];
        [rooterror setMessageText:@"We're sorry, can't root your phone"];
        [rooterror setInformativeText:@"XRoot"];
        [rooterror setAlertStyle:NSWarningAlertStyle];
        [rooterror runModal];
        
    

    }
}

- (void) psneuter
{
    NSBundle *myBundle = [ NSBundle mainBundle ];
    NSString *adb = [ myBundle pathForResource:@"adb" ofType:nil];
    
    NSString *psneuter = [ myBundle pathForResource:@"psneuter" ofType:nil];
    NSString *su = [ myBundle pathForResource:@"su" ofType:nil];
    NSString *superuser = [ myBundle pathForResource:@"SuperUser" ofType:@"apk"];
    NSString *busybox = [ myBundle pathForResource:@"busybox" ofType:nil];
    
    
    NSTask *push_psneuter = [[ NSTask alloc] init];
    [ push_psneuter setLaunchPath:adb];
    [ push_psneuter setArguments:[ NSArray arrayWithObjects:@"push", psneuter, @"/data/local/tmp", nil]];
    [ push_psneuter launch];
    [ push_psneuter waitUntilExit];
    
    NSTask *chmod_ps = [[NSTask alloc] init];
    [ chmod_ps setLaunchPath:adb];
    [ chmod_ps setArguments:[ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp", nil]];
    [ chmod_ps launch];
    [ chmod_ps waitUntilExit];
    
    // Executing Exploit
    
    NSTask *execute = [[NSTask alloc] init];
    [ execute setLaunchPath:adb];
    [ execute setArguments:[ NSArray arrayWithObjects:@"shell", @"/data/local/tmp/psneuter", nil]];
    [ execute launch];
    [ execute waitUntilExit];
    
    // Refresh
    
    NSTask *refresh = [[NSTask alloc] init];
    [ refresh setLaunchPath:adb];
    [ refresh setArguments:[ NSArray arrayWithObjects:@"devices", nil]];
    [ refresh launch];
    [ refresh waitUntilExit];
    
    // Push to system
    
    NSTask *push_su = [[NSTask alloc] init];
    [ push_su setLaunchPath:adb];
    [ push_su setArguments:[ NSArray arrayWithObjects:@"push", su, @"/system/bin", nil]];
    [ push_su launch ];
    [ push_su waitUntilExit];
    
    NSTask *push_super = [[NSTask alloc] init];
    [ push_super setLaunchPath:adb];
    [ push_super setArguments:[ NSArray arrayWithObjects:@"push", superuser, @"/system/app", nil]];
    [ push_super launch];
    [ push_super waitUntilExit];
    
    NSTask *push_busy = [[NSTask alloc] init];
    [ push_busy setLaunchPath:adb];
    [ push_busy setArguments:[ NSArray arrayWithObjects:@"push", busybox, @"/system/bin", nil]];
    [ push_busy launch];
    [ push_busy waitUntilExit];
    
    // chmod system
    NSTask *chmod_super = [[NSTask alloc]init];
    [ chmod_super setLaunchPath:adb];
    [ chmod_super setArguments:[ NSArray arrayWithObjects: @"shell" ,@"chmod", @"0644" , @"/system/app/SuperUser.apk", nil]];
    [ chmod_super launch];
    [ chmod_super waitUntilExit];
    
    NSTask *chmod_su = [[NSTask alloc] init];
    [ chmod_su setLaunchPath:adb];
    [ chmod_su setArguments:[ NSArray arrayWithObjects:@"shell", @"chmod", @"4755", @"/system/bin/su", nil]];
    [ chmod_su launch];
    [ chmod_su waitUntilExit];
    
    NSTask *chmod_busybox = [[NSTask alloc] init];
    [ chmod_busybox setLaunchPath:adb];
    [ chmod_busybox setArguments:[ NSArray arrayWithObjects:@"shell", @"chmod", @"4755", @"/system/bin/busybox", nil]];
    [ chmod_busybox launch];
    [ chmod_busybox waitUntilExit];
    
    [ self checkRoot ];
    
    if ( _rooted )
    {
        NSAlert *rooted = [[NSAlert alloc] init];
        [rooted addButtonWithTitle:@"OK"];
        [rooted setMessageText:@"Your device is successfully rooted"];
        [rooted setInformativeText:@"XRoot"];
        [rooted setAlertStyle:NSWarningAlertStyle];
        [rooted runModal];
        
        [self cleanTemp ];
        [self rebootDevice];
        
        
        
    } else{
        
        NSAlert *rooterror = [[NSAlert alloc] init];
        [rooterror addButtonWithTitle:@"OK"];
        [rooterror setMessageText:@"We're sorry, can't root your phone"];
        [rooterror setInformativeText:@"XRoot"];
        [rooterror setAlertStyle:NSWarningAlertStyle];
        [rooterror runModal];
        [self cleanTemp];
        }

    
}

- (void) zergRush
{
    
    NSBundle *myBundle = [ NSBundle mainBundle ];
    NSString *adb = [ myBundle pathForResource:@"adb" ofType:nil];
    NSString *busybox = [ myBundle pathForResource:@"busybox" ofType:nil];
    NSString *su = [ myBundle pathForResource:@"su" ofType:nil];
    NSString *superuser = [ myBundle pathForResource:@"SuperUser" ofType:@"apk"];
    NSString *zergRush  = [ myBundle pathForResource:@"zergRush" ofType:nil];
    
    NSTask *make_tmp = [[NSTask alloc]init];
    [make_tmp setLaunchPath:adb];
    [make_tmp setArguments:[NSArray arrayWithObjects:@"shell", @"\"mkdir", @"/data/local/tmp\"", @">nul" ,@"2>&1" , nil]];
    [make_tmp launch];
    [make_tmp waitUntilExit];
    
    [self cleanTemp];
    
    
    
    NSTask* push_busybox = [[ NSTask alloc]init];
    [push_busybox setLaunchPath:adb];
    [push_busybox setArguments:[ NSArray arrayWithObjects:@"push", busybox, @"/data/local/tmp", nil]];
    [push_busybox launch];
    [push_busybox waitUntilExit];
    
    NSTask* push_su = [[NSTask alloc]init];
    [push_su setLaunchPath:adb];
    [push_su setArguments:[ NSArray arrayWithObjects:@"push", su, @"/data/local/tmp", nil]];
    [push_su launch];
    [push_su waitUntilExit];
    
    NSTask *push_super = [[NSTask alloc] init];
    [push_super setLaunchPath:adb];
    [push_super setArguments:[ NSArray arrayWithObjects:@"push", superuser, @"/data/local/tmp", nil]];
    [push_super launch];
    [push_super waitUntilExit];
    
    NSTask *push_zergRush = [[NSTask alloc] init];
    [push_zergRush setLaunchPath:adb];
    [push_zergRush setArguments:[ NSArray arrayWithObjects:@"push", zergRush, @"/data/local/tmp", nil]];
    [push_zergRush launch];
    [push_zergRush waitUntilExit];
    
    
    NSTask *chmod_zerg = [[NSTask alloc]init];
    [chmod_zerg setLaunchPath:adb];
    [chmod_zerg setArguments:[NSArray arrayWithObjects:@"shell", @"chmod", @"755", @"/data/local/tmp/zergRush", nil]];
    [chmod_zerg launch];
    [chmod_zerg waitUntilExit];
    
    NSTask *execute = [[NSTask alloc] init ];
    [execute setLaunchPath:adb];
    [execute setArguments:[NSArray arrayWithObjects:@"shell", @"/data/local/tmp/zergRush", nil]];
    [execute launch];
    [execute waitUntilExit];
    
    NSTask *remount_rw = [[NSTask alloc]init];
    [remount_rw setLaunchPath:adb];
    [remount_rw setArguments:[NSArray arrayWithObjects:@"shell", @"/data/local/tmp/busybox", @"\"mount", @"-o", @"remount,rw", @"/system\"", nil]];
    [execute launch];
    [execute waitUntilExit];
    
    NSTask *cat_su = [[NSTask alloc]init];
    [cat_su setLaunchPath:adb];
    [cat_su setArguments:[NSArray arrayWithObjects:@"shell", @"\"cat", @"/data/local/tmp/su", @"/system/bin/su\"", nil]];
    [cat_su launch];
    [cat_su waitUntilExit];
    
    NSTask *cat_super = [[NSTask alloc]init];
    [cat_super setLaunchPath:adb];
    [cat_super setArguments:[NSArray arrayWithObjects:@"shell", @"\"cat", @"/data/local/tmp/SuperUser.apk", @"/system/app/SuperUser.apk", nil]];
    [cat_super launch];
    [cat_super waitUntilExit];
    
    NSTask *chmod_su = [[NSTask alloc]init];
    [chmod_su setLaunchPath:adb];
    [chmod_su setArguments:[NSArray arrayWithObjects:@"shell", @"chmod", @"755", @"/system/bin/su", nil]];
    [chmod_su launch];
    [chmod_su waitUntilExit];
    NSLog(@"test");
    
    NSTask *chmod_super = [[NSTask alloc]init];
    [chmod_super setLaunchPath:adb];
    [chmod_super setArguments:[NSArray arrayWithObjects:@"shell", @"chmod", @"644", @"/system/app/SuperUser.apk", nil]];
    [chmod_super launch];
    [chmod_super waitUntilExit];
    
    
    [ self checkRoot ];
    
    
        if ( _rooted )
        {
            NSAlert *rooted = [[NSAlert alloc] init];
            [rooted addButtonWithTitle:@"OK"];
            [rooted setMessageText:@"Your device is successfully rooted"];
            [rooted setInformativeText:@"XRoot"];
            [rooted setAlertStyle:NSWarningAlertStyle];
            [rooted runModal];
            
            [self cleanTemp ];
            [self rebootDevice];
            
            
            
        } else{
            
            NSAlert *rooterror = [[NSAlert alloc] init];
            [rooterror addButtonWithTitle:@"OK"];
            [rooterror setMessageText:@"We're sorry, can't root your phone"];
            [rooterror setInformativeText:@"XRoot"];
            [rooterror setAlertStyle:NSWarningAlertStyle];
            [rooterror runModal];
            [self cleanTemp];
        }

    
}

- (void) mempodroid
{
    
    
    
}

- (void) cleanTemp
{
    NSBundle *myBundle = [ NSBundle mainBundle];
    NSString *adbPath = [ myBundle pathForResource:@"adb" ofType:nil];
    
    NSTask *clean = [[NSTask alloc] init];
    [clean setLaunchPath:adbPath];
    [clean setArguments:[NSArray arrayWithObjects:@"shell", @"rm", @"/data/local/tmp/*", nil]];
    [clean launch];
    [clean waitUntilExit];
    

}

- (void) pwn
{
    NSBundle *myBundle = [ NSBundle mainBundle];
    NSString *adbPath = [ myBundle pathForResource:@"adb" ofType:nil];
    NSString *busybox = [ myBundle pathForResource:@"busybox" ofType:nil];
    NSString *su = [myBundle pathForResource:@"su" ofType:nil];
    NSString *pwn  = [myBundle pathForResource:@"pwn" ofType:nil];
    NSString *superuser = [ myBundle pathForResource:@"SuperUser" ofType:@"apk"];
    
    NSTask *task_push_busy = [[ NSTask alloc]init];
    [task_push_busy setLaunchPath:adbPath];
    [task_push_busy setArguments:[ NSArray arrayWithObjects:@"push", busybox, @"/data/local/tmp", nil]];
    [task_push_busy launch];
    [task_push_busy waitUntilExit];
    
    NSTask *task_push_su = [[NSTask alloc] init];
    [task_push_su setLaunchPath:adbPath ];
    [task_push_su setArguments:[ NSArray arrayWithObjects:@"push", su , @"/data/local/tmp", nil]];
    [task_push_su launch];
    [task_push_su waitUntilExit];
    
    NSTask *task_push_pwn =[[NSTask alloc] init];
    [task_push_pwn setLaunchPath:adbPath];
    [task_push_pwn setArguments:[ NSArray arrayWithObjects:@"push", pwn, @"/data/local/tmp", nil]];
    [task_push_pwn launch];
    [task_push_pwn waitUntilExit];
    
    NSTask *task_push_super = [[NSTask alloc]init];
    [task_push_super setLaunchPath:adbPath];
    [task_push_super setArguments:[NSArray arrayWithObjects:@"push", superuser, @"/data/local/tmp", nil]];
    [task_push_super launch];
    [task_push_super waitUntilExit];
    
    NSTask *task_chmod = [[NSTask alloc] init];
    [task_chmod setLaunchPath:adbPath];
    [task_chmod setArguments:[ NSArray arrayWithObjects:@"shell", @"chmod", @"755", @"/data/local/tmp/pwn", nil]];
    [task_chmod launch];
    [task_chmod waitUntilExit];
    
    NSTask *execute = [[NSTask alloc] init];
    [execute setLaunchPath:adbPath];
    [execute setArguments: [ NSArray arrayWithObjects:@"shell", @"/data/local/tmp/pwn", nil]];
    [execute launch];
    [execute waitUntilExit];
    
    
    [self checkRoot];
    
    if ( _rooted )
    {
        NSAlert *rooted = [[NSAlert alloc] init];
        [rooted addButtonWithTitle:@"OK"];
        [rooted setMessageText:@"Your device is successfully rooted, Press OK button and we will install SuperUser.apk ...."];
        [rooted setInformativeText:@"XRoot"];
        [rooted setAlertStyle:NSWarningAlertStyle];
        
        
        if([rooted runModal] == NSAlertFirstButtonReturn )
        {
            
            NSTask *task_remount = [[NSTask alloc]init];
            [task_remount setLaunchPath:adbPath];
            NSArray *ar_remount = [ NSArray arrayWithObjects:@"shell", @"su",@"-c", @"\"busybox", @"mount",@"-o", @"remount,rw", @"/system\"", nil];
            [task_remount setArguments:ar_remount];
            [task_remount launch];
            [task_remount waitUntilExit];
            
            // Copy SuperUser
            NSTask *task_cp_super = [[NSTask alloc] init];
            [task_cp_super setLaunchPath:adbPath];
            NSArray *ar_cp_super = [ NSArray arrayWithObjects:@"shell", @"su", @"-c" , @"\"busybox", @"cp" , @"/data/local/tmp/SuperUser.apk", @"/system/app/\"", nil];
            [task_cp_super setArguments:ar_cp_super];
            [task_cp_super launch];
            [task_cp_super waitUntilExit];
            
            
            // chmod SuperUser
            NSTask *task_chmod_super = [[ NSTask alloc] init];
            [task_chmod_super setLaunchPath:adbPath];
            NSArray *ar_chmod_super = [ NSArray arrayWithObjects:@"shell", @"su", @"-c", @"\"chmod", @"644", @"/system/app/SuperUser.apk\"" , nil];
            [task_chmod_super setArguments:ar_chmod_super];
            [task_chmod_super launch];
            [task_chmod_super waitUntilExit];
            
            _rooted = YES;

        }
        
        
        [self rebootDevice];
        
        
        
    } else{
        
        NSAlert *rooterror = [[NSAlert alloc] init];
        [rooterror addButtonWithTitle:@"OK"];
        [rooterror setMessageText:@"We're sorry, can't root your phone"];
        [rooterror setInformativeText:@"XRoot"];
        [rooterror setAlertStyle:NSWarningAlertStyle];
        [rooterror runModal];
        
    }
    


}

- (IBAction)btnUnroot:(NSButton *)sender {
    
    
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *adbPath = [ myBundle pathForResource:@"adb" ofType:nil];
    NSString *busybox = [ myBundle pathForResource:@"busybox" ofType:nil];
    NSString *unroot = [ myBundle pathForResource:@"unroot" ofType:nil];
    
    [self cleanTemp];
    
    [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"\nUnrooting.....please wait.."   ]];
    
    //NSTask *task_clean = [[ NSTask alloc] init];    // Clean Temp Folder
    //[task_clean setLaunchPath:adbPath ];
    
    NSTask *task_push_busy = [ [NSTask alloc] init];    // Pushing Busybox
    [task_push_busy setLaunchPath:adbPath];
    
    NSTask *task_push_unroot = [[NSTask alloc] init];     // Pushing Unroot
    [task_push_unroot setLaunchPath:adbPath];
    
    NSTask *task_chmod_busybox = [[NSTask alloc]init];     // Permission Busybox
    [task_chmod_busybox setLaunchPath:adbPath];
    
    NSTask *task_remount = [[NSTask alloc] init]; // Mount System
    [ task_remount setLaunchPath:adbPath ];
    
    NSTask *task_chmod_unroot = [[NSTask alloc] init];    // Permission Unroot
    [task_chmod_unroot setLaunchPath:adbPath];
    
    NSTask *task_run = [[NSTask alloc] init];   // Excute Unroot
    [task_run setLaunchPath:adbPath];
    
    
    //NSArray *ar_clean = [ NSArray arrayWithObjects:@"shell", @"\"su", @"-c", @"'rm",@"/data/local/tmp/*'\"" , nil];
    //[ task_clean setArguments:ar_clean];
    
    NSArray *ar_push_busy = [ NSArray arrayWithObjects: @"push", busybox, @"/data/local/tmp" , nil];
    [ task_push_busy setArguments:ar_push_busy];
    [task_push_busy launch];
    [task_push_busy waitUntilExit];
    
    NSArray *ar_push_unroot = [ NSArray arrayWithObjects:@"push", unroot, @"/data/local/tmp", nil];
    [ task_push_unroot setArguments:ar_push_unroot];
    [task_push_unroot launch];
    [task_push_unroot waitUntilExit];
    
    NSArray *ar_chmod_busy = [ NSArray arrayWithObjects:@"shell", @"chmod", @"777", @"/data/local/tmp/busybox", nil];
    [ task_chmod_busybox setArguments:ar_chmod_busy];
    [ task_chmod_busybox launch];
    [ task_chmod_busybox waitUntilExit];
    
    NSArray *ar_chmod_unroot = [ NSArray arrayWithObjects:@"shell", @"chmod", @"755" , @"/data/local/tmp/unroot", nil];
    [ task_chmod_unroot setArguments:ar_chmod_unroot];
    [task_chmod_unroot launch];
    [task_chmod_unroot waitUntilExit];
    
    NSArray *ar_mount_sys = [ NSArray arrayWithObjects:@"shell", @"su", @"-c" , @"\"/data/local/tmp/busybox", @"mount", @"-o", @"remount,rw",@"/system\"" , nil];
    [ task_remount setArguments:ar_mount_sys ];
    [task_remount launch];
    [task_remount waitUntilExit];
    
    NSTask *task_del_super = [[NSTask alloc] init];
    [task_del_super setLaunchPath:adbPath];
    NSArray *ar_del_super = [ NSArray arrayWithObjects:@"shell", @"su", @"-c", @"rm" ,@"/system/app/SuperUser.apk", nil];
    [task_del_super setArguments:ar_del_super];
    [task_del_super launch];
    [task_del_super waitUntilExit];
    
    NSTask *task_del_super1 = [[NSTask alloc] init];
    [task_del_super1 setLaunchPath:adbPath];
    [task_del_super1 setArguments:[ NSArray arrayWithObjects:@"shell", @"su", @"-c", @"rm", @"/system/app/SuperSU.apk", nil]];
    [task_del_super1 launch];
    [task_del_super1 waitUntilExit];
    
    NSTask *task_del_super2 = [[NSTask alloc] init];
    [task_del_super2 setLaunchPath:adbPath];
    [task_del_super2 setArguments:[ NSArray arrayWithObjects:@"shell", @"su", @"-c", @"rm", @"/system/app/SuperSu.apk", nil]];
    [task_del_super2 launch];
    [task_del_super2 waitUntilExit];
    
    
    NSArray *ar_excute = [ NSArray arrayWithObjects:@"shell", @"su" , @"-c", @"/data/local/tmp/unroot" , nil];
    [ task_run setArguments:ar_excute];
    [ task_run launch];
    [ task_run waitUntilExit];
    

    
    //[ task_clean launch ];
    //[ self rebootDevice ];

    [_text_log setStringValue: [ NSString stringWithFormat:@"%@%@" , _text_log.stringValue, @"\n\nDone.."   ]];

    
}
@end
