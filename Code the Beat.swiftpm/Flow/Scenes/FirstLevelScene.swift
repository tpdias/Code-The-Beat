import SwiftUI
import SpriteKit
import UIKit

class FirstLevelScene: SKScene {    
    var pianoNode: PianoNode
    var chatNode: ChatNode
    var codeNode: CodeNode
    var secondLineNode: CodeNode
    var codeBackground: SKNode
    let beatbot: Beatbot
    var isPianoBlocked: Bool = false
    var notePlayed = false
    
    var chats: [String] = [
        "Let's begin learning how to represent a note in code!",
        "At the top of your screen, you'll see the code for our variable that stores the current note.",
        "We need to assign a note to this variable. Try playing a key on the keyboard to select a note!",
        "Great! You can also change the value of the variable by playing another note.",
        "Well done! Now you're ready to move on..."
    ]
    var curChat: Int = 0
    
    override init(size: CGSize) {
        SoundManager.soundTrack.stopSounds()
        AppManager.shared.inGame = true
        
        pianoNode = PianoNode(size: size)   
        chatNode = ChatNode(nodeSize: size, name: "BeatBot", message: chats[curChat])
        codeNode = CodeNode(varOrLet: "var", name: "note", type: false, equals: true, value: " ", fontSize: AppManager.shared.titleFontSize) 
        codeNode.codeTextWhite.text = ""
        secondLineNode = CodeNode(varOrLet: "", name: "note", type: false, equals: true, value: "", fontSize: AppManager.shared.titleFontSize)
        codeBackground = SKSpriteNode()
        beatbot = Beatbot(size: CGSize(width: size.width*0.895/4, height: size.width/4), position: CGPoint(x: size.width - 150, y: size.height/2 - 100))
        beatbot.xScale = -1
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        //Background
        let background = SKSpriteNode(imageNamed: "secundaryBackground")
        background.size = size
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        background.alpha = 0.6
        
        pianoNode.zPosition = 1
        pianoNode.position.x = self.size.width/2
        pianoNode.position.y = self.size.height/2 - pianoNode.keyHeight/2.5
        
        codeNode.zPosition = 2
        codeNode.position.x = size.width/2 - 425
        codeNode.position.y = size.height - 110
        
        secondLineNode.zPosition = 2
        secondLineNode.position.x = codeNode.position.x - 50
        secondLineNode.position.y = size.height - 110 - AppManager.shared.titleFontSize*1.1       
        secondLineNode.name = "secondLineNode"
        
        codeBackground = SKSpriteNode(texture: SKTexture(imageNamed: "chatBackground0"), size: CGSize(width: 0.6 * size.width, height: 150)) 
        
        codeBackground.position = CGPoint(x: pianoNode.position.x - 65, y: codeNode.position.y)
        codeBackground.zPosition = 1
        
        addChild(beatbot)
        addChild(chatNode)
        addChild(pianoNode)
        addChild(codeBackground)
//        addChild(appleBackground)
        addChild(background)
        beatbot.animateTlk()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                if(!isPianoBlocked) {
                    if let note = pianoNode.checkTouchedNote(touchedNode) {
                        let particle = ParticleNote(position: location)
                        addChild(particle)
                        chatNode.addNextButton()
                        if curChat == 2 {
                            if !notePlayed {
                                notePlayed = true
                                codeNode.defineVariableVelue(value: note)
                                isPianoBlocked = true
                                chatNode.addNextButton()
                                run(SKAction.wait(forDuration: 0.5)) {
                                    self.isPianoBlocked = false
                                }
                            }                        
                            break
                        } else {
                            if curChat == 3 {
                                chatNode.addNextButton()
                                if(childNode(withName: "secondLineNode") == nil) {
                                    self.addChild(secondLineNode)
                                }
                                self.secondLineNode.defineVariableVelue(value: note)
                                
                                break
                            } 
                            else {
                                if curChat > 3 {
                                    self.secondLineNode.defineVariableVelue(value: note)
                                }
                            }
                        }
                    }
                }
                
                if(touchedNode.name == "nextButtonGreen") {
                    nextChat()
                }
                
                if(name.contains("Button") && AppManager.shared.soundStatus && name != "nextButtonGray") {
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
        self.run(SKAction.fadeOut(withDuration: 1))
        self.run(wait) {
            let funcLevel = FuncLevelScene(size: self.size)
            funcLevel.scaleMode = self.scaleMode
            self.view?.presentScene(funcLevel)
        }
        
    }       
    
    func nextChat() {
        if(curChat >= 4) {
            chatNode.changeButtonColor()
            transitionToNextScene()
        }
        else {
            beatbot.animateTlk()
            curChat += 1
            chatNode.changeText(text: chats[curChat])
            if(curChat == 1) {
                addChild(codeNode)
            }
            if(curChat == 2 || curChat == 3) {
                isPianoBlocked = false
                chatNode.lockButton()
            }
        }
    }
}
