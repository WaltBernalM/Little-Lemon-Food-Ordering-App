//
//  HeroSection.swift
//  LittleLemonApp
//
//  Created by Walter Bernal on 27.08.2024.
//

import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var startersIsEnabled = true
    @State var mainsIsEnabled = true
    @State var dessertsIsEnabled = true
    @State var drinksIsEnabled = true

    @State var searchText = ""

    @State var loaded = false

    @State var isKeyboardVisible = false

    @State var searchCategory: String = ""
    let categories: [String] = ["starters", "desserts", "mains"]
    private let clearGray = Color.init(red: 0, green: 0, blue: 0, opacity: 0.1)

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if !isKeyboardVisible {
                        withAnimation() {
                            Hero()
                                .frame(maxHeight: 180)
                        }
                    }
                    TextField("Search menu", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .background(Color.primaryColor1)
                
                Text("ORDER FOR DELIVERY!")
                    .font(.sectionTitle())
                    .foregroundColor(.highlightColor2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories, id:\.self) { category in
                            Text("\(category)")
                                .padding(5)
                                .padding(.horizontal, 8)
                                .background(searchCategory == category
                                            ? Color.primaryColor1
                                            : Color.primaryColor3)
                                .foregroundColor(searchCategory == category
                                                 ? Color.white
                                                 : Color.primaryColor1)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .onTapGesture {
                                    if searchCategory == category {
                                        searchCategory = ""
                                        return
                                    }
                                    searchCategory = category
                                }
                        }
                    }
                    .toggleStyle(MyToggleStyle())
                    .padding(.horizontal)
                }
                FetchedObjects(
                    predicate: buildPredicate(),
                    sortDescriptors: buildSortDescriptors()
                ) { (dishes: [Dish]) in
                    List(dishes) { dish in
                        NavigationLink(destination: DetailItem(dish: dish)) {
                            FoodItem(dish: dish)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .onAppear {
            if !loaded {
                MenuList.getMenuData(viewContext: viewContext)
                loaded = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            withAnimation {
                self.isKeyboardVisible = true
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { notification in
            withAnimation {
                self.isKeyboardVisible = false
            }
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title",
                                  ascending: true,
                                  selector:
                                    #selector(NSString.localizedStandardCompare))]
    }
    
    func buildPredicate() -> NSPredicate {
        var predicates: [NSPredicate] = []

        if searchText.count > 0 {
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            predicates.append(searchPredicate)
        }

        if searchCategory.count > 0 {
            let categoryPredicate = NSPredicate(format: "category CONTAINS[cd] %@", searchCategory)
            predicates.append(categoryPredicate)
        }

        if predicates.isEmpty {
            return NSPredicate(value: true)
        }

        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
