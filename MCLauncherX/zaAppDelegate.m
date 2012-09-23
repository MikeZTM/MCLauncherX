//
//  zaAppDelegate.m
//  MCLauncherX
//
//  Created by Mike Lee on 9/23/12.
//  Copyright (c) 2012 MikeZTM. All rights reserved.
//

#import "zaAppDelegate.h"

@implementation zaAppDelegate
@synthesize playerName=_playerName;
@synthesize name=_name;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"stats.plist"];
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    _name = [plistDict objectForKey:@"PlayerName"];
    if(!_name){
        _name=@"Player";
    }
    _playerName.stringValue=_name;
}

- (IBAction)launchGame:(id)sender {
    NSString *name=_playerName.stringValue;
    [NSThread detachNewThreadSelector:@selector(startGame:) toTarget:[self class] withObject:name];
//    [[self window] close];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"stats.plist"];
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] init];
    [plistDict setObject:_playerName.stringValue forKey:@"PlayerName"];
    [plistDict writeToFile:filePath atomically: YES];
    sleep(1);
    return exit(0);
}

+(NSString *)getCP{
    NSFileManager *filemgr;
    NSString *currentpath;
    filemgr = [[NSFileManager alloc] init];
//    currentpath = [filemgr currentDirectoryPath];

    currentpath = @"/Applications";
    NSString *cp=@"";
    cp=[cp stringByAppendingString:currentpath];
    cp=[cp stringByAppendingString:@"/MCLauncherX.app/Contents/minecraft/bin/minecraft.jar:"];
    cp=[cp stringByAppendingString:currentpath];
    cp=[cp stringByAppendingString:@"/MCLauncherX.app/Contents/minecraft/bin/lwjgl_util.jar:"];
    cp=[cp stringByAppendingString:currentpath];
    cp=[cp stringByAppendingString:@"/MCLauncherX.app/Contents/minecraft/bin/lwjgl.jar:"];
    cp=[cp stringByAppendingString:currentpath];
    cp=[cp stringByAppendingString:@"/MCLauncherX.app/Contents/minecraft/bin/jinput.jar"];
    return cp;
}

+(NSString *)getDcp{
    NSFileManager *filemgr;
    NSString *currentpath;
    filemgr = [[NSFileManager alloc] init];
    currentpath = @"/Applications";
    NSString *dcp=@"-Djava.library.path=";
    dcp=[dcp stringByAppendingString:currentpath];
    dcp=[dcp stringByAppendingString:@"/MCLauncherX.app/Contents/minecraft/bin/natives"];
    return dcp;
}

+(NSString *)getPara:(NSString *)name{
    NSString *cmd=@"-Xms1024m -Xmx2048m ";
    cmd=[cmd stringByAppendingString:[self getCP]];
    cmd=[cmd stringByAppendingString:@" net.minecraft.client.Minecraft \""];
    cmd=[cmd stringByAppendingString:name];
    cmd=[cmd stringByAppendingString:@"\""];
    return cmd;
}

+(void)startGame:(NSString *)name{
    NSString *temp=[NSString alloc];
    temp=@"\"";
    temp=[temp stringByAppendingString:name];
    temp=[temp stringByAppendingString:@"\""];

    NSTask *myTask = [[NSTask alloc] init];
    NSString *cp=[self getCP];
    NSString *dcp=[self getDcp];
    NSArray *args = [[NSArray alloc] initWithObjects:@"-Xms1024m", @"-Xmx2048m", @"-cp", cp, dcp, @"net.minecraft.client.Minecraft", temp, nil];

    [myTask setLaunchPath:@"/usr/bin/java"];
    [myTask setArguments:args];
    [myTask launch];
    
    [myTask waitUntilExit];
    return exit(0);
}

@end
