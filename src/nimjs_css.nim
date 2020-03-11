import jsffi

type
  CSSRule* = ref object of JsObject
    cssText* {.importc.}: string
    typ* {.importc:"type".} : string
  CSSRuleList* = ref object of JsObject
    length* {.importc.}: int
  StyleSheet* = ref object of JsObject
    cssRules* {.importc.}: CSSRuleList
    ownerRule* {.importc.}: JsObject
    disabled* {.importc.}: bool
    href* {.importc.}: JsObject
    ownerNode*  {.importc.}: JsObject
    parentStyleSheet* {.importc.}: JsObject
    title* {.importc.}: JsObject
  StyleSheetList* = ref object of JsObject
    length* {.importc.}: int

var document {.importc:"document", nodecl.}:JsObject 
var styleSheets* {.importc:"document.styleSheets".} :StyleSheetList

proc `[]`*(list: StyleSheetList, index:int):StyleSheet {.importcpp:"#[@]".}
proc `[]`*(list: CSSRuleList, index:int):CSSRule {.importcpp:"#[@]".}

proc getSheet*(index=0): StyleSheet =
  ## return `index`ed stylesheet
  styleSheets[index]

proc sheet0*(): StyleSheet =
  ## return stylesheet 0, create if necessary
  if styleSheets.length == 0:
    let style = document.createElement("style")
    document.head.appendChild(style)
  styleSheets[0]

proc insertRule*(sheet: StyleSheet, rule:cstring, index=0):int {.importcpp:"#.insertRule(@)", discardable.}
proc addRule*(sheet: StyleSheet, selector, ruleSetsOrAtRules:cstring) {.importcpp:"#.addRule(@)".}
proc deleteRule*(sheet: StyleSheet, index:int) {.importcpp:"#.deleteRule(@)".}

proc addCSS*(css:cstring)=
  ## addCSS as new `style` element in `html.head`
  var style = document.createElement("style")
  style.`type` = cstring"text/css"
  style.innerText = css
  document.head.appendChild(style)
