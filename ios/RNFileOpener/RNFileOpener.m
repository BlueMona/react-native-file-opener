#import "RNFileOpener.h"

@implementation FileOpener
NSURL *fileURL;
@synthesize bridge = _bridge;

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
    
    fileURL = [NSURL fileURLWithPath:filePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:fileURL.path]) {
        NSError *error = [NSError errorWithDomain:@"File not found" code:404 userInfo:nil];
        reject(@"File not found", @"File not found", error);
        return;
    }
   
    QLPreviewController *previewController=[[QLPreviewController alloc]init];
    previewController.delegate=self;
    previewController.dataSource=self;
    previewController.currentPreviewItemIndex = 0;

    
   // self.FileOpener = [UIDocumentInteractionController interactionControllerWithURL:self.fileURL];
    // self.FileOpener.delegate = self;
    
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [ctrl presentModalViewController:previewController animated:YES];
    [previewController.navigationItem setRightBarButtonItem:nil];
    
    // BOOL wasOpened = [self.FileOpener presentOptionsMenuFromRect:ctrl.view.bounds inView:ctrl.view animated:YES];
    // BOOL wasOpened = [self.FileOpener presentPreviewAnimated:YES];
    
    resolve(@"completed");
/*    if (wasOpened) {
        resolve(@"Open success!!");
    } else {
        NSError *error = [NSError errorWithDomain:@"Open error" code:500 userInfo:nil];
        reject(@"Open error", @"Open error", error);
    } */
    
}

@end
