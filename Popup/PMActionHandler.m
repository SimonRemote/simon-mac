//
//  PMActionHandler.m
//  PebbleControl
//
//  Created by Tyler H on 3/14/14.
//
//

#import "PMActionHandler.h"

@implementation PMActionHandler



static bool string_equal(NSString *one, NSString *two) {
    return one && two && [one caseInsensitiveCompare:two] == NSOrderedSame;
}

+ (void) handleCommand:(NSString *)command forApplication:(NSString *)app
{
    //this will be really poorly done for now...
    
    /* iTunes */
    if (string_equal(app, @"iTunes")) {
        
        if (string_equal(command, @"next")) {
            [PMRunner runScriptFromFile:@"iTunes-next"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"iTunes-previous"];
            
        } else if (string_equal(command, @"play")) {
            [PMRunner runScriptFromFile:@"iTunes-play"];
            
        } else if (string_equal(command, @"pause")) {
            [PMRunner runScriptFromFile:@"iTunes-pause"];
            
        } else if (string_equal(command, @"playpause")) {
            [PMRunner runScriptFromFile:@"iTunes-playpause"];
            
        } else if (string_equal(command, @"volume_up")) {
            [PMRunner runScriptFromFile:@"System-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [PMRunner runScriptFromFile:@"System-volume_down"];
            
        } else if (string_equal(command, @"enable_shuffle")) {
            NSLog(@"enable_shufle ran\n");
            [PMRunner runScriptFromFile:@"iTunes-enable_shuffle"];
            [NSThread sleepForTimeInterval:1.0f];
            
        } else if (string_equal(command, @"disable_shuffle")) {
            NSLog(@"disable_shufle ran\n");
            [PMRunner runScriptFromFile:@"iTunes-disable_shuffle"];
            [NSThread sleepForTimeInterval:1.0f];
        }
        
        /* Spotify */
    } else if (string_equal(app, @"Spotify")) {
        
        if (string_equal(command, @"next")) {
            [PMRunner runScriptFromFile:@"Spotify-next"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"Spotify-previous"];
            
        } else if (string_equal(command, @"play")) {
            [PMRunner runScriptFromFile:@"Spotify-play"];
            
        } else if (string_equal(command, @"pause")) {
            [PMRunner runScriptFromFile:@"Spotify-pause"];
            
        } else if (string_equal(command, @"playpause")) {
            [PMRunner runScriptFromFile:@"Spotify-playpause"];
            
        } else if (string_equal(command, @"volume_up")) {
            [PMRunner runScriptFromFile:@"System-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [PMRunner runScriptFromFile:@"System-volume_down"];
            
        } else if (string_equal(command, @"enable_shuffle")) {
            [PMRunner runScriptFromFile:@"Spotify-enable_shuffle"];
            
        } else if (string_equal(command, @"disable_shuffle")) {
            [PMRunner runScriptFromFile:@"Spotify-disable_shuffle"];
            
        } else if (string_equal(command, @"info")) {
            [PMRunner runScriptFromFile:@"Spotify-info"];
        }
        
        /* PowerPoint */
    } else if (string_equal(app, @"PowerPoint")) {
        
        if (string_equal(command, @"next")) {
            [PMRunner runScriptFromFile:@"PowerPoint-next"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"PowerPoint-previous"];
            
        } else if (string_equal(command, @"black_screen")) {
            [PMRunner runScriptFromFile:@"PowerPoint-black_screen"];
            
        } else if (string_equal(command, @"white_screen")) {
            [PMRunner runScriptFromFile:@"PowerPoint-white_screen"];
            
        } else if (string_equal(command, @"volume_up")) {
            [PMRunner runScriptFromFile:@"System-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [PMRunner runScriptFromFile:@"System-volume_down"];
            
        } else if (string_equal(command, @"info")) {
            [PMRunner runScriptFromFile:@"PowerPoint-info"];
        }
        
        /* Keynote */
    } else if (string_equal(app, @"Keynote")) {
        
        if (string_equal(command, @"next")) {
            [PMRunner runScriptFromFile:@"Keynote-next"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"Keynote-previous"];
            
        } else if (string_equal(command, @"volume_up")) {
            [PMRunner runScriptFromFile:@"System-volume_up"];
            
        } else if (string_equal(command, @"volume_down")) {
            [PMRunner runScriptFromFile:@"System-volume_down"];
            
        }
        
        /* System */
    } else if (string_equal(app, @"System")) {
        
        if (string_equal(command, @"next")) {
            [PMRunner runScriptFromFile:@"System-left"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"System-right"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"System-up"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"System-down"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"System-space"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"System-volume_up"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"System-volume_down"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"System-sleep"];
            
        } else if (string_equal(command, @"previous")) {
            [PMRunner runScriptFromFile:@"System-reboot"];
            
        }
    }
}

+ (NSDictionary *) getInfoForApplication:(NSString *)app
{
    if (string_equal(app, @"iTunes")) {
        return [PMRunner runScriptFromFile:@"iTunes-info"];
    } else if (string_equal(app, @"Spotify")) {
        return [PMRunner runScriptFromFile:@"Spotify-info"];
    } else if (string_equal(app, @"PowerPoint")) {
        return [PMRunner runScriptFromFile:@"PowerPoint-info"];
    } else if (string_equal(app, @"Keynote")) {
        return [PMRunner runScriptFromFile:@"Keynote-info"];
    } else if (string_equal(app, @"System")) {
        return [PMRunner runScriptFromFile:@"System-info"];
    }
    
    return nil;
}

@end
