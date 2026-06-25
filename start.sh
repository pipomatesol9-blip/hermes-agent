#!/bin/sh
python3 -c "
import http.server, threading, os

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Hermes Agent activo')
    def log_message(self, *args):
        pass

port = int(os.environ.get('PORT', 8080))
server = http.server.HTTPServer(('0.0.0.0', port), Handler)
thread = threading.Thread(target=server.serve_forever)
thread.daemon = True
thread.start()
print(f'HTTP keepalive en puerto {port}')
" &

hermes gateway start
