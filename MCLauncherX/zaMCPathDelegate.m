//
//  zaMCPathDelegate.m
//  MCLauncherX
//
//  Created by Mike Lee on 1/8/13.
//  Copyright (c) 2013 MikeZTM. All rights reserved.
//

#import "zaMCPathDelegate.h"
#import "zaAppDelegate.h"

@implementation zaMCPathDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification{
    [(zaAppDelegate *)[[NSApplication sharedApplication] delegate] mcpathChange:nil];
}
@end
