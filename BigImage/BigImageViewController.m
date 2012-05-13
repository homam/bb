//
//  BigImageViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BigImageViewController.h"

@interface BigImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BigImageViewController
@synthesize imageView;
@synthesize scrollView;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    scrollView.pagingEnabled = YES;
    CGSize scrollViewSize = CGSizeMake(2000, 1000);
    self.scrollView.contentSize = scrollViewSize;
    //self.scrollView.contentSize = self.imageView.image.size;
    //self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    UILabel *lb = [[UILabel alloc] init];
    lb.text = @"hahhaha!";
    [scrollView addSubview:lb];
    lb.frame = CGRectMake(0, 0, 300, 100);
    
    NSLog(@"scrollView.contentSize = %@", NSStringFromCGSize(scrollView.contentSize));

}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"page = %i",page);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
