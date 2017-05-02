import Foundation
import JavaScriptCore

let context = JSContext()!

context.setObject(
  Person.self,
  forKeyedSubscript: "Person" as NSCopying & NSObjectProtocol
)

context.evaluateScript(
  "Person.sayHello()"
)
context.evaluateScript(
  "Person.sayHelloWithName('Lien')"
)
