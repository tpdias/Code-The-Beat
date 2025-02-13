import SwiftUI
import SpriteKit

class FuncNode: SKNode {
    var codeTextBlue: SKLabelNode
    var codeTextWhite: SKLabelNode
    var codeTextFinalParenteses: SKLabelNode
    init(funcText: String, value: String, fontSize: CGFloat = AppManager.shared.fontSize) {
        let fontSize = fontSize
        let baselineOffset = fontSize / 6 // Pequeno ajuste para equalizar alturas
        
        codeTextBlue = SKLabelNode(text: funcText)
        codeTextBlue.fontColor = UIColor(AppColors.primary)
        codeTextBlue.fontName = AppManager.shared.appFont
        codeTextBlue.fontSize = fontSize
        codeTextBlue.horizontalAlignmentMode = .left
        codeTextBlue.verticalAlignmentMode = .baseline
        codeTextBlue.position = CGPoint(x: 0, y: baselineOffset)
        
        codeTextWhite = SKLabelNode(text: "\"\(value)\"")
        codeTextWhite.fontColor = .orange
        codeTextWhite.fontName = AppManager.shared.appFont
        codeTextWhite.fontSize = fontSize
        codeTextWhite.horizontalAlignmentMode = .left
        codeTextWhite.verticalAlignmentMode = .baseline
        codeTextWhite.position = CGPoint(x: codeTextBlue.frame.maxX + fontSize, y: baselineOffset)
        
        codeTextFinalParenteses = SKLabelNode(text: ")")
        codeTextFinalParenteses.fontColor = UIColor(AppColors.primary)
        codeTextFinalParenteses.fontName = AppManager.shared.appFont
        codeTextFinalParenteses.fontSize = fontSize
        codeTextFinalParenteses.horizontalAlignmentMode = .left
        codeTextFinalParenteses.verticalAlignmentMode = .baseline
        codeTextFinalParenteses.position = CGPoint(x: codeTextWhite.frame.maxX, y: baselineOffset)
        
        super.init()
        
        
        addChild(codeTextBlue)
        addChild(codeTextWhite)
        addChild(codeTextFinalParenteses)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defineVariableVelue(value: String) {
        codeTextWhite.text = "\"\(value)\""
    } 
}
