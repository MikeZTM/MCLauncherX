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
- (IBAction)openPreferences:(id)sender;

@end
