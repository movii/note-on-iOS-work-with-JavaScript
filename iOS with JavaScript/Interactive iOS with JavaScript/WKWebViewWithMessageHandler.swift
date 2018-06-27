//
//  WKWebViewWithMessageHandler.swift
//  Interactive iOS with JavaScript
//
//  Created by Lien on 201714/04/.
//  Copyright © 2017 mo.strangline. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewWithMessageHandler: UIViewController {
  var wkWebView: WKWebView!
  
  @IBAction func refreshWkWebView () {
    wkWebView.reload()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let wkConfig = WKWebViewConfiguration()
    
    let wkPreference = WKPreferences()
    wkPreference.javaScriptEnabled = true
    
    let wkUserContentController = WKUserContentController()
    wkUserContentController.add(
      self as WKScriptMessageHandler,
      name: "WKMesesgaSignal"
    )
    
    wkConfig.userContentController = wkUserContentController
    wkConfig.preferences = wkPreference
    
    wkWebView = WKWebView(frame: self.view.frame, configuration: wkConfig)
    navigationController?.isToolbarHidden = true
    
    wkWebView.navigationDelegate = self
    wkWebView.uiDelegate = self
    
    let width = self.view.bounds.size.width
    let height = self.view.bounds.size.height
    
    wkWebView.frame = CGRect(
      origin: CGPoint(x: 0, y: 0),
      size: CGSize(width: width, height: height)
    )
    
    self.view.addSubview(wkWebView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let htmlPath = "html/wkwebview_with_message_handler"
    let filePath = Bundle.main.path(forResource: htmlPath, ofType: "html")
    let fileURL = URL(fileURLWithPath: filePath!)
    
    wkWebView.load(URLRequest(url: fileURL))
  }
  
  @objc func clearInput () {
    wkWebView.evaluateJavaScript("clearInput()")
  }
}

extension WKWebViewWithMessageHandler: WKUIDelegate {
  func webView(_ webView: WKWebView,
               runJavaScriptAlertPanelWithMessage message: String,
               initiatedByFrame frame: WKFrameInfo,
               completionHandler: @escaping () -> Void) {
    
    
    let ac = UIAlertController(title: "read alert() message from html", message: "\(message)", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "好", style: .default, handler: { action in
      completionHandler()
    }))
    
    self.present(ac, animated: true)
  }
}

extension WKWebViewWithMessageHandler: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    self.navigationItem.title = self.wkWebView.title
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Clear Input",
      style: .plain,
      target: self,
      action: #selector(clearInput)
    )
  }
}

extension WKWebViewWithMessageHandler: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController,
                             didReceive message: WKScriptMessage) {
    
    let msg = message.body as! String
    
    print(msg)
    
    let ac = UIAlertController(title: msg, message: msg, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default))
    self.present(ac, animated: true)
  }
}
