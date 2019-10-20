

#import <UIKit/UIKit.h>
#import "CustomCellCell.h"
#import "Generic.h"
#import "Parser.h"
@interface XmlParserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *table;
    Parser *parser;
}
@property(nonatomic,retain)NSMutableArray *factsArray;
@property(nonatomic)int fileNumber,factsNumber;
@property(nonatomic,retain)IBOutlet UITableView *table;
@end
