//
//  PMRunner.m
//  PebbleControl
//
//  Created by Tyler H on 3/14/14.
//
//

#import "PMRunner.h"
#import "NSAppleEventDescriptor+FCSAdditions.h"

@implementation PMRunner

/* from http://stackoverflow.com/a/13182999 */

+ (NSDictionary *)runScriptFromFile:(NSString *)name
{
    NSDictionary *error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"scpt"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSAppleScript* script = [[NSAppleScript alloc] initWithContentsOfURL:url error:&error];
    NSAppleEventDescriptor *result = [script executeAndReturnError:&error];
    return (NSDictionary *)[result toObject];
}

+ (NSString *)runScriptFromString:(NSString *)string
{
    NSDictionary *error = nil;
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:string];
    NSAppleEventDescriptor *result = [script executeAndReturnError:&error];
    return [result stringValue];
}

@end
