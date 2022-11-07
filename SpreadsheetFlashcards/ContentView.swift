//
//  ContentView.swift
//  SpreadsheetFlashcards
//
//  Created by James Young on 11/6/22.
//
import CoreXLSX
import SwiftUI
import CoreData
import SpriteKit
struct Row: Identifiable{
    let test:String
    let numberTest:String
    let id = UUID()
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var Workbooks = 
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    var scene: SKScene {
            
            let scene = TableScene()
            scene.size = CGSize(width: 300, height: 400)
            scene.scaleMode = .fill
            return scene
        }
    
   

    var body: some View {
        
        SpriteView(scene: scene)
                   .frame(width: 300, height: 400)
                   .ignoresSafeArea()

    }
    private func loadSpreadsheet(){
        let testURL = Bundle.main.url(forResource: "TestSpreadsheet", withExtension: "xlsx")
        guard let file = XLSXFile(filepath: testURL!.relativePath) else {
            fatalError("XLSX file at \(testURL?.relativePath) is corrupted or does not exist")
        }
        do{
            for wbk in try file.parseWorkbooks() {
              for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                if let worksheetName = name {
                  print("This worksheet has a name: \(worksheetName)")
                }
              }
            }
        }catch{
            print("error");
        }
        
        
        
        
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
