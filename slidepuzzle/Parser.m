

#import "Parser.h"



@implementation Row
@synthesize data,description;
@end

@implementation Parser
@synthesize currentelement,data,description,contentArray;


-(void)initParser:(NSString *)datas{
  storingCharacters = NO;
  contentArray = [[NSMutableArray alloc]init];
  currentelement = [[NSMutableString alloc]init];
  NSXMLParser *xmlparser = [[NSXMLParser alloc]initWithData:[datas dataUsingEncoding:NSUTF8StringEncoding]];
  [xmlparser setDelegate:self];
  worked = [xmlparser parse];
  if (worked) {
    NSLog(@"sucess");
     
  }else{
    NSLog(@"Error");
  }
  self.currentelement = nil;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"DATA"]) {
    }else if ([elementName isEqualToString:@"Description"]) {
        [currentelement setString:@""];
        storingCharacters = YES;
    }    
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(!currentelement)
    {
        currentelement =[[NSMutableString alloc]initWithString:string];
         
    }
    else
    {
        [currentelement appendString:string];
      
    }
   
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"DATA"]) {
    }else if ([elementName isEqualToString:@"Description"]) {
        description = [[NSString alloc]initWithString:currentelement];
        [contentArray addObject:description];
           }     storingCharacters = NO;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString *error=[NSString stringWithFormat:@"Error %i, Description: %@, Line: %i, Column: %i",
					 [parseError code],
					 [[parser parserError] localizedDescription],
					 [parser lineNumber],
					 [parser columnNumber]];
	
	NSLog(@"%@",error);
}

















@end
