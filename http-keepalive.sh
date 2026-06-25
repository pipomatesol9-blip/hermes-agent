#!/bin/sh
exec python3 -c "
import http.server, os

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'ok')
    def log_message(self, *args):
        pass

port = int(os.environ.get('PORT', 10000))
httpd = http.server.HTTPServer(('0.0.0.0', port), Handler)
print(f'Keepalive HTTP en puerto {port}', flush=True)
httpd.serve_forever()
"
