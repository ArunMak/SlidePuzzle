

#import "AppDelegate.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
NSString *const FBSessionStateChangedNotification =
@"com.sybrant.puzzlebreak:FBSessionStateChangedNotification";

@interface AppDelegate()
@property (strong, nonatomic) NSURL *openedURL;
@end
@implementation AppDelegate
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if ([kv count] > 1) {
            NSString *val = [[kv objectAtIndex:1]
                             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
    }
    return params;
}

/*
 * A function to get the access token info and save
 * it in the cache, useful for deep linking support
 * in cases where the session is not open.
 */
- (void) handleOpenURLPre:(NSURL *) url
{
    // Parse the URL
    NSString *query = [url fragment];
    if (!query) {
        query = [self.openedURL query];
    }
    NSDictionary *params = [self parseURLParams:query];
    // Look for a valid access token
    if ([params objectForKey:@"access_token"]) {
        NSString *accessToken = [params objectForKey:@"access_token"];
        NSString *expires_in = [params objectForKey:@"expires_in"];
        // Determine the expiration data
        NSDate *expirationDate = nil;
        if (expires_in != nil) {
            int expValue = [expires_in intValue];
            if (expValue != 0) {
                expirationDate = [NSDate dateWithTimeIntervalSinceNow:expValue];
            }
        }
        if (!expirationDate) {
            expirationDate = [NSDate distantFuture];
        }
        NSDate *nowDate = [NSDate date];
        // Check expiration date later than now
        if (NSOrderedDescending == [expirationDate compare:nowDate]) {
            // Cache the token
            NSDictionary *tokenInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       accessToken, FBTokenInformationTokenKey,
                                       expirationDate, FBTokenInformationExpirationDateKey,
                                       nowDate, FBTokenInformationRefreshDateKey,
                                       nil];
            FBSessionTokenCachingStrategy *tokenCachingStrategy = [FBSessionTokenCachingStrategy defaultInstance];
            [tokenCachingStrategy cacheTokenInformation:tokenInfo];
            // Now open the session and the cached token should
            // be picked up, open with nil permissions because
            // what you send is checked against any cached permissions
            // to determine token validity.
            [FBSession openActiveSessionWithReadPermissions:nil
                                               allowLoginUI:NO
                                          completionHandler:^(FBSession *session,
                                                              FBSessionState state,
                                                              NSError *error) {
                                              [self sessionStateChanged:session
                                                                  state:state
                                                                  error:error];
                                          }];
        }
    }
}

#pragma mark - Authentication methods
/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                //NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
            self.user = nil;
            break;
        case FBSessionStateClosedLoginFailed:
            self.user = nil;
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    // Ask for permissions for getting info about uploaded
    // custom photos.
    NSArray *permissions = [NSArray arrayWithObjects:
                            @"user_photos",
                            nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

/*
 * Closes the active Facebook session
 */
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark - Personalization methods
/*
 * Makes a request for user data and invokes a callback
 */
- (void)requestUserData:(UserDataLoadedHandler)handler
{
    // If there is saved data, return this.
    if (nil != self.user) {
        if (handler) {
            handler(self, self.user);
        }
    } else if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 // Update menu user info
                 // Save the user data
                 self.user = user;
                 if (handler) {
                     handler(self, self.user);
                 }
             }
         }];
    }
}


#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    [FBPlacePickerViewController class];
    [FBFriendPickerViewController class];
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47216939-1"];
    // Override point for customization after application launch.
    
    // Initialze the beverage menu items
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Save the incoming URL to test deep links later.
    self.openedURL = url;
    
    // Work around for app link from FB with valid info. If the
    // session is closed, set the valid info (if any) in the cache
    if ((FBSession.activeSession.state == FBSessionStateCreated) ||
        (FBSession.activeSession.state == FBSessionStateClosed)){
        [self handleOpenURLPre:url];
    }
    // We need to handle URLs by passing them to FBSession in order for SSO authentication
    // to work.
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
       // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



@end
