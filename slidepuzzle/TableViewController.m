

#import "TableViewController.h"
#import "NSObject+alertMsg.h"
#import "XmlParserViewController.h"
@interface TableViewController ()

@end

@implementation TableViewController
@synthesize table,countryArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    countryArray = [[NSMutableArray alloc]initWithObjects:@"India",@"Afghanistan",@"NewZealand",@"Australia",@"Bangladesh",@"Brazil",@"Canda",@"Norway",@"Iran",@"Somalia",@"USA",@"Israel", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [countryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCellCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.userInteractionEnabled = YES;
    if(cell==nil){
        cell = [[CustomCellCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.stageLabel.text = [NSString stringWithFormat:@"STAGE%d",indexPath.row+1];
    cell.countryLabel.text = [countryArray objectAtIndex:indexPath.row];
    cell.primaryLabel.text = @"Revealed";
    cell.secondaryLabel.text = @"BestTime";
    cell.ratingLabel.text=@"Rating";
            NSLog(@"besttime value is %f",[[Generic sharedMySingleton].bestTimeArray[indexPath.row]floatValue]);
    if ([[Generic sharedMySingleton].bestTimeArray[indexPath.row] floatValue] == 0.0) {
       cell.bestTimeLabel.text = @"-";
       cell.revealedLabel.text = @"-";
      
    }else{

        for (int i = 0;i <6 ; i++){
           if ([[Generic sharedMySingleton].bestTimeArray[indexPath.row]floatValue] >= [[Generic sharedMySingleton].startime[i] floatValue]){
            revealedNumber = i;
                i=6;
            }
        }
        cell.revealedLabel.text = [NSString stringWithFormat:@"%d / 25",revealedNumber*5];
        cell.bestTimeLabel.text = [[Generic sharedMySingleton].bestTimeArray objectAtIndex:indexPath.row];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
 return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return  122;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int noofstars;
    if (indexPath.row < [Generic sharedMySingleton].unlockNumber) {
        XmlParserViewController *catogery = [self.storyboard instantiateViewControllerWithIdentifier:@"XmlParser"];
        
        NSLog(@"revelad number is %d",revealedNumber*5);
        catogery.fileNumber = indexPath.row;
        for (int i = 0;i <6 ; i++){
            if ([[Generic sharedMySingleton].bestTimeArray[indexPath.row]floatValue] >= [[Generic sharedMySingleton].startime[i] floatValue]){
               noofstars= i;
                i=6;
            }
        }
        if (noofstars == 0) {
            [self showAlert:@"Not Unlocked any facts"];
            }else{
            catogery.factsNumber = noofstars*5;
            [self.navigationController pushViewController:catogery animated:YES];
            }
    }else{
        [self showAlert:@"Not Yet Revealed"];
    }
    


}

@end
