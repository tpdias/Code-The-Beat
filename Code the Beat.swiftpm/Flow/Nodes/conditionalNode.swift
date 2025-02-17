import SwiftUI
import SpriteKit

class ConditionalNode: SKNode {
    let fontSize = AppManager.shared.fontSize - 4
    let lineSpacing = AppManager.shared.fontSize * 1.5
    let indentSpacing = AppManager.shared.fontSize * 1.5
    let baseX: CGFloat = 0
    let baseY: CGFloat = 0
    var drumTemposValues: SKLabelNode = SKLabelNode(text: "")
    
    override init() {
        super.init()
        setupConditionalCode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConditionalCode() {
        // "var" part
        let varBeats = createCodeLabel(text: "var", color: AppColors.secondary, position: CGPoint(x: baseX, y: baseY), fontSize: fontSize)
        let beatsLabel = createCodeLabel(text: "beats", color: AppColors.primary, position: CGPoint(x: varBeats.frame.maxX + 5, y: baseY), fontSize: fontSize)
        let equals1 = createCodeLabel(text: " =", color: .white, position: CGPoint(x: beatsLabel.frame.maxX + 5, y: baseY), fontSize: fontSize)
        let openBracket1 = createCodeLabel(text: " [", color: .white, position: CGPoint(x: equals1.frame.maxX, y: baseY), fontSize: fontSize)
        let beatsValues = createCodeLabel(text: "1, 2, 3, 4", color: .white, position: CGPoint(x: openBracket1.frame.maxX + 5, y: baseY), fontSize: fontSize)
        let closeBracket1 = createCodeLabel(text: "]", color: .white, position: CGPoint(x: beatsValues.frame.maxX, y: baseY), fontSize: fontSize)
        
        let varDrumTempos = createCodeLabel(text: "var", color: AppColors.secondary, position: CGPoint(x: baseX, y: baseY - lineSpacing), fontSize: fontSize)
        let drumTemposLabel = createCodeLabel(text: "drumTempos", color: AppColors.primary, position: CGPoint(x: varDrumTempos.frame.maxX + 5, y: baseY - lineSpacing), fontSize: fontSize)
        let equals2 = createCodeLabel(text: " =", color: .white, position: CGPoint(x: drumTemposLabel.frame.maxX + 5, y: baseY - lineSpacing), fontSize: fontSize)
        let openBracket2 = createCodeLabel(text: " [", color: .white, position: CGPoint(x: equals2.frame.maxX, y: baseY - lineSpacing), fontSize: fontSize)
        self.drumTemposValues = createCodeLabel(text: "[]", color: .white, position: CGPoint(x: openBracket2.frame.maxX + 5, y: baseY - lineSpacing), fontSize: fontSize)
        let closeBracket2 = createCodeLabel(text: "]", color: .white, position: CGPoint(x: drumTemposValues.frame.maxX, y: baseY - lineSpacing), fontSize: fontSize)
        
        let forTempoLabel = createCodeLabel(text: "for", color: AppColors.secondary, position: CGPoint(x: baseX, y: baseY - lineSpacing * 2), fontSize: fontSize)
        let tempoVariable = createCodeLabel(text: " tempo", color: .white, position: CGPoint(x: forTempoLabel.frame.maxX + 5, y: baseY - lineSpacing * 2), fontSize: fontSize)
        let inKeyword = createCodeLabel(text: " in", color: AppColors.secondary, position: CGPoint(x: tempoVariable.frame.maxX + 5, y: baseY - lineSpacing * 2), fontSize: fontSize)
        let beatsArray = createCodeLabel(text: " beats {", color: AppColors.primary, position: CGPoint(x: inKeyword.frame.maxX + 5, y: baseY - lineSpacing * 2), fontSize: fontSize)
        
        let forDrumTempoLabel = createCodeLabel(text: "for", color: AppColors.secondary, position: CGPoint(x: baseX + indentSpacing, y: baseY - lineSpacing * 3), fontSize: fontSize)
        let drumTempoVariable = createCodeLabel(text: " drumTempo", color: .white, position: CGPoint(x: forDrumTempoLabel.frame.maxX + 5, y: baseY - lineSpacing * 3), fontSize: fontSize)
        let inDrumKeyword = createCodeLabel(text: " in", color: AppColors.secondary, position: CGPoint(x: drumTempoVariable.frame.maxX + 5, y: baseY - lineSpacing * 3), fontSize: fontSize)
        let drumTemposArray = createCodeLabel(text: " drumTempos {", color: AppColors.primary, position: CGPoint(x: inDrumKeyword.frame.maxX + 5, y: baseY - lineSpacing * 3), fontSize: fontSize)
        
        let ifLabel = createCodeLabel(text: "if", color: AppColors.secondary, position: CGPoint(x: baseX + indentSpacing * 2, y: baseY - lineSpacing * 4), fontSize: fontSize)
        let conditionLabel = createCodeLabel(text: "(tempo == drumTempo) {", color: .white, position: CGPoint(x: ifLabel.frame.maxX + 5, y: baseY - lineSpacing * 4), fontSize: fontSize)
        
        let playDrumsLabel = createCodeLabel(text: "playDrums()", color: AppColors.primary, position: CGPoint(x: baseX + indentSpacing * 3, y: baseY - lineSpacing * 5), fontSize: fontSize)
        
        let closingBracketIf = createCodeLabel(text: "}", color: AppColors.primary, position: CGPoint(x: baseX + indentSpacing * 2, y: baseY - lineSpacing * 6), fontSize: fontSize)
        
        let closingBracketForDrum = createCodeLabel(text: "}", color: AppColors.primary, position: CGPoint(x: baseX + indentSpacing, y: baseY - lineSpacing * 7), fontSize: fontSize)
        
        let waitLabel = createCodeLabel(text: "wait(seconds: 1)", color: AppColors.primary, position: CGPoint(x: baseX + indentSpacing, y: baseY - lineSpacing * 8), fontSize: fontSize)
        
        let closingBracketForTempo = createCodeLabel(text: "}", color: AppColors.primary, position: CGPoint(x: baseX, y: baseY - lineSpacing * 9), fontSize: fontSize)
        
        let allNodes = [
            varBeats, beatsLabel, equals1, openBracket1, beatsValues, closeBracket1,
            varDrumTempos, drumTemposLabel, equals2, drumTemposValues,
            forTempoLabel, tempoVariable, inKeyword, beatsArray,
            forDrumTempoLabel, drumTempoVariable, inDrumKeyword, drumTemposArray,
            ifLabel, conditionLabel, playDrumsLabel, closingBracketIf, closingBracketForDrum,
            waitLabel, closingBracketForTempo
        ]
        
        addChildren(nodes: allNodes)
    }
    
    func addChildren(nodes: [SKNode]) {
        for node in nodes {
            addChild(node)
        }
    }
}
