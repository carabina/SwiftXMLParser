Pod::Spec.new do |s|
  s.name = "SwiftXMLParser"
  s.version = "1.0.0"
  s.summary = "SwiftXMLParser is an XMLParser written in Swift4.0."
  s.description = "The XML DOM (Document Object Model) defines the properties and methods 	for accessing and editing XML.An XMLParser notifies its delegate about the items 	(elements, attributes, CDATA , and Text) that it encounters as it processes an XML document."
  s.license = 'MIT'
  s.authors = {"Shubham Garg"=> "91garg.shubham@gmail.com"}
  s.requires_arc = true
  s.source = {:git =>  'https://github.com/ShubhGar/SwiftXMLParser.git', :tag =>   		s.version.to_s }
  s.ios.deployment_target    = '8.0'
 
end





