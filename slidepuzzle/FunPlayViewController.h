

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
@class FunPlayViewController;
@protocol FunplayViewdelegate
-(void)flipsideViewControllerDidFinish:(FunPlayViewController *)controller;
@end
@interface FunPlayViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImagePickerController *imgPicker;
    UIImage *selectedImage,*capturedImage;
    

}
@property(nonatomic,retain)UIImage *selectedImage,*capturedImage;
- (IBAction)CameraButtonAction:(id)sender;
- (IBAction)GalleryButtonAction:(id)sender;
- (IBAction)SettingsButtonAction:(id)sender;
- (IBAction)PointsButtonAction:(id)sender;


@end
