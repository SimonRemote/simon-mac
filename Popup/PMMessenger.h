//
//  PMMessenger.h
//  PebbleControl
//
//  Created by Tyler H on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "PMConnection.h"
#import "PMActionHandler.h"

@interface PMMessenger : NSObject <PMConnectionDelegate>
@property (nonatomic, strong) PMConnection *connection;
- (PMMessenger *)initWithURL:(NSString *)url andChannel:(NSString *)channel;
- (void) deliverInfoForApp:(NSString *)app;
- (void) sendNewInfoForApp:(NSString *)app;
- (bool) isConnected;
- (void) attemptServerReconnect;
@end
