var http = require("http");
var url = require('url');
var querystring = require('querystring');
const dns = require('dns');

http.createServer(function (request, response) {
    pathName= url.parse(request.url).pathname;
    query= url.parse(request.url).query;
    console.log('pathName = ' + pathName);  
    console.log('query = ' + query);  
	console.log(query);
	dns.lookup(query, (err, address, family) => {
	  response.writeHead(200, {'Content-Type': 'text/plain'});
	  // response.write('Domain: ' + query + '\n');
	  response.write('IPv' + family + ' Adresse: ' + address);
	  response.end();
console.log(request);
	});

   // Send the HTTP header 
   // HTTP Status: 200 : OK
   // Content Type: text/plain
   // response.writeHead(200, {'Content-Type': 'text/plain'});

   // Send the response body as "Hello World"
   // response.end('Hello World\n');
   
   // console.log(request);
}).listen(8081);

// Console will print the message
console.log('Server running at http://127.0.0.1:8081/');
