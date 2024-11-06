const http = require('http');
const url = require('url');
const handle = require('./requestHandler').handle;

function onRequest(request, response) {
    const parsedUrl = url.parse(request.url, true);
    const pathname = parsedUrl.pathname;

    if (handle[pathname]) {
        handle[pathname](response);
    } else {
        response.writeHead(404, { 'Content-Type': 'text/html' });
        response.end('<h1>404 Not Found</h1>');
    }
}

http.createServer(onRequest).listen(8080, () => {
    console.log('Server running at http://localhost:8080');
});
