#import "PanelController.h"
#import "BackgroundView.h"
#import "StatusItemView.h"
#import "MenubarController.h"
#import "ApplicationDelegate.h"

#import <Sparkle/Sparkle.h>

//remote
#import "SRActionHandler.h"

#define OPEN_DURATION .00
#define CLOSE_DURATION .00

#define SEARCH_INSET 17

#define POPUP_HEIGHT 180
#define PANEL_WIDTH 280
#define MENU_ANIMATION_DURATION .1

#pragma mark -

@implementation PanelController


@synthesize backgroundView = _backgroundView;
@synthesize hasActivePanel = _hasActivePanel;
@synthesize delegate = _delegate;
@synthesize headerText = _headerText;
@synthesize channelText = _channelText;
@synthesize statusText = _statusText;
@synthesize preferencesButton;
@synthesize quitButton;
@synthesize channel;

#pragma mark -

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate
{
    self = [super initWithWindowNibName:@"Panel"];
    if (self != nil)
    {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{

}

#pragma mark -

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Make a fully skinned panel
    NSPanel *panel = (id)[self window];
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
    [_channelText setStringValue:channel];
    [_statusText setAttributedStringValue:[self formattedStatusText]];
}

#pragma mark - Public accessors

- (BOOL)hasActivePanel
{
    return _hasActivePanel;
}

- (void)setHasActivePanel:(BOOL)flag
{
    if (_hasActivePanel != flag)
    {
        _hasActivePanel = flag;
        
        if (_hasActivePanel)
        {
            [self openPanel];
        }
        else
        {
            [self closePanel];
        }
    }
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    self.hasActivePanel = NO;
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
    if ([[self window] isVisible])
    {
        self.hasActivePanel = NO;
    }
}

- (void)windowDidResize:(NSNotification *)notification
{
    NSWindow *panel = [self window];
    NSRect statusRect = [self statusRectForWindow:panel];
    NSRect panelRect = [panel frame];
    
    CGFloat statusX = roundf(NSMidX(statusRect));
    CGFloat panelX = statusX - NSMinX(panelRect);
    
    self.backgroundView.arrowX = panelX;
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
    self.hasActivePanel = NO;
}


#pragma mark - Public methods

- (NSRect)statusRectForWindow:(NSWindow *)window
{
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = NSZeroRect;
    
    StatusItemView *statusItemView = nil;
    if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
    {
        statusItemView = [self.delegate statusItemViewForPanelController:self];
    }
    
    if (statusItemView)
    {
        statusRect = statusItemView.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
    else
    {
        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    return statusRect;
}

- (void)openPanel
{
    NSWindow *panel = [self window];
    
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = [self statusRectForWindow:panel];

    NSRect panelRect = [panel frame];
//    panelRect.size.width = PANEL_WIDTH;
//    panelRect.size.height = POPUP_HEIGHT;
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    
    [NSApp activateIgnoringOtherApps:NO];
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
    NSTimeInterval openDuration = OPEN_DURATION;
    
    NSEvent *currentEvent = [NSApp currentEvent];
    if ([currentEvent type] == NSLeftMouseDown)
    {
        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
        if (shiftPressed || shiftOptionPressed)
        {
            openDuration *= 10;
            
            if (shiftOptionPressed)
                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
                      NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
        }
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
}

- (void)closePanel
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[self window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        
        [self.window orderOut:nil];
    });
}

- (void)update
{
    [_statusText setAttributedStringValue:[self formattedStatusText]];
    [_channelText setStringValue:channel];
    
    /* do other stuff, like channel */
    // ta da
}

- (NSAttributedString *)formattedStatusText
{

    ApplicationDelegate *appDelegate = (ApplicationDelegate *)[[NSApplication sharedApplication] delegate];
    NSString *status;
    NSColor *color;
    
    /* update connection status text */
    NSInteger num = [appDelegate numberActiveControllers];
    if (num > 0) {
        CGFloat red = 46.0f/255.0f;
        CGFloat green = 204.0f/255.0f;
        CGFloat blue = 133.0f/255.0f;
        
        
        color = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0f];
        
        NSString *format = (num == 1) ? @"%ld controller connected" : @"%ld controllers connected";
        status = [NSString stringWithFormat:format, num];
    } else {
        CGFloat red = 192.0f/255.0f;
        CGFloat green = 57.0f/255.0f;
        CGFloat blue = 43.0f/255.0f;
        
        color = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0f];
        status = [NSString stringWithFormat:@"No controllers connected"];
    }
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    [options setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [options setObject:color forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:status attributes:options];
    
    return aString;
}

- (IBAction)preferencesClicked:(id)sender {
    ApplicationDelegate *app = (ApplicationDelegate *)[[NSApplication sharedApplication] delegate];
    [app generateNewChannel];
//    [[SUUpdater sharedUpdater] checkForUpdates:nil];
}
- (IBAction)quitClicked:(id)sender {
    [NSApp terminate:self];
}

@end
