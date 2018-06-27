//
//  UIWebViewWithInterceptRequest.swift
//  Interactive iOS with JavaScript
//
//  Created by Lien on 13/04/2017.
//  Copyright © 2017 mo.strangline. All rights reserved.
//

import UIKit

class UIWebViewWithInterceptRequest: UIViewController {
  
  @IBOutlet weak var webview: UIWebView!
  
  @IBAction func refreshWebView() {
    webview.reload()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let path = Bundle.main.path(forResource: "html/uiwebview_with_intercept_request", ofType: "html")
    let pathUrl = URL(fileURLWithPath: path!)
    let requestUrl = URLRequest(url: pathUrl)
    
    webview.scrollView.contentInset = UIEdgeInsets.zero;
    webview.loadRequest(requestUrl)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func alert(message: String) {
    DispatchQueue.main.async(execute: {
      let ac = UIAlertController(title: "invokedByJavaScript", message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: "ok", style: .default)
      ac.addAction(action)
      self.present(ac, animated: true)
    })
  }
  
  @objc func clearInput() {
    webview.stringByEvaluatingJavaScript(from: "clearInput()")
  }
}

extension UIWebViewWithInterceptRequest: UIWebViewDelegate {
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    self.navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
  }
  
  func webView(_ webView: UIWebView,
               shouldStartLoadWith request: URLRequest,
               navigationType: UIWebViewNavigationType) -> Bool {
    
    print("*** scheme: \((request.url?.scheme)! as String)")
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Clear Input",
      style: .plain,
      target: self,
      action: #selector(clearInput)
    )
    
    if request.url != nil &&
       request.url?.scheme == "jsbridge" {
      
      let fullURL = request.url?.absoluteString as String!
      
      // let query = request.url?.query
      
      if let method = request.url?.host, method == "alert" {
        let queryItems = URLComponents(string: fullURL!)!.queryItems!
        let param1 = queryItems.filter({$0.name == "param1"}).first!
        let value1:String = param1.value as String!
        
        alert(message: "\(value1)")
      }
      return false
    }
    return true
  }
}
