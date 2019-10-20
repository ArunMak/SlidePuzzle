#import "SliderPuzzleMainViewController.h"
#import "CompletedViewController.h"
#define TILE_SPACING    4
#define SHUFFLE_NUMBER	100

@implementation SliderPuzzleMainViewController

@synthesize tiles, tileImageView,stagenumber,gameView,timeLabel,bestTimeLabel;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{  
    countmove = 0;
    thetime = 0;
    bestTimeLabel.text = [Generic sharedMySingleton].bestTimeArray[stagenumber];
    NUM_HORIZONTAL_PIECES = [[Generic sharedMySingleton].horizontalslice[stagenumber]integerValue];
    NUM_VERTICAL_PIECES = [[Generic sharedMySingleton].verticalslice[stagenumber]integerValue];
    self.tiles = [[NSMutableArray alloc] init];
	Pic = [NSString stringWithFormat:@"%@",[Generic sharedMySingleton].imagelist[stagenumber]];
    [self initPuzzle:Pic];
     timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

/**
 * take an image path, load the image and break it into tiles to use as our puzzle pieces. 
 **/ 
-(void) initPuzzle:(NSString *) imagePath{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	UIImage *orgImage = [UIImage imageNamed:imagePath];
	
	if( orgImage == nil ){
		return; 
	}
    
    if (tileImageView != nil && [prefs boolForKey:@"Refresh"] == TRUE) {
        for (tileImageView in tiles) {
            [tileImageView removeFromSuperview];
        }
    }
	
	[self.tiles removeAllObjects];
	
	tileWidth = orgImage.size.width/NUM_HORIZONTAL_PIECES;
	tileHeight = orgImage.size.height/NUM_VERTICAL_PIECES;
	
	blankPosition = CGPointMake( NUM_HORIZONTAL_PIECES-1, NUM_VERTICAL_PIECES-1 );
	int part = 0;
	for( int x=0; x<NUM_VERTICAL_PIECES; x++ ){
		for( int y=0; y<NUM_HORIZONTAL_PIECES; y++ ){
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
			[gameView insertSubview:tileImageView atIndex:0];
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

- (IBAction)HintButtonAction:(id)sender {
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        hintImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 457)];
        UIImage *hintimage = [UIImage imageNamed:Pic];
        [hintImageview setImage:hintimage];
        [gameView addSubview:hintImageview];
        //iphone 5
    }
    else
    {
        hintImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 383)];
        UIImage *hintimage = [UIImage imageNamed:Pic];
        [hintImageview setImage:hintimage];
        [gameView addSubview:hintImageview];
        //iphone 3.5 inch screen iphone 3g,4s
    }

   
}

- (IBAction)ShowHintButtonAction:(id)sender {
    
  [hintImageview removeFromSuperview];

}



#pragma mark user input hanlding 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	UITouch *touch = [touches anyObject];
    CGPoint currentTouch = [touch locationInView:gameView];
	
	Tile *t = [self getPieceAtPoint:currentTouch];
	if( t != nil ){
        //Start the game timer
      
           
      
        //Move the pieces
		[self movePiece:t withAnimation:YES];
        //Count the moves
       
            countmove++;
            
       
		if( [self puzzleCompleted] ){
            NSString *Winning;
            [Generic sharedMySingleton].levelnumber = stagenumber +1;
           
            if ([Generic sharedMySingleton].unlockNumber == 0)
            {
                [Generic sharedMySingleton].unlockNumber = [Generic sharedMySingleton].levelnumber;
                   
            }else{
                if ([Generic sharedMySingleton].unlockNumber <= [Generic sharedMySingleton].levelnumber) {
                    [Generic sharedMySingleton].unlockNumber = [Generic sharedMySingleton].levelnumber;
                    }
            
            }
            [[Generic sharedMySingleton].prefs setObject:[NSNumber numberWithInt:[Generic sharedMySingleton].unlockNumber] forKey:@"unlockNumber"];
            Winning = [NSString stringWithFormat:@"It took you: %i Moves in %i Seconds!", countmove, thetime];
          countmove = 0;
            thetime = 0;
            if (timer != nil) {
                countmove = 0;
                thetime = 0;
                [timer invalidate];
                timer = nil;
                NSString *timeString = stime;
                timeString = [timeString stringByReplacingOccurrencesOfString:@"m" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"s" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@":" withString:@"."];
                timeString = [timeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                float timefloat = [timeString floatValue];
                for (int i = 0;i <6 ; i++){
                    if (timefloat >= [[Generic sharedMySingleton].startime[i]floatValue ]){
                        [Generic sharedMySingleton].starnumber = i;
                        i=6;
                    }
                }
                float bestTime = [[Generic sharedMySingleton].bestTimeArray[stagenumber] floatValue];
                if (bestTime == 0.00)
                {
                    [Generic sharedMySingleton].bestTimeArray[stagenumber] = timeString;
                   
                }else{
                    
                    if (timefloat < bestTime) {
                        [Generic sharedMySingleton].bestTimeArray[stagenumber] = timeString;
                      
                    }
                }
                [[Generic sharedMySingleton].prefs setObject:[Generic sharedMySingleton].bestTimeArray forKey:@"bestTimeArray"];
                CompletedViewController *catogery = [self.storyboard instantiateViewControllerWithIdentifier:@"LevelCompleted"];
                catogery.levelnum = stagenumber;
                catogery.stimevalue = stime;
                
                [self.navigationController pushViewController:catogery animated:YES];
                }
		}
	}
}

- (void)onTimer {
    if (timer != nil) {
    stime = [NSString stringWithFormat:@"%02im:%02is", thetime/60, thetime%60];
    timeLabel.text = stime;
    thetime++;
    }
//    }else{
//        thetime = 0;
//    }
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

- (void)flipsideViewControllerDidFinish:(SelectstageViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Perform Settings Changes to the Main View
    switch ([prefs integerForKey:@"PuzzleLayoutX"]) {
        case 0:
            NUM_HORIZONTAL_PIECES = 2;
            break;
        case 1:
            NUM_HORIZONTAL_PIECES = 3;
            break;
        case 2:
            NUM_HORIZONTAL_PIECES = 4;
            break;
        case 3:
            NUM_HORIZONTAL_PIECES = 5;
            break;
        default:
            break;
    }
    
    switch ([prefs integerForKey:@"PuzzleLayoutY"]) {
        case 0:
            NUM_VERTICAL_PIECES = 2;
            break;
        case 1:
            NUM_VERTICAL_PIECES = 3;
            break;
        case 2:
            NUM_VERTICAL_PIECES = 4;
            break;
        case 3:
            NUM_VERTICAL_PIECES = 5;
            break;
        default:
            break;
    }
    
    if ([prefs boolForKey:@"Refresh"] == TRUE) {
        countmove = 0;
        thetime = 0;
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
       Pic = [NSString stringWithFormat:@"%@",[Generic sharedMySingleton].imagelist[stagenumber]];
        [self initPuzzle:Pic];
    }
}

- (IBAction)showInfo:(id)sender
{
    [timer invalidate];
    timer = nil;
    thetime = 0;
    countmove = 0;
    SelectstageViewController *catogery = [self.storyboard instantiateViewControllerWithIdentifier:@"selectstage"];
    [self.navigationController pushViewController:catogery animated:YES];
//    SliderPuzzleFlipsideViewController *controller = [[[SliderPuzzleFlipsideViewController alloc] initWithNibName:@"SliderPuzzleFlipsideViewController" bundle:nil] autorelease];
//    controller.delegate = self;
//    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentModalViewController:controller animated:YES];
}

@end