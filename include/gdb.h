#ifndef GDB_H
#define GDB_H

/*
 * Functions callable in remote gdb support subsystem.
 */

/* Call at bootup to listen on AF_INET or AF_UNIX respectively */
void gdb_inet_init(int listenport);
void gdb_unix_init(const char *socketpath);

/* Call when stopping for a breakpoint */
void gdb_startbreak(void);

/* Call to find out if debugging on this address is available */
int gdb_canhandle(u_int32_t pcaddr);

/* Call for diagnostic purposes. */
void gdb_dumpstate(void);

#endif /* GDB_H */
