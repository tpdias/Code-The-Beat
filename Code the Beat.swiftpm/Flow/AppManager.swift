import SwiftUI
import SpriteKit
import UIKit

class AppManager {
    static let shared = AppManager()
    
    var soundStatus: Bool = true
    var biggerBackground = false
    var pauseStatus: Bool = false 
    var openDyslexicStatus: Bool = false
    var appFontSizeTexts: CGFloat = 28
    var appFont: String = "Retro Gaming"
    let buttonSound: String = "ButtonSound"
    var fontSize: CGFloat = 24
    var titleFontSize: CGFloat = 48
    var inGame = false
    
    let wait = SKAction.wait(forDuration: 0.2)
    let fadeOut = SKAction.fadeOut(withDuration: 0.5)
    let fadeIn = SKAction.fadeIn(withDuration: 0.5)
    
    init() {
            let cfURL = Bundle.main.url(forResource: "Retro Gaming", withExtension: "ttf")! as CFURL
            let cfURLOpenD = Bundle.main.url(forResource: "OpenDyslexic3-Regular", withExtension: "ttf")! as CFURL
            CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
            CTFontManagerRegisterFontsForURL(cfURLOpenD, CTFontManagerScope.process, nil)
            var fontNames: [[AnyObject]] = []
            for name in UIFont.familyNames {
                fontNames.append(UIFont.fontNames(forFamilyName: name) as [AnyObject])
            }                
    }
    func animateToggle(toggle: SKSpriteNode, toggleState: Bool) {
        let transitionTexture = SKTexture(imageNamed: "ToggleTransition")
        var nextTexture = SKTexture()
        if(!toggleState){
            nextTexture = SKTexture(imageNamed: "ToggleOff")
        } else {
            nextTexture = SKTexture(imageNamed: "ToggleOn")
        }
        
        let changeToTransition = SKAction.setTexture(transitionTexture)
        let wait = SKAction.wait(forDuration: 0.1)
        let changeToOn = SKAction.setTexture(nextTexture)
        
        let sequence = SKAction.sequence([changeToTransition, wait, changeToOn])
        
        toggle.run(sequence)
    }
    func animateSoundButton(button: SKSpriteNode) {
        button.texture = SKTexture(imageNamed: "SoundButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)   
        let sequence = SKAction.sequence([waitForAnimation])
        button.run(sequence) { 
            if(AppManager.shared.soundStatus) {
                button.texture = SKTexture(imageNamed: "SoundButton")
            }
            else {
                button.texture = SKTexture(imageNamed: "SoundButtonOff")
            }
        }
    }
    
    func animateButton(button: SKSpriteNode, textureName: String) {
        button.texture = SKTexture(imageNamed: textureName + "Pressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)
        button.run(waitForAnimation) {
            button.texture = SKTexture(imageNamed: textureName)
        }
    }
    
    func changeFont(){
        AppManager.shared.openDyslexicStatus.toggle()
        AppManager.shared.appFont = AppManager.shared.openDyslexicStatus ? "OpenDyslexic3" : "Retro Gaming"
        AppManager.shared.appFontSizeTexts = AppManager.shared.openDyslexicStatus ? 24 : 28
    }
    
    func changePauseStatus(pauseNode: PauseNode) {
        AppManager.shared.pauseStatus.toggle()
        if(AppManager.shared.pauseStatus) {
            pauseNode.pauseButton.removeFromParent()
            pauseNode.addChild(pauseNode.resumeButton)
            pauseNode.addChild(pauseNode.homeButton)
            pauseNode.addChild(pauseNode.configButton)
            
        } else {
            pauseNode.addChild(pauseNode.pauseButton)
            pauseNode.resumeButton.removeFromParent()
            pauseNode.homeButton.removeFromParent()
            pauseNode.configButton.removeFromParent()
        }
    }
    func checkSounds(name: String) {
        if(name.contains("Button") && AppManager.shared.soundStatus) {
            SoundManager.shared.playButtonSound()
        }
        if(name.contains("Toggle") && AppManager.shared.soundStatus) {
            SoundManager.shared.playToggleSound()
        }
    }
    
    func changeSoundStatus() {
        if(AppManager.shared.soundStatus) {
            AppManager.shared.soundStatus = false
            SoundManager.soundTrack.stopSounds()
        } else {
            AppManager.shared.soundStatus = true
            if !inGame {
                SoundManager.soundTrack.playAudio(audio: SoundManager.soundTrack.soundtrack, loop: true, volume: 0.5)
            }
        }
    }
}

extension UIColor {
    public static let mainGreen: UIColor = UIColor(red: 0.623, green: 0.863, blue: 0.396, alpha: 1)
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct AppColors {
    static let primary = Color(hex: "00CCBF") 
    static let secondary = Color(hex: "FF5F5D") 
    static let accent = Color(hex: "71A5A1") 
    
    static let background = Color(hex: "B8DAD7") 
    static let secondaryBackground = Color(hex: "F2B4AE") 
    static let tertiaryBackground = Color(hex: "D1A58C") 
    static let quaternaryBackground = Color(hex: "A8C4E3") 

    
    // Supporting Colors
    static let neutral = Color(hex: "BA8970") 
    static let tertiary = Color(hex: "FFD166") 
    static let quaternary = Color(hex: "3D5A80") 
    
    static let primaryHighlight = Color(hex: "5FFFF2")  
    static let secondaryHighlight = Color(hex: "FF8A84") 
    static let tertiaryHighlight = Color(hex: "FFE08D")  
    static let quaternaryHighlight = Color(hex: "75A9FF") 
}

func createCodeLabel(text: String, color: Color, position: CGPoint, fontSize: CGFloat = AppManager.shared.fontSize) -> SKLabelNode {
    let label = SKLabelNode(text: text)
    label.fontName = AppManager.shared.appFont
    label.fontSize = fontSize
    label.fontColor = UIColor(color)
    label.horizontalAlignmentMode = .left
    label.verticalAlignmentMode = .baseline
    label.position = position
    label.zPosition = 4
    return label
}
