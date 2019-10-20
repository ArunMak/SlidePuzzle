

#import <UIKit/UIKit.h>
#import "Tile.h"
#import "Generic.h"
#import "SelectgameViewController.h"
typedef enum {
	NONE			= 0,
	UP				= 1,
	DOWN			= 2,
	LEFT			= 3,
	RIGHT			= 4
} ShuffleMove;
@interface FunSlideViewController : UIViewController{
CGFloat tileWidth;
CGFloat tileHeight;

NSMutableArray *tiles;
CGPoint blankPosition;
NSString *stime;
NSTimer *timer;
int stagenumber;
UIImageView *hintImageview;
Tile *tileImageView;
}
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIView *slideView;
@property(nonatomic,retain)UIImage *puzzleImage;
- (IBAction)showInfo:(id)sender;
@property(nonatomic)int stagenumber;
@property (nonatomic,retain) NSMutableArray *tiles;
@property (nonatomic,retain) Tile *tileImageView;

-(void) initPuzzle:(UIImage*) imagePath;

-(ShuffleMove) validMove:(Tile *) tile;
-(void) movePiece:(Tile *) tile withAnimation:(BOOL) animate;
-(void) movePiece:(Tile *) tile inDirectionX:(NSInteger) dx inDirectionY:(NSInteger) dy withAnimation:(BOOL) animate;
-(void) shuffle;

-(Tile *) getPieceAtPoint:(CGPoint) point;
-(BOOL) puzzleCompleted;
- (IBAction)HintButtonAction:(id)sender;
- (IBAction)ShowHintButtonAction:(id)sender;
@end
