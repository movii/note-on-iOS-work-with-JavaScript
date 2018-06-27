//
//  UIWebViewWithJavaScriptCore.swift
//  Interactive iOS with JavaScript
//
//  Created by Lien on 13/04/2017.
//  Copyright © 2017 mo.strangline. All rights reserved.
//

import UIKit
import JavaScriptCore

class UIWebViewWithJavaScriptCore:UIViewController {
  
  @IBOutlet weak var webview: UIWebView!
  
  var context:JSContext?
  
  @IBAction func refreshWebView() {
    webview.reload()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let path = Bundle.main.path(forResource: "html/uiwebview_with_javascriptcore", ofType: "html")
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
  
  @objc func clearInput() {
    context!.objectForKeyedSubscript("clearInput").call(withArguments: [])
  }
}

extension UIWebViewWithJavaScriptCore: UIWebViewDelegate {
  func webViewDidFinishLoad(_ webView: UIWebView) {
    self.navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    
    context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Clear Input",
      style: .plain,
      target: self,
      action: #selector(clearInput)
    )
    
    let callBack : @convention(block) (String?) -> Void = { paramFromJS in
      print("*** parameters from: \(paramFromJS ?? "default value" as String)")
      let msg = "\(paramFromJS ?? "default value" as String)"
      self.alert(message: msg)
    }
    
    context?.setObject(
      unsafeBitCast(callBack, to: AnyObject.self),
      forKeyedSubscript: "invokeNative" as NSCopying & NSObjectProtocol
    )
  }
}
