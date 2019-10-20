

#import <UIKit/UIKit.h>
#import "SliderPuzzleMainViewController.h"
#import "Generic.h"
#import "NSObject+alertMsg.h"
@class SelectstageViewController;
@protocol selectstageviewdelegate
-(void)flipsideViewControllerDidFinish:(SelectstageViewController *)controller;
@end

@interface SelectstageViewController : UIViewController<UIScrollViewDelegate>{
   
    UIButton *stageButton;
    NSArray *stagenumarray;
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain) UIButton *stageButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageview;
@property (assign, nonatomic) IBOutlet id <selectstageviewdelegate> delegate;
-(IBAction)StageselectedButtonAction:(id)sender;
@end
