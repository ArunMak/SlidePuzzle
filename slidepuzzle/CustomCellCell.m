
#import "CustomCellCell.h"

@implementation CustomCellCell
@synthesize stageLabel,countryLabel,ratingImageview,ratingLabel,revealedLabel,bestTimeLabel,primaryLabel,secondaryLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ratingImageview = [[UIImageView alloc]init];
        stageLabel = [[UILabel alloc]init];
         primaryLabel = [[UILabel alloc]init];
         secondaryLabel = [[UILabel alloc]init];
        countryLabel = [[UILabel alloc]init];
         ratingLabel = [[UILabel alloc]init];
         revealedLabel = [[UILabel alloc]init];
         bestTimeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:ratingImageview];
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:stageLabel];
        [self.contentView addSubview:countryLabel];
        [self.contentView addSubview:ratingLabel];
        [self.contentView addSubview:revealedLabel];
        [self.contentView addSubview:bestTimeLabel];
        [self.contentView addSubview:secondaryLabel];
        
        
           }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame;
    frame= CGRectMake(8,10,80,20);
    stageLabel.frame = frame;
    [stageLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    frame= CGRectMake(8,40,80,20);
    primaryLabel.frame = frame;
    [primaryLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    frame= CGRectMake(8,70,80,20);
    secondaryLabel.frame = frame;
    [secondaryLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    frame= CGRectMake(8,100,80,20);
    ratingLabel.frame = frame;
    [ratingLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    frame= CGRectMake(125,10,150,20);
    countryLabel.frame = frame;
    [countryLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    frame= CGRectMake(125,70,80,20);
    revealedLabel.frame = frame;
    [revealedLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    frame= CGRectMake(125,100,80,20);
    bestTimeLabel.frame = frame;
    [bestTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    frame= CGRectMake(125,40,100,20);
    ratingImageview.frame = frame;
    
      }


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
