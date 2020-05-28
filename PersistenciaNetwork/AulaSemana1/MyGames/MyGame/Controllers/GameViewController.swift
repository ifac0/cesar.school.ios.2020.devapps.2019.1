//
//  GameViewController.swift
//  MyGame
//
//  Created by Ivan Costa on 28/05/20.
//

import UIKit

class GameViewController: UIViewController {

    var game: Game!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var ivCoverConsole: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData(){
        lbTitle.text = game.title
        lbConsole.text = game.console?.name
        
        if let releaseDate = game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            lbReleaseDate.text = formatter.string(from: releaseDate)
        } else {
            lbReleaseDate.text = "Lançamento"
        }
        
        if let image = game.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCoverFull")
        }
        
        if let imageConsole = game.console?.coverConsole as? UIImage {
            ivCoverConsole.image = imageConsole
        } else {
            ivCoverConsole.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }
    
}
