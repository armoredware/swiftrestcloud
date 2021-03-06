//
//  LoginViewController.swift
//  ARMOREDWARE Web Security Scan
//
//  Created by Michael DeBiase on 3/25/18.
//  Copyright © 2018 ARMOREDWARE. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    struct Login: Codable {
        var access_token: String
    }
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var failLbl: UILabel!
    
    var loginFail = false
    var aT: String = " "

   
    
    @IBAction func login1(_ sender: Any) {
        
        guard let url = URL(string: "https://armoredware.com/auth") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postDictionary = ["username": "\(self.email.text!)","password":"\(self.password.text!)"]
       
        
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
                
                let aData = try JSONDecoder().decode(Login.self, from: data)
               
                print(aData.access_token)
                DispatchQueue.main.async(){
                    self.aT = aData.access_token
                    self.performSegue(withIdentifier: "login1", sender: self)
                }
                
            }catch let jsonError {
                DispatchQueue.main.async(){
                    self.failLbl.text = "Login Failed, Please try again."
                }
                print(jsonError)
            }
           
        }
        task.resume()
        
        
      
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let destination = segue.destination as? DashboardViewController else {return}
        destination.token1 = aT
       
    }
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "register", sender: self)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // UIColor.darkGray.cgColor 
        //UIColor(red:127/255.0, green:30/255.0, blue: 172/255.0, alpha: 1.0).cgColor,
        let newLayer = CAGradientLayer()
        //newLayer.colors = [UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.colors = [UIColor.black.cgColor, UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor(red:169/255.0, green:80/255.0, blue: 186/255.0, alpha: 1.0).cgColor,   UIColor(red:113/255.0, green:202/255.0, blue: 252/255.0, alpha: 1.0).cgColor, UIColor(red:60/255.0, green:92/255.0, blue: 254/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)
        
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
