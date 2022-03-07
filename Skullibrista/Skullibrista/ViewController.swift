//
//  ViewController.swift
//  Skullibrista
//
//  Created by Rennan Bruno on 06/03/22.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var street: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var viGameOver: UIView!
    @IBOutlet weak var lbTimePlayed: UILabel!
    @IBOutlet weak var lbInstructions: UILabel!
    
    var isMoving = false
    lazy var motionManager = CMMotionManager()
    var gameTimer: Timer!
    var startDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viGameOver.isHidden = true
        
        //Vazando as imagens para que ao virar o celular não apareceça a borda branca.
        street.frame.size.width = view.frame.size.width * 2
        street.frame.size.height = view.frame.size.height * 2
        //Fixando o street sempre no mieo da tela
        street.center = view.center
        
        //Fixando o player sempre no meio da tela
        player.center = view.center
        //Criando um array de imagens a serem animadas
        player.animationImages = []
        for i in 0...7 {
            let image = UIImage(named: "player\(i)")!
            player.animationImages?.append(image)
        }
        //Setando o tempo que o array vai percorrer as imagens
        player.animationDuration = 0.5
        //Iniciando a animação de imagens
        player.startAnimating()
        
        //Escontedo o label de instruções do game
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            self.start()
        }
    }
    
    func start() {
        //Escondendo as instruções e a tela de game over
        lbInstructions.isHidden = true
        viGameOver.isHidden = true
        isMoving = false
        startDate = Date()
        
        //Zerando os angulos quando o jogo recomeçar
        self.player.transform = CGAffineTransform(rotationAngle: 0)
        self.street.transform = CGAffineTransform(rotationAngle: 0)
        
        //Utilizando o gerenciador de movimento do device.
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { data, error in
               
                if error == nil {
                    if let data = data {
                        print("x:", data.gravity.x, "y: ", data.gravity.y, "z: ", data.gravity.z)
                        //Configurando a angulação da caveira.
                        let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                        self.player.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                        //Validando se a caveira está dentro do angulo desejado no jogo
                        if !self.isMoving {
                            self.checkGameOver()
                        }
                    }
                }
                
            })
            }
            //Criando um timer para verificar a posição da caveira a cada 4 segundos
            gameTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            self.rotateWorld()
        })
            
    }
    //Gerando angulos aleatório no jogo para que o player tenha que manter a caveira dentro
    func rotateWorld() {
        let randomAngle = Double(arc4random_uniform(120))/100 - 0.6
        isMoving = true
        UIView.animate(withDuration: 0.75, animations: {
            self.street.transform = CGAffineTransform(rotationAngle: CGFloat(randomAngle))
        }) { (success) in
            self.isMoving = false
        }
    }
    
    //Criando o metodo para iniciar o Game Over
    func checkGameOver(){
        let worldAngle = atan2(Double(street.transform.a), Double(street.transform.b))
        let playerAngle = atan2(Double(player.transform.a), Double(player.transform.b))
        let diference = abs(worldAngle - playerAngle)
        if diference > 0.25 {
            gameTimer.invalidate()
            viGameOver.isHidden = false
            motionManager.stopDeviceMotionUpdates()
            //Calculando o tempo jogado.
            let secondsPlayed = round(Date().timeIntervalSince(startDate))
            lbTimePlayed.text = "Você jogou durante \(secondsPlayed) segundos"
            
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        start()
    }
    
}

