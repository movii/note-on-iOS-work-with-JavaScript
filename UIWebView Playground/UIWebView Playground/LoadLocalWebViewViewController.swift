//
//  LoadLocalViewController.swift
//  UIWebView Playground
//
//  Created by Lien on 2017/3/18.
//  Copyright © 2017年 mo.strangline. All rights reserved.
//

import UIKit

class LoadLocalWebViewViewController: UIViewController {
  
  @IBOutlet weak var evalJsBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "LoadLocal" ||
       segue.identifier == "LoadLocalWithAlert" ||
       segue.identifier == "loadLocalWithAlertFromFile" ||
       segue.identifier == "interceptRequest" {
      
      let navgationVC = segue.destination as! UINavigationController
      let webviewBrowserVC = navgationVC.topViewController as! WebViewBrowserViewController
      
      let path = Bundle.main.path(forResource: "webview playground/index", ofType: "html")
      webviewBrowserVC.requestURL = URLRequest(
        url: URL(
          fileURLWithPath: path!
        )
      )
      
      if segue.identifier == "LoadLocal" {
        webviewBrowserVC.requestType = "local"
        webviewBrowserVC.sayHello = false
      }
      else if segue.identifier == "loadLocalWithAlertFromFile" {
        webviewBrowserVC.requestType = "localWithAlertFromFile"
        webviewBrowserVC.sayHello = false
      }
      else if segue.identifier == "interceptRequest" {
        webviewBrowserVC.requestType = "local"
        webviewBrowserVC.sayHello = false
      }
      else {
        webviewBrowserVC.requestType = "local"
        webviewBrowserVC.sayHello = true
      }
    }
  }
}
