//
//  ViewController.swift
//  Skullibrista
//
//  Created by Rennan Bruno on 06/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var street: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var viGameOver: UIView!
    @IBOutlet weak var lbTimePlayed: UILabel!
    @IBOutlet weak var lbInstructions: UILabel!
    
    
    
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
    }

    @IBAction func playAgain(_ sender: UIButton) {
    }
    
}

