

#import <Foundation/Foundation.h>

@interface Tile : UIImageView {
    
	CGPoint originalPosition; 
	CGPoint currentPosition; 
}

@property (nonatomic,readwrite) CGPoint originalPosition;
@property (nonatomic,readwrite) CGPoint currentPosition;

@end
