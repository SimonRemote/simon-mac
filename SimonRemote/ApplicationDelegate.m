#import "ApplicationDelegate.h"
#import <Sparkle/Sparkle.h>

#define CHANNEL_LEN 8
#define WS_SERVER_URL @"ws://simon-server.tyhoff.com/"

@implementation ApplicationDelegate {
    Reachability* reach;
    NSTimer *tickTimer;
    NSString *channel;
}

@synthesize panelController = _panelController;
@synthesize menubarController = _menubarController;
@synthesize messenger = _messenger;
@synthesize numberActiveControllers = _numberActiveControllers;

NSString *letters = @"ABCDEFGHIJKLMNPQRSTUVWXYZ";

#pragma mark - Notifications

- (void) receiveSleepNote: (NSNotification*) note
{
    //add disconnect
    [tickTimer invalidate];
    NSLog(@"receiveSleepNote: %@", [note name]);
}

- (void) receiveWakeNote: (NSNotification*) note
{
    //add connect
    if ([tickTimer isValid]) {
        [tickTimer invalidate];
    }
    
    tickTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0
                                     target: self
                                   selector:@selector(timerTick:)
                                   userInfo: nil repeats:YES];
    
    NSLog(@"receiveWakeNote: %@", [note name]);
}


-(void)reachabilityChanged:(NSNotification*)note
{
    if([reach isReachable])
    {
        //add connect websocket
        NSLog(@"Notification Says Reachable\n");
    }
    else
    {
        //add disconect webscocket
        NSLog(@"Notification Says Unreachable\n");
    }
}

- (void)pushNewInfo:(NSNotification *)notification
{
    if (_numberActiveControllers == 0) {
        return;
    }
    
    if ([[notification name] isEqualToString:@"com.apple.iTunes.playerInfo"]) {
        [[self messenger] sendNewInfoForApp:@"iTunes"];
    } else if ([[notification name] isEqualToString:@"com.spotify.client.PlaybackStateChanged"]) {
        [[self messenger] sendNewInfoForApp:@"Spotify"];
    }
}

- (void)dealloc
{
    [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
}

#pragma mark -

void *kContextActivePanel = &kContextActivePanel;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kContextActivePanel) {
        self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSString *)randomStringWithLength:(int)len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

- (NSString *)getChannel
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString * _channel = [defaults objectForKey:@"channel"];

    if (_channel != nil) {
        return _channel;
    }
    
    _channel = [self randomStringWithLength:CHANNEL_LEN];
    [defaults setObject:_channel forKey:@"channel"];
    
    return _channel;
}

- (void)generateNewChannel
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString * _channel = [self randomStringWithLength:CHANNEL_LEN];
    [defaults setObject:_channel forKey:@"channel"];
    
    [[self panelController] setChannel:_channel];
    [[[self messenger] connection] changeChannelTo:_channel];
    [[self panelController] update];
    
}

- (void)printNotification:(NSNotification*) note
{
    NSLog(@"name: %@ object: %@\n", [note name], [note object]);
}

#pragma mark - NSApplicationDelegate
- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    SUUpdater *updater = [SUUpdater sharedUpdater];
    [updater setAutomaticallyChecksForUpdates:YES];
    [updater setAutomaticallyDownloadsUpdates:YES];
    [updater checkForUpdatesInBackground];
}

- (void)setupNotificationsAndTimers
{
    // Reachability
    
    reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableOnWWAN = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];

    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveSleepNote:)
                                                               name: NSWorkspaceWillSleepNotification object: NULL];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveWakeNote:)
                                                               name: NSWorkspaceDidWakeNotification object: NULL];
    
    // Player state changes
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(pushNewInfo:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(pushNewInfo:)
                                                            name:@"com.spotify.client.PlaybackStateChanged"
                                                          object:nil];
    
    // set up reconnect timer
    
    tickTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0
                                                 target: self
                                               selector:@selector(timerTick:)
                                               userInfo: nil repeats:YES];
}


- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // Install icon into the menu bar
    self.menubarController = [[MenubarController alloc] init];
    channel = [self getChannel];
    _messenger = [[SRMessenger alloc] initWithURL:WS_SERVER_URL andChannel:channel];
    
    
    
    [self setupNotificationsAndTimers];
}

- (void)timerTick:(NSTimer *)timer
{
    //I'm removing reachable check for local testing
    if ( ([[self messenger] isConnected] == NO) /* && [reach isReachable] */) {
        NSLog(@"Attempting server reconnect\n");
        [[self messenger] attemptServerReconnect];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Explicitly remove the icon from the menu bar
    self.menubarController = nil;
    return NSTerminateNow;
}

#pragma mark - Actions

- (IBAction)togglePanel:(id)sender
{
    self.menubarController.hasActiveIcon = !self.menubarController.hasActiveIcon;
    self.panelController.hasActivePanel = self.menubarController.hasActiveIcon;
}

#pragma mark - Public accessors

- (PanelController *)panelController
{
    if (_panelController == nil) {
        _panelController = [[PanelController alloc] initWithDelegate:self];
        [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
        [_panelController setChannel:channel];

    }
    return _panelController;
}

#pragma mark - PanelControllerDelegate

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller
{
    return self.menubarController.statusItemView;
}

- (void) setNumberActiveControllers:(NSInteger)numberActiveControllers
{
    _numberActiveControllers = numberActiveControllers;
    [_panelController update];
}

@end
