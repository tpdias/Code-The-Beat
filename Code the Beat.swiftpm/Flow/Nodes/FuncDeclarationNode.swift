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
    
    init(chord: String, note1: String, note2: String, note3: String) {
        let fontSize = AppManager.shared.fontSize
        let baselineOffset = fontSize / 6 // Pequeno ajuste para equalizar alturas
        
        codeTextPink = SKLabelNode(text: "func")
        codeTextPink.fontName = AppManager.shared.appFont
        codeTextPink.fontColor = UIColor(AppColors.secondary)
        codeTextPink.fontSize = fontSize
        codeTextPink.horizontalAlignmentMode = .left
        codeTextPink.verticalAlignmentMode = .baseline
        codeTextPink.position = CGPoint(x: 0, y: baselineOffset)
        
        codeTextBlue = SKLabelNode(text: " playChord\(chord)() {")
        codeTextBlue.fontColor = UIColor(AppColors.primary)
        codeTextBlue.fontName = AppManager.shared.appFont
        codeTextBlue.fontSize = fontSize
        codeTextBlue.horizontalAlignmentMode = .left
        codeTextBlue.verticalAlignmentMode = .baseline
        codeTextBlue.position = CGPoint(x: codeTextPink.frame.maxX + fontSize, y: baselineOffset)
        
        funcBody1 = FuncNode(funcText: "playSound(note: ", value: "\(note1)")
        funcBody2 = FuncNode(funcText: "playSound(note: ", value: "\(note2)")
        funcBody3 = FuncNode(funcText: "playSound(note: ", value: "\(note3)")
        
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
        
        funcCall = SKLabelNode(text: "playChord\(chord)()") 
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
    
    func changeChord(chord: String, note1: String, note2: String, note3: String) {
        codeTextBlue.text = " playChord\(chord)() {"
        funcBody1.defineVariableVelue(value: note1)
        funcBody2.defineVariableVelue(value: note2)
        funcBody3.defineVariableVelue(value: note3)
        funcCall.text = "playChord\(chord)()"
    }
    
}
