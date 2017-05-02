//
//  NativeInvokeJavaScript.swift
//  wkwebview playground
//
//  Created by Lien on 2017/3/31.
//  Copyright © 2017年 Lien. All rights reserved.
//

import UIKit

class NativeInvokeJavaScriptViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SayHello" ||
       segue.identifier == "SayHelloTo" ||
       segue.identifier == "SayHelloToWithReply" {
      
      let navigationVC = segue.destination as! UINavigationController
      let wxWebViewVC = navigationVC.topViewController as! NativeInvokeJavaScriptBrowserViewController
      
      switch segue.identifier! {
        case "SayHelloTo": wxWebViewVC.requestJavaScriptMethod = "SayHelloTo"
        case "SayHelloToWithReply": wxWebViewVC.requestJavaScriptMethod = "SayHelloToWithReply"
        default: wxWebViewVC.requestJavaScriptMethod = "SayHello" // "SayHello"
      }
      
      
    }
  }
  
}

