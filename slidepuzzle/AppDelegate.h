

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"
extern NSString *const FBSessionStateChangedNotification;
typedef void(^UserDataLoadedHandler)(id sender, id<FBGraphUser> user);
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<FBGraphUser> user;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;
- (void)requestUserData:(UserDataLoadedHandler)handler;


@end


