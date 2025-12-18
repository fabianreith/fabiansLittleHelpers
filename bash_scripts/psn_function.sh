psn() {
ps -ef -o user,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,command,etime,euid | egrep "PID|$@"
}
