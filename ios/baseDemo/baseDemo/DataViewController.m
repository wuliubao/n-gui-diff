//
//  DataViewController.m
//  baseDemo
//
//  Created by aos on 2019/1/3.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import "DataViewController.h"
#import "itemData.h"

@interface DataViewController ()
@property NSMutableArray *itemArr;
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    
    ItemData *item1 = [ItemData initWithPhoto:@"photos.png" Name:@"first1" Data:@"2019.1.3"];
    ItemData *item2 = [ItemData initWithPhoto:@"photos.png" Name:@"first2" Data:@"2019.1.3"];
    ItemData *item3 = [ItemData initWithPhoto:@"photos.png" Name:@"first3" Data:@"2019.1.3"];
    ItemData *item4 = [ItemData initWithPhoto:@"photos.png" Name:@"first4" Data:@"2019.1.3"];
    ItemData *item5 = [ItemData initWithPhoto:@"photos.png" Name:@"first5" Data:@"2019.1.3"];
    ItemData *item6 = [ItemData initWithPhoto:@"photos.png" Name:@"first6" Data:@"2019.1.3"];
    ItemData *item7 = [ItemData initWithPhoto:@"photos.png" Name:@"first7" Data:@"2019.1.3"];
    ItemData *item8 = [ItemData initWithPhoto:@"photos.png" Name:@"first8" Data:@"2019.1.3"];
    
    _itemArr = [[NSMutableArray alloc]initWithObjects:item1,item2,item3,item4,item5,item6,item7,item8, nil];
    
    UITableView *itemTable = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    [itemTable setRowHeight:80];
    [itemTable setSeparatorColor:[UIColor brownColor]];
    UIEdgeInsets inset = itemTable.separatorInset;
    itemTable.separatorInset = UIEdgeInsetsMake(inset.top, 0, inset.bottom, inset.right);
    itemTable.delegate = self;
    itemTable.dataSource = self;
    	
    [self.view addSubview:itemTable];
    
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArr.count;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *home = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (home == nil) {
        home = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    ItemData *item = [_itemArr objectAtIndex:indexPath.row];
    home.imageView.image = [UIImage imageNamed:item.photo];
    
    CGSize itemSize = CGSizeMake(60,60);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [home.imageView.image drawInRect:imageRect];
    home.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsGetCurrentContext();
    
    home.textLabel.text = item.name;
    home.detailTextLabel.text = item.data;
    return home;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}


@end
