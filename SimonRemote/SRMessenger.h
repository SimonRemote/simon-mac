//
//  PMMessenger.h
//  SimonRemote
//
//  Created by Tyler H on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "SRConnection.h"
#import "SRActionHandler.h"

@interface SRMessenger : NSObject <PMConnectionDelegate>
@property (nonatomic, strong) SRConnection *connection;
- (SRMessenger *)initWithURL:(NSString *)url andChannel:(NSString *)channel;
- (void) deliverInfoForApp:(NSString *)app;
- (void) sendNewInfoForApp:(NSString *)app;
- (bool) isConnected;
- (void) attemptServerReconnect;
@end
