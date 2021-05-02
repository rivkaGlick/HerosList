//
//  ViewController.swift
//  Heros
//
//  Created by rivki glick on 28/04/2021.
//

import UIKit
import Alamofire
import Foundation
import Kingfisher
import NVActivityIndicatorView



class HerosListController: UIViewController, UITableViewDataSource, UISearchBarDelegate,UITableViewDelegate {
 
    
    // MARK: - Properties
    @IBOutlet var tblview: UITableView!
    @IBOutlet var searchview: UISearchBar!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    var data =  [Hero]()


    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblview.dataSource = self
        tblview.delegate = self
        searchview.delegate = self
        
        searchview.showsScopeBar = true
        searchview.delegate = self
        
        if data.count > 0
        {
            tblview.isHidden = false
        }
        else
        {
            tblview.isHidden = true
        }
        start(id: "245")
        start(id: "246")
        start(id: "247")
    }
    
    func start(id:String)  {
        NetworkManager.shared().getHeroById(id: id) { [self] (hero) in
            if hero is NSDictionary {
//                for hero in (heros as! NSArray) {
                        let heroImg = (hero as! NSDictionary).object(forKey: "image") as! NSDictionary
                        let imgString = (heroImg ).object(forKey: "url")as! String
                        let biographyDic =  (hero as! NSDictionary).object(forKey: "biography") as! NSDictionary
                    let powerstatsDic =  (hero as! NSDictionary).object(forKey: "powerstats") as! NSDictionary
                    let workDic =  (hero as! NSDictionary).object(forKey: "work") as! NSDictionary
                    let connectionsDic =  (hero as! NSDictionary).object(forKey: "connections") as! NSDictionary
                        let biography = Biography(alignment: biographyDic.object(forKey: "alignment") as! String, alter_egos: biographyDic.object(forKey: "alter-egos") as! String, first_appearance: biographyDic.object(forKey: "first-appearance") as! String, full_name: biographyDic.object(forKey: "full-name") as! String)
                    let powerstats = Powerstats(combat: powerstatsDic.object(forKey: "combat") as! String, durability: powerstatsDic.object(forKey: "durability") as! String, intelligence: powerstatsDic.object(forKey: "intelligence") as! String, power: powerstatsDic.object(forKey: "power") as! String, speed: powerstatsDic.object(forKey: "speed") as! String, strength: powerstatsDic.object(forKey: "strength") as! String)
                    let work = Work(base: workDic.object(forKey: "base") as! String, occupation: workDic.object(forKey: "occupation") as! String)
                    let connections = Connections(group_affiliation: connectionsDic.object(forKey: "group-affiliation") as! String, relatives: connectionsDic.object(forKey: "relatives") as! String)
                    
                        let hero = Hero(id: (hero as! NSDictionary).object(forKey: "id") as! String, name: (hero as! NSDictionary).object(forKey: "name") as! String, image: imgString,biography: biography,powerstats: powerstats,work: work,connections: connections)
                        data.append(hero)
                        

//                    }
            }
            else {
                // create the alert
                let alert = UIAlertController(title: "Error", message: (hero as? String), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
      
            if data.count > 0
            {
                tblview.isHidden = false
            }
            else
            {
                tblview.isHidden = true
            }
                tblview.reloadData()
        } error: { [self] (error) in
                indicatorView.stopAnimating()
                print(error as Any)
            }
    }
    
    func setIndicator() {
        indicatorView.color = UIColor.gray
        indicatorView.type = NVActivityIndicatorType.ballRotateChase
    }
    
    // MARK: - UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "HeroListTableViewCell", for: indexPath) as? HeroListTableViewCell {
            cell.setImg(hero: data[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
        let hero = data[indexPath.row]
        let heroDetailsViewController:HeroDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeroDetailsViewController") as! HeroDetailsViewController
        heroDetailsViewController.hero = hero
        self.navigationController?.pushViewController(heroDetailsViewController, animated: true)
       }
    // MARK: Action
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar)
       {
        setIndicator()
        indicatorView.startAnimating()
        NetworkManager.shared().getHerosList(searchText: seachBar.text!) { [self] (heros) in
            if heros is NSArray {
                for hero in (heros as! NSArray) {
                        let heroImg = (hero as! NSDictionary).object(forKey: "image") as! NSDictionary
                        let imgString = (heroImg ).object(forKey: "url")as! String
                        let biographyDic =  (hero as! NSDictionary).object(forKey: "biography") as! NSDictionary
                    let powerstatsDic =  (hero as! NSDictionary).object(forKey: "powerstats") as! NSDictionary
                    let workDic =  (hero as! NSDictionary).object(forKey: "work") as! NSDictionary
                    let connectionsDic =  (hero as! NSDictionary).object(forKey: "connections") as! NSDictionary
                        let biography = Biography(alignment: biographyDic.object(forKey: "alignment") as! String, alter_egos: biographyDic.object(forKey: "alter-egos") as! String, first_appearance: biographyDic.object(forKey: "first-appearance") as! String, full_name: biographyDic.object(forKey: "full-name") as! String)
                    let powerstats = Powerstats(combat: powerstatsDic.object(forKey: "combat") as! String, durability: powerstatsDic.object(forKey: "durability") as! String, intelligence: powerstatsDic.object(forKey: "intelligence") as! String, power: powerstatsDic.object(forKey: "power") as! String, speed: powerstatsDic.object(forKey: "speed") as! String, strength: powerstatsDic.object(forKey: "strength") as! String)
                    let work = Work(base: workDic.object(forKey: "base") as! String, occupation: workDic.object(forKey: "occupation") as! String)
                    let connections = Connections(group_affiliation: connectionsDic.object(forKey: "group-affiliation") as! String, relatives: connectionsDic.object(forKey: "relatives") as! String)
                    
                        let hero = Hero(id: (hero as! NSDictionary).object(forKey: "id") as! String, name: (hero as! NSDictionary).object(forKey: "name") as! String, image: imgString,biography: biography,powerstats: powerstats,work: work,connections: connections)
                        data.append(hero)
                        

                    }
            }
            else {
                // create the alert
                let alert = UIAlertController(title: "Error", message: (heros as? String), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
      
            indicatorView.stopAnimating()
            seachBar.resignFirstResponder()
            if data.count > 0
            {
                tblview.isHidden = false
            }
            else
            {
                tblview.isHidden = true
            }
                tblview.reloadData()
        } error: { [self] (error) in
                indicatorView.stopAnimating()
                print(error as Any)
            }

       }

}

