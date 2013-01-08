//
//  zaAppDelegate.m
//  MCLauncherX
//
//  Created by Mike Lee on 9/23/12.
//  Copyright (c) 2012 MikeZTM. All rights reserved.
//

#import "zaAppDelegate.h"
#import "zaPreferencesWindowController.h"

@implementation zaAppDelegate{
    NSString *filePath;
    NSMutableDictionary *plistDict;
}
@synthesize playerName=_playerName;
@synthesize name=_name;
@synthesize window=_window;
@synthesize preferences=_preferences;
@synthesize MCpath=_MCpath;
@synthesize memAmount=_memAmount;
@synthesize accountPswd=_accountPswd;
@synthesize memSlider=_memSlider;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //check player name
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:@"stats.plist"];
    plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if(!plistDict){
        plistDict=[[NSMutableDictionary alloc] init];
    }
    _name = [plistDict objectForKey:@"PlayerName"];
    _MCpath = [plistDict objectForKey:@"MCPath"];
    _memAmount = [plistDict objectForKey:@"MemAmount"];
    _accountPswd = [plistDict objectForKey:@"Pswd"];
    //set default player name
    if(!_name){
        _name=@"";
    }
    if(!_MCpath){
        _MCpath=@"";
    }
    if(!_memAmount){
        _memAmount=@"1024";
        NSLog(@"%d",[_memAmount intValue]);
    }
    if(!_accountPswd){
        _accountPswd=@"";
    }
    _playerName.stringValue=_name;
    [_mcpathTextField setStringValue:_MCpath];
    [_MemTextField setStringValue:_memAmount];
    [_pswdTextField setStringValue:_accountPswd];
    [_memSlider setIntValue:[_memAmount intValue]];
    //version check
    //    NSString *launcher_ver = [plistDict objectForKey:@"LauncherVer"];
    //    if(!launcher_ver){
    //        launcher_ver=@"1";
    //    }
    //    NSString *version = [plistDict objectForKey:@"Version"];
    //    if(!version){
    //        version=@"1";
    //    }
}

- (IBAction)launchGame:(id)sender {
    //get player name
    NSString *name=_playerName.stringValue;
    //start game thread
    [NSThread detachNewThreadSelector:@selector(startGame:) toTarget:[self class] withObject:name];
    //save player name to plist
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [plistDict setObject:_playerName.stringValue forKey:@"PlayerName"];
    [plistDict writeToFile:filePath atomically: YES];
    //waitting for game thread
    sleep(1);
    //exit luancher thread
    return exit(0);
}

-(NSString *)getCP{
    //prepare class path
    NSFileManager *filemgr;
    filemgr = [[NSFileManager alloc] init];
    //    currentpath = [filemgr currentDirectoryPath];
    NSString *currentpath;
    currentpath = [_MCpath substringToIndex:[_MCpath length]-13];
    NSString *cp=@"";
    cp=[cp stringByAppendingString:currentpath];
    cp=[cp stringByAppendingString:@"minecraft.jar:"];
    cp=[cp stringByAppendingString:currentpath];
    cp=[cp stringByAppendingString:@"lwjgl_util.jar:"];
    cp=[cp stringByAppendingString:currentpath];
    cp=[cp stringByAppendingString:@"lwjgl.jar:"];
    cp=[cp stringByAppendingString:currentpath];
    cp=[cp stringByAppendingString:@"jinput.jar"];
    return cp;
}

-(NSString *)getDcp{
    //prepare native class path
    NSFileManager *filemgr;
    filemgr = [[NSFileManager alloc] init];
    NSString *currentpath;
    currentpath = [_MCpath substringToIndex:[_MCpath length]-13];
    NSString *dcp=@"-Djava.library.path=";
    dcp=[dcp stringByAppendingString:currentpath];
    dcp=[dcp stringByAppendingString:@"bin/natives"];
    return dcp;
}

-(void)startGame:(NSString *)name{
    //game thread
    NSString *temp=[NSString alloc];
    temp=@"\"";
    temp=[temp stringByAppendingString:name];
    temp=[temp stringByAppendingString:@"\""];

    NSTask *myTask = [[NSTask alloc] init];
    NSString *cp=[self getCP];
    NSString *dcp=[self getDcp];
    NSString *xms=@"-Xms";
    xms=[xms stringByAppendingString:_memAmount];
    xms=[xms stringByAppendingString:@"m"];
    NSString *xmx=@"-Xmx";
    xmx=[xmx stringByAppendingString:_memAmount];
    xmx=[xmx stringByAppendingString:@"m"];
    NSArray *args = [[NSArray alloc] initWithObjects:xms, xmx, @"-cp", cp, dcp, @"net.minecraft.client.Minecraft", temp, nil];

    [myTask setLaunchPath:@"/usr/bin/java"];
    [myTask setArguments:args];
    [myTask launch];

    [myTask waitUntilExit];
    return exit(0);
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (IBAction)openPreferences:(id)sender {
    [_window orderOut:self];
    [_preferences makeKeyAndOrderFront:self];
}

-(void)setMC:(NSString*)path{
    _MCpath=path;
    [plistDict setObject:_playerName.stringValue forKey:@"MCPath"];
    [plistDict writeToFile:filePath atomically: YES];
}

-(void)setMemory:(NSString*)amount{
    _memAmount=amount;
    [plistDict setObject:_playerName.stringValue forKey:@"MemAmount"];
    [plistDict writeToFile:filePath atomically: YES];
}

-(void)setPswd:(NSString*)pswd{
    _accountPswd=pswd;
    [plistDict setObject:_playerName.stringValue forKey:@"Pswd"];
    [plistDict writeToFile:filePath atomically: YES];
}

- (IBAction)memChange:(id)sender {
    [self setMemAmount:[[self MemTextField] stringValue]];
    NSLog(_memAmount);
}

- (IBAction)mcpathChange:(id)sender {
    [self setMC:[[self mcpathTextField] stringValue]];
    NSLog(_MCpath);
}
@end
