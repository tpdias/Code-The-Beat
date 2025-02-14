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
        "Awesome! Now our array holds all the chords we need for our track!",
        
        "Now that we have our chord sequence, let’s turn it into a loop!",
        "Notice that when you *press the Play* button, the sequence plays only once, but it iterates for every chord with a * for *.",
        "Try pressing the loop button to see the loop function in the code section!",
        "Nice!"
        
    ]
    var curChat: Int = 0
    var beatbot: Beatbot
    var loopNode: LoopNode
    
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
        
        loopNode = LoopNode(size: size)
        
        super.init(size: size)

        self.size = size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        //Background
        backgroundColor = UIColor(AppColors.tertiaryBackground)
        
        
        codeBackground = SKSpriteNode(texture: SKTexture(imageNamed: "FuncNodeBackground"), size: CGSize(width: 530, height: 450)) 
        
        codeBackground.position = CGPoint(x: 265, y: size.height - 500)
        codeBackground.zPosition = 1
        
        chordsArrayNode.setupArray()
        chordsArrayNode.position = CGPoint(x: codeBackground.position.x - 245, y: codeBackground.position.y + 180)
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
            button.zPosition = 10
            
            
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
                    checkLoopButtons(name: name)
                    continue
                }
                if(name.contains("Toggle") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playToggleSound()
                    continue
                }           
                //drag
                if name.contains("chordSquare") && isDragOn {
                    if let button = touchedNode as? SKSpriteNode {
                        squareTouch(button: button, location: location)
                    }
                    else {
                        if let button = touchedNode.parent as? SKSpriteNode {
                            squareTouch(button: button, location: location)                            
                        }
                    }
                }
                
            }
        }
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
    
    func checkLoopButtons(name: String) {
        if let loopButton = loopNode.checkLoopTouch(name: name) {
            switch loopButton {
            case 1:
                playButtonPressed()
            case 2:
                loopButtonPressed()
            case 3:
                stopButtonPressed()
            default:
                break
            }
        }
    }
    
    func squareTouch(button: SKSpriteNode, location: CGPoint) {
        let particle = ParticleNote(position: location)
        addChild(particle)
        
        playSquareSound(button: button)
        
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
        
        if isDragOn {
            draggedButton = button
            button.zPosition += 1
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
    
    
    func checkSlotsCompletion() {
        var count = 0
        for chord in chordsArray {
            if chord != "" {
                count += 1
            }
        }
        if(count == 4 && curChat == 3) {
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
    
    func playButtonPressed() {
        stopButtonPressed()
        removeCode()
        setupForCode()
        if(curChat == 6) {
            chatNode.addNextButton()
        }
        playChordsSequentially()        
    }
    
    func loopButtonPressed() {
        stopButtonPressed()    
        removeCode()
        setupLoopCode()
        
        let loopAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.run { self.playChordsSequentially() },
            SKAction.wait(forDuration: Double(chordsArray.count) * 1.3),
            SKAction.run {
                for square in self.chordSquares {
                    self.changeSquareColor(square: square, state: 1)
                }
            }
        ]))
        
        run(loopAction, withKey: "loopPlayback")
        
        if curChat == 7 {
            chatNode.addNextButton()
        }
    }
    
    func stopButtonPressed() {
        removeCode()
        removeAction(forKey: "sequential") 
        removeAction(forKey: "loopPlayback")
        for square in chordSquares {
            changeSquareColor(square: square, state: 1)
        }
    }
    
    func playChordsSequentially() {
        var actions: [SKAction] = []
        
        for chord in chordsArray {
            guard let chord = chord else { continue }
            
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
    
    func transitionToNextScene() {
        let wait = SKAction.wait(forDuration: 1)
        
        self.run(wait) {
            let finalArray = self.chordsArray.compactMap { $0 }
            let conditionalScene = ConditionalScene(size: self.size, chords: finalArray)
            conditionalScene.scaleMode = self.scaleMode
            self.view?.presentScene(conditionalScene)
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
        if(curChat >= 8) {
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
                chatNode.lockButton()
            }
            if(curChat == 5) {
                transitionToLoop()                
            }
            if(curChat == 6 || curChat == 7) {
                chatNode.lockButton()
            }
        }
    }
    
    func transitionToLoop() {
        self.backgroundColor = UIColor(AppColors.quaternaryBackground)
        addChild(loopNode)
        setupSequentialCode()
        self.isDragOn = false
        chordsArrayNode.removeAllChildren()
        for square in chordSquares {
            changeSquareColor(square: square, state: 1)
        }
    }
    
    func setupSequentialCode(down: Bool = false) {
        let fontSize = chordsArrayNode.fontSize
        if let firstLine = childNode(withName: "firstLine") { return }
        let funcText = "playChord(chord: " 
        let firstLine = FuncNode(funcText: funcText, value: chordsArray[0]!, fontSize: fontSize)
        let secondLine = FuncNode(funcText: funcText, value: chordsArray[1]!, fontSize: fontSize)
        let thirdLine = FuncNode(funcText: funcText, value: chordsArray[2]!, fontSize: fontSize)
        let fourthLine = FuncNode(funcText: funcText, value: chordsArray[3]!, fontSize: fontSize)
        
        let baseLine = fontSize/6.0
        let height = down ? 1.0 : 0.0
        
        firstLine.position = chordsArrayNode.position
        firstLine.position.y = down ? firstLine.position.y - baseLine * height - fontSize * 1.2 * height : firstLine.position.y
        
        secondLine.position = CGPoint(x: firstLine.position.x, y: firstLine.position.y - baseLine * 1 - fontSize * 1.2 * 1)
        thirdLine.position = CGPoint(x: firstLine.position.x, y: firstLine.position.y - baseLine * 2 - fontSize * 1.2 * 2)
        fourthLine.position = CGPoint(x: firstLine.position.x, y: firstLine.position.y - baseLine * 3 - fontSize * 1.2 * 3)
        
        firstLine.name = "firstLine"
        secondLine.name = "secondLine"
        thirdLine.name = "thirdLine"
        fourthLine.name = "fourthLine"
     
        firstLine.zPosition = 4
        secondLine.zPosition = 4
        thirdLine.zPosition = 4
        fourthLine.zPosition = 4
        
        addChild(firstLine)
        addChild(secondLine)
        addChild(thirdLine)
        addChild(fourthLine)
    }
    
    func setupLoopCode() {
        let fontSize = chordsArrayNode.fontSize
        setupForCode(down: true)
        let baseX = chordsArrayNode.position.x
        let baselineOffset = fontSize/6.0
        let whileCode = SKLabelNode(text: "while")
        whileCode.fontName = AppManager.shared.appFont
        whileCode.fontSize = fontSize
        whileCode.fontColor = UIColor(AppColors.secondary)
        whileCode.horizontalAlignmentMode = .left
        whileCode.verticalAlignmentMode = .baseline
        whileCode.position = CGPoint(x: baseX, y: codeBackground.position.y + 180.0 - baselineOffset - fontSize * 1.2)
        
        let middleText = SKLabelNode(text: "(")
        middleText.fontName = AppManager.shared.appFont
        middleText.fontSize = fontSize
        middleText.fontColor = UIColor(AppColors.primary)
        middleText.horizontalAlignmentMode = .left
        middleText.verticalAlignmentMode = .baseline
        middleText.position = CGPoint(x: whileCode.frame.maxX + 1, y: whileCode.position.y)
        
        let trueText = SKLabelNode(text: "true")
        trueText.fontName = AppManager.shared.appFont
        trueText.fontSize = fontSize
        trueText.fontColor = UIColor(AppColors.secondary)
        trueText.horizontalAlignmentMode = .left
        trueText.verticalAlignmentMode = .baseline
        trueText.position = CGPoint(x:  middleText.frame.maxX, y: whileCode.position.y)
        
        let endText = SKLabelNode(text: ") {")
        endText.fontName = AppManager.shared.appFont
        endText.fontSize = fontSize
        endText.fontColor = UIColor(AppColors.primary)
        endText.horizontalAlignmentMode = .left
        endText.verticalAlignmentMode = .baseline
        endText.position = CGPoint(x:  trueText.frame.maxX, y: whileCode.position.y)
        
        let endCodeLabel = SKLabelNode(text: "}")
        endCodeLabel.fontName = AppManager.shared.appFont
        endCodeLabel.fontSize = fontSize
        endCodeLabel.fontColor = UIColor(AppColors.primary)
        endCodeLabel.horizontalAlignmentMode = .left
        endCodeLabel.verticalAlignmentMode = .baseline
        endCodeLabel.position = CGPoint(x: baseX, y: whileCode.position.y - baselineOffset * (4) - fontSize * 1.2 * (5))
        
        whileCode.name = "while"
        middleText.name = "middle"
        endText.name = "end"
        endCodeLabel.name = "endCode"
        trueText.name = "true"
        
        whileCode.zPosition = 4
        middleText.zPosition = 4
        endText.zPosition = 4
        endCodeLabel.zPosition = 4
        trueText.zPosition = 4
        
        addChild(whileCode)
        addChild(middleText)
        addChild(trueText)
        addChild(endText)
        addChild(endCodeLabel)
    }
    
    func removeCode() {
        let sequentialNodes = ["firstLine", "secondLine", "thirdLine", "fourthLine"]
        
        let whileNodes = ["while", "whileConditionOpen", "whileConditionTrue", "whileConditionClose", "whileOpenBracket", "whileCloseBracket", "middle", "end", "true"]
        let whileNodes2 = ["endCode"]
        
        let forNodes = ["for", "variableChord", "inKeyword", "chordsArrayText", "loopOpenBracket", "playChordText", "loopCloseBracket"]
        
        let chordsArrayNodes = ["chordsArrayLabel", "equals", "openBracket", "closeBracket"]
        
        let valueNodes = (0..<4).map { "valueNode\($0)" }
        let commaNodes = (0..<3).map { "comma\($0)" }
        
        func removeNodes(_ names: [String]) {
            for name in names {
                if let node = childNode(withName: name) {
                    node.removeFromParent()
                }
            }
        }
        
        chordsArrayNode.removeAllChildren()
        removeNodes(sequentialNodes)
        removeNodes(whileNodes)
        removeNodes(forNodes)
        removeNodes(chordsArrayNodes)
        removeNodes(valueNodes)
        removeNodes(whileNodes2)
        removeNodes(commaNodes)
    }
    
    func setupForCode(down: Bool = false) {
        removeCode() // Limpa o código anterior
        chordsArrayNode.removeAllChildren()
        
        let fontSize = chordsArrayNode.fontSize
        let baselineOffset = fontSize / 6.0
        let spacing = AppManager.shared.fontSize * 0.8
        
        let baseX = chordsArrayNode.position.x
        let baseY = codeBackground.position.y + 180.0 - (down ? (baselineOffset + 2 * fontSize * 1.2) : (baselineOffset + fontSize * 1.2))
        let baseY2 = codeBackground.position.y + 180.0
        
        chordsArrayNode.arraySecondLine(values: self.chords)
        chordsArrayNode.position.y = baseY2
        chordsArrayNode.zPosition = 4        
        chordsArrayNode.removeFromParent()
        
        // Criando linha do array
        let chordsArrayLabel = createCodeLabel(text: "chordsArray", color: AppColors.primary, position: CGPoint(x: baseX, y: baseY2), fontSize: fontSize, name: "chordsArrayLabel")
        let equals = createCodeLabel(text: "=", color: .white, position: CGPoint(x: chordsArrayLabel.frame.maxX + spacing, y: baseY2), fontSize: fontSize, name: "equals")
        let openBracket = createCodeLabel(text: "[", color: .white, position: CGPoint(x: equals.frame.maxX + spacing, y: baseY2), fontSize: fontSize, name: "openBracket")
        
        var currentX = openBracket.frame.maxX + spacing - 5
        var valueNodes: [SKLabelNode] = []
        var commaNodes: [SKLabelNode] = []
        
        let chordsFiltered = chordsArray.compactMap { $0 }
        for (index, value) in chordsFiltered.enumerated() {
            let valueLabel = createCodeLabel(text: "\"\(value)\"", color: AppColors.secondary, position: CGPoint(x: currentX, y: baseY2), fontSize: fontSize, name: "valueNode\(index)")
            valueNodes.append(valueLabel)
            currentX += valueLabel.frame.width + spacing * 0.3
            
            if index < chordsFiltered.count - 1 {
                let commaLabel = createCodeLabel(text: ",", color: .white, position: CGPoint(x: currentX, y: baseY2), fontSize: fontSize, name: "comma\(index)")
                commaNodes.append(commaLabel)
                currentX += commaLabel.frame.width + spacing * 0.3
            }
        }
        
        let closeBracket = createCodeLabel(text: "]", color: .white, position: CGPoint(x: currentX, y: baseY2), fontSize: fontSize, name: "closeBracket")
        
        // Criando estrutura do loop `for`
        let forKeyword = createCodeLabel(text: "for", color: AppColors.secondary, position: CGPoint(x: baseX, y: baseY), fontSize: fontSize, name: "for")
        let variableChord = createCodeLabel(text: "chord", color: AppColors.primary, position: CGPoint(x: forKeyword.frame.maxX + spacing, y: baseY), fontSize: fontSize, name: "variableChord")
        let inKeyword = createCodeLabel(text: "in", color: AppColors.secondary, position: CGPoint(x: variableChord.frame.maxX + spacing, y: baseY), fontSize: fontSize, name: "inKeyword")
        let chordsArrayText = createCodeLabel(text: "chords", color: AppColors.primary, position: CGPoint(x: inKeyword.frame.maxX + spacing, y: baseY), fontSize: fontSize, name: "chordsArrayText")
        let loopOpenBracket = createCodeLabel(text: "{", color: AppColors.primary, position: CGPoint(x: chordsArrayText.frame.maxX + spacing, y: baseY), fontSize: fontSize, name: "loopOpenBracket")
        
        let playChordText = FuncNode(funcText: "playChord(chord: ", value: "chord", fontSize: fontSize)
        playChordText.position = CGPoint(x: baseX + 20, y: loopOpenBracket.position.y - baselineOffset * 2 - fontSize * 1.2 * 1)
        playChordText.codeTextWhite.text = "chord"
        playChordText.zPosition = 4
        playChordText.codeTextFinalParenteses.position.x -= fontSize
        playChordText.name = "playChordText"
        
        let loopCloseBracket = createCodeLabel(text: "}", color: AppColors.primary, position: CGPoint(x: baseX, y: playChordText.position.y - baselineOffset * 2 - fontSize * 1.2 * 1), fontSize: fontSize, name: "loopCloseBracket")
        
        // Adicionando os nós à cena
        addChildren([chordsArrayLabel, equals, openBracket])
        valueNodes.forEach { addChild($0) }
        commaNodes.forEach { addChild($0) }
        addChild(closeBracket)
        
        addChildren([forKeyword, variableChord, inKeyword, chordsArrayText, loopOpenBracket, playChordText, loopCloseBracket])
    }
    
    /// Função auxiliar para adicionar múltiplos filhos à cena
    func addChildren(_ nodes: [SKNode]) {
        nodes.forEach { addChild($0) }
    }
    
}
