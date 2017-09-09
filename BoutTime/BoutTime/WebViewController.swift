//
//  WebViewController.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 7/26/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var url = "https://en.wikipedia.org/wiki/HTTP_404"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        webView.delegate  = self
        
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL!)
        webView.loadRequest(request)
        self.webView.dataDetectorTypes = []
        
    }
    
    func navigationBarSetup() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 148/255, blue: 0/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .white
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension WebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .linkClicked {
            return false
        }
        
        return true
    }
    
}
