

#import "FunSlideViewController.h"
#import "FunPlayViewController.h"
#define TILE_SPACING    4
#define SHUFFLE_NUMBER	100

@interface FunSlideViewController ()

@end

@implementation FunSlideViewController
@synthesize tiles, tileImageView,stagenumber,puzzleImage,slideView,scoreLabel;

int NUM_HORIZONTAL_PIECE = 3;
int NUM_VERTICAL_PIECE = 3;
int countmov = 0;
int thetim = 0;

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
    
    
    self.tiles = [[NSMutableArray alloc] init];
//    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSMutableString *savePath = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
//    NSURL *url;
//    [savePath appendString:@"/profilepic.png"];
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:savePath];
//    if (fileExists)
//    {
//        url = [NSURL fileURLWithPath:savePath];
//        
//    }
     timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    if ([[UIScreen mainScreen]bounds].size.height == 568) {
       puzzleImage= [self imageWithImage:puzzleImage scaledToSize:CGSizeMake(310, 456)];
    }else{
        puzzleImage= [self imageWithImage:puzzleImage scaledToSize:CGSizeMake(310, 380)];
    }

	
    [self initPuzzle:puzzleImage];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 * take an image path, load the image and break it into tiles to use as our puzzle pieces.
 **/
-(void)initPuzzle:(UIImage*)imagePath{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"pathimage is %@",imagePath);
	UIImage *orgImage = imagePath;
	
	if( orgImage == nil ){
		return;
	}
    
    if (tileImageView != nil && [prefs boolForKey:@"Refresh"] == TRUE) {
        for (tileImageView in tiles) {
            [tileImageView removeFromSuperview];
        }
    }
	
	[self.tiles removeAllObjects];
	
	tileWidth = orgImage.size.width/NUM_HORIZONTAL_PIECE;
	tileHeight = orgImage.size.height/NUM_VERTICAL_PIECE;
	
	blankPosition = CGPointMake( NUM_HORIZONTAL_PIECE-1, NUM_VERTICAL_PIECE-1 );
	int part = 0;
	for( int x=0; x<NUM_VERTICAL_PIECE; x++ ){
		for( int y=0; y<NUM_HORIZONTAL_PIECE; y++ ){
			CGPoint orgPosition = CGPointMake(y,x);
			
			if( blankPosition.y == orgPosition.y && blankPosition.x == orgPosition.x ){
				continue;
			}
			
			CGRect frame = CGRectMake(tileWidth*y, tileHeight*x,
									  tileWidth, tileHeight );
			CGImageRef tileImageRef = CGImageCreateWithImageInRect( orgImage.CGImage, frame );
			UIImage *tileImage = [UIImage imageWithCGImage:tileImageRef];
			
			CGRect tileFrame =  CGRectMake((tileWidth+TILE_SPACING)*y, (tileHeight+TILE_SPACING)*x,
										   tileWidth, tileHeight );
			
			tileImageView = [[Tile alloc] initWithImage:tileImage];
			tileImageView.frame = tileFrame;
			tileImageView.originalPosition = orgPosition;
			tileImageView.currentPosition = orgPosition;
            
			CGImageRelease( tileImageRef );
			tileImageView.tag = part;
            NSString *tilestr = [[NSString alloc]initWithFormat:@"%d",tileImageView.tag  ];
            UILabel *lbl = [[UILabel alloc]init];
            lbl.frame = CGRectMake((tileImageView.frame.size.width/2)-10, (tileImageView.frame.size.height/2)-10, 20, 20) ;
            lbl.text = tilestr;
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl sizeToFit];
            [tileImageView addSubview:lbl];			[tiles addObject:tileImageView];
			
            
            
			// now add to view
			[slideView insertSubview:tileImageView atIndex:0];
            NSLog(@"tileview index is %d",tileImageView.tag);
			
            part++;
		}
	}
	
	[self shuffle];
}

#pragma mark tile handling methods

-(ShuffleMove) validMove:(Tile *) tile{
	// blank spot above current piece
	if( tile.currentPosition.x == blankPosition.x && tile.currentPosition.y == blankPosition.y+1 ){
		return UP;
	}
	
	// bank splot below current piece
	if( tile.currentPosition.x == blankPosition.x && tile.currentPosition.y == blankPosition.y-1 ){
		return DOWN;
	}
	
	// bank spot left of the current piece
	if( tile.currentPosition.x == blankPosition.x+1 && tile.currentPosition.y == blankPosition.y ){
		return LEFT;
	}
	
	// bank spot right of the current piece
	if( tile.currentPosition.x == blankPosition.x-1 && tile.currentPosition.y == blankPosition.y ){
		return RIGHT;
	}
	
	return NONE;
}

-(void) movePiece:(Tile *) tile withAnimation:(BOOL) animate{
	switch ( [self validMove:tile] ) {
		case UP:
			[self movePiece:tile
			   inDirectionX:0 inDirectionY:-1 withAnimation:animate];
			break;
		case DOWN:
			[self movePiece:tile
			   inDirectionX:0 inDirectionY:1 withAnimation:animate];
			break;
		case LEFT:
			[self movePiece:tile
			   inDirectionX:-1 inDirectionY:0 withAnimation:animate];
			break;
		case RIGHT:
			[self movePiece:tile
			   inDirectionX:1 inDirectionY:0 withAnimation:animate];
			break;
		default:
			break;
	}
}

-(void) movePiece:(Tile *) tile inDirectionX:(NSInteger) dx inDirectionY:(NSInteger) dy withAnimation:(BOOL) animate{
	tile.currentPosition = CGPointMake( tile.currentPosition.x+dx,
                                       tile.currentPosition.y+dy);
	blankPosition = CGPointMake( blankPosition.x-dx, blankPosition.y-dy );
	
	int x = tile.currentPosition.x;
	int y = tile.currentPosition.y;
	
	if( animate ){
		[UIView beginAnimations:@"frame" context:nil];
	}
	tile.frame = CGRectMake((tileWidth+TILE_SPACING)*x, (tileHeight+TILE_SPACING)*y,
                            tileWidth, tileHeight );
	if( animate ){
		[UIView commitAnimations];
	}
}

-(void) shuffle{
	NSMutableArray *validMoves = [[NSMutableArray alloc] init];
	
	srandom(time(NULL));
	
	for( int i=0; i<SHUFFLE_NUMBER; i++ ){
		[validMoves removeAllObjects];
		
		// get all of the pieces that can move
		for( Tile *t in tiles ){
			if( [self validMove:t] != NONE ){
				[validMoves addObject:t];
			}
		}
		
		// randomly select a piece to move
		NSInteger pick = random()%[validMoves count];
		//NSLog(@"shuffleRandom using pick: %d from array of size %d", pick, [validMoves count]);
		[self movePiece:(Tile *)[validMoves objectAtIndex:pick] withAnimation:NO];
	}
	
    
}


#pragma mark helper methods
-(Tile *) getPieceAtPoint:(CGPoint) point{
	CGRect touchRect = CGRectMake(point.x, point.y, 1.0, 1.0);
	
	for( Tile *t in tiles ){
		if( CGRectIntersectsRect(t.frame, touchRect) ){
			return t;
		}
	}
	return nil;
}

-(BOOL) puzzleCompleted{
	for( Tile *t in tiles ){
		if( t.originalPosition.x != t.currentPosition.x || t.originalPosition.y != t.currentPosition.y ){
			return NO;
		}
	}
	
	return YES;
}

#pragma mark user input hanlding

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	UITouch *touch = [touches anyObject];
    CGPoint currentTouch = [touch locationInView:slideView];
	
	Tile *t = [self getPieceAtPoint:currentTouch];
	if( t != nil ){
        //Start the game timer
        
       
        
        //Move the pieces
		[self movePiece:t withAnimation:YES];
        //Count the moves
        
        countmov++;
        NSLog(@"moves is %d",countmov);
        
		if( [self puzzleCompleted] ){
//            NSString *Winning;
            //            if ([prefs boolForKey:@"CountMoves"] == TRUE && [prefs boolForKey:@"Timer"] == TRUE) {
        //    Winning = [NSString stringWithFormat:@"It took you: %i Moves in %i Seconds!", countmov, thetim];
                      
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"You Won!"
                                                              message:stime
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
            countmov = 0;
            thetim = 0;
            if (timer != nil) {
                [timer invalidate];
                timer = nil;
            }
		}
	}
}

- (void)onTimer {
    
    if (timer != nil) {
        stime = [NSString stringWithFormat:@"%02im:%02is", thetim/60, thetim%60];
        scoreLabel.text = stime;
        NSLog(@"result is %@",stime);
        thetim++;
    }

}


#pragma mark view prperties

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

-(void)flipsideViewControllerDidFinish:(FunPlayViewController*)controller
{
    [self dismissModalViewControllerAnimated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Perform Settings Changes to the Main View
    switch ([prefs integerForKey:@"PuzzleLayoutX"]) {
        case 0:
            NUM_HORIZONTAL_PIECE = 2;
            break;
        case 1:
            NUM_HORIZONTAL_PIECE = 3;
            break;
        case 2:
            NUM_HORIZONTAL_PIECE = 4;
            break;
        case 3:
            NUM_HORIZONTAL_PIECE = 5;
            break;
        default:
            break;
    }
    
    switch ([prefs integerForKey:@"PuzzleLayoutY"]) {
        case 0:
            NUM_VERTICAL_PIECE = 2;
            break;
        case 1:
            NUM_VERTICAL_PIECE = 3;
            break;
        case 2:
            NUM_VERTICAL_PIECE = 4;
            break;
        case 3:
            NUM_VERTICAL_PIECE = 5;
            break;
        default:
            break;
    }
    
    if ([prefs boolForKey:@"Refresh"] == TRUE) {
        countmov = 0;
        thetim = 0;
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
       
        [self initPuzzle:puzzleImage];
    }
}
- (IBAction)HintButtonAction:(id)sender {
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        hintImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 457)];
        UIImage *hintimage = puzzleImage;
        [hintImageview setImage:hintimage];
        [slideView addSubview:hintImageview];
        //iphone 5
    }
    else
    {
        hintImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 383)];
        UIImage *hintimage = puzzleImage;
        [hintImageview setImage:hintimage];
        [slideView addSubview:hintImageview];
        //iphone 3.5 inch screen iphone 3g,4s
    }
    
    
}

- (IBAction)ShowHintButtonAction:(id)sender {
    
    [hintImageview removeFromSuperview];
    
}
- (IBAction)showInfo:(id)sender
{
    FunPlayViewController *catogery = [self.storyboard instantiateViewControllerWithIdentifier:@"FunPlay"];
    [self.navigationController pushViewController:catogery animated:YES];
    //    SliderPuzzleFlipsideViewController *controller = [[[SliderPuzzleFlipsideViewController alloc] initWithNibName:@"SliderPuzzleFlipsideViewController" bundle:nil] autorelease];
    //    controller.delegate = self;
    //    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //    [self presentModalViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
