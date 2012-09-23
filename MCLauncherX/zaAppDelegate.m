//
//  zaAppDelegate.m
//  MCLauncherX
//
//  Created by Mike Lee on 9/23/12.
//  Copyright (c) 2012 MikeZTM. All rights reserved.
//

#import "zaAppDelegate.h"

@implementation zaAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)launchGame:(id)sender {
    [self getPara];
    system("");
}

- (NSString *)getCP{
    NSFileManager *filemgr;
    NSString *currentpath;
    filemgr = [[NSFileManager alloc] init];
    currentpath = [filemgr currentDirectoryPath];
    NSString *cp=@"-cp .minecraft\bin\minecraft.jar;.minecraft\bin\lwjgl_util.jar;.minecraft\bin\lwjgl.jar;.minecraft\bin\jinput.jar -Djava.library.path=\".minecraft\bin\natives\" ";
    
}

-(NSString *)getPara{
    
}

@end
