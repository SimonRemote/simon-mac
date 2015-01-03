//
//  PMActionHandler.m
//  SimonRemote
//
//  Created by Tyler H on 3/14/14.
//
//

#import "SRActionHandler.h"

@implementation SRActionHandler



static bool string_equal(NSString *one, NSString *two) {
    return one && two && [one caseInsensitiveCompare:two] == NSOrderedSame;
}

+ (void) handleCommand:(NSString *)command forApplication:(NSString *)app
{
    //this will be really poorly done for now...
    
    /* iTunes */
    if (string_equal(app, @"iTunes")) {
        
        if (string_equal(command, @"next")) {
            [SRRunner runScriptFromFile:@"iTunes-next"];
            
        } else if (string_equal(command, @"previous")) {
            [SRRunner runScriptFromFile:@"iTunes-previous"];
            
        } else if (string_equal(command, @"play")) {
            [SRRunner runScriptFromFile:@"iTunes-play"];
            
        } else if (string_equal(command, @"pause")) {
            [SRRunner runScriptFromFile:@"iTunes-pause"];
            
        } else if (string_equal(command, @"playpause")) {
            [SRRunner runScriptFromFile:@"iTunes-playpause"];
            
        } else if (string_equal(command, @"volume_up")) {
            [SRRunner runScriptFromFile:@"iTunes-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [SRRunner runScriptFromFile:@"iTunes-volume_down"];
            
        } else if (string_equal(command, @"enable_shuffle")) {
            NSLog(@"enable_shufle ran\n");
            [SRRunner runScriptFromFile:@"iTunes-enable_shuffle"];
            [NSThread sleepForTimeInterval:1.0f];
            
        } else if (string_equal(command, @"disable_shuffle")) {
            NSLog(@"disable_shufle ran\n");
            [SRRunner runScriptFromFile:@"iTunes-disable_shuffle"];
            [NSThread sleepForTimeInterval:1.0f];
            
        } else if([command hasPrefix:@"airplay_set-"]) {
            // Written by https://github.com/inonprince
            NSString* deviceName = nil;
            deviceName = [command substringFromIndex:12];
            NSString *script = @"set selecteddevice to \"%@\"\n"
            "tell application \"iTunes\"\n"
            "set apDevices to (get every AirPlay device whose available is true)\n"
            "set apNames to (get name of every AirPlay device whose available is true)\n"
            "set apChoices to {}\n"
            "repeat with i from 1 to length of apNames\n"
            "if item i of apNames is selecteddevice then set end of apChoices to item i of apDevices\n"
            "end repeat\n"
            "set current AirPlay devices to apChoices\n"
            "end tell";
            [SRRunner runScriptFromString:[NSString stringWithFormat:script, deviceName]];
        }
        
        /* Spotify */
    } else if (string_equal(app, @"Spotify")) {
        
        if (string_equal(command, @"next")) {
            [SRRunner runScriptFromFile:@"Spotify-next"];
            
        } else if (string_equal(command, @"previous")) {
            [SRRunner runScriptFromFile:@"Spotify-previous"];
            
        } else if (string_equal(command, @"play")) {
            [SRRunner runScriptFromFile:@"Spotify-play"];
            
        } else if (string_equal(command, @"pause")) {
            [SRRunner runScriptFromFile:@"Spotify-pause"];
            
        } else if (string_equal(command, @"playpause")) {
            [SRRunner runScriptFromFile:@"Spotify-playpause"];
            
        } else if (string_equal(command, @"volume_up")) {
            [SRRunner runScriptFromFile:@"Spotify-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [SRRunner runScriptFromFile:@"Spotify-volume_down"];
            
        } else if (string_equal(command, @"enable_shuffle")) {
            [SRRunner runScriptFromFile:@"Spotify-enable_shuffle"];
            
        } else if (string_equal(command, @"disable_shuffle")) {
            [SRRunner runScriptFromFile:@"Spotify-disable_shuffle"];
            
        } else if (string_equal(command, @"info")) {
            [SRRunner runScriptFromFile:@"Spotify-info"];
        }
    
        /* PowerPoint */
    } else if (string_equal(app, @"PowerPoint")) {
        
        if (string_equal(command, @"next")) {
            [SRRunner runScriptFromFile:@"PowerPoint-next"];
            
        } else if (string_equal(command, @"previous")) {
            [SRRunner runScriptFromFile:@"PowerPoint-previous"];
            
        } else if (string_equal(command, @"black_screen")) {
            [SRRunner runScriptFromFile:@"PowerPoint-black_screen"];
            
        } else if (string_equal(command, @"white_screen")) {
            [SRRunner runScriptFromFile:@"PowerPoint-white_screen"];
            
        } else if (string_equal(command, @"volume_up")) {
            [SRRunner runScriptFromFile:@"System-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [SRRunner runScriptFromFile:@"System-volume_down"];
            
        } else if (string_equal(command, @"info")) {
            [SRRunner runScriptFromFile:@"PowerPoint-info"];
        }
        
        /* Keynote */
    } else if (string_equal(app, @"Keynote")) {
        
        if (string_equal(command, @"next")) {
            [SRRunner runScriptFromFile:@"Keynote-next"];
            
        } else if (string_equal(command, @"previous")) {
            [SRRunner runScriptFromFile:@"Keynote-previous"];
            
        } else if (string_equal(command, @"volume_up")) {
            [SRRunner runScriptFromFile:@"System-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [SRRunner runScriptFromFile:@"System-volume_down"];
            
        }
        
        /* System */
    } else if (string_equal(app, @"System")) {
        
        if (string_equal(command, @"left")) {
            [SRRunner runScriptFromFile:@"System-left"];
            
        } else if (string_equal(command, @"right")) {
            [SRRunner runScriptFromFile:@"System-right"];
            
        } else if (string_equal(command, @"up")) {
            [SRRunner runScriptFromFile:@"System-up"];
            
        } else if (string_equal(command, @"down")) {
            [SRRunner runScriptFromFile:@"System-down"];
            
        } else if (string_equal(command, @"space")) {
            [SRRunner runScriptFromFile:@"System-space"];
            
        } else if (string_equal(command, @"volume_up")) {
            [SRRunner runScriptFromFile:@"System-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [SRRunner runScriptFromFile:@"System-volume_down"];
            
        }
    }
}

+ (NSDictionary *) getInfoForApplication:(NSString *)app
{
    if (string_equal(app, @"iTunes")) {
        return [SRRunner runScriptFromFile:@"iTunes-info"];
    } else if (string_equal(app, @"Spotify")) {
        return [SRRunner runScriptFromFile:@"Spotify-info"];
    } else if (string_equal(app, @"PowerPoint")) {
        return [SRRunner runScriptFromFile:@"PowerPoint-info"];
    } else if (string_equal(app, @"Keynote")) {
        return [SRRunner runScriptFromFile:@"Keynote-info"];
    } else if (string_equal(app, @"System")) {
        // It doesn't return anything useful, so let's not put forth effort.
        // return [SRRunner runScriptFromFile:@"System-info"];
    }
    
    return nil;
}

@end
