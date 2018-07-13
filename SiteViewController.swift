//
//  SiteViewController.swift
//  ARMOREDWARE Web Security Scan
//
//  Created by Michael DeBiase on 3/25/18.
//  Copyright © 2018 ARMOREDWARE. All rights reserved.
//

import UIKit

class SiteViewController: UIViewController {
    
    struct Site: Codable {
        var user_id: String!
        var site_url: String!
        var name: String!
        var domain: String!
        var uptime: String!
        var alerts: String!
        var verbosity: String!
        var alias: String!
        var os: String!
        var middleware: String!
        var database: String!
        var platform: String!
        var cms: String!
        var appfirewall: String!
        var loadspeed: String!
        var vulnerabilities: String!
        var adacompliance: String!
        var virus: String!
        var malware: String!
        var pagerank: String!
        var backlinks: String!
        var ipaddress: String!
        var ports: String!
        var bruteforce: String!
        var traceroute: String!
        var price: Double!
        var seal: String!
        var paid: String!
        var verified: String!
        var html: String!
        var js: String!
        var title: String!
        var thumbnail: String!
        var scanned: String!
        var resources: Int!
        var pages: [String]!
        var timestamp: Double!
        var isLatest: String!
    }
    
    var token1: String!
    var site_details = " "
    var new1 = " "
    var site_url: String!
    var enc_site_url: String!
    var pageTemp: [String]!
    
    var siteArray2 = ["Loading..."]
    
    @IBOutlet weak var siteTableView: UITableView!
    
    @IBAction func Pages(_ sender: Any) {
        self.performSegue(withIdentifier: "pages", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newLayer = CAGradientLayer()
        //newLayer.colors = [UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.colors = [UIColor.black.cgColor, UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor(red:169/255.0, green:80/255.0, blue: 186/255.0, alpha: 1.0).cgColor,   UIColor(red:113/255.0, green:202/255.0, blue: 252/255.0, alpha: 1.0).cgColor, UIColor(red:60/255.0, green:92/255.0, blue: 254/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)

        
        // Do any additional setup after loading the view.
        enc_site_url = site_url.replacingOccurrences(of: "://", with: "12___21")
        guard let url = URL(string: "https://armoredware.com/sites/site_details_\(self.enc_site_url!)") else { return }
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
                
                let aData = try JSONDecoder().decode(Site.self, from: data)
                self.new1 = aData.user_id
                print(aData.user_id)
                //site_details = aData.user_id
                //
                DispatchQueue.main.async(){
                    self.new1 = aData.user_id
                    //self.siteArray2 = [self.new1]
                    self.siteArray2 = [String("User ID: \(aData.user_id!)"), String("URL: \(aData.domain!)"), String("Last Scanned: \(aData.timestamp!)"), String("Monthly Fee: \(aData.price!)"), String("Title: \(aData.name!)"), String("IP Address: \(aData.ipaddress!)"), String("Load Speed: \(aData.loadspeed!)"), String("Server OS: \(aData.os!)"), String("Platforms: \(aData.platform!)")]
                    self.pageTemp = aData.pages
                    print("SiteA2",self.siteArray2)
                    self.siteTableView.reloadData()
                    //self.siteArray.append("mike")
                    //self.performSegue(withIdentifier: "login1", sender: self)
                    
                }
            }catch let jsonError {
                DispatchQueue.main.async(){
                    //self.failLbl.text = "Login Failed, Please try again."
                }
                print(jsonError)
            }
        }
        task.resume()
        

        self.siteTableView.dataSource = self
        self.siteTableView.delegate = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let destination = segue.destination as? PagesViewController else {return}
        destination.token1 = token1
        destination.site_url = site_url
        destination.pageArray = pageTemp
        
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
extension SiteViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteArray2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "siteCell")!
        cell.textLabel?.text = self.siteArray2[indexPath.row]
        return cell
    }
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Tapped ",pageArray[indexPath.row])
        page_uri = pageArray[indexPath.row]
        self.performSegue(withIdentifier: "pageinfo", sender: self)
     
   }*/
}
