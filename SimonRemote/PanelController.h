#import "BackgroundView.h"
#import "StatusItemView.h"

@class PanelController;

@protocol PanelControllerDelegate <NSObject>

@optional

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;

@end

#pragma mark -

@interface PanelController : NSWindowController <NSWindowDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet BackgroundView *backgroundView;
@property (retain) IBOutlet NSTextField *channelText;
@property (retain) IBOutlet NSTextField *headerText;
@property (retain) IBOutlet NSTextField *statusText;
@property (unsafe_unretained) IBOutlet NSButton *preferencesButton;
@property (unsafe_unretained) IBOutlet NSButton *quitButton;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic) NSString *channel;
@property (nonatomic, unsafe_unretained, readonly) id<PanelControllerDelegate> delegate;

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;
- (void)openPanel;
- (void)closePanel;
- (void)update;

@end
