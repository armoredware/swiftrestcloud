//
//  RegisterViewController.swift
//  ARMOREDWARE Web Security Scan
//
//  Created by Michael DeBiase on 3/25/18.
//  Copyright © 2018 ARMOREDWARE. All rights reserved.
//

/*
 email = request.form['email']
 password = request.form['password']
 domains = request.form['domains']
 memberlevel= request.form['memberlevel']
 token= request.form['token']
 APIkey= request.form['APIkey']
 config= request.form['config']
 name= request.form['name']
 paid= request.form['paid']
 paymentdue= request.form['paymentdue']
 ads= request.form['ads']
 products= request.form['products']
 company= request.form['company']
 address= request.form['address']
 city= request.form['city']
 state= request.form['state']
 zip= request.form['zip']
 phone= request.form['phone']
 */

import UIKit

class RegisterViewController: UIViewController {
    
    struct Register: Codable {
        var username: String
        var password: String
    }
    
    struct Login: Codable {
        var access_token: String
    }
    
    var aT: String = " "
    var jUser: String = " "
    var jPassword: String = " "
    
    @IBOutlet weak var regemail: UITextField!
    
    @IBOutlet weak var lbfail: UILabel!
    
    @IBOutlet weak var regpassword: UITextField!
    
    @IBAction func register(_ sender: Any) {
        
        guard let url = URL(string: "https://armoredware.com/users/register") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postDictionary = ["email": "\(self.regemail.text!)",
            "password":"\(self.regpassword.text!)",
            "domains":"None",
            "memberlevel":"None",
            "token":"None",
            "APIkey":"None",
            "config":"None",
            "name":"None",
            "paid":"None",
            "paymentdue":"None",
            "ads":"None",
            "products":"None",
            "company":"None",
            "address":"None",
            "city":"None",
            "state":"None",
            "zip":"None",
            "phone":"None"] as [String : Any]
        
        
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
                
                let aData = try JSONDecoder().decode(Register.self, from: data)
                
                print(aData.username)
                DispatchQueue.main.async(){
                    self.lbfail.text = "New User Created"
                    self.jUser = aData.username
                    self.jPassword = aData.password
                    //self.performSegue(withIdentifier: "dashboard", sender: self)
                    self.login(jUser:self.jUser, jPassword:self.jPassword)
                }
                
            }catch let jsonError {
                DispatchQueue.main.async(){
                    self.lbfail.text = "Login Failed, Please try again."
                }
                print(jsonError)
            }
            
        }
        task.resume()

    }
    
    func login(jUser: String, jPassword: String){
        
        
        guard let url = URL(string: "https://armoredware.com/auth") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postDictionary = ["username": "\(jUser)","password":"\(jPassword)"]
        
        
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
                    self.performSegue(withIdentifier: "dashboard", sender: self)
                }
                
            }catch let jsonError {
                DispatchQueue.main.async(){
                    self.lbfail.text = "Login Failed, Please try again."
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newLayer = CAGradientLayer()
        //newLayer.colors = [UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.colors = [UIColor.black.cgColor, UIColor(red:49/255.0, green:27/255.0, blue: 146/255.0, alpha: 1.0).cgColor, UIColor(red:169/255.0, green:80/255.0, blue: 186/255.0, alpha: 1.0).cgColor,   UIColor(red:113/255.0, green:202/255.0, blue: 252/255.0, alpha: 1.0).cgColor, UIColor(red:60/255.0, green:92/255.0, blue: 254/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)
        // Do any additional setup after loading the view.
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
