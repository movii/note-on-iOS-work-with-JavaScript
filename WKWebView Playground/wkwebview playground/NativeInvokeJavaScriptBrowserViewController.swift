//
//  NativeInvokeJavaScriptBrowserViewController.swift
//  wkwebview playground
//
//  Created by Lien on 2017/3/31.
//  Copyright © 2017年 Lien. All rights reserved.
//

import UIKit
import WebKit

class NativeInvokeJavaScriptBrowserViewController: UIViewController {
  
  var requestJavaScriptMethod: String?
  var wkWebView: WKWebView!
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    wkWebView = WKWebView(
      frame: CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: CGSize(
          width: self.view.bounds.size.width,
          height: self.view.bounds.size.height
        )
      )
    )
    
    wkWebView.navigationDelegate = self
    wkWebView.uiDelegate = self
    
    self.view.addSubview(wkWebView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let htmlPath = "html/native_invoke_javascript"
    let filePath = Bundle.main.path(forResource: htmlPath, ofType: "html")
    let fileURL = URL(fileURLWithPath: filePath!)
    
    wkWebView.load(URLRequest(url: fileURL))
  }
  
  @IBAction func done() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
  }
}

extension NativeInvokeJavaScriptBrowserViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    switch requestJavaScriptMethod!
    {
      case "SayHelloTo":
        wkWebView.evaluateJavaScript("sayHelloTo('Lien')")
      
      case "SayHelloToWithReply":
        wkWebView.evaluateJavaScript("sayHelloToWithReply('Lien')") { (any,error) -> Void in
          print("\(any as! String)")
          // self.dismiss(animated: true, completion: nil)
        }
      
      default:
        wkWebView.evaluateJavaScript("sayHello()")
    }
  }
}

extension NativeInvokeJavaScriptBrowserViewController: WKUIDelegate {
  // read browser's window.alert() message
  func webView(_ webView: WKWebView,
               runJavaScriptAlertPanelWithMessage message: String,
               initiatedByFrame frame: WKFrameInfo,
               completionHandler: @escaping () -> Void) {
    
    let ac = UIAlertController(
      title: "Navtive invoke JavaScript",
      message: "\(message)",
      preferredStyle: .alert
    )
    
    ac.addAction(UIAlertAction(title: "好", style: .default, handler: { action in
      completionHandler()
    }))
    
    self.present(ac, animated: true)
  }
}
