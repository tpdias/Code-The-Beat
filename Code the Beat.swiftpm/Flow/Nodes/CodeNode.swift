import SwiftUI
import SpriteKit

class CodeNode: SKNode {
    var codeTextPink: SKLabelNode
    var codeTextBlue: SKLabelNode
    var codeTextPurple: SKLabelNode
    var codeTextWhite: SKLabelNode
    var codeTextEquals: SKLabelNode
    
    var codeTextArray: SKLabelNode
    var arrayLineCount: CGFloat = 2.0
    var fontSize: CGFloat
    var baselineOffset: CGFloat
    
    init(varOrLet: String, name: String,type: Bool, equals: Bool, value: String, fontSize: CGFloat) {
        self.fontSize = fontSize
        self.baselineOffset = fontSize / 6 // Pequeno ajuste para equalizar alturas
        
        codeTextPink = SKLabelNode(text: varOrLet)
        codeTextPink.fontColor = UIColor(AppColors.secondary)
        codeTextPink.fontName = AppManager.shared.appFont
        codeTextPink.fontSize = fontSize
        codeTextPink.horizontalAlignmentMode = .left
        codeTextPink.verticalAlignmentMode = .baseline
        codeTextPink.position = CGPoint(x: 0, y: baselineOffset)
        
        codeTextBlue = SKLabelNode(text: "\(name)")
        codeTextBlue.fontColor = UIColor(AppColors.primary)
        codeTextBlue.fontName = AppManager.shared.appFont
        codeTextBlue.fontSize = fontSize
        codeTextBlue.horizontalAlignmentMode = .left
        codeTextBlue.verticalAlignmentMode = .baseline
        codeTextBlue.position = CGPoint(x: codeTextPink.frame.maxX + fontSize, y: baselineOffset)
        
        codeTextPurple = SKLabelNode(text: "String")
        codeTextPurple.fontColor = .purple
        codeTextPurple.fontName = AppManager.shared.appFont
        codeTextPurple.fontSize = fontSize
        codeTextPurple.horizontalAlignmentMode = .left
        codeTextPurple.verticalAlignmentMode = .baseline
        codeTextPurple.position = CGPoint(x: codeTextBlue.frame.maxX + fontSize, y: baselineOffset) 
        
        codeTextEquals = SKLabelNode(text: equals ? "=" : "")
        codeTextEquals.fontColor = .white
        codeTextEquals.fontName = AppManager.shared.appFont
        codeTextEquals.fontSize = fontSize
        codeTextEquals.horizontalAlignmentMode = .left
        codeTextEquals.verticalAlignmentMode = .baseline
        if(type) {
            codeTextEquals.position = CGPoint(x: codeTextPurple.frame.maxX + fontSize, y: baselineOffset)
        } else {
            codeTextEquals.position = CGPoint(x: codeTextBlue.frame.maxX + fontSize, y: baselineOffset)
        }
        
        codeTextWhite = SKLabelNode(text: "\"\(value)\"")
        codeTextWhite.fontColor = .orange
        codeTextWhite.fontName = AppManager.shared.appFont
        codeTextWhite.fontSize = fontSize
        codeTextWhite.horizontalAlignmentMode = .left
        codeTextWhite.verticalAlignmentMode = .baseline
        codeTextWhite.position = CGPoint(x: codeTextEquals.frame.maxX + fontSize, y: baselineOffset)
        
        codeTextArray = SKLabelNode(text: "[]")
        codeTextArray.fontColor = .white
        codeTextArray.fontName = AppManager.shared.appFont
        codeTextArray.fontSize = fontSize
        codeTextArray.horizontalAlignmentMode = .left
        codeTextArray.verticalAlignmentMode = .baseline
        codeTextArray.position = CGPoint(x: codeTextEquals.frame.maxX + fontSize, y: baselineOffset)
        
        super.init()
        
        if(type) {
            addChild(codeTextPurple)
        }
        addChild(codeTextPink)
        addChild(codeTextBlue)
        addChild(codeTextWhite)
        addChild(codeTextEquals)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupArray() {
        self.codeTextWhite.removeFromParent()
        self.codeTextBlue.fontSize = fontSize
        self.codeTextPink.fontSize = fontSize
        self.codeTextArray.fontSize = fontSize
        self.codeTextEquals.fontSize = fontSize
        addChild(codeTextArray)
        let secondLine = CodeNode(varOrLet: "", name: "chordsArray", type: false, equals: true, value: "", fontSize: fontSize)
        secondLine.codeTextWhite.text = "[\" \", \" \", \" \", \" \"]"
        secondLine.position = CGPoint(x: 0 - 25, y: 0 - baselineOffset * (arrayLineCount - 1) - fontSize * 1.2 * (arrayLineCount - 1))
        secondLine.codeTextWhite.fontColor = .white
        addChild(secondLine)
    }
    
    func addElementArray(element: String, index: Int) {
        checkMaxLines()
        let codeTextAddElement = SKLabelNode(text: "chordArray.insert(\"\(element)\", at: \(index))")
        codeTextAddElement.fontColor = UIColor(AppColors.primary)
        codeTextAddElement.fontName = AppManager.shared.appFont
        codeTextAddElement.fontSize = fontSize
        codeTextAddElement.horizontalAlignmentMode = .left
        codeTextAddElement.verticalAlignmentMode = .baseline
        codeTextAddElement.position = CGPoint(x: 0, y: 0 - baselineOffset * arrayLineCount - fontSize * 1.2 * arrayLineCount)
        codeTextAddElement.name = "element"
        arrayLineCount += 1
        addChild(codeTextAddElement)
    }
    
    func removeElementArray(index: Int) {
        checkMaxLines()
        let codeTextAddElement = SKLabelNode(text: "chordArray.remove(at: \(index))")
        codeTextAddElement.fontColor = UIColor(AppColors.primary)
        codeTextAddElement.fontName = AppManager.shared.appFont
        codeTextAddElement.fontSize = fontSize
        codeTextAddElement.horizontalAlignmentMode = .left
        codeTextAddElement.verticalAlignmentMode = .baseline
        codeTextAddElement.position = CGPoint(x: 0, y: 0 - baselineOffset * arrayLineCount - fontSize * 1.2 * arrayLineCount)
        codeTextAddElement.name = "element"
        arrayLineCount += 1
        addChild(codeTextAddElement)
    }
    
    func checkMaxLines() {
        if(children.count >= 12) {
//            var count = 0.0
//            for child in children {
//                guard let name = child.name else { continue }
//                if name.contains("element") {
//                    child.removeFromParent()
//                    count += 1
//                }
//            }
//            arrayLineCount -= count
            removeAllChildren()
            arrayLineCount = 0
        }
    }
    func defineVariableVelue(value: String) {
        codeTextWhite.text = "\"\(value)\""
    }   
}
