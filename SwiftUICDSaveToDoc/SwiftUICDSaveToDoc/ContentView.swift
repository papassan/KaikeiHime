//
//  ContentView.swift
//  SwiftUICDSaveToDoc
//
//  Created by 福田 敏一 on 2019/12/04.
//  Copyright © 2019 株式会社パパスサン. All rights reserved.
//


import SwiftUI
import CoreData

public class Student: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
}
struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Student.entity(), sortDescriptors: []) var students: FetchedResults<Student>
    
    
    var body: some View {
        VStack {
            List {
                ForEach(self.students, id: \.self) { student in
                    Text(student.name ?? "Unknown")
                }
            }
            
                HStack {
                Button("保存") {
                    let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                    let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

                    let chosenFirstName = firstNames.randomElement()!
                    let chosenLastName = lastNames.randomElement()!

                    // more code to come
                    let student = Student(context: self.moc)
                    student.id = UUID()
                    student.name = "\(chosenFirstName) \(chosenLastName)"
                    
                    try! self.moc.save()
                    
                }.padding(.all)
                 .border(Color.blue, width: 5)
                    .foregroundColor(.green)
                    .font(.title)
                    .frame(width: 100, height: 0, alignment: .center)
                    Spacer()
                Button(action: {
                    self.moc.delete(self.students[0])
                    
                    try! self.moc.save()
                    
                }) {
                    //Text("削除")
                    Image(systemName: "trash")
                }.padding(.all)
                    .background(Color.red)
                    .cornerRadius(40)
                    .foregroundColor(.black)
                    .padding(10)
                    .overlay(
                    RoundedRectangle(cornerRadius: 20).stroke(Color.purple, lineWidth: 5)
                )
            }.padding(20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}

