//
//  ViewController.swift
//  mepirate
//
//  Created by beependra on 5/3/17.
//  Copyright © 2017 beependra. All rights reserved.
//

import UIKit
import Alamofire
import TTGSnackbar
import coreData


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //checkForUpdate()
        downloadDatabase()        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func downloadDatabase(){
        checkForUpdate()
        let destination = Alamofire.Request.suggestedDownloadDestination(
            directory: .CachesDirectory,
            domain: .UserDomainMask
        )
        
        Alamofire.download(.GET, databaseDwldUrl, destination: destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                print(totalBytesRead)
            }
            .response { request, response, _, error in
                print(response)
                print("fileURL: \(destination(NSURL(string: "")!, response))")
        }
    }
    func checkForUpdate(){
        let headers = [
            //"access-token": accessToken,
            ]
        let parameters = [
//            "name" : username,
//            "username" : email,
            ]
        let requestString = checkUpdateUrl
        
        
        // Both calls are equivalent
        Alamofire.request(requestString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in //debugPrint(response)
            
            // print(response.request)  // original URL request
            // print(response.response) // HTTP URL response
            //print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                if    let list = JSON as? NSDictionary// NSArray
                {
                    if let error:Bool = list["error"] as? Bool{
                        if error == false {
                            // print(datadef.object(forKey: "datadic"))
                            
//                            if let resultController = self.storyboard!.instantiateViewController(withIdentifier: "loginSegue") as? loginViewController {
//                                self.present(resultController, animated: true, completion: nil)
                            downloadDatabase()
//                                
                        }
                        
                        else{
                            print("noauth")
                            let snackbar = TTGSnackbar.init(message: (list["msg"] as? String)!, duration: .middle)
                            snackbar.show()
                        }
                        
                    }
                    else{
                        //success = false
                    
                        let snackbar = TTGSnackbar.init(message: "Server Error", duration: .middle)
                        snackbar.show()
                        
                    }
                }
                
            }
        }
        
        
    }
    func parseJsontoDb(){
        
    }



}

