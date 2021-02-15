//
//  LinksTableViewCell.h
//  Dapi Task
//
//  Created by Antoun on 15/02/2021.
//  Copyright © 2021 Antoun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;

@property (weak, nonatomic) IBOutlet UILabel *labelLink;

@property (weak, nonatomic) IBOutlet UILabel *labelSize;

- (void)setDetails:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
