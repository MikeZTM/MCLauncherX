//
//  zaAppDelegate.h
//  MCLauncherX
//
//  Created by Mike Lee on 9/23/12.
//  Copyright (c) 2012 MikeZTM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface zaAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSWindow *preferences;
- (IBAction)launchGame:(id)sender;
@property (weak) IBOutlet NSTextField *playerName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *MCpath;
@property (strong, nonatomic) NSString *memAmount;
@property (strong, nonatomic) NSString *accountPswd;
- (IBAction)openPreferences:(id)sender;
-(void)setMC:(NSString*)path;
-(void)setMemory:(NSString*)amount;
-(void)setPswd:(NSString*)pswd;
- (IBAction)memChange:(id)sender;
- (IBAction)mcpathChange:(id)sender;
@property (weak) IBOutlet NSTextField *mcpathTextField;
@property (weak) IBOutlet NSTextField *MemTextField;
@property (weak) IBOutlet NSSecureTextField *pswdTextField;
@property (weak) IBOutlet NSSlider *memSlider;
@end
