import SwiftUI
import SpriteKit

class ControllerButton: SKSpriteNode {
    var sound: String = ""
    
     init(sound: String, texture: SKTexture, size: CGSize) {
        self.sound = sound
        super.init(texture: texture, color: .clear, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
