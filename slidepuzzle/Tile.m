

#import "Tile.h"

@implementation Tile

@synthesize originalPosition;
@synthesize currentPosition;

- (void) dealloc
{
	[self removeFromSuperview];
	
}


@end
