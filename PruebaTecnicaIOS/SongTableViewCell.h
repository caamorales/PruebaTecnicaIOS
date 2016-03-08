//
//  SongTableViewCell.h
//  PruebaTecnicaIOS
//
//  Created by Camilo Morales on 8/3/16.
//  Copyright © 2016 SlashMobility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionCensoredNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end
