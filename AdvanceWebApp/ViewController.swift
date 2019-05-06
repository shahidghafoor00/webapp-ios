//
//  ViewController.swift
//  AdvanceWebApp
//
//  Created by Shahid Ghafoor on 01/05/2019.
//  Copyright © 2019 Shahid Ghafoor. All rights reserved.
//

import UIKit
import WebKit
import Foundation
import SystemConfiguration

class ViewController: UIViewController, WKUIDelegate ,WKNavigationDelegate {

    var activityIndicatorView: ActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isInternetAvailable() {
            // webview navigation
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.scrollView.bounces = true
            let myURL = URL(string:"https://urgentimoveis.com.br/")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
            // swipe left or right for going back or forward
            webView.allowsBackForwardNavigationGestures = true
        } else {
            showAlert()
        }
        
    }

    func webView(_ webView: WKWebView,
didStartProvisionalNavigation navigation: WKNavigation!) {
    
        //         add loading view to the main view
        self.activityIndicatorView = ActivityIndicatorView(title: "Carregando...", center: self.view.center)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
        self.activityIndicatorView.startAnimating()
        
        print("provision nev ..receiving.....")
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicatorView.stopAnimating()
        print("finish..loading")
    }
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}

