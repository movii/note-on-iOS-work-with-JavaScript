//
//  UIWebVIewWithJSExport.swift
//  Interactive iOS with JavaScript
//
//  Created by Lien on 201714/04/.
//  Copyright © 2017 mo.strangline. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JSMethodsProtocol: JSExport {
  func alert(message: String)
}

class UIWebVIewWithJSExport: UIViewController, JSMethodsProtocol {
  
  var context:JSContext?
  
  @IBOutlet var webview: UIWebView!
  
  @IBAction func refreshWebView () {
    webview.reload()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let path = Bundle.main.path(forResource: "html/uiwebview_with_jsexport", ofType: "html")
    let pathUrl = URL(fileURLWithPath: path!)
    let requestUrl = URLRequest(url: pathUrl)
    
    webview.loadRequest(requestUrl)
  }
  
  @objc func clearInput() {
    context!.objectForKeyedSubscript("clearInput").call(withArguments: [])
  }
  
  func alert(message: String) {
    print("\(message)")
    DispatchQueue.main.async(execute: {
      let ac = UIAlertController(
        title: "invokedByJavaScript",
        message: message,
        preferredStyle: .alert
      )
      let action = UIAlertAction(title: "ok", style: .default)
      ac.addAction(action)
      self.present(ac, animated: true)
    })
  }
}

extension UIWebVIewWithJSExport: UIWebViewDelegate {
  func webViewDidFinishLoad(_ webView: UIWebView) {
    self.navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    
    context = webView.value(
      forKeyPath: "documentView.webView.mainFrame.javaScriptContext"
    ) as? JSContext
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Clear Input",
      style: .plain,
      target: self,
      action: #selector(clearInput)
    )
    
    context?.setObject(
      self,
      forKeyedSubscript: "jsBridge" as NSCopying & NSObjectProtocol
    )
  }
}
