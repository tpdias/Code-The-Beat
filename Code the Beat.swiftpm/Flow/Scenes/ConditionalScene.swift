import SwiftUI
import SpriteKit
import UIKit

class ConditionalScene: SKScene {
    var pauseNode: PauseNode
    var chatNode: ChatNode
    var codeBackground: SKNode
    
    var codeNode: CodeNode = CodeNode(varOrLet: "var", name: "beats", type: false, equals: true, value: "5", fontSize: AppManager.shared.fontSize)
    var chords: [String] = ["Em", "C", "G", "D"]
    var chordsArray: [String]
    
    var slotTextures: [SKTexture] = []    
    var slotsBackground: SKSpriteNode
    var buttonSlots: [SKSpriteNode]  = []
    var chordSquares: [SKSpriteNode] = []

    var curChat: Int = 0
    var beatbot: Beatbot
    
    var chats: [String] = [
        "Let's complete our beat with a drum set to add more groove!",
        "To do this, we'll use conditionals. With `if`, we can compare values using `&&` (AND condition) and `||` (OR condition).",
        "Each chord will last for 4 beats. Select on the DJ controller which beats you want to hear the basic drum track, and watch the code update in real-time!",
        "Nice! Now, complete your drum pattern by adding a snare and claps. When you're happy with the beat, click 'Next' to continue!"
    ]
    var drumsControllerNode: DrumsControllerNode
    var curTempo: Int = 1
    
    init(size: CGSize, chords: [String]) {
        chordsArray = chords
        SoundManager.soundTrack.stopSounds()
        AppManager.shared.inGame = true
        pauseNode = PauseNode(size: size)
        chatNode = ChatNode(nodeSize: size, name: "BeatBot", message: chats[curChat])
        beatbot = Beatbot(size: CGSize(width: size.width*0.895/4, height: size.width/4), position: CGPoint(x: size.width - 150, y: size.height/2 - 100))
        beatbot.xScale = -1
                
        codeBackground = SKSpriteNode()
        slotsBackground = SKSpriteNode(texture: SKTexture(imageNamed: "slotsBackground"), size: CGSize(width: 150 * 5, height: 150*1.5))
        
        drumsControllerNode = DrumsControllerNode(texture: SKTexture(imageNamed: "drumsBackground"), color: .clear, size: CGSize(width: size.width/3, height: size.width/3))
        drumsControllerNode.position = CGPoint(x: size.width/2 - 100, y: size.height/2 - size.width/6)
        super.init(size: size)
        
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        //Background
        backgroundColor = UIColor(AppColors.background)
        
        codeBackground = SKSpriteNode(texture: SKTexture(imageNamed: "FuncNodeBackground"), size: CGSize(width: 530, height: 450)) 
        
        codeBackground.position = CGPoint(x: 265, y: size.height - 500)
        codeBackground.zPosition = 1
        
        let side = 150.0 
        
        for i in 1...8 {
            slotTextures.append(SKTexture(imageNamed: "slot\(i)"))    
        }
        
        slotsBackground.position = CGPoint(x: size.width*3/5, y: size.height - side)
        slotsBackground.zPosition = 1
        addChild(slotsBackground)
        
        for i in 0..<4 {
            let slot = SKSpriteNode(texture: SKTexture(imageNamed: "slot3"), size: CGSize(width: side*1.05, height: side*1.05))
            slot.position = CGPoint(x: slotsBackground.position.x + side*1.2*CGFloat(i) + side * 0.2 - size.width*3/13.25, y: slotsBackground.position.y)
            slot.zPosition = 2
            slot.name = "slot\(i)"
            let label = SKLabelNode(text: "\(i)")
            label.fontColor = .white
            label.fontSize = AppManager.shared.fontSize + 4
            label.position.y = -slot.frame.height/2 - 30
            label.fontName = AppManager.shared.appFont
            slot.addChild(label)
            addChild(slot)
            buttonSlots.append(slot)
            slot.run(SKAction.repeatForever(SKAction.animate(with: slotTextures, timePerFrame: 0.2)))
        }
        
        for (i, chord) in chordsArray.enumerated() {
            let button = SKSpriteNode(texture: SKTexture(imageNamed: "chordSquare1"), size: CGSize(width: side, height: side))
            button.name = "chordSquare\(chord)"
            button.position = buttonSlots[i].position
            switch chord {
            case "Em":
                button.texture = SKTexture(imageNamed: "chordSquare1")
                break
            case "C":
                button.texture = SKTexture(imageNamed: "chordSquareGold1")
                button.name = "chordSquareGold\(i)"
            case "G":
                button.texture = SKTexture(imageNamed: "chordSquareSeeBlue1")
                button.name = "chordSquareSeeBlue\(i)"
            case "D":
                button.texture = SKTexture(imageNamed: "chordSquareCyan1")
                button.name = "chordSquareCyan\(i)"
            default:
                break
            }
            button.zPosition = 10
            
            
            let label = SKLabelNode(text: chords[i])
            label.fontName = AppManager.shared.appFont
            label.fontColor = .white
            label.fontSize = AppManager.shared.titleFontSize
            label.name = button.name ?? "" + "label"
            button.addChild(label)
            addChild(button)
            chordSquares.append(button)
        }
        
        
        
        addChild(chatNode)
        addChild(pauseNode)   
        addChild(beatbot)
        addChild(drumsControllerNode)
        beatbot.animateTlk()
     
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
                drumsControllerNode.checkDrumsToutch(name: name)
            }
        }
    }
    
    func playSquareSound(button: SKSpriteNode) {
        guard let index = getSquareIndex(button: button), index < chords.count else { return }
        let noteName = chords[index] 
        
        let soundFileName: String
        switch noteName {
        case "Em":
            soundFileName = "EMin"
        case "C":
            soundFileName = "CMaj"
        case "G":
            soundFileName = "GMaj"
        case "D":
            soundFileName = "DMaj"
        default:
            return 
        }
        
        playSound(noteName: soundFileName, duration: 1.0)
    }
    
    func playSound(noteName: String, duration: TimeInterval) {
        let fileName = "\(noteName).mp3"
        let audioNode = SKAudioNode(fileNamed: fileName)
        audioNode.autoplayLooped = false
        
        addChild(audioNode)
        audioNode.run(SKAction.play())
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: duration),
            SKAction.run { audioNode.removeFromParent() }
        ]))
    }
    
    func getSquareIndex(button: SKSpriteNode) -> Int?  {
        guard let buttonName = button.name,
              let lastChar = buttonName.last,  
                let index = Int(String(lastChar)) else { return nil }
        return index
    }
    
    func changeSquareColor(square: SKSpriteNode, state: Int) {
        switch getSquareIndex(button: square) {
        case 0: 
            square.texture = SKTexture(imageNamed: "chordSquare\(state)")
        case 1:
            square.texture = SKTexture(imageNamed: "chordSquareGold\(state)")
        case 2:
            square.texture = SKTexture(imageNamed: "chordSquareSeeBlue\(state)")
        case 3:
            square.texture = SKTexture(imageNamed: "chordSquareCyan\(state)")
        default:
            square.texture = SKTexture(imageNamed: "chordSquare\(state)")
        }
    }
    
    func getChordIndex(button: SKSpriteNode) -> Int? {
        guard let buttonName = button.name,
              let lastChar = buttonName.last,  
                let index = Int(String(lastChar)),
              index < chords.count else { return nil }
        
        guard let finalIndex = chordsArray.firstIndex(of: chords[index]) else { return nil }
        return finalIndex
    }
    
    func playLoop() {        
        let loopAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.run { self.playChordsSequentially() },
            SKAction.wait(forDuration: Double(chordsArray.count) * 1.3),
            SKAction.run {
                for square in self.chordSquares {
                    self.changeSquareColor(square: square, state: 1)
                }
            }
        ]))

        let tempoLoop = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 1.3/4),
            SKAction.run {
                if(self.curTempo == 4) {
                    self.curTempo = 1
                    self.drumsControllerNode.changeTempo(tempo: self.curTempo)                   
                } else {
                    self.curTempo += 1
                    self.drumsControllerNode.changeTempo(tempo: self.curTempo)
                }
                if(self.drumsControllerNode.pressedDrumsIndexes.contains(self.curTempo - 1)) {
                    self.playSound(noteName: "drums", duration: 1)
                } else {
                    if(self.drumsControllerNode.pressedSnareIndexes.contains(self.curTempo - 1)) {
                        self.playSound(noteName: "snare", duration: 1)
                    } else {
                        if(self.drumsControllerNode.pressedHiHatsIndexes.contains(self.curTempo - 1)) {
                            self.playSound(noteName: "clap", duration: 1)
                        }
                    }
                }
            }
        ]))
        run(tempoLoop, withKey: "tempoLoop")
        run(loopAction, withKey: "loopPlayback")
    }
    
    
    func playChordsSequentially() {
        var actions: [SKAction] = []
        
        for chord in chordsArray {            
            let soundFileName: String
            switch chord {
            case "Em":
                soundFileName = "EMin"
            case "C":
                soundFileName = "CMaj"
            case "G":
                soundFileName = "GMaj"
            case "D":
                soundFileName = "DMaj"
            default:
                continue
            }
            
            if let button = chordSquares.first(where: { square in
                if let label = square.children.first as? SKLabelNode {
                    return label.text == chord
                }
                return false
            }) {
                let highlightAction = SKAction.run { self.changeSquareColor(square: button, state: 2) }
                let playAction = SKAction.run { self.playSound(noteName: soundFileName, duration: 1.3) }
                let waitAction = SKAction.wait(forDuration: 1.3)
                let turnOffAction = SKAction.run { self.changeSquareColor(square: button, state: 1) } 
                
                
                actions.append(highlightAction)
                actions.append(playAction)
                actions.append(waitAction)
                actions.append(turnOffAction)
            }
        }
        
        run(SKAction.sequence(actions), withKey: "sequential")
    }
    
    func nextChat() {
        curChat += 1
        if(curChat >= 3) {
            chatNode.changeButtonColor()
            transitionToNextScene()
        }
        else {
            beatbot.animateTlk()
            chatNode.changeText(text: chats[curChat])
            if(curChat == 1) {
                codeBackground.alpha = 0
                codeNode.alpha = 0
                addChild(codeNode)
                addChild(codeBackground)
                codeNode.run(SKAction.fadeIn(withDuration: 0.3))
                codeBackground.run(SKAction.fadeIn(withDuration: 0.3))              
            }
            if(curChat == 2) {
                  playLoop()
            }
        }
    }
    
    func transitionToNextScene() {
        let wait = SKAction.wait(forDuration: 1)
        
        self.run(wait) {
            let conditionalScene = IntroScene(size: self.size)
            conditionalScene.scaleMode = self.scaleMode
            self.view?.presentScene(conditionalScene)
        }
        
        self.run(SKAction.fadeOut(withDuration: 1))
    }    
    
}
