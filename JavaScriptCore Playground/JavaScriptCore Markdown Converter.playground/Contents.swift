//: Playground - noun: a place where people can play

import JavaScriptCore

let context: JSContext = JSContext()!

let mdConverterPath = Bundle.main.path(
  forResource: "Markdown.Converter",
  ofType: "js",
  inDirectory: "pagedown"
)!

let contentData = FileManager.default.contents(
  atPath: mdConverterPath
)!

let content = String(
  data: contentData,
  encoding: String.Encoding.utf8
)

context.evaluateScript(content)

let script =
  "var converter = new Markdown.Converter();" +
  "var markdownText = \"# Hello World\";" +
  "converter.makeHtml(markdownText)"

context.evaluateScript(script)

// encoding and decoding URL in SWIFT 
"Hi%20Lien".removingPercentEncoding
