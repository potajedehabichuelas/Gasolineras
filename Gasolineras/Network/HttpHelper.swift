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
    class func httpPostURL(url: String, postPath: String?, parametersDict:Dictionary<String, AnyObject>?) -> AnyObject?
    {
        // ? declares variable as optional, just in case the request fails
        var responseJSON : AnyObject? = nil;
        
        //Create the urls
        var fullURL = url;
        if (postPath != nil) {
            fullURL = url.stringByAppendingString(postPath!);
        }
        
        //Semaphore to wait for completition block
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager();
        
        manager.POST(fullURL,
            parameters: parametersDict,
            success: {
                (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                print("JSON: " + responseObject.description);
                
                responseJSON = responseObject;
                //Signal semaphore
                dispatch_semaphore_signal(semaphore);
                
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                print("[HTTPHelper Error]: " + error.localizedDescription);
                //Maybe check for internet connection ?
                
                //Signal semaphore
                dispatch_semaphore_signal(semaphore);
        });
        
        //Wait for the completition of the request
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
        return responseJSON;
    }
    

    //GET Request
    class func httpGetURL(url: String, postPath: String?, parametersDict:Dictionary<String, AnyObject>?) -> AnyObject?
    {
    
        // ? declares variable as optional, just in case the request fails
        var responseJSON : AnyObject? = nil;
        
        //Create the urls
        //Create the urls
        var fullURL = url;
        if (postPath != nil) {
            fullURL = url.stringByAppendingString(postPath!);
        }
        
        //Semaphore to wait for completition block
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager();
        
        manager.GET(fullURL,
            parameters: parametersDict,
            success: {
                (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //println("JSON: " + responseObject.description);
                
                responseJSON = responseObject;
                //println(responseJSON);
                //Signal semaphore
                dispatch_semaphore_signal(semaphore);
                
            },failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                print("[HTTPHelper Error]: " + error.localizedDescription);
                //Maybe check for internet connection ?
                
                //Signal semaphore
                dispatch_semaphore_signal(semaphore);
        });
        
        //Wait for the completition of the request
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        return responseJSON;

    }
}
