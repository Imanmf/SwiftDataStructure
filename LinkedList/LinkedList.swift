//
//  LinkedList.swift -- Implemented based on java Linked List
//  https://developer.classpath.org/doc/java/util/LinkedList-source.html
//  DataStructure
//
//  Created by Iman Mosayyebi on 11/17/23.
//

/**
 Linked list implementation of the List interface. In addition to the
 methods of the List interface, this class provides access to the first
 and last list elements in O(1) time for easy stack, queue, or double-ended
 queue (deque) creation. The list is doubly-linked, with traversal to a
 given index starting from the end closest to the element.
 
 - Attention:  LinkedList is not synchronized, so if you need multi-threaded access, consider that.
 - Authors: Iman Mosayebi (iman.mosayyebi@gmail.com)
 */

public class LinkedList<T> {
    //MARK: - private
    // The current length of the list.
    private var size: Int
    
    // The first element in the list.
    private var first: Entry<T>?
    
    //The last element in the list.
    private var last: Entry<T>?
    
    // Class to represent an entry in the list. Holds a single element.
    private final class Entry<S>: CustomStringConvertible, CustomDebugStringConvertible {
        
        // Entry uniq id
        private var id: UUID
        
        // The element in the list.
        var data: S
        
        // The next list entry, nil if this is last.
        var next: Entry<S>?
        
        // The previous list entry, nil if this is first.
        var previous: Entry<S>?
        
        /**
         Construct an entry.
         - Parameter data: data the list element
         */
        init(data: S) {
            self.data = data
            self.next = nil
            self.previous = nil
            self.id = UUID()
        }
        
        public static func==(lhs: Entry, rhs: Entry) -> Bool {
            return (lhs.id == rhs.id)
        }
        
        public var description: String {
            guard let next = next else {
                return "\(String(describing: data)) /."
            }
            return "\(String(describing: data)) <-> " + String(describing: next) + " "
        }
        
        var debugDescription: String {
            return description
        }
    } // class Entry
    
    /**
     Obtain the Entry at a given position in a list. This method of course
     takes linear time, but it is intelligent enough to take the shorter of the
     paths to get to the Entry required. This implies that the first or last
     entry in the list is obtained in constant time, which is a very desirable
     property.
     
     - Parameter n: the number of the entry to get
     - Returns: the entry at position n
     */
    private func getEntry(_ n: Int) -> Entry<T>? {
        if n < self.size / 2 {
            var e = self.first
            // n less than size/2, iterate from start
            for _ in 0..<n {
                e = e?.next
            }
            return e
        } else {
            var e = self.last
            // n greater than size/2, iterate from end
            for _ in n+1..<self.size {
                e =  e?.previous
            }
            return e
        }
    }
    
    /**
     Remove an entry from the list. This will adjust size and deal
     with 'first' and 'last' appropriatly.
     
     - Parameter e: the entry to remove
     */
    private func removeEntry(_ e: Entry<T>) {
        self.size -= 1
        if self.size == 0 {
            self.first = nil
            self.last = nil
        } else {
            if let first = self.first, e == first {
                self.first = e.next
                e.next?.previous = nil
            } else if let last = self.last, e == last {
                self.last = e.previous
                e.previous?.next = nil
            } else {
                e.next?.previous = e.previous
                e.previous?.next = e.next
            }
        }
    }
    
    /**
     Inserts an element at the end of the list.
     
     - Parameter e: the entry to add
     */
    private func addLastEntry(_ e: Entry<T>) {
        if self.size == 0 {
            self.first = e
            self.last = e
        } else {
            e.previous = self.last
            self.last?.next = e
            self.last = e
        }
        self.size += 1
    }
    
    /**
     Checks that the index is in the range of possible elements (inclusive).
     
     - Parameter index: the index to check
     - Returns: true if index is in range, flase if index is out of range
     */
    private func checkBoundsInclusive(_ index: Int) -> Bool {
        if index < 0 || index > self.size {
            return false
        }
        return true
    }
    
    /**
     Checks that the index is in the range of existing elements (exclusive).
     
     - Parameter index: the index to check
     - Returns: true if index is in range, flase if index is out of range
     */
    private func checkBoundsExclusive(_ index: Int) -> Bool {
        if index < 0 || index >= self.size {
            return false
        }
        return true
    }
    
    //MARK: - public functions
    //Create an empty linked list.
    public init() {
        self.size = 0
        self.first = nil
        self.last = nil
    }
    
    /**
     Create a linked list containing the elements, in order, of a given
     collection.
     
     - Parameter c: the collection to populate this list from
     */
    public convenience init(_ c: some Collection<T>) {
        self.init()
        self.addAll(c)
    }
    
    /**
     Returns the first element in the list.
     
     - Returns: the first list element, nil if empty
     */
    public func getFirst() -> T? {
        return first?.data
    }
    
    /**
     Returns the last element in the list.
     
     - Returns: the last list element, nil if empty
     */
    public func getLast() -> T? {
        return last?.data
    }
    
    /**
     Remove and return the first element in the list.
     
     - Returns: the former first element in the list, nil if empty
     */
    @discardableResult
    public func removeFirst() -> T? {
        guard let first = self.first else {
            return nil
        }
        self.size -= 1
        let r = first.data
        
        if first.next != nil {
            self.first?.next?.previous = nil
        }  else {
            last = nil
        }
        
        self.first = self.first?.next
        
        return r
    }
    
    /**
     Remove and return the last element in the list.
     
     - Returns: the former last element in the list, nil if empty
     */
    @discardableResult
    public func removeLast() -> T? {
        guard let last = self.last else {
            return nil
        }
        self.size -= 1
        let r = last.data
        
        if last.previous != nil {
            self.last?.previous?.next = nil
        } else {
            first = nil
        }
        
        self.last = self.last?.previous
        
        return r
    }
    
    /**
     Insert an element at the first of the list.
     
     - Parameter o: the element to insert
     */
    public func addFirst(_ o: T) {
        let e = Entry(data: o)
        
        if self.size == 0 {
            self.first = e
            self.last = e
        } else {
            e.next = self.first
            self.first?.previous = e
            self.first = e
        }
        self.size += 1
    }
    
    /**
     Insert an element at the last of the list.
     
     - Parameter o: the element to insert
     */
    public func addLast(_ o: T) {
        self.addLastEntry(Entry(data: o))
    }
    
    /**
     Adds an element to the end of the list.
     
     - Parameter o: the entry to add
     */
    public func add(_ o: T) {
        self.addLastEntry(Entry(data: o))
    }
    
    /**
     Append the elements of the collection in iteration order to the end of
     this list. If this list is modified externally (for example, if this
     list is the collection), behavior is unspecified.
     
     - Parameter c: the collection to append
     - Returns: true if the list was modified
     */
    @discardableResult
    public func addAll(_ c: some Collection<T>) -> Bool {
        return addAll(index: self.size, c)
    }
    
    /**
     Insert the elements of the collection in iteration order at the given
     index of this list. If this list is modified externally (for example,
      if this list is the collection), behavior is unspecified.
     
     - Parameter c: the collection to append
     - Returns: true if the list was modified
     */
    @discardableResult
    public func addAll(index: Int, _ c: some Collection<T>) -> Bool {
        guard checkBoundsInclusive(index) else { return false}
        let cSize = c.count
        
        if cSize == 0 { return false }
        var itr = c.makeIterator()
        
        // Get the entries just before and after index. If index is at the start
        // of the list, BEFORE is null. If index is at the end of the list, AFTER
        // is null. If the list is empty, both are null.
        var after: Entry<T>? = nil
        var before: Entry<T>? = nil
        if index != self.size {
            after = getEntry(index)
            before = after?.previous
        } else {
            before = self.last
        }
        
        // Create the first new entry. We do not yet set the link from `before'
        // to the first entry, in order to deal with the case where (c == this).
        // [Actually, we don't have to handle this case to fufill the
        // contract for addAll(), but Sun's implementation appears to.]
        guard let data = itr.next() else { return false }
        var e = Entry(data: data)
        e.previous = before
        var prev = e
        let firstNew = e
        
        // Create and link all the remaining entries.
        for _ in 1..<cSize {
            guard let data = itr.next() else { return false }
            e = Entry(data: data)
            e.previous = prev
            prev.next = e
            prev = e
        }
        
        self.size += cSize
        prev.next = after
        if after != nil {
            after?.previous = e
        } else {
            last = e
        }
        
        if before != nil {
            before?.next = firstNew
        } else {
            self.first = firstNew
        }
        
        return true
    }
    
    /**
     Insert the linkedlist at the given index of this list.
     
     - Parameter l: the linkedlist to append
     - Returns: true if the list was modified
     */
    @discardableResult
    public func addAll(index: Int, _ l: LinkedList<T>) -> Bool {
        guard checkBoundsInclusive(index) else { return false}
        let cSize = l.count
        
        if cSize == 0 { return false }
        
        // is null. If the list is empty, both are null.
        var after: Entry<T>? = nil
        var before: Entry<T>? = nil
        if index != self.size {
            after = getEntry(index)
            before = after?.previous
            
            l.first?.previous = before
            before?.next = l.first
            l.last?.next = after
            after?.previous = l.last
        } else {
            before = self.last
            
            before?.next = l.first
            l.first?.previous = before
        }
        self.size += cSize
        
        if after == nil {
            self.last = l.last
        }
        
        if before == nil {
            self.first = l.first
        }
        
        return true
    }
    
    //Remove all elements from this list.
    public func clear() {
        if self.size > 0 {
            self.first = nil
            self.last = nil
            self.size = 0
        }
    }
    
    /**
     Return the element at index.
     
     - Parameter index: the place to look
     - Returns: the element at index, nil if index is out of range
     */
    public func get(index: Int) -> T? {
        guard checkBoundsExclusive(index) else { return nil }
        return getEntry(index)?.data
    }
    
    /**
     Replace the element at the given location in the list.
     
     - Parameter index: which index to change
     - Parameter o: the new element
     - Returns: the prior element, nil if index is out of range
     */
    @discardableResult
    public func set(index: Int, _ o: T) -> T? {
        guard checkBoundsExclusive(index) else { return nil }
        let e = getEntry(index)
        let old = e?.data
        e?.data = o
        return old
    }
    
    /**
     Inserts an element in the given position in the list.
     
     - Parameter index: where to insert the element
     - Parameter o: the element to insert
     */
    public func add(index: Int, _ o: T) {
        guard checkBoundsInclusive(index) else { return }
        let e = Entry(data: o)
        
        if index < self.size {
            let after = getEntry(index)
            e.next = after
            e.previous = after?.previous
            if after?.previous == nil {
                first = e
            } else {
                after?.previous?.next = e
            }
            after?.previous = e
            size += 1
        } else {
            self.addLastEntry(e)
        }
    }
    
    /**
     Removes the element at the given position from the list.
     
     - Parameter index: the location of the element to remove
     - Returns: the removed element, nil if index is out of range
     */
    @discardableResult
    public func remove(index: Int) -> T? {
        guard checkBoundsExclusive(index) else { return nil }
        let e = getEntry(index)!
        removeEntry(e)
        return e.data
    }
    
    @discardableResult
    public static func+=(lhs: LinkedList, rhs: LinkedList) -> Bool {
        return lhs.addAll(index: lhs.size, rhs)
    }
    
    public static func+(lhs: LinkedList, rhs: LinkedList) -> LinkedList {
        lhs.addAll(index: lhs.size, rhs)
        return lhs
    }
    //MARK: - public get variables
    /**
     Returns an array which contains the elements of the list in order.
     
     - Returns: an array containing the list elements
    */
    public var toArray: [T] {
        var array: [T] = []
        var e = self.first
        while e != nil {
            array.append(e!.data)
            e = e?.next
        }
        return array
    }
    
    /**
     Returns the size of the list.
     
     - Returns: the list size
     */
    public var count: Int {
        return self.size
    }
}

//MARK: Equatable Objects
extension LinkedList where T : Equatable {
    
    /**
     Returns true if the list contains the given object.
     
     - Parameter o: the element to look for
     - Returns: true if it is found
     */
    public func contains(_ o: T) -> Bool {
        var e = self.first
        while e != nil {
            if o == e!.data {
                return true
            }
            e = e?.next
        }
        return false
    }
    
    /**
     Removes the entry at the lowest index in the list that matches the given
     object.
     
     - Parameter o: the object to remove
     - Returns: true if an instance of the object was removed, nil if o is not  exist
     */
    @discardableResult
    public func remove(_ o: T) -> Bool {
        var e = first
        while e != nil {
            if o == e!.data {
                removeEntry(e!)
                return true
            }
            e = e?.next
        }
        return false
    }
    
    /**
     Returns the first index where the element is located in the list, or nil.
     
     - Parameter o: the element to look for
     - Returns: its position, or nil if not found
     */
    public func indexOf(_ o: T) -> Int? {
        var index = 0
        var e = self.first
        while e != nil {
            if o == e!.data {
                return index
            }
            index += 1
            e = e?.next
        }
        return nil
    }
    
    /**
     Returns the last index where the element is located in the list, or nil.
     
     - Parameter o: the element to look for
     - Returns: its position, or nil if not found
     */
    public func lastIndexOf(_ o: T) -> Int? {
        var index = self.size - 1
        var e = self.last
        while e != nil {
            if o == e!.data {
                return index
            }
            index -= 1
            e = e?.previous
        }
        return nil
    }
}

//MARK: - CustomStringConvertible
extension LinkedList: CustomStringConvertible, CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
    
    public var description: String {
        guard let first = first else {
            return "Empty list"
        }
        return String(describing: first)
    }
}
