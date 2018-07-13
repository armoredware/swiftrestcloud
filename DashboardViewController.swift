//
//  DashboardViewController.swift
//  ARMOREDWARE Web Security Scan
//
//  Created by Michael DeBiase on 3/25/18.
//  Copyright © 2018 ARMOREDWARE. All rights reserved.
//

import UIKit



class DashboardViewController: UIViewController {
    
    struct Dashboard: Codable {
        var user_id: String
        var sites: [String]
    }
    
    var sites: [String]!
    var site_url: String!
    var siteArray = ["Please Add Sites"]
  
    @IBOutlet weak var token: UILabel!
    @IBOutlet weak var dashboardTableView: UITableView!
    
    var token1: String!
    
    
    @IBAction func addNewSite(_ sender: Any) {
         performSegue(withIdentifier: "addSite", sender: self)
    }
    
    
    @IBAction func site(_ sender: Any) {
        performSegue(withIdentifier: "site", sender: self)
    }
    
    
    @IBAction func settings(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newLayer = CAGradientLayer()
        //newLayer.colors = [UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.colors = [UIColor.black.cgColor, UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor(red:169/255.0, green:80/255.0, blue: 186/255.0, alpha: 1.0).cgColor,   UIColor(red:113/255.0, green:202/255.0, blue: 252/255.0, alpha: 1.0).cgColor, UIColor(red:60/255.0, green:92/255.0, blue: 254/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)
        
        
        token.text = token1
        print("Token",token1)
        // Do any additional setup after loading the view.
        guard let url = URL(string: "https://armoredware.com/sites/get_sites") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT \(self.token1!)", forHTTPHeaderField: "Authorization")
        //let postDictionary = ["Authorization": "JWT \(self.token1!)"]
        //let postDictionary = ["": ""]
        
       
        //print(postDictionary)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request){ (data, _, _) in
            guard let data = data else { return }
            do{
                
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
                let aData = try JSONDecoder().decode(Dashboard.self, from: data)
                
                print(aData.sites)
                
            DispatchQueue.main.async(){
                    self.sites = aData.sites
                    self.siteArray = aData.sites
                //self.siteArray = aData.sites
                    //self.site_url = aData.sites
                    //self.performSegue(withIdentifier: "login1", sender: self)
                self.dashboardTableView.reloadData()
                }
                
            }catch let jsonError {
                DispatchQueue.main.async(){
                    //self.failLbl.text = "Login Failed, Please try again."
                }
                print(jsonError)
            }
            
        }
        task.resume()

        self.dashboardTableView.dataSource = self
        self.dashboardTableView.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "addSite") {
        guard let destination = segue.destination as? ViewController else {return}
        destination.token1 = token1
        }else if (segue.identifier == "site"){
        guard let destination = segue.destination as? SiteViewController else {return}
            destination.token1 = token1
            destination.site_url = site_url
        }else if (segue.identifier == "settings"){
            guard let destination = segue.destination as? SettingsViewController else {return}
            destination.token1 = token1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DashboardViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell")!
        cell.textLabel?.text = self.siteArray[indexPath.row]
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
     print("Tapped ",siteArray[indexPath.row])
     site_url = siteArray[indexPath.row]
     self.performSegue(withIdentifier: "site", sender: self)
     
     }
}
