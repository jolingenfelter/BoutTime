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
        
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL!)
        webView.loadRequest(request)
        
    }
    
    @IBAction func closeWebView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
