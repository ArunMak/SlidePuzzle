
#import <UIKit/UIKit.h>

@interface CustomCellCell : UITableViewCell{
    UILabel *stageLabel,*countryLabel,*ratingLabel,*revealedLabel,*bestTimeLabel,*primaryLabel,*secondaryLabel;
    
    UIImageView *ratingImageview;
}

@property(nonatomic,retain)UILabel *stageLabel,*countryLabel,*ratingLabel,*revealedLabel,*bestTimeLabel,*primaryLabel,*secondaryLabel;
@property(nonatomic,retain)UIImageView *ratingImageview;
@end
