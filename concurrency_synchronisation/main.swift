//
//  main.swift
//  concurrency_synchronisation
//
//  Created by nech on 21/11/2021.
//

import Foundation

// put all tickets in stock array and print
struct Ticket{
    let nr: Int;
    var sold: Bool;
    var used: Bool;

    var description: String{
      return "Ticket Number \(nr) \t Sold: \(sold)\t Used: \(used)"
    }
}
var ticketStock = [Ticket]()

func fillStock(){
    for i in 0..<20{
    ticketStock.append(Ticket(nr: i, sold: false, used: false))
        print(ticketStock[i].description)
    }
}

// divide customers into three groups
class Customer{
    var id:Int;
  var boughtTickets = [Ticket]();
    
    init(id: Int){
      self.id = id
    }

    func printTickets(){
    if boughtTickets.count > 0 {
      for i in 0..<boughtTickets.count{
        print(boughtTickets[i].description)
      }
    }
  }
  var description: String{
    return "Customer id:\(id) \tTickets: \(printTickets())"
  }
}

var customersGroup1 = [Customer]()
var customersGroup2 = [Customer]()
var customersGroup3 = [Customer]()

func dividCustomers(){
    for i in 1..<6{
      customersGroup1.append(Customer(id: i))
    }
    for i in 6..<11{
      customersGroup2.append(Customer(id: i))
    }
    for i in 11..<16{
      customersGroup3.append(Customer(id: i))
    }
}
func printCustomers(){
    print("**************** Customers ******************")
    for i in 0..<customersGroup1.count{
    print(customersGroup1[i].description)
    }
    for i in 0..<customersGroup1.count{
    print(customersGroup2[i].description)
    }
    for i in 0..<customersGroup1.count{
    print(customersGroup3[i].description)
    }
}

//
class TicketCounter{
  
  func sellTickets(requestedTickets:Int, stock: inout [Ticket]) -> [Ticket]{
    var soldTickets = [Ticket]()
      print("Trying to sell \(requestedTickets) Ticket(s)")
        for _ in 0..<requestedTickets{
        if(stock.count > 0){
          print("Removing - \(stock[stock.count - 1].description)")
          stock[stock.count - 1].sold = true
          print("Stamping Ticket Number: \(stock[stock.count-1].nr)")
          print("Selling - \(stock[stock.count - 1].description)")
          soldTickets.append(stock[stock.count - 1])
          stock.remove(at: stock.count - 1)
        } else {
          print("No more tickets")
          break
      }
 }
  return soldTickets
}
}
var counter1 = TicketCounter()
var counter2 = TicketCounter()
var counter3 = TicketCounter()
let customerQueue = DispatchQueue.global(qos: .userInitiated)

func boxOffice(){
    print("********************* Selling **********************")
    for i in 0..<customersGroup1.count{

    if(ticketStock.count == 0){
    print("Sold out")
    break
  }
    customerQueue.sync{
    let random = Int.random(in: 1..<3)
    print("Counter 1")
    sleep(UInt32(random));
    customersGroup1[i].boughtTickets = counter1.sellTickets(requestedTickets: random, stock: &ticketStock)
  }
  
  customerQueue.sync{
    let random = Int.random(in: 1..<3)
    print("Counter 2")
    sleep(UInt32(random));
    customersGroup2[i].boughtTickets = counter2.sellTickets(requestedTickets: random, stock: &ticketStock)
  }

  customerQueue.sync{
    let random = Int.random(in: 1..<3)
    print("Counter 3")
    sleep(UInt32(random));
    customersGroup3[i].boughtTickets = counter3.sellTickets(requestedTickets: random, stock: &ticketStock)
  }

  }
}
let enterQueue = DispatchQueue.global(qos: .userInitiated)
func enter(){
    print("********************* Enter **********************")
  for i in 0..<customersGroup1.count{
      enterQueue.sync{
      print("Welcome Customer \(customersGroup1[i].id)")
      print("You have \(customersGroup1[i].boughtTickets.count) Tickets!")
    for j in 0..<customersGroup1[i].boughtTickets.count{
      if(!customersGroup1[i].boughtTickets[j].used){
        print("Checking your tickets .. - \(customersGroup1[i].boughtTickets[j].description)")
        print("Ticket valid. Welcome!")
          customersGroup1[i].boughtTickets[j].used = true
        print("Invalidating ticket .. - \(customersGroup1[i].boughtTickets[j].description)")
        } else {
        print("Invalid ticket!")
      }
    }
  }
        enterQueue.sync{
        print("Welcome Customer \(customersGroup2[i].id)")
        print("You have \(customersGroup2[i].boughtTickets.count) Tickets!")
      for j in 0..<customersGroup2[i].boughtTickets.count{
        if(!customersGroup2[i].boughtTickets[j].used){
          print("Checking your tickets .. - \(customersGroup2[i].boughtTickets[j].description)")
          print("Ticket valid. Welcome!")
            customersGroup2[i].boughtTickets[j].used = true
          print("Invalidating ticket .. - \(customersGroup2[i].boughtTickets[j].description)")
          } else {
          print("Invalid ticket!")
        }
      }
    }
        enterQueue.sync{
        print("Welcome Customer \(customersGroup3[i].id)")
        print("You have \(customersGroup3[i].boughtTickets.count) Tickets!")
      for j in 0..<customersGroup3[i].boughtTickets.count{
        if(!customersGroup3[i].boughtTickets[j].used){
          print("Checking your tickets .. - \(customersGroup3[i].boughtTickets[j].description)")
          print("Ticket valid. Welcome!")
            customersGroup3[i].boughtTickets[j].used = true
          print("Invalidating ticket .. - \(customersGroup3[i].boughtTickets[j].description)")
          } else {
          print("Invalid ticket!")
        }
      }
    }
    }
}



fillStock()
dividCustomers()
boxOffice()
printCustomers()
enter()

