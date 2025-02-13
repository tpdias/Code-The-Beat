import SwiftUI
import SpriteKit

class LoopLevelScene: SKScene {
    //pause
    var pauseNode: PauseNode
    var chatNode: ChatNode
    var codeBackground: SKNode
    
    var chats: [String] = [
        "To play sounds, we use a **function**!",
        "Think of functions like buttons on a **DJ Pad**, each button plays a already recorded sound when pressed.",
        "Try pressing the **blue button** to play the C note.",
        "Great! Now, the **red button** plays a G chord (G, B, and D) with a single function call, you can see on the code on the left.",
        "See? We don’t need to replay everything manually, just like in coding we don't need to rewrite code!",
        "Good job! Let's move on."
    ]
    var curChat: Int = 0
    var chords: [String]
    
    init(size: CGSize, chords: [String]) {
        self.chords = chords
        SoundManager.soundTrack.stopSounds()
        AppManager.shared.inGame = true
        
        pauseNode = PauseNode(size: size)
        chatNode = ChatNode(nodeSize: size, name: "BeatBot", message: chats[curChat])
        codeBackground = SKSpriteNode()
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        //Background
        backgroundColor = UIColor(AppColors.quaternaryBackground)
        
        codeBackground = SKSpriteNode(texture: SKTexture(imageNamed: "FuncNodeBackground"), size: CGSize(width: 500, height: 450)) 
        
        codeBackground.position = CGPoint(x: 275, y: size.height - 450)
        codeBackground.zPosition = 1
        
        
        addChild(chatNode)
        addChild(pauseNode)        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                pauseNode.checkPauseNodePressed(view: self, touchedNode: touchedNode)
                
                if(touchedNode.name == "nextButtonGreen") {
                    nextChat()
                }
                
                if(name.contains("Button") && AppManager.shared.soundStatus && name != "nextButtonGray" && !name.contains("Pad")) {
                    SoundManager.shared.playButtonSound()
                    continue
                }
                if(name.contains("Toggle") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playToggleSound()
                    continue
                }               
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func transitionToNextScene() {
        let wait = SKAction.wait(forDuration: 1)
        self.run(wait) {
            let arrayLevel = ArrayLevelScene(size: self.size)
            arrayLevel.scaleMode = self.scaleMode
            self.view?.presentScene(arrayLevel)
        }
        self.run(SKAction.fadeOut(withDuration: 1))
        
    }       
    
   
    func nextChat() {
        if(curChat >= 5) {
            chatNode.changeButtonColor()
            transitionToNextScene()
        }
        else {
            curChat += 1
            chatNode.changeText(text: chats[curChat])
            if(curChat == 1) {
                
                addChild(codeBackground)
            }
            if(curChat == 2 || curChat == 3) {
                
                chatNode.removeNextButton()
            }
        }
    }
}
