import SwiftUI
import SpriteKit

class CreditsScene: SKScene {
    var about: SKLabelNode
    var aboutText: SKLabelNode
    var creditsText: SKLabelNode
    var creditsImage: SKSpriteNode
    var copyright: SKLabelNode
    var copyrightText: SKLabelNode
    
    override init(size: CGSize) {
        let titleFont:CGFloat = 28
        let textFont:CGFloat = AppManager.shared.openDyslexicStatus ? 20 : 24
        creditsText = SKLabelNode(text: "Hi I'm Thiago, a 24 years old Computer Engineering Student from Brazil, currently studying on Germany. I'm an iOS Developer and an Alumni at Apple Developer Academy POA and I love to work on projects that I'm passionate about and to help people learn how to code. I also won the 2024 Swift Student Challenge with my project Parallelo.")
        creditsText.preferredMaxLayoutWidth = size.width / 1.3
        creditsText.numberOfLines = -1
        creditsText.position = CGPoint(x: size.width/2, y: size.height/2 + 200 - creditsText.frame.size.height)
        creditsText.zPosition = 1
        creditsText.fontName = AppManager.shared.appFont
        creditsText.fontSize = textFont
        creditsText.fontColor = .white
        
        about = SKLabelNode(text: "About")
        about.position = CGPoint(x: size.width / 2 , y: creditsText.position.y - 50)
        about.fontColor = UIColor(AppColors.secondary)
        about.fontSize = titleFont
        about.fontName = AppManager.shared.appFont
        
        aboutText = SKLabelNode(text: "Code the Beat is a game where you learn the principles of coding while create a incredible music beat from scratch. You're going to use loops, arrays and all sort of stuff to make the beat more alive.")
        aboutText.numberOfLines = -1
        aboutText.preferredMaxLayoutWidth = size.width / 1.3
        aboutText.zPosition = 1
        aboutText.fontName = AppManager.shared.appFont
        aboutText.fontSize = textFont
        aboutText.fontColor = .white
        aboutText.position = CGPoint(x: size.width/2, y: about.position.y - 100 - aboutText.frame.size.height / 2)
        
        copyright = SKLabelNode(text: "Copyright")
        copyright.position = CGPoint(x: size.width / 2 , y: aboutText.position.y - 50)
        copyright.fontColor = UIColor(AppColors.secondary)
        copyright.fontName = AppManager.shared.appFont
        copyright.fontSize = titleFont
        
        copyrightText = SKLabelNode(text: "Soundtrack: Something Wrong with my Dog by Pix: https://www.youtube.com/watch?v=ZfTxmwhrMfY\nPrimary Font: Retro Gaming: https://www.dafont.com/retro-gaming.font\nSecondary Font: OpenDyslexic - https://opendyslexic.org/")
        copyrightText.numberOfLines = -1
        copyrightText.position = CGPoint(x: size.width / 2 , y: copyright.position.y - 140 - copyrightText.frame.size.height / 2)
        copyrightText.fontColor = .white
        copyrightText.preferredMaxLayoutWidth = size.width / 1.3
        copyrightText.fontName = AppManager.shared.appFont
        copyrightText.fontSize = textFont
        
        creditsImage = SKSpriteNode(imageNamed: "Thiago1")
        creditsImage.position = CGPoint(x: size.width - size.width/6, y: size.height - 150)
        creditsImage.scale(to: CGSize(width: size.width/6, height: size.width/6))
        creditsImage.zPosition = 2
        creditsImage.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "Thiago1"), SKTexture(imageNamed: "Thiago2")], timePerFrame: 1)))
        super.init(size: size)
        self.backgroundColor = .black.withAlphaComponent(0.4)
        addChild(creditsText)
        addChild(about)
        addChild(aboutText)
        addChild(copyright)
        addChild(copyrightText)
        addChild(creditsImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {        
        //Background
        let background = SKSpriteNode(imageNamed: "MenuBackground")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2 - 25)
        background.zPosition = -1
        background.alpha = 0.35
        addChild(background)
        
        // First Line
        let firstLineLabel = SKLabelNode(text: "Credits")
        firstLineLabel.fontName = AppManager.shared.appFont
        firstLineLabel.fontColor = UIColor(AppColors.secondary)
        firstLineLabel.fontSize = 48
        firstLineLabel.horizontalAlignmentMode = .center
        firstLineLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 300)
        firstLineLabel.zPosition = 2
        addChild(firstLineLabel)
        
        
        // First Line
        let firstLineLabelB = SKLabelNode(text: "Credits")
        firstLineLabelB.fontName = AppManager.shared.appFont
        firstLineLabelB.fontColor = .black
        firstLineLabelB.fontSize = 48
        firstLineLabelB.horizontalAlignmentMode = .center
        firstLineLabelB.position = CGPoint(x: size.width / 2 - 8, y: size.height / 2 + 300 - 5)
        firstLineLabelB.zPosition = 1
        addChild(firstLineLabelB)
        
        
        //Back Button, return to menu on click
        let backButton = SKSpriteNode(imageNamed: "BackButton")
        backButton.scale(to: CGSize(width: 50, height: 50))
        backButton.position = CGPoint(x: 100, y: size.height - 100)
        backButton.zPosition = 1
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                if name == "backButton" {
                    // Voltar para o menu principal
                    if(AppManager.shared.soundStatus){
                        SoundManager.shared.playButtonSound()
                    }
                    if let backButton = touchedNode as? SKSpriteNode {
                        let menuScene = MenuScene(size: size)
                        menuScene.scaleMode = scaleMode
                        performTransition(nextScene: menuScene, button: backButton)
                    }
                }
            }
        }
    }
    func performTransition(nextScene: SKScene, button: SKSpriteNode) {
        button.texture = SKTexture(imageNamed: "BackButtonPressed")
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
