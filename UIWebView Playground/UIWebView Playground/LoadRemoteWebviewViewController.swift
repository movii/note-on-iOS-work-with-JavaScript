//
//  LoadRemoteWebviewViewController.swift
//  UIWebView Playground
//
//  Created by Lien on 2017/3/18.
//  Copyright © 2017年 mo.strangline. All rights reserved.
//

import UIKit

class LoadRemoteWebviewViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "LoadRemote" {
      let navgationVC = segue.destination as! UINavigationController
      let webviewBrowserVC = navgationVC.topViewController as! WebViewBrowserViewController
      
      webviewBrowserVC.requestURL = URLRequest(url: URL(string: "http://www.douban.com")!)
      webviewBrowserVC.requestType = "remote"
      webviewBrowserVC.sayHello = false
    }
  }
  
}
