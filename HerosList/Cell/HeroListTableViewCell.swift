//
//  HeroListTableViewCell.swift
//  Heros
//
//  Created by rivki glick on 02/05/2021.
//

import UIKit

class HeroListTableViewCell: UITableViewCell {
    
    
    // MARK: - Properties
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var heroImg: UIImageView!

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Set up
    
    func setImg(hero:Hero){
        
        let posterURL = URL(string:hero.image)
        
        heroImg.kf.indicatorType = .activity
        heroImg.kf.setImage(
            with: posterURL,
            options: [.transition(.fade(0.5)),
                      .diskCacheExpiration(.days(1))]
        )
        nameLbl.text = hero.name
        
    }

}
