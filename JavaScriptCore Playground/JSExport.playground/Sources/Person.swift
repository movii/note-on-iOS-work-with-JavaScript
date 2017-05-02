import Foundation
import JavaScriptCore

@objc protocol PersonJavaScritMethod : JSExport {
  static func sayHello() -> String
  static func sayHello(name: String) -> String
}

public class Person : NSObject, PersonJavaScritMethod {
  public static func sayHello() -> String { return "Hello" }
  public static func sayHello(name: String) -> String { return "Hello \(name)" }
}
