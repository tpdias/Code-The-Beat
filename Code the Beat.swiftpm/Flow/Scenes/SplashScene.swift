import SwiftUI
import SpriteKit



class SplashScene: SKScene {
    var background: SKSpriteNode
    var orientation: SKSpriteNode
    var orientationLabel: SKLabelNode
    var textures: [SKTexture] = []
    override init(size: CGSize) {
        background = SKSpriteNode(texture: SKTexture(imageNamed: "splash0"), color: .clear, size: CGSize(width: 1024, height: 636))
        if(AppManager.shared.biggerBackground) {
            background.scale(to: CGSize(width: 1520, height: 1050))
        }
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        background.name = "background"
        
        orientation = SKSpriteNode(imageNamed: "OrientationView")
        orientation.scale(to: size)
        orientation.position = CGPoint(x: size.width/2, y: size.height/2)
        orientation.zPosition = 2
        
        orientationLabel = SKLabelNode(text: "Use on Landscape Mode")
        orientationLabel.fontName = AppManager.shared.appFont
        orientationLabel.fontSize = 64
        orientationLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        orientationLabel.fontColor = .white
        orientationLabel.zPosition = 3
        
        super.init(size: size)
        for i in 1...13 {
            self.textures.append(SKTexture(imageNamed: "splash" + String(i)))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        self.scene?.scaleMode = .aspectFit
        let action = SKAction.animate(with: textures, timePerFrame: 3.5/TimeInterval(textures.count), resize: false, restore: false)
        
        self.addChild(self.orientation)
        self.addChild(self.orientationLabel)
        self.run(SKAction.wait(forDuration: 3)) {
            self.orientation.removeFromParent()
            self.orientationLabel.removeFromParent()
            self.addChild(self.background)
            self.background.run(SKAction.sequence([action, SKAction.wait(forDuration: 1.2)])) {
                let mainMenuScene = MenuScene(size: self.size)
                mainMenuScene.scaleMode = self.scaleMode
                self.view?.presentScene(mainMenuScene)
            }
        }                
    }
}
