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
    
    func setupArray(values: [String] = [" ", " ", " ", " "]) {
        self.codeTextWhite.removeFromParent()
        self.codeTextBlue.fontSize = fontSize
        self.codeTextPink.fontSize = fontSize
        self.codeTextArray.fontSize = fontSize
        self.codeTextEquals.fontSize = fontSize
        addChild(codeTextArray)
        arraySecondLine(values: values)
    }
    
    func arraySecondLine(values: [String] = [" ", " ", " ", " "]) {
        let baseX = 0.0
        let baseY = -baselineOffset * (arrayLineCount - 1) - fontSize * 1.2 * (arrayLineCount - 1)
        let spacing = AppManager.shared.fontSize * 0.8  
        
        let chordsArrayLabel = createCodeLabel(text: "chordsArray", color: AppColors.primary, position: CGPoint(x: baseX, y: baseY), fontSize: fontSize)
        
        let equals = createCodeLabel(text: "=", color: .white, position: CGPoint(x: chordsArrayLabel.position.x + chordsArrayLabel.frame.width + spacing, y: baseY), fontSize: fontSize)
        let openBracket = createCodeLabel(text: "[", color: .white, position: CGPoint(x: equals.position.x + equals.frame.width + spacing, y: baseY), fontSize: fontSize)
        
        var valueNodes: [SKLabelNode] = []
        var commaNodes: [SKLabelNode] = []
        
        var currentX = openBracket.position.x + openBracket.frame.width + spacing - 5
        
        for (index, value) in values.enumerated() {
            let valueLabel = createCodeLabel(text: "\"\(value)\"", color: AppColors.secondary, position: CGPoint(x: currentX, y: baseY), fontSize: fontSize)
            valueNodes.append(valueLabel)
            currentX += valueLabel.frame.width + spacing * 0.3
            
            if index < values.count - 1 {
                let commaLabel = createCodeLabel(text: ",", color: .white, position: CGPoint(x: currentX, y: baseY), fontSize: fontSize)
                commaNodes.append(commaLabel)
                currentX += commaLabel.frame.width + spacing * 0.3
            }
        }
        
        let closeBracket = createCodeLabel(text: "]", color: .white, position: CGPoint(x: currentX, y: baseY), fontSize: fontSize)
        
        addChild(chordsArrayLabel)
        addChild(equals)
        addChild(openBracket)
        valueNodes.forEach { addChild($0) }
        commaNodes.forEach { addChild($0) }
        addChild(closeBracket)
    }

    
    func addElementArray(element: String, index: Int) {
        checkMaxLines()
        let codeTextAddElement = SKLabelNode(text: "chordArray.insert(")
        codeTextAddElement.fontColor = UIColor(AppColors.primary)
        codeTextAddElement.fontName = AppManager.shared.appFont
        codeTextAddElement.fontSize = fontSize
        codeTextAddElement.horizontalAlignmentMode = .left
        codeTextAddElement.verticalAlignmentMode = .baseline
        codeTextAddElement.position = CGPoint(x: 0, y: 0 - baselineOffset * arrayLineCount - fontSize * 1.2 * arrayLineCount)
        codeTextAddElement.name = "element"
        
        let element = SKLabelNode(text: "\"\(element)\"")
        element.fontSize = fontSize
        element.fontName = AppManager.shared.appFont
        element.fontColor = .orange
        element.horizontalAlignmentMode = .left
        element.verticalAlignmentMode = .baseline
        element.position = CGPoint(x: codeTextAddElement.frame.maxX, y: codeTextAddElement.position.y)
        
        let middleText = SKLabelNode(text: ", at:")
        middleText.fontSize = fontSize
        middleText.fontName = AppManager.shared.appFont
        middleText.fontColor = UIColor(AppColors.primary)
        middleText.horizontalAlignmentMode = .left
        middleText.verticalAlignmentMode = .baseline
        middleText.position = CGPoint(x: element.frame.maxX, y: element.position.y)
        
        let position = SKLabelNode(text: " \(index)")
        position.fontSize = fontSize
        position.fontName = AppManager.shared.appFont
        position.fontColor = UIColor(AppColors.tertiary)
        position.horizontalAlignmentMode = .left
        position.verticalAlignmentMode = .baseline
        position.position = CGPoint(x: middleText.frame.maxX + fontSize, y: middleText.position.y)
        
        let endText = SKLabelNode(text: ")")
        endText.fontSize = fontSize
        endText.fontName = AppManager.shared.appFont
        endText.fontColor = UIColor(AppColors.primary)
        endText.horizontalAlignmentMode = .left
        endText.verticalAlignmentMode = .baseline
        endText.position = CGPoint(x: position.frame.maxX, y: position.position.y)
        
        
        arrayLineCount += 1
        addChild(codeTextAddElement)
        addChild(element)
        addChild(middleText)
        addChild(position)
        addChild(endText)
    }
    
    func removeElementArray(index: Int) {
        checkMaxLines()
        let codeTextAddElement = SKLabelNode(text: "chordArray.remove(at:")
        codeTextAddElement.fontColor = UIColor(AppColors.primary)
        codeTextAddElement.fontName = AppManager.shared.appFont
        codeTextAddElement.fontSize = fontSize
        codeTextAddElement.horizontalAlignmentMode = .left
        codeTextAddElement.verticalAlignmentMode = .baseline
        codeTextAddElement.position = CGPoint(x: 0, y: 0 - baselineOffset * arrayLineCount - fontSize * 1.2 * arrayLineCount)
        codeTextAddElement.name = "element"

        let position = SKLabelNode(text: " \(index)")
        position.fontSize = fontSize
        position.fontName = AppManager.shared.appFont
        position.fontColor = UIColor(AppColors.tertiary)
        position.horizontalAlignmentMode = .left
        position.verticalAlignmentMode = .baseline
        position.position = CGPoint(x: codeTextAddElement.frame.maxX + fontSize, y: codeTextAddElement.position.y)
        
        let endText = SKLabelNode(text: ")")
        endText.fontSize = fontSize
        endText.fontName = AppManager.shared.appFont
        endText.fontColor = UIColor(AppColors.primary)
        endText.horizontalAlignmentMode = .left
        endText.verticalAlignmentMode = .baseline
        endText.position = CGPoint(x: position.frame.maxX, y: position.position.y)
        
        
        arrayLineCount += 1
        addChild(position)
        addChild(codeTextAddElement)
        addChild(endText)
    }
    
    func checkMaxLines() {
        if(children.count >= 45) {
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
