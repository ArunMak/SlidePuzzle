

#import "SelectstageViewController.h"
#import "Tile.h"
#import "Generic.h"

typedef enum {
	NONE			= 0,
	UP				= 1,
	DOWN			= 2, 
	LEFT			= 3,
	RIGHT			= 4
} ShuffleMove;

@interface SliderPuzzleMainViewController : UIViewController  {
    CGFloat tileWidth; 
	CGFloat tileHeight;
	
	NSMutableArray *tiles; 
	CGPoint blankPosition; 
    
    NSTimer *timer;
    int stagenumber,countmove,thetime;
    NSString *stime;
    NSString *Pic;
    Tile *tileImageView;
    UIImageView *hintImageview;
    int NUM_HORIZONTAL_PIECES,NUM_VERTICAL_PIECES;
}
@property (strong, nonatomic) IBOutlet UILabel *bestTimeLabel;

- (IBAction)showInfo:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *gameView;
@property(nonatomic)int stagenumber;
@property (nonatomic,retain) NSMutableArray *tiles;
@property (nonatomic,retain) Tile *tileImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
-(void) initPuzzle:(NSString *) imagePath;
-(ShuffleMove) validMove:(Tile *) tile;
-(void) movePiece:(Tile *) tile withAnimation:(BOOL) animate;
-(void) movePiece:(Tile *) tile inDirectionX:(NSInteger) dx inDirectionY:(NSInteger) dy withAnimation:(BOOL) animate;
-(void) shuffle;

-(Tile *) getPieceAtPoint:(CGPoint) point;
-(BOOL) puzzleCompleted;

- (IBAction)HintButtonAction:(id)sender;
- (IBAction)ShowHintButtonAction:(id)sender;

@end
