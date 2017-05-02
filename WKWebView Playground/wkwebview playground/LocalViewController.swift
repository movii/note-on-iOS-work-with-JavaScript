//
//  LocalViewController.swift
//  wkwebview playground
//
//  Created by Lien on 2017/3/28.
//  Copyright © 2017年 Lien. All rights reserved.
//

import UIKit
import WebKit

class LocalViewController: UIViewController {
  
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
  
  override func viewDidLayoutSubviews() {
    let htmlPath = "html/index"
    let filePath = Bundle.main.path(forResource: htmlPath, ofType: "html")
    let fileURL = URL(fileURLWithPath: filePath!)

    wkWebView.load(URLRequest(url: fileURL))
  }
}

extension LocalViewController: WKNavigationDelegate {

}

// WKWebView's WKUIDelegate Protocol
extension LocalViewController: WKUIDelegate {
  // read browser's window.alert() message
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
  
  // read browser' s window.confirm() message
  func webView(_ webView: WKWebView,
               runJavaScriptConfirmPanelWithMessage message: String,
               initiatedByFrame frame: WKFrameInfo,
               completionHandler: @escaping (Bool) -> Void) {
    
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
    
    alertController.addAction(
      UIAlertAction(title: "OK", style: .default, handler: { (action) in
        completionHandler(true)
      })
    )
    
    alertController.addAction(
      UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        completionHandler(false)
      })
    )
    
    present(alertController, animated: true, completion: nil)
  }
  
  // read browser's widnow.prompt() message
  func webView(_ webView: WKWebView,
               runJavaScriptTextInputPanelWithPrompt prompt: String,
               defaultText: String?,
               initiatedByFrame frame: WKFrameInfo,
               completionHandler: @escaping (String?) -> Void) {
    
    let title = "Intercept Prompt"
    let message = "Intercept Window.prompt() from JavaScript, original msg is: \(prompt)"
    let cancelButtonTitle = "Cancel"
    let otherButtonTitle = "Ok"
    
    
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    ac.addTextField { textField in
      if let defaultText = defaultText, defaultText.characters.count <= 0 {
        textField.placeholder = "first textField's placeholder"
      }
      else {
        textField.text = defaultText
      }
    }
    
    ac.addTextField { textField in
      textField.placeholder = "second UITextField's placeholder"
    }
    
    let otherAction = UIAlertAction(title: otherButtonTitle, style: .default) { _ in
      NSLog("\"Ok\" has been pressed.")
      let firstTextField = ac.textFields![0] as UITextField
      let secondTextField = ac.textFields![1] as UITextField
      
      print("firstName \(firstTextField.text ?? "firstName"), secondName \(secondTextField.text ?? "secondName")")
      completionHandler(nil)
    }
    
    let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
      NSLog("\"Cancel\" has been pressed.")
      completionHandler(nil)
    }
    
    ac.addAction(otherAction)
    ac.addAction(cancelAction)
    
    present(ac, animated: true, completion: nil)
  }
}

extension LocalViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    print("message")
  }
}
