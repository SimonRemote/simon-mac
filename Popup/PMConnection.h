//
//  PMConnection.h
//  PebbleControl
//
//  Created by Tyler H on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

@protocol PMConnectionDelegate;

@interface PMConnection : NSObject <SRWebSocketDelegate>

@property (nonatomic, assign) id <PMConnectionDelegate> delegate;

- (void)connectWithURL:(NSString *)url andChannel:(NSString *)channel;
- (void)reconnect;
- (void)closeConnection;
- (void)destroyConnection;
- (void)sendDictionary:(NSDictionary *)dict;
- (void)changeChannelTo:(NSString *)channel;
@end


@protocol PMConnectionDelegate <NSObject>

- (void)connection:(PMConnection *)connection didReceiveMessage:(id)message;

@optional
- (void)connectionDidOpen:(PMConnection *)connection;
- (void)connectionDidClose:(PMConnection *)connection;

@end