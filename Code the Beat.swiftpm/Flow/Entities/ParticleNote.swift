import SwiftUI
import SpriteKit

class ParticleNote: SKSpriteNode {
    var textures: [SKTexture] = []
    
    init(position: CGPoint) {
        for i in 1...9 {
            textures.append(SKTexture(imageNamed: "note\(i)"))
        }
        super.init(texture: textures[0], color: .clear, size: CGSize(width: 64, height: 64))
        self.position = position
        let randomColorIndex = Int.random(in: 1...4)
        self.zPosition = 20
     
        switch randomColorIndex {
        case 1:
            self.color = UIColor(AppColors.primaryHighlight) 
        case 2:
            self.color = UIColor(AppColors.secondaryHighlight)
        case 3:
            self.color = UIColor(AppColors.tertiaryHighlight) 
        case 4:
            self.color = UIColor(AppColors.quaternaryHighlight) 
        default:
            self.color = UIColor.white 
        }
        
        self.colorBlendFactor = 1.0 
        
        run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.3)))
        animateUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateUp() {
        let direction: CGFloat = Bool.random() ? 1 : -1
        let speed = CGFloat.random(in: 1.0...3.0) 
        let amplitude = CGFloat.random(in: 20...50)
        
        let moveUpWithZigZag = SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: amplitude * direction, y: 50 * speed, duration: 0.2 * speed * 2.0), 
            SKAction.moveBy(x: -amplitude * direction, y: 50 * speed, duration: 0.2 * speed * 2.0) 
        ]))
        
        run(moveUpWithZigZag) 
        removeAfterAnimation()
    }
    
    func removeAfterAnimation() {
        let wait = SKAction.wait(forDuration: 1.0) 
        let fadeOut = SKAction.fadeOut(withDuration: 1.0) 
        let remove = SKAction.removeFromParent() 
        
        let sequence = SKAction.sequence([wait, fadeOut, remove]) 
        run(sequence)
    }
}
