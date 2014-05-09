//
//  PMMessenger.m
//  PebbleControl
//
//  Created by Tyler H on 3/14/14.
//
//

#import "PMMessenger.h"
#import "ApplicationDelegate.h"

@implementation PMMessenger {
    bool ignorePlayer;
    bool isConnected;
}

@synthesize connection = _connection;

- (PMMessenger *)initWithURL:(NSString *)url andChannel:(NSString *)channel
{
    self = [super init];
    if (self) {
        _connection = [[PMConnection alloc] init];
        [_connection connectWithURL:url andChannel:channel];
        
        _connection.delegate = self;
    }
    
    ignorePlayer = NO;
    isConnected = NO;
    
    return self;
}

- (bool)isConnected
{
    return isConnected;
}

- (void)attemptServerReconnect
{
    [_connection reconnect];
}

- (void)connection:(PMConnection *)connection didReceiveMessage:(id)message
{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if ([root[@"type"] isEqualToString:@"status"]) {
        NSDictionary *status = root[@"status"];
        NSInteger numConnections = [(NSNumber *)status[@"numConnections"] integerValue];
        NSLog(@"numconnections: %ld\n", numConnections);
        ApplicationDelegate *app = (ApplicationDelegate *)[[NSApplication sharedApplication] delegate];
        [app setNumberActiveControllers:numConnections];
        
    } else if ([root[@"type"] isEqualToString:@"message"]) {
        NSDictionary *message = root[@"message"];
        NSString *app = message[@"app"];
        NSString *command = message[@"command"];
        ignorePlayer = YES;
        
        //execute command if not info
        if (![command isEqualToString:@"info"]) {
            [PMActionHandler handleCommand:command forApplication:app];
        }
        
        [self deliverInfoForApp:app];
    }
    
    isConnected = YES;
}

- (void) deliverInfoForApp:(NSString *)app
{
    NSDictionary * info = [PMActionHandler getInfoForApplication:app];
    
    if (info == nil) {
        NSLog(@"Info is null\n");
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"info" forKey:@"type"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"idTo"];
    [dict setObject:info forKey:@"info"];
    
    NSLog(@"%@\n", dict);
    
    [[self connection] sendDictionary:dict];
}

- (void) sendNewInfoForApp:(NSString *)app
{
    if (!ignorePlayer) {
        [self deliverInfoForApp:app];
    }
    ignorePlayer = NO;
}

- (void) connectionDidOpen:(PMConnection *)connection
{
    NSLog(@"connection opened\n");
    isConnected = YES;
}

- (void) connectionDidClose:(PMConnection *)connection
{
    NSLog(@"connection closed\n");
    isConnected = NO;
}


@end
