#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "QuickLook/QuickLook.h"

@import UIKit;

@interface FileOpener : NSObject <RCTBridgeModule,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (nonatomic) UIDocumentInteractionController * FileOpener;
@end
