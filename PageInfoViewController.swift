//
//  PageInfoViewController.swift
//  ARMOREDWARE Web Security Scan
//
//  Created by Michael DeBiase on 3/25/18.
//  Copyright © 2018 ARMOREDWARE. All rights reserved.
//

import UIKit

class PageInfoViewController: UIViewController {
    
    struct Site: Codable {
        var user_id: String!
        var last_mod: String!
        var timestamp: Double!
        var domain: String!
        var url: String!
        var xss: String!
        var sqli: String!
        var sql: String!
        var csrf: String!
        var hash: String!
        var uptime: String!
        var loadspeed: String!
        var pagecontent: String!
        var externallinks: String!
        var scripts: String!
        var base64: String!
        var documenttype: String!
        var virus: String!
        var malware: String!
        var reputation: String!
        var popups: String!
        var bruteforce: String!
        var title: String!
        var redirect: String!
        var sensitivedata: String!
        var emailaddresses: String!
        var adaissues: String!
        var accesscontrol: String!
        var vulnerability: String!
        var scanned: String!
    }

    @IBOutlet weak var pageinfoTableView: UITableView!
    
    var site_url: String!
    var token1: String!
    var page_uri: String!
    
    //added from Settings
    var site_details = " "
    var new1 = " "

    var enc_site_url: String!
    var pageTemp: [String]!
    
    var siteArray3 = ["Loading..."]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newLayer = CAGradientLayer()
        //newLayer.colors = [UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.colors = [UIColor.black.cgColor, UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor(red:169/255.0, green:80/255.0, blue: 186/255.0, alpha: 1.0).cgColor,   UIColor(red:113/255.0, green:202/255.0, blue: 252/255.0, alpha: 1.0).cgColor, UIColor(red:60/255.0, green:92/255.0, blue: 254/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)

        // Do any additional setup after loading the view.
        print("Domain: ", site_url,"/ Page:",page_uri)
        print("Token: ", token1)
        
        // Do any additional setup after loading the view.
        enc_site_url = site_url.replacingOccurrences(of: "://", with: "12___21")
        
        enc_site_url = enc_site_url.replacingOccurrences(of: "/", with: "13___31")
        
        guard let url = URL(string: "https://armoredware.com/page_details_\(self.enc_site_url!)") else { return }
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
                    self.siteArray3 = [aData.user_id, aData.url]
                    //self.pageTemp = aData.pages
                    print("SiteA2",self.siteArray3)
                    self.pageinfoTableView.reloadData()
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
        
        
        self.pageinfoTableView.dataSource = self
        self.pageinfoTableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let destination = segue.destination as? PagesViewController else {return}
        destination.token1 = token1
        destination.site_url = site_url
        //destination.pageArray = pageTemp
        
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
extension PageInfoViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteArray3.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pageinfoCell")!
        cell.textLabel?.text = self.siteArray3[indexPath.row]
        return cell
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
