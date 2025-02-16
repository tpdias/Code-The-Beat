import SwiftUI
import SpriteKit
import UIKit

class DrumsControllerNode: SKSpriteNode {
    var drumTypes: [String] = ["base", "hi-hats", "snare"]
    var baseButtons: [SKSpriteNode] = []
    var hiHatsButtons: [SKSpriteNode] = []
    var snareButtons: [SKSpriteNode] = []
    var baseNode: SKSpriteNode
    var hiHatsNode: SKSpriteNode
    var snareNode: SKSpriteNode
    var beatsLabel: [SKLabelNode] = []
    
    var pressedDrumsIndexes: [Int] = []
    var pressedHiHatsIndexes: [Int] = []
    var pressedSnareIndexes: [Int] = []
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        //icons        
        let iconsSize = size.width/8
        baseNode = SKSpriteNode(texture: SKTexture(imageNamed: "drumIcon"), size: CGSize(width: iconsSize, height: iconsSize))
        hiHatsNode = SKSpriteNode(texture: SKTexture(imageNamed: "clappIcon"), size: CGSize(width: iconsSize, height: iconsSize))
        snareNode = SKSpriteNode(texture: SKTexture(imageNamed: "hihatIcon"), size: CGSize(width: iconsSize, height: iconsSize))
        baseNode.position = CGPoint(x: 40, y: size.height/2 + 100)
        hiHatsNode.position = CGPoint(x: baseNode.position.x, y: baseNode.position.y - iconsSize * 1.2)
        snareNode.position = CGPoint(x: hiHatsNode.position.x, y: hiHatsNode.position.y - iconsSize * 1.2)
        
        super.init(texture: texture, color: color, size: size)
        self.anchorPoint = CGPoint(x: 0, y: 0)

        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupUI() {
        let collumWidth = size.width/5
        let lineHeight = size.height/4

        
        //labels
        for i in 1...4 {
            let label = SKLabelNode(text: String(i))
            label.fontSize = AppManager.shared.fontSize
            label.fontColor = .white
            label.fontName = AppManager.shared.appFont
            label.position = CGPoint(x: collumWidth + (collumWidth * CGFloat(i)) - collumWidth/2.0, y: (lineHeight * 4.0) - lineHeight/2.0)
            label.name = "label\(i)"
            beatsLabel.append(label)
            addChild(label)
        }
        
        //baseButtons
        baseButtons = createButtons(height: 3.0, type: "drums")
        hiHatsButtons = createButtons(height: 2.0, type: "hihat")
        snareButtons = createButtons(height: 1.0, type: "snare")
      
        func createButtons(height: CGFloat, type: String) -> [SKSpriteNode] {
            var buttons: [SKSpriteNode] = []
            for i in 1...4 {
                let button = SKSpriteNode(texture: SKTexture(imageNamed: "lightOff"), size: CGSize(width: collumWidth/1.4, height: collumWidth/1.4))
                button.position = CGPoint(x: collumWidth + (collumWidth * CGFloat(i)) - collumWidth/2.0, y: (lineHeight * CGFloat(height)) - lineHeight/2.0)
                button.name = "\(type)\(i)"
                buttons.append(button)
                addChild(button)
            }
            return buttons
        }
        
        //icons position and adding        
        baseNode.position = CGPoint(x: collumWidth/2.0, y: (lineHeight * 3.0) - lineHeight/2.0)
        hiHatsNode.position = CGPoint(x: collumWidth/2.0, y: (lineHeight * 2.0) - lineHeight/2.0)
        snareNode.position =  CGPoint(x: collumWidth/2.0, y: lineHeight - lineHeight/2.0)
        addChild(baseNode)
        addChild(hiHatsNode)
        addChild(snareNode)
        
    }
    
    func checkDrumsToutch(name: String, label: SKLabelNode) {
        if let last = name.last {
            if let wrapperdIndex = Int(String(last)) {
                let index = wrapperdIndex - 1
                switch name.dropLast(1) {
                case "drums":                                        
                    if let toBeRemovedIndex = pressedDrumsIndexes.firstIndex(of: index) {
                        pressedDrumsIndexes.remove(at: toBeRemovedIndex)
                        baseButtons[index].texture = SKTexture(imageNamed: "lightOff")                
                    } else {
                        baseButtons[index].texture = SKTexture(imageNamed: "lightOn")
                        pressedDrumsIndexes.append(index)                        
                    }
                    let newArray = pressedDrumsIndexes.map { value in
                        value + 1
                    }
                    label.text = "\(newArray)"
                    if let toBeRemovedIndex = pressedHiHatsIndexes.firstIndex(of: index) {
                        pressedHiHatsIndexes.remove(at: toBeRemovedIndex)
                        hiHatsButtons[index].texture = SKTexture(imageNamed: "lightOff")
                        return
                    }
                    if let toBeRemovedIndex = pressedSnareIndexes.firstIndex(of: index) {
                        pressedSnareIndexes.remove(at: toBeRemovedIndex)
                        snareButtons[index].texture = SKTexture(imageNamed: "lightOff")
                        return
                    }
                case "hihat":      
                    if let toBeRemovedIndex = pressedHiHatsIndexes.firstIndex(of: index) {
                        pressedHiHatsIndexes.remove(at: toBeRemovedIndex)
                        hiHatsButtons[index].texture = SKTexture(imageNamed: "lightOff")
                        return
                    } else {
                        hiHatsButtons[index].texture = SKTexture(imageNamed: "lightOn")
                        pressedHiHatsIndexes.append(index)
                    }
                    if let toBeRemovedIndex = pressedDrumsIndexes.firstIndex(of: index) {
                        pressedDrumsIndexes.remove(at: toBeRemovedIndex)
                        baseButtons[index].texture = SKTexture(imageNamed: "lightOff")
                        return
                    }
                    if let toBeRemovedIndex = pressedSnareIndexes.firstIndex(of: index) {
                        pressedSnareIndexes.remove(at: toBeRemovedIndex)
                        snareButtons[index].texture = SKTexture(imageNamed: "lightOff")
                        return
                    }
                case "snare":
                    if let toBeRemovedIndex = pressedSnareIndexes.firstIndex(of: index) {
                        pressedSnareIndexes.remove(at: toBeRemovedIndex)
                        snareButtons[index].texture = SKTexture(imageNamed: "lightOff")
                        return
                    }
                     else {
                    snareButtons[index].texture = SKTexture(imageNamed: "lightOn")
                    pressedSnareIndexes.append(index)
                    }
                    if let toBeRemovedIndex = pressedDrumsIndexes.firstIndex(of: index) {
                        pressedDrumsIndexes.remove(at: toBeRemovedIndex)
                        baseButtons[index].texture = SKTexture(imageNamed: "lightOff")
                        return
                    }
                    if let toBeRemovedIndex = pressedHiHatsIndexes.firstIndex(of: index) {
                        pressedHiHatsIndexes.remove(at: toBeRemovedIndex)
                        hiHatsButtons[index].texture = SKTexture(imageNamed: "lightOff")
                        return
                    }
                default:
                    return
                }
            }
        }
    }
   
    func changeTempo(tempo: Int) {
        for label in beatsLabel {
            label.fontColor = .white
        }
        beatsLabel[tempo - 1].fontColor = UIColor(AppColors.primary)
    }
    
    
}
