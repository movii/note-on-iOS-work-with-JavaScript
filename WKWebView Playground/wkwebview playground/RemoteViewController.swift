//
//  ViewController.swift
//  wkwebview playground
//
//  Created by Lien on 2017/3/25.
//  Copyright © 2017年 Lien. All rights reserved.
//

import UIKit
import WebKit

class RemoteViewController: UIViewController {
  
  var wkWebView: WKWebView!
  var progressView: UIProgressView!
  
  let keyPathForProgress: String = "estimatedProgress"
  let keyPathForLoading: String = "loading"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 注册
    let wkConfig = WKWebViewConfiguration()
    
    wkConfig.userContentController.add(
      self as WKScriptMessageHandler,
      name: "WKWebViewApp"
    )
    
    navigationController?.isToolbarHidden = true
  
    wkWebView = WKWebView(frame: self.view.frame, configuration: wkConfig)
    wkWebView.navigationDelegate = self
    wkWebView.uiDelegate = self
    
    // add refresh button
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .refresh,
      target: wkWebView,
      action: #selector(wkWebView.reload)
    )
    // add hitory.back button
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "Back",
      style: .plain,
      target: wkWebView,
      action: #selector(wkWebView.goBack)
    )
    
    navigationItem.leftBarButtonItem?.isEnabled = false
    
    progressView = UIProgressView(
      frame: CGRect(
        origin: CGPoint(x: 0, y: 64),
        size: CGSize(width: self.view.frame.width, height: 1)
      )
    )
    
    progressView.tintColor = UIColor.green
    
    //progressView.progress = 0.0
    wkWebView.addObserver(self, forKeyPath: keyPathForProgress, options: [.new, .old], context: nil)
    wkWebView.addObserver(self, forKeyPath: keyPathForLoading, options: .new, context: nil)
    
    let width = self.view.bounds.size.width
    let height = self.view.bounds.size.height
    
    wkWebView.frame = CGRect(
      origin: CGPoint(x: 0, y: 0),
      size: CGSize(width: width, height: height)
    )
    wkWebView.addSubview(progressView)
    self.view.addSubview(wkWebView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLayoutSubviews() {
    let url = URL(string: "https://www.google.com")!
    wkWebView.load(URLRequest(url: url))
    wkWebView.allowsBackForwardNavigationGestures = true
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    
    if keyPath == keyPathForProgress {
      let newProgress = (change![.newKey] as AnyObject).floatValue!
      let oldProgress = (change![.oldKey] as AnyObject).floatValue!
      
      if newProgress < oldProgress {
        return
      }
      
      if newProgress >= 1 {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
      }
      else {
        progressView.isHidden = false
        progressView.setProgress(Float(wkWebView.estimatedProgress), animated: true)
      }
    }
    
    if keyPath == keyPathForLoading {
      if wkWebView.canGoBack {
        showNavigationItemHistoryBackButton()
      }
      else {
        hideNavigationItemHistoryBackButton()
      }
    }
  }
  
  private func hideNavigationItemHistoryBackButton () {
    self.navigationItem.leftBarButtonItem?.isEnabled = false
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
  }
  
  private func showNavigationItemHistoryBackButton () {
    self.navigationItem.leftBarButtonItem?.isEnabled = true
    self.navigationItem.leftBarButtonItem?.tintColor = self.view.tintColor
  }
}

extension RemoteViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    self.navigationItem.title = self.wkWebView.title
    // wkWebView.evaluateJavaScript(
     // "document.querySelector('#gb-main').style.backgroundColor = '#999'")
    // wkWebView.evaluateJavaScript("alert('testing with UIAlertController')", completionHandler: nil)
    // let jsString = "window.webkit.messageHandlers.WKWebViewApp.postMessage({'message1': 'this is message 1', 'message2': 'this is message2'})"
    // wkWebView.evaluateJavaScript(jsString, completionHandler: nil)
  }
}

extension RemoteViewController: WKUIDelegate {
  func webView(_ webView: WKWebView,
               runJavaScriptAlertPanelWithMessage message: String,
               initiatedByFrame frame: WKFrameInfo,
               completionHandler: @escaping () -> Void) {
    completionHandler()
    
    let alert = UIAlertController(
      title: "iOS Alert",
      message: "\(message)",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    
    self.present(alert, animated: true)
  }
}

extension RemoteViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    let Dict = message.body as! Dictionary<String, String>
    print(Dict)
  }
}



