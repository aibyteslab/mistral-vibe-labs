from http.server import BaseHTTPRequestHandler, HTTPServer
import json


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            body = json.dumps({"service": "demo-api"}).encode()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(body)
        else:
            self.send_error(404)


if __name__ == "__main__":
    # Lab only: bound to localhost, never published.
    HTTPServer(("127.0.0.1", 8080), Handler).serve_forever()
