//
//  HttpHelper.swift
//  Slang Dictionary
//
//  Created by Daniel Bolivar herrera on 16/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit


class HttpHelper: NSObject {
    
    //POST Request
    class func httpPostURL(_ url: String, postPath: String?, parametersDict:Dictionary<String, AnyObject>?) -> AnyObject?
    {
        // ? declares variable as optional, just in case the request fails
        var responseJSON : AnyObject? = nil;
        
        //Create the urls
        var fullURL = url;
        if (postPath != nil) {
            fullURL = url + postPath!;
        }
        
        //Semaphore to wait for completition block
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0);
        
        let manager : AFHTTPSessionManager = AFHTTPSessionManager();
        
        manager.post(fullURL, parameters: parametersDict, progress: nil, success: {
            (operation: URLSessionTask!, responseObject: Any) in
            //print("JSON: " + responseObject!.description);
            
            responseJSON = responseObject as AnyObject?;
            //Signal semaphore
            semaphore.signal();
            
            }, failure: { (operation: URLSessionTask?, error: Error!) in
                print("[HTTPHelper Error]: " + error.localizedDescription);
                //Maybe check for internet connection ?
                
                //Signal semaphore
                semaphore.signal();
        })
        
        //Wait for the completition of the request
        _ = semaphore.wait(timeout: DispatchTime.distantFuture);
        
        return responseJSON;
    }
    
    
    //GET Request
    class func httpGetURL(_ url: String, postPath: String?, parametersDict:Dictionary<String, AnyObject>?) -> AnyObject?
    {
        
        // ? declares variable as optional, just in case the request fails
        var responseJSON : AnyObject? = nil;
        
        //Create the urls
        //Create the urls
        var fullURL = url;
        if (postPath != nil) {
            fullURL = url + postPath!;
        }
        
        //Semaphore to wait for completition block
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0);
        
        let manager : AFHTTPSessionManager = AFHTTPSessionManager();
        
        manager.get(fullURL, parameters: parametersDict, progress: nil, success:  {
            (operation: URLSessionTask!, responseObject: Any) in
            //println("JSON: " + responseObject.description);
            
            responseJSON = responseObject as AnyObject?;
            //println(responseJSON);
            //Signal semaphore
            semaphore.signal();
            
            }, failure: { (operation: URLSessionTask?, error: Error!) in
                print("[HTTPHelper Error]: " + error.localizedDescription);
                //Maybe check for internet connection ?
                
                //Signal semaphore
                semaphore.signal();
        })
        
        //Wait for the completition of the request
        _ = semaphore.wait(timeout: DispatchTime.distantFuture);
        
        return responseJSON;
        
    }
}
