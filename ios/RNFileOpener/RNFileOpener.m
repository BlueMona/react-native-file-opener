#import "RNFileOpener.h"

@implementation FileOpener
NSURL *fileURL;
@synthesize bridge = _bridge;
RCTPromiseResolveBlock currentResolver = nil;
QLPreviewController *previewController = nil;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [NSURL fileURLWithPath:fileURL.path];
}

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(open, filePath:(NSString *)filePath fileMine:(NSString *)fileMine
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    if (currentResolver != nil) {
        NSLog(@"Preview still opened");
        currentResolver(@"completed prematurely");
    }
    currentResolver = resolve;
    fileURL = [NSURL fileURLWithPath:filePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:fileURL.path]) {
        NSError *error = [NSError errorWithDomain:@"File not found" code:404 userInfo:nil];
        reject(@"File not found", @"File not found", error);
        return;
    }
   
    previewController=[[QLPreviewController alloc]init];
    previewController.delegate=self;
    previewController.dataSource=self;
    previewController.currentPreviewItemIndex = 0;
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl presentViewController:previewController
        animated:YES
        completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    ];
    [previewController.navigationItem setRightBarButtonItem:nil];
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    if (controller != previewController) return;
    if (currentResolver != nil) currentResolver(@"completed");
    currentResolver = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
