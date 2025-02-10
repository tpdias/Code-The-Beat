import SwiftUI
import SpriteKit
import UIKit

class FuncDeclarationNode: SKNode {
    var codeTextPink: SKLabelNode
    var codeTextBlue: SKLabelNode    
    var funcBody1: FuncNode
    var funcBody2: FuncNode
    var funcBody3: FuncNode
    var funcEnding: SKLabelNode
    
    var funcCall: SKLabelNode
    
    override init() {
        let fontSize = AppManager.shared.fontSize
        let baselineOffset = fontSize / 6 // Pequeno ajuste para equalizar alturas
        
        codeTextPink = SKLabelNode(text: "func")
        codeTextPink.fontName = AppManager.shared.appFont
        codeTextPink.fontColor = UIColor(AppColors.secondary)
        codeTextPink.fontSize = fontSize
        codeTextPink.horizontalAlignmentMode = .left
        codeTextPink.verticalAlignmentMode = .baseline
        codeTextPink.position = CGPoint(x: 0, y: baselineOffset)
        
        codeTextBlue = SKLabelNode(text: " playChordGMaj() {")
        codeTextBlue.fontColor = UIColor(AppColors.primary)
        codeTextBlue.fontName = AppManager.shared.appFont
        codeTextBlue.fontSize = fontSize
        codeTextBlue.horizontalAlignmentMode = .left
        codeTextBlue.verticalAlignmentMode = .baseline
        codeTextBlue.position = CGPoint(x: codeTextPink.frame.maxX + fontSize, y: baselineOffset)
        
        funcBody1 = FuncNode(funcText: "playSound(note: ", value: "G")
        funcBody2 = FuncNode(funcText: "playSound(note: ", value: "B")
        funcBody3 = FuncNode(funcText: "playSound(note: ", value: "D")
        
        funcBody1.position = CGPoint(x: 0, y: baselineOffset - fontSize * 1.5)
        funcBody2.position = CGPoint(x: 0, y: baselineOffset - fontSize * 3)
        funcBody3.position = CGPoint(x: 0, y: baselineOffset - fontSize * 4.5)
        
        funcEnding = SKLabelNode(text: "}")
        funcEnding.fontColor = UIColor(AppColors.primary)
        funcEnding.fontName = AppManager.shared.appFont
        funcEnding.fontSize = fontSize
        funcEnding.horizontalAlignmentMode = .left
        funcEnding.verticalAlignmentMode = .baseline
        funcEnding.position = CGPoint(x: 0, y: baselineOffset - fontSize * 6)
        
        funcCall = SKLabelNode(text: "playChordGMaj()") 
        funcCall.fontColor = UIColor(AppColors.primary)
        funcCall.fontName = AppManager.shared.appFont
        funcCall.fontSize = fontSize
        funcCall.horizontalAlignmentMode = .left
        funcCall.verticalAlignmentMode = .baseline
        funcCall.position = CGPoint(x: 0, y: baselineOffset - fontSize * 7.5)
        
        super.init()
        
        addChild(codeTextPink)
        addChild(funcBody1)
        addChild(funcBody2)
        addChild(funcBody3)
        addChild(codeTextBlue)
        addChild(funcCall)
        addChild(funcEnding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
