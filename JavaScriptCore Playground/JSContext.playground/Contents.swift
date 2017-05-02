//: Playground - noun: a place where people can play

import UIKit
import JavaScriptCore

let context: JSContext = JSContext()
let result: JSValue = context.evaluateScript("1+3")

let resultOfType = context.evaluateScript("let num1 = 10, num2 = 20")

let result4 = context.evaluateScript(
  "function sum(num1, num2) { return num1 + num2 }"
)

let result2 = context.evaluateScript("sum(num1, num2)")

let JSString1 = "(function () { return 'jsResult1' })"
let jsString2 = "function () { return 'jsResult2' }"

context.evaluateScript(JSString1)
context.evaluateScript(jsString2)

let squareFunc = context.objectForKeyedSubscript("sum")
let result3 = squareFunc?.call(withArguments: [10, 20]).toString()
