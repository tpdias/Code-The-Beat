import SwiftUI
import SpriteKit



class SplashScene: SKScene {
    var background: SKSpriteNode
    var orientation: SKSpriteNode
    var orientationLabel: SKLabelNode
    var textures: [SKTexture] = []
    override init(size: CGSize) {
        background = SKSpriteNode(imageNamed: "M3Splash0")
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
        addChild(background)
        for i in 0..<6 {
            self.textures.append(SKTexture(imageNamed: "Splash" + String(i)))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        self.scene?.scaleMode = .aspectFit
        let splashTime: TimeInterval = 3
        let wait = SKAction.wait(forDuration: splashTime * 2.3)
        let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: splashTime/(3*TimeInterval(textures.count)), resize: true, restore: true))
        let play = SKAction.run {
           // SoundManager.shared.playAudio(audio: "Electric", loop: true, volume: 0.1)
        }
        background.run(SKAction.group([action, play])) 
        self.run(SKAction.wait(forDuration: splashTime)) {
            self.addChild(self.orientation)
            self.addChild(self.orientationLabel)
            self.background.removeFromParent()
        }
        self.run(SKAction.wait(forDuration: splashTime)) {
            SoundManager.shared.stopSounds()
        }
        self.run(wait) {
            let mainMenuScene = MenuScene(size: self.size)
            mainMenuScene.scaleMode = self.scaleMode
            self.view?.presentScene(mainMenuScene)
        }
        
        
    }
}
