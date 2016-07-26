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
        
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
        
    }
    
    @IBAction func closeWebView(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}