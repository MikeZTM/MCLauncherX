//
//  zaPreferencesWindowController.m
//  MCLauncherX
//
//  Created by Mike Lee on 1/8/13.
//  Copyright (c) 2013 MikeZTM. All rights reserved.
//

#import "zaPreferencesWindowController.h"
#import "zaAppDelegate.h"

@interface zaPreferencesWindowController ()

@end

@implementation zaPreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowClosing:)
                                                     name:NSWindowWillCloseNotification
                                                   object:nil];
    }

    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowClosing:(NSNotification*)aNotification {
    [[(zaAppDelegate *)[[NSApplication sharedApplication] delegate] window] makeKeyAndOrderFront:self];
}

@end
