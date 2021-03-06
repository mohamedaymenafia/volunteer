//
//  ListViewController.swift
//  Benevole
//
//  Created by Mohamed aymen AFIA on 19/05/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Firebase
class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
@IBOutlet var tvListPosts: UITableView!
    var ref: DatabaseReference!

    var listOfPosts = [Post]()
    var listOfPosts2 = [Post]()
    
    
    var postDetails : Post?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadPostFormFirebase()
        
        //listOfPosts.append(Post(postTitre: "facilitateur immersion culturelle", userUID: "", postDate: "2018-05-17",postSecteur: "Action bénévole"))
        //print("user uit\(UserUID!)")
      //  listOfPosts.append(Post(userUID: "", postTitre: "facilitateur immersion culturelle", postDescrition: "Description", postTache: "Tache", postCompetence: "Competence", postNature: "Nature", postInstruction: "Instruction", postDurée: "Durée", postNombrePost: "Nombre de post", postSecteur: "Action bénévole", postLangue: "Langue", postCause: "Cause", postDate: "Langue", postImage: "Cause"))
        
        tvListPosts.delegate = self
        tvListPosts.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfPosts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = listOfPosts[indexPath.row]

        let cellWithImage = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! PostTableViewCell
        
        
        cellWithImage.count = indexPath.row
        cellWithImage.setText(post: post)
        return cellWithImage
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DescViewController") as! DescViewController
        let post = listOfPosts2[indexPath.row]
        
        //vc.posts = listOfPosts[indexPath.row]
        vc.postDetails = post
        
        //GoToPosting()
       self.show(vc, sender: nil)
        //self.performSegue(withIdentifier: "step12", sender: nil)
        
    }
    
    
    func GoToPosting(){
        
        performSegue(withIdentifier: "show", sender: postDetails)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if  segue.identifier == "show"{
            
            if let vcposting = segue.destination as? EditPostViewController{
                
                if let userUID = sender as? Post{
                    
                    vcposting.posts = userUID
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    func loadPostFormFirebase(){
        
        
        self.ref.child("Posts").queryOrdered(byChild: "postDate").observe(.value, with: {
            (snapshot) in
            self.listOfPosts.removeAll()
            //self.listOfPosts.append(Post(postText: "", userUID: "x", postDate: "", postImage: ""))
             //self.listOfPosts.append(Post(userUID: "", postTitre: "", postDescrition: "", postTache: "", postCompetence: "", postNature: "", postInstruction: "", postDurée: "", postNombrePost: "", postSecteur: "", postLangue: "", postCause: "", postDate: "", postImage: ""))
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot{
                    
                    if let postDic = snap.value as? [String:Any]{
                        
                        var titreText:String?
                        if let posttitre = postDic["titre"] as? String {
                            
                            titreText = posttitre
                        }
                        var userUID:String?
                        if let userUIDF = postDic["userUID"] as? String {
                            
                            userUID = userUIDF
                        }
                        var postDate:CLong?
                        if let postDateF = postDic["postDate"] as? CLong {
                            
                            postDate = postDateF
                        }
                        var postImage:String?
                        if let postImageF = postDic["imagePath"] as? String {
                            
                            postImage = postImageF
                        }
                        var secteurText:String?
                        if let postSecteur = postDic["secteur"] as? String {
                            
                            secteurText = postSecteur
                        }
                        
                        var descriptionText:String?
                        if let value = postDic["description"] as? String {
                            
                            descriptionText = value
                        }
                        var tacheText:String?
                        if let value = postDic["tache"] as? String {
                            
                            tacheText = value
                        }
                        var competenceText:String?
                        if let value = postDic["competence"] as? String {
                            
                            competenceText = value
                        }
                        var natureText:String?
                        if let value = postDic["nature"] as? String {
                            
                            natureText = value
                        }
                        
                        var instuctionText:String?
                        if let value = postDic["instruction"] as? String {
                            
                            instuctionText = value
                        }
                        var duréeText:String?
                        if let value = postDic["durée"] as? String {
                            
                            duréeText = value
                        }
                        var nbPosteText:String?
                        if let value = postDic["nombrePoste"] as? String {
                            
                            nbPosteText = value
                        }
                        var langueText:String?
                        if let value = postDic["langue"] as? String {
                            
                            langueText = value
                        }
                        
                        var causeText:String?
                        if let value = postDic["cause"] as? String {
                            
                            causeText = value
                        }
                        
                        var imageurl:String?
                        if let value = postDic["imagePath"] as? String {
                            
                            imageurl = value
                        }
                        
                        self.listOfPosts.append(Post(postTitre: titreText!, userUID: userUID!, postDate: "\(postDate!)", postSecteur: secteurText!))
                        
                        
                        self.listOfPosts2.append(Post(userUID: userUID!, postTitre: titreText!, postDescrition: descriptionText!, postTache: tacheText!, postCompetence: competenceText!, postNature: natureText!, postInstruction: instuctionText!, postDurée: duréeText!, postNombrePost: nbPosteText!, postSecteur: secteurText!, postLangue: langueText!, postCause: causeText!, postDate: "\(postDate!)", postImage: imageurl!))
                        
                    }
                    
                }
                
                self.tvListPosts.reloadData()
                
                
            }
            
            
        })
        
    }
    
    
    
    
    
}
