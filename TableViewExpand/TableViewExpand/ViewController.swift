//
//  ViewController.swift
//  TableViewExpand
//
//  Created by user on 31.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

let globalURL = "http://bible.mypressonline.com/wp-content/uploads/NewTestament/"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sections = [
        Section(book: "Євангеліє від Матвія", label: "Mathew", chapter: generateRange(28), expanded: false),
        Section(book: "Євангеліє від Марка", label: "Mark", chapter: generateRange(16), expanded: false),
        Section(book: "Євангеліє від Луки", label: "Luke", chapter: generateRange(28), expanded: false),
        Section(book: "Євангеліє від Івана", label: "John", chapter: generateRange(24), expanded: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread.sleepForTimeInterval(2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].chapter.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].expanded {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].book, section: section, delegate: self)
        header.arrowLabel.text = ">"
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = String(sections[indexPath.section].chapter[indexPath.row])
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        tableView.beginUpdates()
        if sections[section].expanded {
            header.setCollapsed(false)
        } else {
            header.setCollapsed(true)
        }
        for i in 0..<sections[section].chapter.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioVC = AudioVC()
        let book = sections[indexPath.section].label
        let chapter = sections[indexPath.section].chapter[indexPath.row]
        let relPathToPlay = book! + "/" + String(chapter)
        let fullPathToPlay = globalURL + relPathToPlay + ".mp3"
        audioVC.customInit(url: fullPathToPlay, book: sections[indexPath.section].label)
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(audioVC, animated: true)
    }
    
    static func generateRange(_ num: Int) -> [Int] {
        var arr = [Int]()
        arr += 1...num
        return arr
    }
    
}

