//
//  RAViewController.m
//  RACollectionViewTripletLayout-Demo
//
//  Created by Ryo Aoyama on 5/25/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//

#import "RAViewController.h"
#import "RACollectionViewCell.h"


@interface RAViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation RAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self setupPhotosArray];
}

- (void)setupPhotosArray
{
    [_photosArray removeAllObjects];
    _photosArray = nil;
    _photosArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 20; i++) {
        NSString *photoName = [NSString stringWithFormat:@"%ld.jpg",i];
        UIImage *photo = [UIImage imageNamed:photoName];
        [_photosArray addObject:photo];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1; //Sorry, has not supported sections two or more.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photosArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5.f, 0, 5.f, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForLargeItemsInSection:(NSInteger)section
{
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    UIImage *image = [_photosArray objectAtIndex:fromIndexPath.item];
    [_photosArray removeObjectAtIndex:fromIndexPath.item];
    [_photosArray insertObject:image atIndex:toIndexPath.item];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    RACollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    [cell.imageView removeFromSuperview];
    cell.imageView.frame = cell.bounds;
    cell.imageView.image = _photosArray[indexPath.item];
    [cell.contentView addSubview:cell.imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_photosArray.count == 1) {
        return;
    }
    [self.collectionView performBatchUpdates:^{
        [_photosArray removeObjectAtIndex:indexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

- (IBAction)reflesh:(UIBarButtonItem *)sender
{
    [self setupPhotosArray];
    [self.collectionView reloadData];
}


@end
