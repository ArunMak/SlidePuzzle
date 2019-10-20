

#import "ViewController.h"
#import "SelectstageViewController.h"
#import "Generic.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+alertMsg.h"
#import <Social/Social.h>
@interface CompletedViewController : ViewController
{
    UIImageView *Cstarimageview;
}
@property(nonatomic)int levelnum;
@property(nonatomic,retain)NSString *stimevalue;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelnumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *starimageview;
@property (strong, nonatomic) IBOutlet UIView *scoreview;
- (IBAction)FbShareButtonAction:(id)sender;
- (IBAction)NextLevelButtonAction:(id)sender;
@end
