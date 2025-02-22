import SpriteKit
import SwiftUI
import UIKit

var onMenu = true
struct MainMenuView: View {
    var body: some View {
        GeometryReader { geometry in 
            //SpriteKitView(scene: SplashScene(size: CGSize(width: geometry.size.width, height: geometry.size.height)), size: geometry.size)
            
           SpriteKitView(scene: SplashScene(size: CGSize(width: 1330, height: 998)), size: CGSize(width: 1330, height: 998))
               
        }
        .ignoresSafeArea()
    }
}

struct SpriteKitView: UIViewRepresentable {
    typealias UIViewType = SKView
    let scene: SKScene
    let size: CGSize
    
    init(scene: SKScene, size: CGSize) {
        self.scene = scene
        self.size = size
    }
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update the view if needed
    }
}


class MenuScene: SKScene {
    var initialSize: CGSize = .zero
    let blockView: SKSpriteNode
    
    override init(size: CGSize) {
        AppManager.shared.inGame = false
        self.blockView = SKSpriteNode(imageNamed: "BlockView")
        blockView.scale(to: size)
        blockView.position = CGPoint(x: size.width/2, y: size.height/2)
        blockView.zPosition = 10
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        onMenu = true
        self.size = view.bounds.size
        createMenu()
        if(AppManager.shared.soundStatus) {
            SoundManager.soundTrack.playAudio(audio: SoundManager.soundTrack.soundtrack, loop: true, volume: 0.5)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override var size: CGSize {
        get {
            return self.initialSize // Return the size
        }
        set {
            // define the size
            if self.initialSize == .zero {
                self.initialSize = newValue
            }
        }
    }
    
    func createMenu() {
        guard let viewSize = view?.bounds.size else { return }
        self.size = viewSize
        backgroundColor = SKColor.black
        
        //Background
        let background = SKSpriteNode(imageNamed: "MenuBackground")
        background.size = size
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        background.alpha = 0.7
        addChild(background)
        
//        //Sound Button
//        let soundButton = SKSpriteNode(imageNamed: "SoundButton")
//        if(!AppManager.shared.soundStatus) {
//            soundButton.texture = SKTexture(imageNamed: "SoundButtonOff")
//        }
//        //soundButton.scale(to: CGSize(width: 48, height: 48)
//        soundButton.scale(to: CGSize(width: size.width / 25, height: size.width / 25))
//        soundButton.position = CGPoint(x: size.width - 100, y: size.height - 100)
//        soundButton.zPosition = 1
//        soundButton.name = "soundButton"
//        addChild(soundButton)
        
        
        // First Line
        let firstLineLabel = SKLabelNode(text: "Code the Beat")
        firstLineLabel.fontName = AppManager.shared.appFont
        firstLineLabel.fontColor = .white
        firstLineLabel.fontSize = 64
        firstLineLabel.horizontalAlignmentMode = .center
        firstLineLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        firstLineLabel.zPosition = 2
        addChild(firstLineLabel)
        
        // First Line
        let firstLineLabelB = SKLabelNode(text: "Code the Beat")
        firstLineLabelB.fontName = AppManager.shared.appFont
        firstLineLabelB.fontColor = .black
        firstLineLabelB.fontSize = 64
        firstLineLabelB.horizontalAlignmentMode = .center
        firstLineLabelB.position = CGPoint(x: size.width / 2 - 8, y: size.height / 2 + 100 - 5)
        firstLineLabelB.zPosition = 1
        addChild(firstLineLabelB)
        
        // Botton "Play"
        let playButton = SKSpriteNode(imageNamed: "Button")
        //playButton.scale(to: CGSize(width: 192, height: 96))
        playButton.scale(to: CGSize(width: size.width/7, height: size.height / 10))
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        playButton.name = "playButton"
        addChild(playButton)
        
        //play Text
        let playLabel = SKLabelNode(text: "START")
        playLabel.fontSize = 24
        playLabel.position = playButton.position
        playLabel.fontColor = .black
        playLabel.fontName = AppManager.shared.appFont
        playLabel.name = "playLabel"
        addChild(playLabel)
        
        // Button "Configurations"
        let optionsButton = SKSpriteNode(imageNamed: "Button")
        optionsButton.scale(to: CGSize(width: 192, height: 96))
        optionsButton.position = CGPoint(x: size.width / 2, y: playButton.position.y - 120)
        optionsButton.name = "optionsButton"
        addChild(optionsButton)
        
        let optionsLabel = SKLabelNode(text: "OPTIONS")
        optionsLabel.fontSize = 24
        optionsLabel.fontColor = .black
        optionsLabel.fontName = AppManager.shared.appFont
        optionsLabel.position = optionsButton.position
        optionsLabel.name = "optionsLabel"
        addChild(optionsLabel)
        
        // Button "Credits"
        let creditsButton = SKSpriteNode(imageNamed: "Button")
        creditsButton.scale(to: CGSize(width: 192, height: 96))
        creditsButton.position = CGPoint(x: size.width / 2, y: optionsButton.position.y - 120)
        creditsButton.name = "creditsButton"
        addChild(creditsButton)
        
        let creditsLabel = SKLabelNode(text: "CREDITS")
        creditsLabel.fontSize = 24
        creditsLabel.fontColor = .black
        creditsLabel.position = creditsButton.position
        creditsLabel.fontName = AppManager.shared.appFont
        creditsLabel.name = "creditsLabel"
        addChild(creditsLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(self.size.width <= self.size.height) {
            addChild(blockView)
        }
        else {
            blockView.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                if((name.contains("Button") || name.contains("Label")) && AppManager.shared.soundStatus) {
                    SoundManager.shared.playButtonSound()
                }
                switch name {
                case "playButton":
                    if let playButton = touchedNode as? SKSpriteNode {
                        onMenu = false
                        let gameScene = IntroScene(size: self.size)
                        gameScene.scaleMode = self.scaleMode
                        
                        if let label = childNode(withName: "playLabel") as? SKLabelNode {
                           
                            performTransition(nextScene: gameScene, button: playButton, label: label)    
                        }
                    }
                    break
                case "playLabel":
                    if let playButton = self.childNode(withName: "playButton") as? SKSpriteNode {
                        onMenu = false
                        let gameScene = IntroScene(size: size)
                        gameScene.scaleMode = self.scaleMode
                        
                        if let label = childNode(withName: "playLabel") as? SKLabelNode {
                            performTransition(nextScene: gameScene, button: playButton, label: label)    
                        }
                    }
                    break
                case "creditsButton":
                    if let creditsButton = touchedNode as? SKSpriteNode {
                        let creditsScene = CreditsScene(size: self.size)
                        creditsScene.scaleMode = self.scaleMode
                        if let label = childNode(withName: "creditsLabel") as? SKLabelNode {
                            performTransition(nextScene: creditsScene, button: creditsButton, label: label)
                        }
                    }
                    break
                case "creditsLabel":
                    if let creditsButton = self.childNode(withName: "creditsButton") as? SKSpriteNode {
                        let creditsScene = CreditsScene(size: self.size)
                        creditsScene.scaleMode = self.scaleMode
                        if let label = childNode(withName: "creditsLabel") as? SKLabelNode {
                            performTransition(nextScene: creditsScene, button: creditsButton, label: label)
                        }
                    }
                    break
                case "optionsButton":
                    if let optionsButton = touchedNode as? SKSpriteNode {
                        let optionsScene = OptionsScene(size: self.size)
                        optionsScene.scaleMode = self.scaleMode
                        if let label = childNode(withName: "optionsLabel") as? SKLabelNode {
                            performTransition(nextScene: optionsScene, button: optionsButton, label: label)
                        }
                    }
                    
                    break
                case "optionsLabel":
                    if let optionsButton = childNode(withName: "optionsButton") as? SKSpriteNode {
                        let optionsScene = OptionsScene(size: self.size)
                        optionsScene.scaleMode = self.scaleMode
                        if let label = childNode(withName: "optionsLabel") as? SKLabelNode {
                            performTransition(nextScene: optionsScene, button: optionsButton, label: label)
                        }
                    }
                    break
//                case "soundButton":  
//                    if let soundButton = touchedNode as? SKSpriteNode {
//                        AppManager.shared.changeSoundStatus()
//                        AppManager.shared.animateSoundButton(button: soundButton)    
//                    }
//                    break
                default:
                    break
                }
            }
        }
    }
    func performTransition(nextScene: SKScene, button: SKSpriteNode, label: SKLabelNode) {
        button.texture = SKTexture(imageNamed: "ButtonPressed")
        label.position.y -= 10
        let waitForAnimation = SKAction.wait(forDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        
        let sequence = SKAction.sequence([waitForAnimation, fadeOut])

        // Run the action on the whole scene
        self.run(sequence) {
            // Transition to the next scene after the fade-out effect
            self.view?.presentScene(nextScene)
        }
    }

}

