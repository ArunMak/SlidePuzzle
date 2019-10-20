

#import "Generic.h"
@implementation Generic
@synthesize levelnumber,imagelist,starnumber,horizontalslice,verticalslice,startime,xmlStarArray,bestTimeArray,coinArray,xmlArray,unlockNumber,prefs;
static Generic* _sharedGeneric = nil;
+(Generic*)sharedMySingleton
{
	@synchronized([Generic class])
	{
		if (!_sharedGeneric){
			[[self alloc] init];
            
        }
		return _sharedGeneric;
	}
	return nil;
}
+(id)alloc
{
	@synchronized([Generic class])
	{
		NSAssert(_sharedGeneric == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedGeneric = [super alloc];
		return _sharedGeneric;
	}
    
	return nil;
}
-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
       
         imagelist = [[NSMutableArray alloc]init];
        prefs = [NSUserDefaults standardUserDefaults];
        [prefs synchronize];
        unlockNumber = [[prefs objectForKey:@"unlockNumber"]integerValue];
        if ([[UIScreen mainScreen]bounds].size.height == 568) {
            [imagelist addObject:@"one1.jpg"];
            [imagelist addObject:@"two1.jpg"];
            [imagelist addObject:@"three1.jpg"];
            [imagelist addObject:@"four1.jpg"];
            [imagelist addObject:@"five1.jpg"];
            [imagelist addObject:@"six1.jpg"];
            [imagelist addObject:@"seven1.jpg"];
            [imagelist addObject:@"eight1.jpg"];
            [imagelist addObject:@"nine1.jpg"];
            [imagelist addObject:@"ten1.jpg"];
            [imagelist addObject:@"eleven1.jpg"];
            [imagelist addObject:@"twelve1.jpg"];
            }else{
            [imagelist addObject:@"one.jpg"];
            [imagelist addObject:@"two.jpg"];
            [imagelist addObject:@"three.jpg"];
            [imagelist addObject:@"four.jpg"];
            [imagelist addObject:@"five.jpg"];
            [imagelist addObject:@"six.jpg"];
            [imagelist addObject:@"seven.jpg"];
            [imagelist addObject:@"eight.jpg"];
            [imagelist addObject:@"nine.jpg"];
            [imagelist addObject:@"ten.jpg"];
            [imagelist addObject:@"eleven.jpg"];
            [imagelist addObject:@"twelve.jpg"];
        }
        xmlArray = [[NSMutableArray alloc]initWithObjects:@"onedet",@"twodet",@"threedet",@"fourdet",@"fivedet",@"sixdet",@"sevendet",@"eightdet",@"ninedet",@"tendet",@"elevendet",@"twelvedet", nil];
        horizontalslice = [[NSMutableArray alloc]initWithObjects:@"3",@"3",@"3",@"4",@"4",@"4",@"5",@"5",@"5",@"6",@"6",@"6", nil];
        verticalslice = [[NSMutableArray alloc]initWithObjects:@"3",@"3",@"3",@"4",@"4",@"4",@"5",@"5",@"5",@"6",@"6",@"6", nil];
        startime = [[NSMutableArray alloc]initWithObjects:@"5.0",@"4.00",@"2.25",@"1.25",@"0.25",@"0.00" ,nil];
        xmlStarArray = [[NSMutableArray alloc]init];
        coinArray = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        bestTimeArray = [[NSMutableArray alloc]initWithObjects:@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00",@"0.00", nil];
        NSArray *arrayObj = [[NSArray alloc]init];
        arrayObj = [prefs objectForKey:@"bestTimeArray"];
        if (arrayObj == NULL)
        {}else{
            bestTimeArray = [NSMutableArray arrayWithArray:arrayObj];
        }
        
       	}
	return self;
}

@end
