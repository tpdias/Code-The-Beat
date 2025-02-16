import SwiftUI
import SpriteKit

class FuncLevelScene: SKScene {
    var chatNode: ChatNode
    var playSoundNode: FuncNode
    var codeBackground: SKNode
    var funcDeclarationNode: FuncDeclarationNode
    var djController: DJController
        
    var chats: [String] = [
        "To play sounds, we use a function!",
        "Think of functions like buttons on a DJ Pad, each button plays a already recorded sound when pressed.",
        "Try pressing the cyan button to play the C note.",
        "Great! Now, the red button plays a G chord (G, B, and D) with a single function call, you can see on the code on the left.",
        "See? We don’t need to replay everything manually, just like in coding we don't need to rewrite code!"
    ]
        var curChat: Int = 0
        
        override init(size: CGSize) {
            SoundManager.soundTrack.stopSounds()
            AppManager.shared.inGame = true
            
            chatNode = ChatNode(nodeSize: size, name: "BeatBot", message: chats[curChat])
            playSoundNode = FuncNode(funcText: "playSound(note: ", value: "C")
            codeBackground = SKSpriteNode()
            
            djController = DJController(size: CGSize(width: size.width/2.2, height: size.width/2.2))
            
            funcDeclarationNode = FuncDeclarationNode(chord: "GMaj", note1: "G", note2: "B", note3: "D")
            funcDeclarationNode.name = "funcDeclarationNode"
            
            super.init(size: size)

        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func didMove(to view: SKView) {
            
            //Background
            let background = SKSpriteNode(imageNamed: "terciaryBackground")
            background.size = size
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(x: 0, y: -25)
            background.zPosition = -1
            background.alpha = 0.6
            
            playSoundNode.zPosition = 2
            playSoundNode.position.x = size.width/2 - 600
            playSoundNode.position.y = size.height - 110
            playSoundNode.name = "playSoundNode"
            
            funcDeclarationNode.zPosition = 2
            funcDeclarationNode.position.x = size.width/2 - 600
            funcDeclarationNode.position.y = size.height - 110
            
            codeBackground = SKSpriteNode(texture: SKTexture(imageNamed: "FuncNodeBackground"), size: CGSize(width: 500, height: 450)) 
            
            codeBackground.position = CGPoint(x: 275, y: playSoundNode.position.y - 150)
            codeBackground.zPosition = 1
            
            djController.position = CGPoint(x: size.width/2 + 200, y: size.height/1.75)
            
            addChild(chatNode)
            addChild(djController)
            addChild(background)

            
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let touchedNode = atPoint(location)
                if let name = touchedNode.name {
                    
                    if let button = djController.checkPadClicks(name: name) {
                        let particle = ParticleNote(position: location)
                        addChild(particle)
                        if(curChat > 0) {
                            switch button {
                            case 1: 
                                playNote(note: "C")
                                if(curChat == 2) {
                                    chatNode.addNextButton()
                                }
                            case 2:
                                playNote(note: "D")
                            case 3:
                                playChord(chord: "DMin", note1: "D", note2: "F", note3: "A")
                            case 4:
                                playChord(chord: "GMaj", note1: "G", note2: "B", note3: "D")
                                if(curChat == 3) {
                                    chatNode.addNextButton()
                                }
                            default:
                                break
                            }
                        }
                    }
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
        
    func playNote(note: String) {
        playSoundNode.defineVariableVelue(value: note)
        guard let soundName = playSoundNode.name,
              let declarationName = funcDeclarationNode.name else { return}
        if(childNode(withName: soundName) == nil) {
            addChild(playSoundNode)
        }
        if(childNode(withName: declarationName) != nil) {
            funcDeclarationNode.removeFromParent()
        }
    }
    
    func playChord(chord: String, note1: String, note2: String, note3: String) {
        guard let soundName = playSoundNode.name,
              let declarationName = funcDeclarationNode.name else { return}
        funcDeclarationNode.changeChord(chord: chord, note1: note1, note2: note2, note3: note3)
        if(childNode(withName: soundName) != nil) {
            playSoundNode.removeFromParent()
        }
        if(childNode(withName: declarationName) == nil) {
            addChild(funcDeclarationNode)
        }
    }

    
        func nextChat() {
            if(curChat >= 4) {
                chatNode.changeButtonColor()
                transitionToNextScene()
            }
            else {
                curChat += 1
                chatNode.changeText(text: chats[curChat])
                if(curChat == 1) {
                    addChild(playSoundNode)
                    addChild(codeBackground)
                }
                if(curChat == 2 || curChat == 3) {
                    
                    chatNode.lockButton()
                }
            }
        }
}
