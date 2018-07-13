//
//  QuoteViewController.swift
//  ARMOREDWARE Web Security Scan
//
//  Created by Michael DeBiase on 3/26/18.
//  Copyright © 2018 ARMOREDWARE. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {
    
    struct Added: Codable {
        var success: String
    }
    
   var token1: String!
    var site_url: String!
    var quote: String!
    var error: String!
    var pages: [String]!
    var user_id: String!
    
    

    @IBOutlet weak var LBprice: UILabel!
    
    @IBOutlet weak var LBfail: UILabel!
    
    @IBOutlet weak var LBurl: UILabel!
    
    @IBAction func siteAdded(_ sender: Any) {
        guard let url = URL(string: "https://armoredware.com/sites/add_site") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT \(self.token1!)", forHTTPHeaderField: "Authorization")
        //let postDictionary = ["Authorization": "JWT \(self.token1!)"]
        let postDictionary = ["site_url": "\(self.site_url!)"]
        
        
        print(postDictionary)
        
        do{
            let jsonBody = try
                JSONSerialization.data(withJSONObject:  postDictionary, options: [])
            request.httpBody = jsonBody
        } catch{}
        
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request){ (data, _, _) in
            guard let data = data else { return }
            do{
                
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
                let aData = try JSONDecoder().decode(Added.self, from: data)
                
                
                DispatchQueue.main.async(){
                    print(aData.success)
                    //self.site_url = aData.site_url
              
                    self.performSegue(withIdentifier: "siteAdded", sender: self)
                }
                
            }catch let jsonError {
                DispatchQueue.main.async(){
                    self.LBfail.text = "Error."
                }
                print(jsonError)
            }
            
        }
        task.resume()
        
        
        //performSegue(withIdentifier: "siteAdded", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let newLayer = CAGradientLayer()
        //newLayer.colors = [UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.colors = [UIColor.black.cgColor, UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor(red:169/255.0, green:80/255.0, blue: 186/255.0, alpha: 1.0).cgColor,   UIColor(red:113/255.0, green:202/255.0, blue: 252/255.0, alpha: 1.0).cgColor, UIColor(red:60/255.0, green:92/255.0, blue: 254/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)
        
        print("Token: ",token1)
        print("Pages: ", pages)
        self.LBurl.text = site_url
        
        self.LBprice.text = "$ " + quote
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let destination = segue.destination as? DashboardViewController else {return}
        destination.token1 = token1
        
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
