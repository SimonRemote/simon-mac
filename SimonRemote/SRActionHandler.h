//
//  PMActionHandler.h
//  SimonRemote
//
//  Created by Tyler H on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "SRRunner.h"

@interface SRActionHandler : NSObject

+ (void) handleCommand:(NSString *)command forApplication:(NSString *)app;
+ (NSDictionary *) getInfoForApplication:(NSString *)app;

@end
