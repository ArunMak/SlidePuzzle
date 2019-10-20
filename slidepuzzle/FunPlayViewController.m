

#import "FunPlayViewController.h"
#import "NSObject+alertMsg.h"
#import "FunSlideViewController.h"
@interface FunPlayViewController ()

@end

@implementation FunPlayViewController
@synthesize selectedImage,capturedImage;
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
    imgPicker = [[UIImagePickerController alloc]init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CameraButtonAction:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imgPicker.allowsEditing = YES;
        imgPicker.showsCameraControls = YES;
        [self presentViewController:imgPicker
                           animated:YES completion:nil];
       
    }

}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
               
     selectedImage = capturedImage;
    UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    FunSlideViewController *catogery = [self.storyboard instantiateViewControllerWithIdentifier:@"Funslide"];
    catogery.puzzleImage =selectedImage;
    [self.navigationController pushViewController:catogery animated:YES];
    
}
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error){
        [self showAlert:@"Failed to save image"];
    }
}
//-(void)saveimage{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"profilepic.png"];
//    UIImage *image = selectedImage;
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [imageData writeToFile:savedImagePath atomically:YES];
//    
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath];
//    if (fileExists)
//    {
//        
//    }
//    
//}

- (IBAction)GalleryButtonAction:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
        imgPicker.delegate = self;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}

- (IBAction)SettingsButtonAction:(id)sender {
}

- (IBAction)PointsButtonAction:(id)sender {
}
- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end
