//
//  ApiHelper.swift
//  Itop-Driver
//
//  Created by Crocodic MBP-2 on 5/4/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ApiHelper {
    static let shared = ApiHelper()
    
    /// Path API
    enum Path: String {
        case path = "path"
    }
    
    /// Base API
    let BASE_URL = "BASE_URL"
    
    /// Setting headers for CrudBooster, comment data variable dictionary value to remove header when request
    var headers: [String : String] {
        let data : [String : String] = [ : ]
        
        return data
    }
    
    /// Create full url API
    func setUrl(path: Path) -> URL {
        return URL(string: BASE_URL + path.rawValue)!
    }
    
    /// Alamofire session manager is Alamfire with some configuration of url session configuration
    private var afManager: SessionManager? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    /// Make API request to server
    ///
    /// - Parameters:
    ///   - url: Full url API
    ///   - method: Method when requesting API
    ///   - parameters: Parameters used in requesting
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    private func apiRequest(url: URL, method: Alamofire.HTTPMethod, parameters: Parameters, completion: @escaping((JSON, Bool, String) -> Void)) -> DataRequest? {
        return afManager?.request(url, method: method, parameters: parameters, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                print("Get response request : \(response.result.value ?? "")")
                if let data = response.data {
                    let json = try! JSON(data: data)
                    let status = json["api_status"].intValue
                    let message = json["api_message"].stringValue
                    completion(json, status == 1, message)
                }
            } else {
                if let error = response.result.error {
                    completion("", false, error.localizedDescription)
                    return
                }
                print(response.result.debugDescription)
                completion("", false, "Terjadi suatu kesalahan")
            }
        }
    }
    
    /// Upload data to server
    ///
    /// - Parameters:
    ///   - url: Full url API
    ///   - method: Method when requesting API
    ///   - parameters: All parameters needed when requesting, recomended using only 2 data type (String and Data), Data used for file to upload
    ///   - mimeType: Mime type for file upload. Reference: https://www.sitepoint.com/mime-types-complete-list/ find upload file extention you use
    ///   - completion: Callback response from API
    private func uploadRequest(url: URL, method: Alamofire.HTTPMethod, parameters: [String : [String : Any]], completion: @escaping((JSON, Bool, String) -> Void)) {
        afManager?.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                for (mimeType, actualValue) in value {
                    if let data = actualValue as? Data {
                        multipartFormData.append(data, withName: key, fileName: "file.jpg", mimeType: mimeType)
                    } else if let data = "\(actualValue)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
        }, to: url, method: method, headers: headers) { (encodingResult) in
            switch encodingResult{
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        print("Get response request : \(response.result.value ?? "")")
                        if let data = response.data {
                            let json = try! JSON(data: data)
                            let status = json["api_status"].intValue
                            let message = json["api_message"].stringValue
                            completion(json, status == 1, message)
                        }
                    } else {
                        print(response.result.debugDescription)
                        completion("", false, "Terjadi suatu kesalahan")
                    }
                })
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
            }
        }
    }
    
    /// Generate value upload data with their mimeType, make sure mimeType empty if value not file
    ///
    /// - Parameters:
    ///   - data: value for upload data/ for parameter key
    ///   - mimeType: Mime type for file upload. Reference this [link](https://www.sitepoint.com/mime-types-complete-list/) to find upload file extention you use, empty this if value not file
    /// - Returns: Dictionary that key as mimeType and value as value parameters
    private func uploadValue(data: Any, mimeType: String = "") -> [String : Any] {
        var parameters = [String : Any]()
        parameters.updateValue(data, forKey: mimeType)
        return parameters
    }
    
    /// Template: Example function to request API
    ///
    /// - Parameters:
    ///   - value: Value of parameters required
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    func example(value: String, completion: @escaping((JSON, Bool, String) -> Void)) -> DataRequest? {
        var parameters = Parameters()
        parameters.updateValue(value, forKey: "parameter")
        
        let url = setUrl(path: .path)
        
        return apiRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    /// Template: Example function to request API with response as list
    ///
    /// - Parameters:
    ///   - searchText: Search text to find specific name
    ///   - limit: Limit response array every page
    ///   - offset: Number of page in list
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    func exampleList(searchText: String, limit: Int, offset: Int, completion: @escaping((JSON, Bool, String) -> Void)) -> DataRequest? {
        var parameters = Parameters()
        parameters.updateValue(searchText, forKey: "search")
        parameters.updateValue(offset, forKey: "offset")
        parameters.updateValue(limit, forKey: "limit")
        
        let url = setUrl(path: .path)
        
        return apiRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }
    
    /// Template: Example function to upload file request
    ///
    /// - Parameters:
    ///   - value: Value of parameters required
    ///   - photo: File that will upload
    ///   - completion: Callback response from API
    func exampleUpload(value: String, photo: Data, completion: @escaping((JSON, Bool, String) -> Void)) {
        let valueWithMime = uploadValue(data: value)
        let photoWithMime = uploadValue(data: photo, mimeType: "image/jpg")
        
        var parameters = [String : [String : Any]]()
        parameters.updateValue(valueWithMime, forKey: "parameter")
        parameters.updateValue(photoWithMime, forKey: "parameter")
        
        let url = setUrl(path: .path)
        
        uploadRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
}
