import SwiftUI
import SpriteKit

class ChatNode: SKNode {
    var textLabel: SKLabelNode 
    var nameLabel: SKLabelNode
    var chatBackground: SKSpriteNode
    var nextButtonTemp: SKSpriteNode
    var backgroundTextures: [SKTexture] = []
    init(nodeSize: CGSize, name: String, message: String) {
        //Background
        for i in 1..<9 {
            backgroundTextures.append(SKTexture(imageNamed: ("chatBackground" + String(i))))
        }
        
        let nodeSize = CGSize(width: nodeSize.width, height: nodeSize.height/4)
        chatBackground = SKSpriteNode(imageNamed: "chatBackground0")
        chatBackground.anchorPoint = CGPoint(x: 0.5, y: 0)
        chatBackground.position = CGPoint(x: nodeSize.width / 2, y: 0)
        chatBackground.scale(to: CGSize(width: nodeSize.width, height: nodeSize.height))
        chatBackground.zPosition = 1
        chatBackground.run(SKAction.repeatForever(SKAction.animate(with: backgroundTextures, timePerFrame: 0.1)))
        //Name
        nameLabel = SKLabelNode(text: name)
        nameLabel.position = CGPoint(x: 40, y: nodeSize.height - 10 - nameLabel.fontSize * 2)
        nameLabel.zPosition = 2
        nameLabel.fontName = AppManager.shared.appFont
        nameLabel.fontSize = 28
        nameLabel.fontColor = .white
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.name = "nameLabel"
        //Message
        //        let nLines = CGFloat((message.components(separatedBy: "\n")).count)
        //        let offset:CGFloat = (28 * 2 * (nLines)) - (nLines - 1) * 15
        textLabel = SKLabelNode(text: message)
        textLabel.position = CGPoint(x: 40, y: nameLabel.position.y - 56)
        let labelHeight = textLabel.calculateAccumulatedFrame().height
        textLabel.position.y -= labelHeight / 2     
        textLabel.zPosition = 2
        textLabel.fontName = AppManager.shared.appFont
        textLabel.fontSize = AppManager.shared.appFontSizeTexts
        textLabel.numberOfLines = 5
        textLabel.preferredMaxLayoutWidth = chatBackground.size.width - 100
        textLabel.fontColor = .white
        textLabel.horizontalAlignmentMode = .left
        textLabel.name = "message"
        //nextButton
        nextButtonTemp = SKSpriteNode(imageNamed: "RightButtonGray")
        nextButtonTemp.position = CGPoint(x: nodeSize.width - 50 - 50, y: 50)
        nextButtonTemp.scale(to: CGSize(width: 50, height: 50))
        nextButtonTemp.zPosition = 2
        nextButtonTemp.name = "nextButtonGray"
        super.init()
        addChild(nameLabel)
        addChild(textLabel)
        addChild(chatBackground)
        addChild(nextButtonTemp)
        changeButtonColor()
        
        self.name = "chat"
        self.alpha = 0
        self.run(SKAction.fadeIn(withDuration: 2))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeButtonColor() {
        nextButtonTemp.texture = SKTexture(imageNamed: "RightButtonGray")
        nextButtonTemp.name = "nextButtonGray"
        let wait = SKAction.wait(forDuration: 1)
        nextButtonTemp.run(wait){ 
            self.nextButtonTemp.texture = SKTexture(imageNamed: "RightButton")
            self.nextButtonTemp.name = "nextButtonGreen"
        }
    }
    
    func changeText(text: String) {
        changeButtonColor()
        textLabel.text = text
        textLabel.position = CGPoint(x: 40, y: nameLabel.position.y - 60)
        let labelHeight = textLabel.calculateAccumulatedFrame().height
        
        textLabel.position.y -= labelHeight / 2
    }
    
    func removeNextButton() {
        if let parent = nextButtonTemp.parent {
            nextButtonTemp.removeFromParent()
        }
    }
    func addNextButton() {
        if let parent = nextButtonTemp.parent { 
            if(nextButtonTemp.name == "nextButtonGray") {
                self.nextButtonTemp.texture = SKTexture(imageNamed: "RightButton")
                self.nextButtonTemp.name = "nextButtonGreen"
            }
            return
        }
        addChild(nextButtonTemp)
    }
    
    func lockButton() {
        nextButtonTemp.removeAllActions()
        nextButtonTemp.texture = SKTexture(imageNamed: "RightButtonGray")
        nextButtonTemp.name = "nextButtonGray"
    }
}
