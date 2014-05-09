//
//  PMConnection.m
//  PebbleControl
//
//  Created by Tyler H on 3/14/14.
//
//

#import "PMConnection.h"

@implementation PMConnection {
    SRWebSocket *_webSocket;
    NSString *_url;
    NSString *_channel;
}

@synthesize delegate = _delegate;

- (void) sendDictionary:(NSDictionary *)dict
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString* msg = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    [_webSocket send:msg];
}

- (void)connectWithURL:(NSString *)url andChannel:(NSString *)channel
{
    _url = url;
    _channel = channel;
    [self connect];
}

- (void)changeChannelTo:(NSString *)channel
{
    _channel = channel;
    [self reconnect];
}

- (void)connect
{
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    _webSocket.delegate = self;
    [_webSocket open];
}

- (void)reconnect
{
    [self _reconnect];
}

- (void)closeConnection
{
    _webSocket.delegate = nil;
    [_webSocket close];
}

- (void)destroyConnection
{
    [self closeConnection];
    _webSocket = nil;
}

- (void)_reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    _webSocket.delegate = self;
    
    [_webSocket open];
}

- (void)registerOnChannel:(NSString *)channel
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"registration" forKey:@"type"];
    
    NSMutableDictionary *registration = [NSMutableDictionary dictionary];
    [registration setObject:[NSNumber numberWithBool:YES] forKey:@"isListener"];
    [registration setObject:channel forKey:@"channel"];
    
    [dict setObject:registration forKey:@"registration"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString* msg = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"msg sent: %@\n", msg);
    [_webSocket send:msg];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    [self registerOnChannel:_channel];
    
    if ([self.delegate respondsToSelector:@selector(connectionDidOpen:)]) {
        [self.delegate connectionDidOpen:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    _webSocket = nil;
    
    if ([self.delegate respondsToSelector:@selector(connectionDidClose:)]) {
        [self.delegate connectionDidClose:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Message:\n%@\n\n", message);
    
    // send to delegate
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveMessage:)]) {
        [self.delegate connection:self didReceiveMessage:message];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    _webSocket = nil;
    
    if ([self.delegate respondsToSelector:@selector(connectionDidClose:)]) {
        [self.delegate connectionDidClose:self];
    }
}

@end
