//
//  PMRunner.h
//  PebbleControl
//
//  Created by Tyler H on 3/14/14.
//
//

#import <Foundation/Foundation.h>

@interface PMRunner : NSObject

+ (NSDictionary *)runScriptFromFile:(NSString *)path;
+ (NSString *)runScriptFromString:(NSString *)script;

@end
