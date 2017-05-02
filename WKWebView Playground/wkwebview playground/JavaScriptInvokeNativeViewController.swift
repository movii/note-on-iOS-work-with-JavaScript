//
//  JavaScriptInvokeNativeViewController.swift
//  wkwebview playground
//
//  Created by Lien on 2017/4/1.
//  Copyright © 2017年 Lien. All rights reserved.
//

import UIKit
import WebKit

class JavaScriptInvokeNativeViewController: UIViewController {
  var wkWebView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let wkConfig = WKWebViewConfiguration()
    
    let wkPreference = WKPreferences()
    wkPreference.javaScriptEnabled = true
    
    // 注册
    let wkUserContentController = WKUserContentController()
    
    // 注册 message handler
    wkUserContentController.add(self as WKScriptMessageHandler, name: "WKMesesgaSignal")
    
    // 注册 WKWebView 自定义 script 文件
    let userScript = loadUserScript(with: "html/user_script")
    wkUserContentController.addUserScript(userScript)
    
    wkConfig.userContentController = wkUserContentController
    wkConfig.preferences = wkPreference
    
    wkWebView = WKWebView(frame: self.view.frame, configuration: wkConfig)
    
    wkWebView.navigationDelegate = self

    self.view.addSubview(wkWebView)
    wkWebView.load(URLRequest(url: URL(string: "https://m.douban.com")!))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func loadUserScript(with path: String) -> WKUserScript {
    let filePath = Bundle.main.path(forResource: path, ofType: "js")
    var script:String?
    
    do {
      script = try String(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
    }
    catch { print("Cannot Load File") }
    
    return WKUserScript(
      source: script!,
      injectionTime: .atDocumentEnd,
      forMainFrameOnly: true
    )
  }
}

extension JavaScriptInvokeNativeViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    self.navigationItem.title = self.wkWebView.title
    wkWebView.evaluateJavaScript("changePageBackgroundColor()")
    wkWebView.evaluateJavaScript("addFakeSignalButton()")
  }
}

extension JavaScriptInvokeNativeViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController,
                             didReceive message: WKScriptMessage) {
    
    let Dict = message.body as! Dictionary<String, String>
    
    var title: String?
    var desc: String?
    
    for (key, value) in Dict {
      if key == "title" {
          title = value
      }
      
      if key == "desc" {
        desc = value
      }
    }
    
    let ac = UIAlertController(title: title!, message: desc!, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default))
    self.present(ac, animated: true)
  }
}
