//
//  ViewController.swift
//  ARMOREDWARE Web Security Scan
//
//  Created by Michael DeBiase on 3/19/18.
//  Copyright © 2018 ARMOREDWARE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Quote: Codable {
        var user_id: String
        var site_url: String
        var quote: String
        var pages: [String]
        var error: String
    }
    

    var token1: String!
    var site_url: String = " "
    var user_id: String = " "
    var quote: String = " "
    var pages: [String] = [" "]
    var error: String = " "
    
    @IBOutlet weak var LBfail: UILabel!
    
    @IBOutlet weak var UIurl: UITextField!
    
    @IBAction func quote(_ sender: Any) {
        
        
        guard let url = URL(string: "https://armoredware.com/sites/get_quote") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT \(self.token1!)", forHTTPHeaderField: "Authorization")
        //let postDictionary = ["Authorization": "JWT \(self.token1!)"]
        let postDictionary = ["site_url": "\(self.UIurl.text!)"]
        
        
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
                
                let aData = try JSONDecoder().decode(Quote.self, from: data)
                
                
                DispatchQueue.main.async(){
                    print(aData.site_url)
                    self.site_url = aData.site_url
                    self.pages = aData.pages
                    self.error = aData.error
                    self.quote = aData.quote
                    self.user_id = aData.user_id
                    self.performSegue(withIdentifier: "quote", sender: self)
                }
                
            }catch let jsonError {
                DispatchQueue.main.async(){
                    self.LBfail.text = "Quote Error."
                }
                print(jsonError)
            }
            
        }
        task.resume()
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let destination = segue.destination as? QuoteViewController else {return}
        destination.token1 = token1
        destination.site_url = site_url
        destination.error = error
        destination.pages = pages
        destination.quote = quote
        destination.user_id = user_id
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newLayer = CAGradientLayer()
        //newLayer.colors = [UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.colors = [UIColor.black.cgColor, UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor(red:169/255.0, green:80/255.0, blue: 186/255.0, alpha: 1.0).cgColor,   UIColor(red:113/255.0, green:202/255.0, blue: 252/255.0, alpha: 1.0).cgColor, UIColor(red:60/255.0, green:92/255.0, blue: 254/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)
        print("Token:",token1)
        // Do any additional setup after loading the view, typically from a nib.
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

