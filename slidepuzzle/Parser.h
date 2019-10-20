

#import <Foundation/Foundation.h>

@interface Parser : NSObject<NSXMLParserDelegate>
{

    NSMutableString *currentelement;
    NSString *data,*description;
    NSMutableArray *contentArray;
    BOOL worked,storingCharacters;
    int index;
}
@property(nonatomic,retain) NSMutableString *currentelement;
@property(nonatomic,retain)NSString *data,*description;
@property(nonatomic,retain) NSMutableArray *contentArray;
-(void)initParser:(NSString *)data;
@end














@interface Row : NSObject
{}
@property(nonatomic,retain)NSString *data,*description;
@end
