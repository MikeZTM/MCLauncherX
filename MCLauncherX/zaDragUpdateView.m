//
//  zaDragUpdateView.m
//  MCLauncherX
//
//  Created by Mike Lee on 1/8/13.
//  Copyright (c) 2013 MikeZTM. All rights reserved.
//

#import "zaDragUpdateView.h"
#import "zaAppDelegate.h"

@implementation zaDragUpdateView{
    bool highlight;
}

- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
    highlight=YES;
    [self setNeedsDisplay: YES];
    return NSDragOperationGeneric;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender{
    highlight=NO;
    [self setNeedsDisplay: YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    highlight=NO;
    [self setNeedsDisplay: YES];
    return YES;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    NSArray *draggedFilenames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    if ([[[draggedFilenames objectAtIndex:0] pathExtension] isEqual:@"zip"]){
        return YES;
    } else {
        return NO;
    }
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender{
    NSArray *draggedFilenames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    [self updateFromZip:[draggedFilenames objectAtIndex:0]];
}

- (void)drawRect:(NSRect)rect{
    [super drawRect:rect];
    if ( highlight ) {
        [[NSColor keyboardFocusIndicatorColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: [self bounds]];
    }else{
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: [self bounds]];
    }
}

- (void)updateFromZip:(NSString *)path{
    NSTask *unzipTask = [[NSTask alloc] init];
    NSString *dest = [(zaAppDelegate *)[[NSApplication sharedApplication] delegate] MCpath];
    dest = [dest substringToIndex:[dest length]-18];
    NSString *delPath = [[NSString alloc] initWithFormat:dest,nil];
    [unzipTask setLaunchPath:@"/usr/bin/unzip"]; //this is where the unzip application is on the system.
    [unzipTask setCurrentDirectoryPath:dest]; //this means we only have to pass one argument, the path to the zip.
    NSArray *arguments = [NSArray arrayWithObjects:@"-o",path,nil];
    [unzipTask setArguments:arguments];
    [unzipTask launch];
    [unzipTask waitUntilExit];
    //delete files
    dest=[dest stringByAppendingString:@"/todelete.txt"];
    NSString *textDataFile = [NSString stringWithContentsOfFile:dest encoding:NSUTF8StringEncoding error:nil];
    NSArray *chunks = [textDataFile componentsSeparatedByString: @";"];
    for (NSString* file in chunks) {
        @try {
            NSString *tmp=[delPath stringByAppendingString:file];
            [[NSFileManager defaultManager] removeItemAtPath:tmp error:nil];
        }
        @catch (NSException *exception) {
        }
    }
    @try {
        [[NSFileManager defaultManager] removeItemAtPath:dest error:nil];
    }
    @catch (NSException *exception) {
    }
}

@end
