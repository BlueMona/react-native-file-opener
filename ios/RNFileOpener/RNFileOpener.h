#if __has_include(<React/RCTBridgeModule.h>)
  #import <React/RCTBridgeModule.h>
#else
  #import "RCTBridgeModule.h"
#endif
#import "RCTBridge.h"
#import "QuickLook/QuickLook.h"

@import UIKit;

@interface FileOpener : NSObject <RCTBridgeModule,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (nonatomic) UIDocumentInteractionController * FileOpener;
@end
