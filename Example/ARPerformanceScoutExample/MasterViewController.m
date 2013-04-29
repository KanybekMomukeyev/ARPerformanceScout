//
//  MasterViewController.m
//  ARPerformanceScoutExample
//
// Copyright (c) 2013 Artsy (http://artsy.net/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "ARPerformanceScout.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    
    ARpS_startTimer();
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    NSDate *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
    
    /**
     
        ⊛ ARPerformanceScout ⊛
     
        # Usage example with the ARPerfomanceScout.
        
        - Run the app with a call to `writeSomethingToAFile_blocksTheUI` to see the UI blocking. Remove the call to `ARpS_block()` to see how the UI blocking becomes harder to see.
        - Run the app with a call to `writeSomethingToAFile_improvedToNotBlockTheUI` to see the work being dispatched on a background thread.
     
     */
    
    ARpS_measure(^{
        [self writeSomethingToAFile_blocksTheUI];
    });
    
    
    ARpS_measure(^{
       [self writeSomethingToAFile_improvedToNotBlockTheUI];
    });
}

/**
 This is a method that demonstrates a real-world use of ARPerformanceScout.
 
 
 The call to `fileExistsAtPath:` blocks the UI;
 But since the work being done is less than 60ms, it is hard to see;
 To find out quickly whether that is the case or not, call `ARpS_blockThread()`.
 */

- (void)writeSomethingToAFile_blocksTheUI {
    NSString *content = @"⊛ Hello, performance scout! ⊛";
    NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *documentsDirectory =[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
    NSString *fileName = @"hello_scout_blocking.txt";
    NSString *fullPath = [documentsDirectory stringByAppendingPathExtension:fileName];
    
    [[NSFileManager defaultManager] createFileAtPath:fullPath
                                            contents:fileContents
                                          attributes:nil];
    
    /**
        This is the UI-blocking call to `fileExistsAtPath:`.
     */
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:nil];
    if (fileExists) {
    }
    
    ARpS_blockThread(2);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"⊛ ARPerformanceScout ⊛" message:@"Finished work on the main thread" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

/**
 This method is the improved version of `writeSomethingToAFile_blocksTheUI`.
 
 The `fileExistsAtPath:` method is being run on a background thread so it doesn't block the UI.
 When the work is done, it shows an alert view on the main thread.
 */

- (void)writeSomethingToAFile_improvedToNotBlockTheUI {
    NSString *content = @"⊛ Hello, performance scout! ⊛";
    NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *documentsDirectory =[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
    NSString *fileName = @"hello_scout_non_blocking.txt";
    NSString *fullPath = [documentsDirectory stringByAppendingPathExtension:fileName];
    
    [[NSFileManager defaultManager] createFileAtPath:fullPath
                                            contents:fileContents
                                          attributes:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ARpS_blockThread(2);
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:nil];
        if (fileExists) {
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"⊛ ARPerformanceScout ⊛" message:@"Finished work on a background thread" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        });
    });
}

@end
