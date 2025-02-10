import SwiftUI
import SpriteKit

class ArrayLevelScene: SKScene {
    var pauseNode: PauseNode
    var chatNode: ChatNode
    var codeBackground: SKNode

    var chords: [String] = ["Em", "C", "G", "D"]
    var chordsArray: [String?] = ["","","",""]
    var chordsArrayNode: CodeNode
    
    var slotsBackground: SKSpriteNode
    var buttonSlots: [SKSpriteNode] = []
    
    var chordSquares: [SKSpriteNode] = []
    var draggedButton: SKSpriteNode? 
    var buttonOriginalPositions: [String: CGPoint] = [:]
    
    var isDragOn = false
    var slotTextures: [SKTexture] = []
    
    var chats: [String] = [
        "To create our beat, we need 4 chords, lets use: Em, C, G, and D.",
        "Each pad is programmed with one of these chords. To use them in our beat, we need to store them in an array!",
        "An array is a special type of variable that holds multiple values. Instead of storing chords in separate variables, we can use one array to store them all!",
        "Try dragging the chord pads into the slots above to build our chord progression!",
        "Awesome! Now our array holds all the chords we need for our track!"
    ]
    var curChat: Int = 0
    var beatbot: Beatbot
    
    override init(size: CGSize) {
        SoundManager.soundTrack.stopSounds()
        AppManager.shared.inGame = true
        
        pauseNode = PauseNode(size: size)
        chatNode = ChatNode(nodeSize: size, name: "BeatBot", message: chats[curChat])
        codeBackground = SKSpriteNode()
        
        chordsArrayNode = CodeNode(varOrLet: "var", name: "chordsArray", type: false, equals: true, value: "", fontSize: AppManager.shared.fontSize - 4)    
        
        slotsBackground = SKSpriteNode(texture: SKTexture(imageNamed: "slotsBackground"), size: CGSize(width: 150 * 5, height: 150*1.5))
        
        
        beatbot = Beatbot(size: CGSize(width: size.width*0.895/4, height: size.width/4), position: CGPoint(x: size.width - 150, y: size.height/2 - 100))
        beatbot.xScale = -1
        
        super.init(size: size)

        self.size = size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        //Background
        backgroundColor = .black
        let background: SKSpriteNode = SKSpriteNode(imageNamed: "firstGameBackground")
        background.size = size
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        background.alpha = 0.7
        addChild(background)
        
        
        codeBackground = SKSpriteNode(texture: SKTexture(imageNamed: "FuncNodeBackground"), size: CGSize(width: 500, height: 450)) 
        
        codeBackground.position = CGPoint(x: 275, y: size.height - 500)
        codeBackground.zPosition = 1
        
        chordsArrayNode.setupArray()
        chordsArrayNode.position = CGPoint(x: codeBackground.position.x - 225, y: codeBackground.position.y + 180)
        chordsArrayNode.zPosition = 2
        
        let side = 150.0 

        for i in 1...8 {
            slotTextures.append(SKTexture(imageNamed: "slot\(i)"))    
        }
        
        for i in 0..<4 {
            let button = SKSpriteNode(texture: SKTexture(imageNamed: "chordSquare1"), size: CGSize(width: side, height: side))
            var position = CGPoint(x: size.width/2, y: size.height/2 + side)
            button.name = "chordSquare\(i)"
            switch i {
            case 0:            
                break
            case 1:
                button.texture = SKTexture(imageNamed: "chordSquareGold1")
                button.name = "chordSquareGold\(i)"
                position.x += side * 1.5
            case 2:
                button.texture = SKTexture(imageNamed: "chordSquareSeeBlue1")
                button.name = "chordSquareSeeBlue\(i)"
                position.y -= side * 1.5
            case 3:
                button.texture = SKTexture(imageNamed: "chordSquareCyan1")
                button.name = "chordSquareCyan\(i)"
                position.x += side * 1.5
                position.y -= side * 1.5
            default:
                break
            }
            button.position = position
            button.zPosition = 3
            
            
            let label = SKLabelNode(text: chords[i])
            label.fontName = AppManager.shared.appFont
            label.fontColor = .white
            label.fontSize = AppManager.shared.titleFontSize
            label.name = button.name ?? "" + "label"
            button.addChild(label)
            addChild(button)
            chordSquares.append(button)
            buttonOriginalPositions[button.name!] = position
        }
        
        
        slotsBackground.position = CGPoint(x: size.width*3/5, y: size.height - side * 0.8)
        slotsBackground.zPosition = 1
        addChild(slotsBackground)
    
        for i in 0..<4 {
            let slot = SKSpriteNode(texture: SKTexture(imageNamed: "slotChord"), size: CGSize(width: side*1.05, height: side*1.05))
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
        
        addChild(chatNode)
        addChild(pauseNode)   
        addChild(beatbot)
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
                //drag
                if name.contains("chordSquare") {
                    if let button = touchedNode as? SKSpriteNode {
                        squareTouch(button: button)
                    }
                    else {
                        if let button = touchedNode.parent as? SKSpriteNode {
                            squareTouch(button: button)
                        }
                    }
                }
            }
        }
    }
    
    func squareTouch(button: SKSpriteNode) {
        for slot in buttonSlots {
            if let occupiedButton = slot.userData?["occupiedBy"] as? SKSpriteNode, occupiedButton == button {
                slot.userData?["occupiedBy"] = nil 
                if let index = getChordIndex(button: button) {
                    chordsArray[index] = ""  
                    chordsArrayNode.removeElementArray(index: index)
                    slot.run(SKAction.repeatForever(SKAction.animate(with: slotTextures, timePerFrame: 0.3)))
                    changeSquareColor(square: button, state: 1)
                    
                }
            }
        }
        
        if(isDragOn) {
            draggedButton = button
            button.zPosition += 1
        }
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let draggedButton = draggedButton else { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            draggedButton.position = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let button = draggedButton else { return }
        button.zPosition -= 1
        var snappedToSlot = false
        for slot in buttonSlots {
            if button.frame.intersects(slot.frame) {
                
                
                if let occupiedButton = slot.userData?["occupiedBy"] as? SKSpriteNode, occupiedButton != button {
                    continue
                }
                
                let snapAction = SKAction.move(to: slot.position, duration: 0.2)
                snapAction.timingMode = .easeOut
                button.run(snapAction)
                
                slot.userData = NSMutableDictionary()
                slot.userData?["occupiedBy"] = button
                if let buttonName = button.name,
                   let slotName = slot.name,
                   let index = Int(slotName.replacingOccurrences(of: "slot", with: "")), 
                   !chordsArray.contains(buttonName) {           
                    slot.removeAllActions()
                    slot.texture = SKTexture(imageNamed: "slot9")
                    addElement(element: buttonName, index: index)
                    changeSquareColor(square: button, state: 2)
                    checkSlotsCompletion()
                }
                
                snappedToSlot = true
                break
            }
        }
        
        if !snappedToSlot, let originalPosition = buttonOriginalPositions[button.name!] {
            let moveBack = SKAction.move(to: originalPosition, duration: 0.3)
            moveBack.timingMode = .easeOut
            button.run(moveBack)
        }
        
        draggedButton = nil
    }
    
    func checkSlotsCompletion() {
        var count = 0
        print(chordsArray)
        for chord in chordsArray {
            if chord != "" {
                count += 1
            }
        }
        if(count == 4) {
            nextChat()
            chatNode.addNextButton()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let button = draggedButton, let originalPosition = buttonOriginalPositions[button.name!] {
            let moveBack = SKAction.move(to: originalPosition, duration: 0.3)
            moveBack.timingMode = .easeOut
            button.run(moveBack)
            button.zPosition -= 1
        }
        draggedButton = nil
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
    
    func addElement(element: String, index: Int) {
        guard let lastChar = element.last, let j = Int(String(lastChar)), j < chords.count else { return }
        
        let chord = chords[j]
        
        if index < chordsArray.count {
            chordsArray[index] = chord
        } else {
            chordsArray.append(chord)
        }
        
        chordsArrayNode.addElementArray(element: chord, index: index)
        
    }
    
    func nextChat() {
        curChat += 1
        if(curChat >= 5) {
            chatNode.changeButtonColor()
            transitionToNextScene()
        }
        else {
            beatbot.animateTlk()
            chatNode.changeText(text: chats[curChat])
            if(curChat == 2) {
                codeBackground.alpha = 0
                chordsArrayNode.alpha = 0
                addChild(codeBackground)
                addChild(chordsArrayNode)
                codeBackground.run(SKAction.fadeIn(withDuration: 0.3))
                chordsArrayNode.run(SKAction.fadeIn(withDuration: 0.3))
            }
            if(curChat == 3) {
                isDragOn = true 
                chatNode.removeNextButton()
            }
        }
    }

}
