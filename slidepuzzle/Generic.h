
#import <UIKit/UIKit.h>


@interface Generic : NSObject
{
    NSUserDefaults *prefs ;
     int levelnumber,unlockNumber;
    NSMutableArray *imagelist,*horizontalslice,*verticalslice,*startime,*xmlStarArray,*bestTimeArray,*coinArray;

    
}

@property(nonatomic,retain) NSUserDefaults *prefs ;
@property(nonatomic)int starnumber,levelnumber,unlockNumber;
@property(nonatomic,retain)NSMutableArray *imagelist,*horizontalslice,*verticalslice,*startime,*xmlStarArray,*bestTimeArray,*coinArray,*xmlArray;

+(Generic*)sharedMySingleton;

@end
