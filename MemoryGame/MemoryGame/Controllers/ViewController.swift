//
//  ViewController.swift
//  MemoryGame
//
//  Created by Emilio Heinzmann on 10/10/20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var game: MemoryGame = MemoryGame()
    var isShowingTwoCards = false
    
    @IBOutlet weak var playsLabel: UILabel!
    @IBOutlet weak var collectionViewController: UICollectionView!
    
    @IBAction func restartButtonPress(_ sender: Any) {
        self.newGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let landscapeRawValue = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(landscapeRawValue, forKey: "orientation")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }

}

extension ViewController {
    
    var alertAction: UIAlertAction {
       UIAlertAction(title: "Bacana, bora de novo", style: .default, handler: { _ in self.newGame()})
   }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCard", for: indexPath) as! CollectionViewCell
        
        let currentImageName = game.cards[indexPath.item].imageName
        let currentCard = game.cards[indexPath.item]
        let imageName = currentCard.isIn(game.matchedCards) || currentCard.isIn(game.visibleCards) ? currentImageName : "hidden_card"
        
        cell.cellImage.image = UIImage(named: imageName)
        
        return cell.withShadow
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {
            return
        }
        
        if !isShowingTwoCards {
            game.guessCard(at: indexPath.item) { needsFlip in
                
                self.playsLabel.text = "Jogadas: \(self.game.numberOfPlays)"
                
                if self.game.visibleCards.count == 2 {
                    self.isShowingTwoCards = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.isShowingTwoCards = false
                        self.game.hideVisibleAndNotMatchedCards()
                        self.collectionViewController.reloadData()
                    }
                }
                
                if needsFlip {
                    cell.flip(card: self.game.cards[indexPath.item]) {
                        self.collectionViewController.reloadData()
                    }
                } else {
                    self.collectionViewController.reloadData()
                }
                
                if self.game.hasWon {
                    self.showMessageForTheWinner()
                }
            }
        }
    }
    
    func showMessageForTheWinner() {
        let alert = UIAlertController(title: "Boa, você terminou!", message: "Você precisou de \(game.numberOfPlays) tentativas para finalizar o jogo.", preferredStyle: .alert)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func newGame() {
        self.game = MemoryGame()
        self.playsLabel.text = "Jogadas: 0"
        self.collectionViewController.reloadData()
    }
}

