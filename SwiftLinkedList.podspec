Pod::Spec.new do |spec|

  spec.name         = "SwiftLinkedList"
  spec.version      = "0.0.1"
  spec.summary      = "A linked list Implemented based on java Linked List."

  spec.description  = <<-DESC
   Linked list implementation of the List interface. In addition to the
   methods of the List interface, this class provides access to the first
   and last list elements in O(1) time for easy stack, queue, or double-ended
   queue (deque) creation. The list is doubly-linked, with traversal to a
   given index starting from the end closest to the element.
                   DESC

  spec.homepage     = "https://github.com/Imanmf/SwiftDataStructure"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "mosayyebi" => "iman.mosayyebi@gmail.com" }

  spec.ios.deployment_target = "12.0"
  spec.osx.deployment_target = "10.13"
#   spec.watchos.deployment_target = "2.0"
#   spec.tvos.deployment_target = "9.0"
#   spec.visionos.deployment_target = "1.0"

  spec.source       = { :git => "https://github.com/Imanmf/SwiftDataStructure.git", :tag => "#{spec.version}" }
  spec.source_files  = "LinkedList/**/*.swift"
  spec.swift_versions = ['5.0', '5.1', '5.2', '5.3']

end
