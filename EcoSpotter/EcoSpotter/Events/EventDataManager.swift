import Foundation

class EventDataManager {
    static let shared = EventDataManager() // Singleton instance
    private var events: [Event] = [] // Store events
    private var toDoEvents: [Event] = []  // Store TO DO events 

    weak var delegate: EventDataManagerDelegate?
    
    func addToDoEvent(_ event: Event) {
        if !isEventInToDoList(event) {
            toDoEvents.append(event)
            print("Event added to To-Do list.")
            printToDoEvents()
        } else {
            print("Event is already in the To-Do list.")
        }
    }

    func printToDoEvents() {
            print("Current To-Do Events:")
            for event in toDoEvents {
                print("\(event.title) - \(event.description)")
            }
        }
    
    private init() {
        // Load events from storage if needed
    }
    
    // Add a new event
    func addEvent(_ event: Event) {
        events.append(event)
        delegate?.didAddEvent(event)
    }
    
    // Retrieve all events
    func getAllEvents() -> [Event] {
        return events
    }
    func getAllToDoEvents() -> [Event] {
        return toDoEvents
    }
    // Retrieve a specific event by index
    func getEvent(at index: Int) -> Event? {
        guard index >= 0, index < events.count else {
            return nil
        }
        return events[index]
    }
    
    func markEventAsCompleted(event: Event) {
            if let index = events.firstIndex(where: { $0.title == event.title && $0.description == event.description }) {
                events[index].isComplete = true
                toDoEvents.remove(at: index)
            }
        }
        
    func getCompletedEvents() -> [Event] {
        return events.filter { $0.isComplete }
    }
    
}

protocol EventDataManagerDelegate: AnyObject {
    func didAddEvent(_ event: Event)
}

extension EventDataManager {
    func isEventInToDoList(_ event: Event) -> Bool {
        return toDoEvents.contains(where: {
            $0.title == event.title &&
            $0.location.coordinate.latitude == event.location.coordinate.latitude &&
            $0.location.coordinate.longitude == event.location.coordinate.longitude
        })
    }
}
