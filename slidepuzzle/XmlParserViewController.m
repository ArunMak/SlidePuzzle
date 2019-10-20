

#import "XmlParserViewController.h"
#import "Parser.h"
@interface XmlParserViewController ()

@end

@implementation XmlParserViewController
@synthesize table,factsNumber,fileNumber,factsArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"file number is %d",fileNumber);
    NSString *sPath = [[NSBundle mainBundle]pathForResource:[Generic sharedMySingleton].xmlArray[fileNumber] ofType:@"xml"];
    NSData *data=[NSData dataWithContentsOfFile:sPath];
    NSString *sfilePath = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    parser = [[Parser alloc]init];
    [parser initParser:sfilePath];
    
	// Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return factsNumber ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [parser.contentArray objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"9CORODED.TTF" size:10]];
    cell.textLabel.numberOfLines = 9;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  150;
}


#pragma mark - Table view delegate


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
