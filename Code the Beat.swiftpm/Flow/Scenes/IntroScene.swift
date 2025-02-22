import SwiftUI
import SpriteKit

class IntroScene: SKScene {
    let chatNode: ChatNode
    let beatbot: Beatbot
    
    let chats: [String] = [
        "Hello World! I'm BeatBot your guide in this jorney of coding and music",
        "Have you ever imagined creating an amazing sound while learning to program?",
        "Here, every line of code you write turns into a new beat!"
    ]
    var curChat: Int = 0
    
    override init(size: CGSize) {
        chatNode = ChatNode(nodeSize: size, name: "BeatBot", message: chats[0])
        beatbot = Beatbot(size: CGSize(width: size.width*0.895/3, height: size.width/3), position: CGPoint(x: size.width/2, y: size.height/2))
        super.init(size: size)
        beatbot.animateTlk()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        //Background
        let background = SKSpriteNode(imageNamed: "primaryBackground")
        background.size = size
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        background.alpha = 0.6
        
        addChild(background)
        beginChat()
        addChild(beatbot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                if(name.contains("Button") && AppManager.shared.soundStatus && name != "nextButtonGray") {
                    SoundManager.shared.playButtonSound()                    
                }
                if(name.contains("Toggle") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playToggleSound()
                    
                }
                if(name == "nextButtonGreen") {
                    changeChat()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func transitionToFirstLevel() {
        let wait = SKAction.wait(forDuration: 1)
        
        chatNode.run(SKAction.fadeOut(withDuration: 0.3))
        
        self.run(wait) {
            let firstLevel = FirstLevelScene(size: self.size)
            firstLevel.scaleMode = self.scaleMode
            self.view?.presentScene(firstLevel)
        }
        
    }     
    
    func beginChat() {
        chatNode.alpha = 0
        addChild(chatNode)
        chatNode.run(SKAction.fadeIn(withDuration: 1))
    }
    
    func changeChat() {
        if(curChat >= 2) {
            chatNode.changeButtonColor()
            transitionToFirstLevel()
        } else {
            curChat += 1
            chatNode.changeText(text: chats[curChat])
        }
    }
}
