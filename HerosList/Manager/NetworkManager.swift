//
//  MetworkManager.swift
//  Heros
//
//  Created by rivki glick on 28/04/2021.
//

import Foundation
import UIKit
import Alamofire


var BaseUrl = ""
var HOST = ""
var key = ""


class NetworkManager : NSObject {
    
    var manager : Alamofire.SessionManager?
    //
    private static var networkManagerShared: NetworkManager = {
        BaseUrl = "https://superheroapi.com/api/"
        HOST = "reqres.in"
        key = "10158505242635943"
        
        var networkManager = NetworkManager()
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default
        )
        networkManager.manager = manager
        return networkManager
    }()
    
    class func shared() -> NetworkManager {
        return networkManagerShared
    }
    
    
    func getHeroById( id:String, completion: @escaping (_ heros:AnyObject) -> Void,error: @escaping (String?) -> Void)  {
        if Connectivity.isConnectedToInternet {
            manager?.request(
                URL(string: BaseUrl + key+"/" + id)!,
                method: .get,
                parameters: nil,
                headers: nil).responseJSON{ (response) in
                    print(response)
                    self.handleObjectArrayResponse(type: Hero.self, response: response, functionName: "id", textFromJson: "data") { (data) in
                        completion(data )
                    } error: { (error) in
                        print(error as Any)
                    }
                    }
                }
        else {
             print("No Internet")
            self.handleError(statusCode: 0, errorHandler: error)
        }
  
    }
    
    func getHerosList( searchText:String, completion: @escaping (_ heros:AnyObject) -> Void,error: @escaping (String?) -> Void)  {
        if Connectivity.isConnectedToInternet {
            manager?.request(
                URL(string: BaseUrl + key+"/search/" + searchText)!,
                method: .get,
                parameters: nil,
                headers: nil).responseJSON{ (response) in
                    print(response)
                    self.handleObjectArrayResponse(type: Hero.self, response: response, functionName: "search", textFromJson: "data") { (data) in
                        completion(data )
                    } error: { (error) in
                        print(error as Any)
                    }
                    }
                }
        else {
             print("No Internet")
            self.handleError(statusCode: 0, errorHandler: error)
        }
  
    }

    //MARK: - @handle respond and error
    
    func convertRespondToDictionary(text: String) -> [String: Any]?
    {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func handleObjectArrayResponse<T: Decodable>(type: T.Type, response: DataResponse<Any>, functionName: String,textFromJson:String, completion: @escaping (_ heros:AnyObject) -> Void, error: @escaping (String?) -> Void)
    {
        if self.didSuccessAndHandleError(response: response, functionName: functionName, errorHandler: error)
        {
            do
            {
            if let json = response.result.value {
                print("JSON: \(json)")
                let res = json as! NSDictionary
                
                let responseString = res["response"] as! String
                
                if responseString == "success" {
                   if let data = res["results"]
                   {
                       completion(data as AnyObject)
                   }
                    else
                   {
                      completion(res as AnyObject)
                   }
                }
                else
                {
                    if responseString == "error"
                    {
                        let error = res["error"] as! String
                        completion(error as AnyObject)
                    }
                }
                
               
            }
                else
            {
                print("error")
            }
                
                
            }
            catch let catchError
            {
                print(catchError)
                self.handleError(statusCode: (response.response?.statusCode)!, functionName: functionName, errorHandler: error)
            }
        }
    }
    
    func didSuccessAndHandleError(response: DataResponse<Any>, error: String = "", functionName: String = "", errorHandler: @escaping (String?) -> Void,isShowAlert:Bool? = true) -> Bool
    {
        guard let value = response.result.value as? [String: Any] else
        {
            self.handleError(statusCode: (response.response?.statusCode) ?? 0, functionName: functionName, errorHandler: errorHandler,isShowAlert:isShowAlert)
            return false
        }
        guard response.result.isSuccess  else
        {
            guard let errorString = value["Error"] as? String else
            {
                self.handleError(statusCode: (response.response?.statusCode)!, functionName: functionName, errorHandler: errorHandler,isShowAlert:isShowAlert)
                return false
            }
            self.handleError(error: errorString, errorHandler: errorHandler,isShowAlert:isShowAlert)
            return false
        }
        return true
    }
    
    func checkResponseValue(response: DataResponse<Any>, error: String = "", functionName: String = "", errorHandler: @escaping (String?) -> Void,isShowAlert:Bool? = true) -> Bool
    {
        if !self.didSuccessAndHandleError(response: response, error: error, functionName: functionName, errorHandler: errorHandler,isShowAlert:isShowAlert)
        {
            return false
        }
        let value = response.result.value as? [String: Any]
        guard value!["Response"] as? [String: Any] != nil  || value!["Response"] as?  [Any] != nil else
        {
            self.handleError(statusCode: (response.response?.statusCode)!, functionName: functionName, errorHandler: errorHandler,isShowAlert:isShowAlert)
            return false
        }
        return true
    }
    
    func handleError(statusCode: Int = -1, error: String = "", functionName: String = "", errorHandler: @escaping (String?) -> Void,isShowAlert:Bool? = true)
    {
        var msg:String = ""
        
        if error.isEmpty
        {
            switch statusCode
            {
            case 0:
                msg = "no internet"
                break
            default:
                msg = functionName + " (" + "\(statusCode)" + ")"
                break
            }
        }
        else
        {
            msg = error
        }
        
        if msg.count > 0
        {
            if var topController = UIApplication.shared.keyWindow?.rootViewController
            {
                while let presentedViewController = topController.presentedViewController
                {
                    topController = presentedViewController
                }
                let alert = UIAlertController(title:"", message: msg, preferredStyle:.alert)
                alert.addAction(UIAlertAction(title:"ok", style:.cancel, handler: nil))
                
                if(isShowAlert == true)
                {
                topController.present(alert, animated: true, completion: nil)
                }
            }
        }
        errorHandler(msg)
    }
}

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
