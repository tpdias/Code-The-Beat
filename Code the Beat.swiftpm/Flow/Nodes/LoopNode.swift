import SwiftUI
import SpriteKit

class LoopNode: SKSpriteNode {
    let playButton: SKSpriteNode
    let loopButton: SKSpriteNode
    let stopButton: SKSpriteNode
    
    init(size: CGSize) {
        let buttonSize = CGSize(width: 75, height: 75)
        playButton = SKSpriteNode(texture: SKTexture(imageNamed: "playButton"), size: buttonSize)
        loopButton = SKSpriteNode(texture: SKTexture(imageNamed: "loopButton"), size: buttonSize)
        stopButton = SKSpriteNode(texture: SKTexture(imageNamed: "stopButton"), size: buttonSize)
        
        super.init(texture: SKTexture(imageNamed: "loopPadBackground"), color: .clear, size: CGSize(width: 926*0.5, height: 350*0.5))
        self.position = CGPoint(x: size.width/2 + 100, y: size.height/2)
        self.zPosition = 2
        
        playButton.position = CGPoint(x: -77, y: 0)
        loopButton.position = CGPoint(x: -2, y: 0)
        stopButton.position = CGPoint(x: 73, y: 0)
        
        playButton.name = "playButton"
        stopButton.name = "stopButton"
        loopButton.name = "loopButton"
        
        addChild(playButton)
        addChild(stopButton)
        addChild(loopButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkLoopTouch(name: String) -> Int? {
        switch name {
        case "playButton":
            playButton.texture = SKTexture(imageNamed: "playButtonPressed")
            playButton.run(SKAction.wait(forDuration: 0.5)) {
                self.playButton.texture = SKTexture(imageNamed: "playButton")
            }
            loopButton.texture = SKTexture(imageNamed: "loopButton")
            return 1        
        case "loopButton":
            loopButton.texture = SKTexture(imageNamed: "loopButtonPressed")
            return 2
        case "stopButton":
            stopButton.texture = SKTexture(imageNamed: "stopButtonPressed")
            stopButton.run(SKAction.wait(forDuration: 0.5)) {
                self.stopButton.texture = SKTexture(imageNamed: "stopButton")
            }
            loopButton.texture = SKTexture(imageNamed: "loopButton")
            return 3
        default:
            return nil
        }
    }
}
