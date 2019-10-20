
#import "NSObject+alertMsg.h"
#import "AppDelegate.h"
@implementation NSObject (alertMsg)

-(void)showAlert:(NSString*)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}




@end
   
   
