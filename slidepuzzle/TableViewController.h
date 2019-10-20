

#import <UIKit/UIKit.h>
#import "CustomCellCell.h"
#import "Generic.h"
@interface TableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *table;
    int revealedNumber;
    
}
@property(nonatomic,retain)NSMutableArray *countryArray;
@property(nonatomic,retain)IBOutlet UITableView *table;
@end
