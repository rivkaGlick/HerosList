//
//  HeroDetailsViewController.swift
//  Heros
//
//  Created by rivki glick on 30/04/2021.
//

import UIKit
import Foundation
import Kingfisher


class HeroDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var hero = Hero()
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var heroImg: UIImageView!
    @IBOutlet var biographyTxtView: UITextView!
    
    @IBOutlet var workTxtView: UITextView!
    @IBOutlet var connectionsView: UIView!
    @IBOutlet var connectionsTxtView: UITextView!
    @IBOutlet var powerstatsTxtView: UITextView!
    
    @IBOutlet var scrollView: UIScrollView!

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: 1240, height: scrollView.frame.height)

    }
    
    // MARK: Setup UI with the data
    func setInfo()  {
        nameLbl.text = hero.name
        
        let url = URL(string: hero.image)
        
        
        heroImg.kf.indicatorType = .activity
        heroImg.kf.setImage(
            with: url,
            options: [.transition(.fade(0.2)),
                      .diskCacheExpiration(.days(1))]
        )
        
        biographyTxtView.text = String(format: "Biography\nAlignment: %@\nAlter-egos: %@\nFirst-appearance: %@\nFull-name: %@",hero.biography.alignment,hero.biography.alter_egos,hero.biography.first_appearance,hero.biography.full_name)
        
        workTxtView.text = String(format: "Work\n base: %@\noccupation: %@",hero.work.base,hero.work.occupation)
        
        powerstatsTxtView.text = String(format: "Powerstats \ncombat: %@\ndurability: %@\nintelligence: %@\npower: %@\nspeed: %@\nstrength: %@",hero.powerstats.combat,hero.powerstats.durability,hero.powerstats.intelligence,hero.powerstats.power,hero.powerstats.speed,hero.powerstats.strength)
        
        connectionsTxtView.text = String(format: "Connections\n group-affiliation: %@\nrelatives: %@",hero.connections.group_affiliation,hero.connections.relatives)
        
    }
    
    // MARK: Action
    @IBAction func sharBtnClick(_ sender: Any) {
        let shareText = "Full name:" +  hero.biography.full_name + "\nAlter egos:"  + hero.biography.alter_egos

        let url = URL(string: hero.image)
        let data = try? Data(contentsOf: url!)
        
        if let image =  UIImage(data: data!) {
        let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
            present(vc, animated: true)
        }
    }


}
