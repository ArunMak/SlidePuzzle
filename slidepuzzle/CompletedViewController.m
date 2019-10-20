

#import "CompletedViewController.h"
#import "AppDelegate.h"
@interface CompletedViewController ()
@property (nonatomic, strong) NSMutableData *responseData;
@property (strong, nonatomic) NSDictionary<FBGraphUser> *user;
- (void)sessionStateChanged:(NSNotification*)notification;
- (void)populateUserDetails;
@end

@implementation CompletedViewController
@synthesize levelnumberLabel,levelnum,timeLabel,stimevalue,starimageview,scoreview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        NSLog(@"login already");
        // If a deep link, go to the seleceted menu
        [self populateUserDetails];
    }
    else {
        
                NSLog(@"logout");
    }
}
- (void)populateUserDetails {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate requestUserData:^(id sender, id<FBGraphUser> user) {
    //to get user details using fb json
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen ) {
        // If the user's session is active, personalize, but
        // only if this is not deep linking into the order view.
        [self populateUserDetails];
    } else if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Check the session for a cached token to show the proper authenticated
        // UI. However, since this is not user intitiated, do not show the login UX.
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:NO];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
        
    // Present login modal if necessary after the view has been
    // displayed, not in viewWillAppear: so as to allow display
    // stack to "unwind"
    if (FBSession.activeSession.isOpen ) {
                NSLog(@"hai");
    } else if (FBSession.activeSession.isOpen ||
               FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded ||
               FBSession.activeSession.state == FBSessionStateCreatedOpening) {
    } else {
        //        NSLog(@"OUTSIDE");
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *label = [NSString stringWithFormat:@"%d",levelnum+1];
    levelnumberLabel.text = label;
      timeLabel.text = stimevalue;
  //  [[Generic sharedMySingleton].xmlStarArray insertObject:[NSString stringWithFormat:@"%d",[Generic sharedMySingleton].starnumber+1] atIndex:levelnum];
    int x = 6;
    for (int i = 1 ; i < 6; i++) {
        starimageview = [[UIImageView alloc]initWithFrame:CGRectMake(x, 57, 50, 50)];
        starimageview.tag = i;
        UIImage *starimage = [UIImage imageNamed:@"star_nstd.png"];
        [starimageview setImage:starimage];
        [scoreview addSubview:starimageview];
        x=x+60;
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
     NSLog(@"star number is %d", [Generic sharedMySingleton].starnumber);
    if ([[Generic sharedMySingleton].coinArray[levelnum] integerValue] == 0) {
        NSString *sCoin = [NSString stringWithFormat:@"%d",[Generic sharedMySingleton].starnumber];
        [Generic sharedMySingleton].coinArray[levelnum] = sCoin;
    }else{
        if ([[Generic sharedMySingleton].coinArray[levelnum] integerValue] < [Generic sharedMySingleton].starnumber) {
            NSString *sCoin = [NSString stringWithFormat:@"%d",[Generic sharedMySingleton].starnumber];
            [Generic sharedMySingleton].coinArray[levelnum] = sCoin;
        }
    }
    [self performSelector:@selector(animationDidFinish:) withObject:nil
               afterDelay:2.5];
	// Do any additional setup after loading the view.
}
-(void)animationDidFinish:(id)sender{
    int x = 6;
    NSArray * imageArray = [[NSArray alloc] initWithObjects:
                            [UIImage imageNamed:@"star_std.png"], nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 3.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    NSLog(@"%d",[[Generic sharedMySingleton]starnumber]+1);
    for (int i = 0; i < [[Generic sharedMySingleton]starnumber]+1;i++ ){
    Cstarimageview = [[UIImageView alloc]initWithFrame:CGRectMake(x, 57, 50, 50)];
    Cstarimageview.animationImages =imageArray;
    Cstarimageview.animationDuration = 3;
    Cstarimageview.animationRepeatCount = 0;
    [Cstarimageview .layer addAnimation:transition forKey:nil];
    [Cstarimageview startAnimating];

    [scoreview addSubview:Cstarimageview];
    x=x+60;
    }
    [Cstarimageview stopAnimating];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FbShareButtonAction:(id)sender {
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
    
    
    if ([[FBSession activeSession]isOpen]) {
        /*
         * if the current session has no publish permission we need to reauthorize
         */
//        if ([[[FBSession activeSession]permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
//            
//            [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends
//                                                  completionHandler:^(FBSession *session,NSError *error){
//                                                      [self share];
//                                                  }];
//            
        
            [self share];
        
    }else{
        /*
         * open a new session with publish permission
         */
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceOnlyMe
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (!error && status == FBSessionStateOpen) {
                                                 [self share];
                                             }else{
                                                 NSLog(@"error");
                                             }
                                         }];
    }
    
    
    
    
  //  [self share];
}
-(void)share{
    NSString *sScore = [NSString stringWithFormat:@"Hey Check Out My Score \n Completed level %d in %@ time  Try to Beat me  ",levelnum+1,stimevalue];
    [[FBSession activeSession] reauthorizeWithPublishPermissions:@[ @"publish_stream",@"publish_actions" ] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *authSession, NSError *authError) {
        
        // If auth was successful, create a status update FBRequest
        if (!authError) {
            
            
            //              postRequest =[FBRequest requestForUploadPhoto:[UIImage imageNamed:@"Default.png"]];
            //                FBRequest *postt = [FBRequest requestWithGraphPath:@"www.fliktrip.com" parameters: HTTPMethod:]
            //     UIImage *imgSource = [UIImage imageNamed:@"splash.jpg"];
            //   NSString *strMessage = @"www.fliktrip.com and  This is my dashboard page";
            NSMutableDictionary* photosParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 @"www.google.com",@"source",
                                                 @"https://www.google.com",@"link",@"PuzzleBreak",@"name",sScore,@"description",
                                                 nil];
            
            //  FBRequest *postRequest = [FBRequest requestWithGraphPath:@"me/photos" parameters:photosParams HTTPMethod:@"POST"];
            [FBRequestConnection startWithGraphPath:@"me/feed" parameters:photosParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error)
                {
                    [self showAlert:@"Connection Error...Try Again"];
                    NSLog(@"error is %@",error);
                                    }
                else
                {
                    [self showAlert:[NSString stringWithFormat:@"Your Score is Posted "]];
                   
                }
            }];
        }
    }];
    


}

- (IBAction)NextLevelButtonAction:(id)sender {
    
    SelectstageViewController *catogery = [self.storyboard instantiateViewControllerWithIdentifier:@"selectstage"];
    [self.navigationController pushViewController:catogery animated:YES];
    
}
@end
