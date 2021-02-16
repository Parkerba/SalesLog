//
//  ModelManager.swift
//  SalesLog
//
//  Created by parker amundsen on 10/21/20.
//

import CoreData

final class ModelManager {
    
    private var context: NSManagedObjectContext? = nil
    
    static let shared = ModelManager()
    
    private init() {}
    
    func setContext(_ context: NSManagedObjectContext) {
        self.context = context
        context.undoManager = UndoManager()
    }
    
    func createAndAddItem(name: String, price: Float) {
        guard let context = context else { return }
        let item = Item(context: context)
        item.name = name
        item.price = price
        context.perform {
            context.insert(item)
            do {
                try context.save()
                print("Creation and insertion successful")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchAllOrderItems( completion: ([OrderItem]?) -> Void) {
        let request = NSFetchRequest<OrderItem>(entityName: "OrderItem")
        do {
            let response = try context?.fetch(request)
            completion(response)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllItems(completion: ([Item]?) -> Void) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        do {
            let response = try context?.fetch(request)
            completion(response)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllOrders(completion: ([Order]?) -> Void) {
        let request = NSFetchRequest<Order>(entityName: "Order")
        do {
            let response = try context?.fetch(request)
            completion(response)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addOrder(name: String, paid: Bool, shipped: Bool, orderItemData: [(item: Item, size: String, quantity: Int16)]) {
        guard let context = context else { return }
        let order = Order(context: context)
        order.id = UUID()
        order.date = Date()
        order.name = name
        order.paid = paid
        order.shipped = shipped
        for orderItemElements in orderItemData {
            let orderItem = OrderItem(context: context)
            orderItem.item = orderItemElements.item
            orderItem.quantity = orderItemElements.quantity
            orderItem.size = orderItemElements.size
            order.addToOrderItems(orderItem)
        }
        context.insert(order)
        do {
            try context.save()
            print("order insertion and save successful")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func updateOrder(_ order: Order, name: String, paid: Bool, shipped: Bool, orderItemData: [(item: Item, size: String, quantity: Int16)]) {
        guard let context = context else { return }
        order.name = name
        order.paid = paid
        order.shipped = shipped
        for order in order.orderItems! {
            context.delete(order as! OrderItem)
        }
        order.orderItems = []
        for orderItemElements in orderItemData {
            let orderItem = OrderItem(context: context)
            orderItem.item = orderItemElements.item
            orderItem.quantity = orderItemElements.quantity
            orderItem.size = orderItemElements.size
            context.insert(orderItem)
            order.addToOrderItems(orderItem)
        }
        do {
            try context.save()
            print("order update and save successful")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeItem(_ item: Item) {
        context?.perform {
            self.context?.delete(item)
            do {
                try self.context?.save()
                print("Order item successfully deleted")
            } catch let error {
                self.context?.undo()
                print(error.localizedDescription)
            }
        }
    }
    
    func removeOrder(_ order: Order) {
        context?.perform {
            self.context?.delete(order)
            do {
                try self.context?.save()
                print("Order successfully deleted")
            } catch let error {
                self.context?.undo()
                print(error.localizedDescription)
            }
        }
    }
}
