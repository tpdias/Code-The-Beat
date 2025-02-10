import SwiftUI
import SpriteKit

class DJController: SKSpriteNode {
    var notes: [String] = ["C", "D", "E", "GMaj"]
    var buttons: [ControllerButton]
    init(size: CGSize) {
        buttons = []
       
        super.init(texture: SKTexture(imageNamed: "DJPad"), color: .clear, size: size)
        setupButtons()
        self.texture = SKTexture(imageNamed: "DJPad")
        self.size = size
    }
    
    func setupButtons() {
        for i in 0..<4 {
            var texture = SKTexture(imageNamed: "GrayPadButton1")
            var position = CGPoint(x: 0, y: 0)
            var name = ""
            switch i {
            case 0: 
                name = "BluePadButton1"            
                texture = SKTexture(imageNamed: "BluePadButton1")
                position = CGPoint(x: 40, y: 0)
            case 1:
                name = "GrayPadButton11"
                position = CGPoint(x: 175, y: 0)
            case 2:
                position = CGPoint(x: 40, y: -150)
                name = "GrayPadButton12"
            case 3:
                name = "RedPadButton1"
                texture = SKTexture(imageNamed: "RedPadButton1")
                position = CGPoint(x: 175, y: -150)
            default:
                break
            }
            let button = ControllerButton(sound: notes[i], texture: texture, size: CGSize(width: size.width/6, height: size.height/6))
            button.zPosition = 1
            button.position = position
            button.name = name
            buttons.append(button)
            addChild(button)
        }
       
    }
    
    func checkPadClicks(name: String) -> Int {
        switch name {
        case "BluePadButton1":
            SoundManager.shared.playAudio(audio: "C", loop: false, volume: 0.5)
            animateButton(node: buttons[0])
            return 1
        case "RedPadButton1":
            SoundManager.shared.playAudio(audio: "GMaj", loop: false, volume: 0.5)
            animateButton(node: buttons[3])
            return 4
        case "GrayPadButton11":
            SoundManager.shared.playAudio(audio: "BMin", loop: false, volume: 0.5)
            animateButton(node: buttons[1])
            return 2
        case "GrayPadButton12":
            SoundManager.shared.playAudio(audio: "FMin", loop: false, volume: 0.5)            
            animateButton(node: buttons[2])
            return 3
        default:
            return 0
        }
    }
    
    
    func animateButton(node: SKSpriteNode) {
        if(node.name?.contains("Gray") == true){
            guard let newTextureName = node.name?.dropLast(2) else { return }
            node.texture = SKTexture(imageNamed: newTextureName.appending("2"))
        } else {
            guard let newTextureName = node.name?.dropLast(1) else {return}
            node.texture = SKTexture(imageNamed: newTextureName.appending("2"))
        }
        node.run(SKAction.wait(forDuration: 0.5)) {
            guard let name = node.name else { return }
            if(node.name?.contains("Gray") == true) {
                node.texture = SKTexture(imageNamed: "GrayPadButton1")
            } else {
                node.texture = SKTexture(imageNamed: name)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtonsArrayLevel() {
        buttons = []
        for i in 0..<4 {
            var texture = SKTexture(imageNamed: "GrayPadButton1")
            var position = CGPoint(x: 0, y: 0)
            var name = ""
            switch i {
            case 0: 
                name = "BluePadButton1"            
                texture = SKTexture(imageNamed: "BluePadButton1")
                position = CGPoint(x: 40, y: 0)
            case 1:
                name = "YellowPadButton1"
                position = CGPoint(x: 175, y: 0)
                texture = SKTexture(imageNamed: "YellowPadButton1")
            case 2:
                position = CGPoint(x: 40, y: -150)
                name = "GreenPadButton1"
                texture = SKTexture(imageNamed: "GreenPadButton1")
            case 3:
                name = "RedPadButton1"
                texture = SKTexture(imageNamed: "RedPadButton1")
                position = CGPoint(x: 175, y: -150)
            default:
                break
            }
            let button = ControllerButton(sound: notes[i], texture: texture, size: CGSize(width: size.width/6, height: size.height/6))
            button.zPosition = 1
            button.position = position
            button.name = name
            buttons.append(button)
            addChild(button)
        }
        
    }
    
    func checkPadClicksArrayLevel(name: String) -> Int {
        switch name {
        case "BluePadButton1":
            SoundManager.shared.playAudio(audio: "Cm", loop: false, volume: 0.5)
            animateButton(node: buttons[0])
            return 1
        case "RedPadButton1":
            SoundManager.shared.playAudio(audio: "G#", loop: false, volume: 0.5)
            animateButton(node: buttons[3])
            return 4
        case "YellowPadButton1":
            SoundManager.shared.playAudio(audio: "Fm", loop: false, volume: 0.5)
            animateButton(node: buttons[1])
            return 2
        case "GreenPadButton1":
            SoundManager.shared.playAudio(audio: "G", loop: false, volume: 0.5)            
            animateButton(node: buttons[2])
            return 3
        default:
            return 0
        }
    }
}
