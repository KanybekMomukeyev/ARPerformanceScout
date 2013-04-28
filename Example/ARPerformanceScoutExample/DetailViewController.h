//
//  DetailViewController.h
//  ARPerformanceScoutExample
//
//  Created by Claudiu-Vlad Ursache on 28.04.13.
//  Copyright (c) 2013 Artsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
