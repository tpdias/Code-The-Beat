import SwiftUI
import SpriteKit

class PianoNode: SKNode {
    let noteNames = ["C", "D", "E", "F", "G", "A", "B"] 
    let sharpNotes = ["C#", "D#", "", "F#", "G#", "A#", ""]
    
    let keyWidth: CGFloat 
    let keyHeight: CGFloat
    let blackKeyHeight: CGFloat
    let blackKeyWidth: CGFloat
    
    init(size: CGSize) {
        self.keyWidth = 0.05 * size.width
        self.keyHeight = 3 * keyWidth 
        self.blackKeyHeight = keyHeight * 0.6
        self.blackKeyWidth = keyWidth * 0.6
        super.init()
        setupKeys()
        setupBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.keyWidth = 50
        self.keyHeight = 150
        self.blackKeyHeight = keyHeight * 0.6
        self.blackKeyWidth = keyWidth * 0.6
        super.init(coder: aDecoder)
        setupKeys()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "keyboardBackground1")
        background.size = CGSize(width: keyHeight*4, height: keyHeight*2.5)
        background.position = CGPoint(x: -keyWidth, y: keyHeight/1.5)
        background.zPosition = 1
        var backgroundTextures: [SKTexture] = []
        for i in 1...6 {
            backgroundTextures.append(SKTexture(imageNamed: "keyboardBackground\(i)"))
        }
        for i in (2..<6).reversed() {
            backgroundTextures.append(SKTexture(imageNamed: "keyboardBackground\(i)"))
        }
        background.run(SKAction.repeatForever(SKAction.animate(with: backgroundTextures, timePerFrame: 0.3, resize: false, restore: false)))
        self.addChild(background)
    }
    
    private func setupKeys() {
        let totalWidth = CGFloat(noteNames.count) * keyWidth + CGFloat((noteNames.count - 1) * 10)
        let startX = -totalWidth / 2 + keyWidth / 2
        
        for (index, note) in noteNames.enumerated() {
            // Criar tecla branca
            let whiteKey = SKSpriteNode(color: .white, size: CGSize(width: keyWidth, height: keyHeight))
            whiteKey.position = CGPoint(x: startX + CGFloat(index) * (keyWidth + 10), y: 0)
            whiteKey.name = note
            whiteKey.zPosition = 2
            
            // Adicionar label na tecla branca
            let label = SKLabelNode(text: note)
            label.fontSize = CGFloat(AppManager.shared.fontSize)
            label.fontColor = .black
            label.position = CGPoint(x: 0, y: -keyHeight + 50)
            label.fontName = AppManager.shared.appFont
            label.zPosition = 3
            
            whiteKey.addChild(label)
            addChild(whiteKey)
            
            // Criar tecla preta (sustenidos) se aplicável
            let sharpNote = sharpNotes[index]
            if !sharpNote.isEmpty {
                let blackKey = SKSpriteNode(color: .black, size: CGSize(width: blackKeyWidth, height: blackKeyHeight))
                blackKey.position = CGPoint(x: whiteKey.position.x + keyWidth / 2, y: keyHeight / 4.5)
                blackKey.zPosition = 3
                addChild(blackKey)
            }
        }
    }
    
    func checkTouchedNote(_ node: SKNode) -> String? {
        if let noteName = node.name { 
            if (noteNames.contains(noteName)) {
                guard let note = node as? SKSpriteNode else { return nil }
                playSound(noteName: noteName, duration: 1.0)
                animateNote(node: note)
                return noteName
            }
        }
        return nil
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

    func animateNote(node: SKSpriteNode) {
        let originalColor = node.color
        node.color = UIColor(AppColors.primary)
        node.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.2),
            SKAction.run { node.color = originalColor }
        ]))
    }
    
}
