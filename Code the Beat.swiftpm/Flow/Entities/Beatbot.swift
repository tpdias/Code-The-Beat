import SwiftUI
import SpriteKit

class Beatbot: SKSpriteNode {
    var texturesStd: [SKTexture] = []
    var texturesTlk: [SKTexture] = []
    var isTalking: Bool = false
    
    init(size: CGSize, position: CGPoint) {
        let texture = SKTexture(imageNamed: "BeatBotStd1")
         super.init(texture: texture, color: .clear, size: size)
        setupTextures()
        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextures() {
        for i in 1...3 {
            texturesStd.append(SKTexture(imageNamed: "BeatBotStd\(i)"))
        }
        texturesStd.append(SKTexture(imageNamed: "BeatBotStd2"))

        for i in 1...4 {
            texturesTlk.append(SKTexture(imageNamed: "BeatBotTalking\(i)"))
        }
        texturesTlk.append(contentsOf: [
            SKTexture(imageNamed: "BeatBotTalking3"),
            SKTexture(imageNamed: "BeatBotTalking4"),
            SKTexture(imageNamed: "BeatBotTalking3"),
            SKTexture(imageNamed: "BeatBotTalking4"),
            SKTexture(imageNamed: "BeatBotTalking3"),
            SKTexture(imageNamed: "BeatBotTalking2")
        ])
    }
    
    func animateTlk() {
        if(!isTalking) {
            removeAllActions()
            isTalking = true
            run(SKAction.animate(with: texturesTlk, timePerFrame: 0.5)) {
                self.isTalking = false
                self.animateStd()
            }
        }
    }
    func animateStd() {
        removeAllActions()
        run(SKAction.repeatForever(SKAction.animate(with: texturesStd, timePerFrame: 0.5)))
    }
}
