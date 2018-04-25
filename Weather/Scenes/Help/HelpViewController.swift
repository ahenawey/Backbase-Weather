//
//  HelpViewController.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 21/04/2018.
//  Copyright © 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let htmlFile = Bundle.main.path(forResource: "help", ofType: "html") else {
            let alertController = UIAlertController(title: "Error", message: "Cannot load help, Please try again later", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        webView.loadRequest(URLRequest(url: URL(fileURLWithPath: htmlFile)))
    }
}
