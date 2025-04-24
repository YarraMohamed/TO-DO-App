//
//  TableViewCell.h
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UIImageView *taskPhoto;

@end

NS_ASSUME_NONNULL_END
