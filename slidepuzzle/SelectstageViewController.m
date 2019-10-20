

#import "SelectstageViewController.h"
#import "Generic.h"
@interface SelectstageViewController ()

@end

@implementation SelectstageViewController
@synthesize backgroundImageview,stageButton,scrollview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [scrollview setDelegate:self];
    scrollview.contentSize = CGSizeMake(320, 650);
    [scrollview setScrollEnabled:YES];
    [scrollview setShowsHorizontalScrollIndicator:YES];
    [scrollview setUserInteractionEnabled:YES];
    stagenumarray = [[NSArray alloc]initWithObjects:@"Stage1",@"Stage2",@"Stage3",@"Stage4",@"Stage5",@"Stage6",@"Stage7",@"Stage8",@"Stage9",@"Stage10",@"Stage11",@"Stage12", nil];
    NSInteger xOffset = 13;
    int len = 20;
    int k=0;
    for (int i = 0; i < 12 ; i++ )
    {
        if (k==3) {
            
            len+=120;
            xOffset=13;
            k=0;
        }
        k++;
       
        stageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        stageButton.frame = CGRectMake(xOffset,len +20 , 90 , 90);
        [stageButton addTarget:self action:@selector(StageselectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        stageButton.tag = i;
        [stageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[Generic sharedMySingleton].imagelist[i]]] forState:UIControlStateNormal];
        UILabel *stageLabel = [[UILabel alloc]init];
        stageLabel.frame = CGRectMake(xOffset, len+110, 69, 20);
        stageLabel.numberOfLines = 2;
        stageLabel.textAlignment = UITextAlignmentCenter;
        stageLabel.textColor = [UIColor blackColor];
        [stageLabel setText:stagenumarray[i]];
        xOffset+=102;
        [scrollview addSubview:stageLabel];
        
        [scrollview addSubview:stageButton];
    }
    
	// Do any additional setup after loading the view.
}
-(void)StageselectedButtonAction:(id)sender
{

    UIButton *b = (UIButton*) sender;
    int buttontag = b.tag;
    if (buttontag <= [Generic sharedMySingleton].unlockNumber ) {
        SliderPuzzleMainViewController *catogery = [self.storyboard instantiateViewControllerWithIdentifier:@"slide"];
        catogery.stagenumber = buttontag;
        [self.navigationController pushViewController:catogery animated:YES];
    }else{
    [self showAlert:@"Unlock Previous level"];
    }
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackgroundImageview:nil];
    [super viewDidUnload];
}
@end
