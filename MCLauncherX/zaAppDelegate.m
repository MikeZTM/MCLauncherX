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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths objectAtIndex:0];
    NSLog(@"applicationSupportDirectory: '%@'", applicationSupportDirectory);

    NSString *documentsDirectory = [applicationSupportDirectory stringByAppendingString:@"/MCLauncherX"];
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentsDirectory isDirectory:nil])
        if(![fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:NULL]) {
            NSLog(@"Error: Create folder failed %@", documentsDirectory);
        }
    filePath = [documentsDirectory stringByAppendingPathComponent:@"stats.plist"];
    plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    bool firstRun = false;
    if(!plistDict){
        plistDict=[[NSMutableDictionary alloc] init];
        firstRun=true;
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

    if(firstRun){ //Open preference at first run.
        [self openPreferences:self];
    }
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
    NSArray *vals=[[NSArray alloc] initWithObjects:_playerName.stringValue,_memAmount,_MCpath,_accountPswd,nil];
    //start game thread
    [NSThread detachNewThreadSelector:@selector(startGame:) toTarget:[self class] withObject:vals];
    //save player name to plist
    [plistDict setObject:_playerName.stringValue forKey:@"PlayerName"];
    [plistDict writeToFile:filePath atomically: YES];
}

+(NSString *)getCP:(NSString *)path{
    //prepare class path
    NSFileManager *filemgr;
    filemgr = [[NSFileManager alloc] init];
    //    currentpath = [filemgr currentDirectoryPath];
    NSString *currentpath;
    currentpath = [path substringToIndex:[path length]-13];
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

+(NSString *)getDcp:(NSString *)path{
    //prepare native class path
    NSFileManager *filemgr;
    filemgr = [[NSFileManager alloc] init];
    NSString *currentpath;
    currentpath = [path substringToIndex:[path length]-13];
    NSString *dcp=@"-Djava.library.path=";
    dcp=[dcp stringByAppendingString:currentpath];
    dcp=[dcp stringByAppendingString:@"natives"];
    return dcp;
}

+(void)startGame:(NSArray*)vals{
    //game thread
    @try {
        NSString *temp=[NSString alloc];    //Player name
        temp=@"\"";
        temp=[temp stringByAppendingString:[vals objectAtIndex:0]];
        temp=[temp stringByAppendingString:@"\""];


        NSString *temp2=[NSString alloc];   //Pswd
        temp2=@"\"";
        temp2=[temp2 stringByAppendingString:[vals objectAtIndex:3]];
        temp2=[temp2 stringByAppendingString:@"\""];

        NSTask *myTask = [[NSTask alloc] init];

        NSString *cp=[self getCP:[vals objectAtIndex:2]];
        NSString *dcp=[self getDcp:[vals objectAtIndex:2]];
        NSString *xms=@"-Xms";
        xms=[xms stringByAppendingString:[vals objectAtIndex:1]];
        xms=[xms stringByAppendingString:@"m"];
        NSString *xmx=@"-Xmx";
        xmx=[xmx stringByAppendingString:[vals objectAtIndex:1]];
        xmx=[xmx stringByAppendingString:@"m"];
        NSArray *args;
        if([vals objectAtIndex:3]){
            args = [[NSArray alloc] initWithObjects:xms, xmx, @"-cp", cp, dcp, @"net.minecraft.client.Minecraft", temp, nil];
        }else{
            args = [[NSArray alloc] initWithObjects:xms, xmx, @"-cp", cp, dcp, @"net.minecraft.client.Minecraft", temp, temp2, nil];
        }

        [myTask setLaunchPath:@"/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/bin/java"];
        [myTask setArguments:args];
        [myTask launch];
        sleep(1);   //wait jvm exit on error.
        if ([myTask terminationStatus]==1) {
            @throw [[NSException alloc] initWithName:@"Arguments error" reason:@"args err" userInfo:@""];
        }
    }
    @catch (NSException *exception) {
        if ([[exception description] hasSuffix:@"running"]) {
            return exit(0); //minecraft launched.
        }
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Ops! Could not launch your minecraft!"];
        [alert setInformativeText:@"Check your preferences."];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
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
    [plistDict setObject:_MCpath forKey:@"MCPath"];
    [plistDict writeToFile:filePath atomically: YES];
    NSLog(_MCpath);
}

-(void)setMemory:(NSString*)amount{
    _memAmount=amount;
    [plistDict setObject:_memAmount forKey:@"MemAmount"];
    [plistDict writeToFile:filePath atomically: YES];
    NSLog(_memAmount);
}

-(void)setPswd:(NSString*)pswd{
    _accountPswd=pswd;
    [plistDict setObject:_accountPswd forKey:@"Pswd"];
    [plistDict writeToFile:filePath atomically: YES];
}

- (void)memChange:(id)sender {
    [self setMemory:[[self MemTextField] stringValue]];
}

- (IBAction)mcpathChange:(id)sender {
    [self setMC:[[self mcpathTextField] stringValue]];
}

- (IBAction)memSliderChanged:(id)sender {
    [_MemTextField setStringValue:[(NSSlider*)sender stringValue]];
    [self memChange:nil];
}

- (IBAction)pswdChanged:(id)sender {
    [self setPswd:[[self pswdTextField] stringValue]];
}
@end
