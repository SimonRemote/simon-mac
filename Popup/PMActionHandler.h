//
//  PMActionHandler.h
//  PebbleControl
//
//  Created by Tyler H on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "PMRunner.h"

@interface PMActionHandler : NSObject

+ (void) handleCommand:(NSString *)command forApplication:(NSString *)app;
+ (NSDictionary *) getInfoForApplication:(NSString *)app;

@end
