#import "MenubarController.h"
#import "PanelController.h"
#import "SRMessenger.h"
#import "Reachability.h"
@interface ApplicationDelegate : NSObject <NSApplicationDelegate, PanelControllerDelegate>

@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;
@property (nonatomic, strong) SRMessenger *messenger;
@property (nonatomic) NSInteger numberActiveControllers;

- (IBAction)togglePanel:(id)sender;
- (void)generateNewChannel;
@end
