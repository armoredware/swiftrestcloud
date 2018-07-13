//
//  PagesViewController.swift
//  ARMOREDWARE Web Security Scan
//
//  Created by Michael DeBiase on 3/25/18.
//  Copyright © 2018 ARMOREDWARE. All rights reserved.
//

import UIKit

class PagesViewController: UIViewController {
    
    var token1: String!
    var site_url: String!
    var page_uri: String!
    var pageArray = ["Loading..."]
    
    @IBOutlet weak var pagesTableView: UITableView!
    

    /*override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Token:", token1)
        print("Site:",site_url)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newLayer = CAGradientLayer()
        //newLayer.colors = [UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.colors = [UIColor.black.cgColor, UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor(red:169/255.0, green:80/255.0, blue: 186/255.0, alpha: 1.0).cgColor,   UIColor(red:113/255.0, green:202/255.0, blue: 252/255.0, alpha: 1.0).cgColor, UIColor(red:60/255.0, green:92/255.0, blue: 254/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)
        // Do any additional setup after loading the view.
        print("Token:", token1)
        print("Site:",site_url)
        self.pagesTableView.dataSource = self
        self.pagesTableView.delegate = self
    }

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
extension PagesViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pageCell")!
        cell.textLabel?.text = self.pageArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Tapped ",pageArray[indexPath.row])
        page_uri = pageArray[indexPath.row]
        self.performSegue(withIdentifier: "pageinfo", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let destination = segue.destination as? PageInfoViewController else {return}
        destination.token1 = token1
        destination.site_url = site_url
        destination.page_uri = page_uri
        
    }
}


