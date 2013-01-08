//
//  zaMemChangeDelegate.m
//  MCLauncherX
//
//  Created by Mike Lee on 1/8/13.
//  Copyright (c) 2013 MikeZTM. All rights reserved.
//

#import "zaMemChangeDelegate.h"
#import "zaAppDelegate.h"

@implementation zaMemChangeDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification{
    [(zaAppDelegate *)[[NSApplication sharedApplication] delegate] memChange:nil];
}

@end
