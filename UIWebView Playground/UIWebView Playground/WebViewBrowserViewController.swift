//
//  WebViewBrowserViewController.swift
//  UIWebView Playground
//
//  Created by Lien on 2017/3/18.
//  Copyright © 2017年 mo.strangline. All rights reserved.
//

import UIKit
class WebViewBrowserViewController: ViewController {
  
  var requestURL: URLRequest?
  var requestType: String?
  var sayHello: Bool?
  
  @IBOutlet weak var webviewBrowser: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    handleRequest(requestType: requestType!, requestURL: requestURL!)
  }
  
  @IBAction func done() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
  }
  
  func handleRequest (requestType: String, requestURL: URLRequest) {
    webviewBrowser.loadRequest(requestURL)
  }
}

extension WebViewBrowserViewController: UIWebViewDelegate {
  
  func webView(_ webView: UIWebView,
               shouldStartLoadWith request: URLRequest,
               navigationType: UIWebViewNavigationType) -> Bool {
    
    print("*** scheme: \((request.url?.scheme)! as String)")
    
    if request.url?.scheme == "hello" {
      // let method:String = request.url?.scheme as String!
      print((request.url?.host)! as String )
      
      let path = request.url?.absoluteString as String!
      let msg = String(format: "alert('intercept scheme: %@')", path!)
      
      webviewBrowser.stringByEvaluatingJavaScript(from: msg)
      
      return false
    }
    
    return true
  }
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    if sayHello! {
      let jsString = "alert('UIWebView Start Loading from local file')"
      webviewBrowser.stringByEvaluatingJavaScript(from: jsString)
    }
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    
    if sayHello! {
     // webviewBrowser.stringByEvaluatingJavaScript(from: "alert('UIWebView Did FInish Load.')")
    }
    
    if requestType == "localWithAlertFromFile" {
      do {
        let path = Bundle.main.path(forResource: "webview playground/file", ofType: "js")
        let pathURL = URL(fileURLWithPath: path!)
        let jsString = try String(contentsOf: pathURL, encoding: String.Encoding.utf8)
        webviewBrowser.stringByEvaluatingJavaScript(from: jsString)
        webviewBrowser.stringByEvaluatingJavaScript(from: "sayHelloTo('Lien')")
        let rtnValue = webView.stringByEvaluatingJavaScript(from: "sayHelloWithRtnValue('Lien')")!
        print("returned value from JavaScript: \(rtnValue)")
      }
      catch {}
    }
  }
}
