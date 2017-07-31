#!/usr/bin/env python
import sys,os,time,re,datetime

#########user section#########################
#user specific constants
username = "david"             #your cluster login name (use what shows up in qstatall)
max_run_hours = 200	#maximum number of hours submission script can run
warning_time = 24         #send out a warning after this many hours informing you that the deamon is still running
delayt = 900		  #delay time between job submissions (seconds)
scriptname = 'L1_parametric_cb1'
script_ext = 'sh'
d_log = 'daemon_%s.log'  % ( scriptname )


#subs = [ '203', '205', '207', '209', '211', '213' ]
subs = [ '203', '205', '207', '209', '211', '213', '215', '217', '219', '221', '223', '225', '227', '229', '231', '233', '235', '237' ]

runs = range(1,5) #goes from 1 to 4

###############################################

def daemonize(stdin='/dev/null',stdout='/dev/null',stderr='/dev/null'):
	try:
		#try first fork
		pid=os.fork()
		if pid>0:
			sys.exit(0)
	except OSError, e:
		sys.stderr.write("fork #1 failed: (%d) %s\n" % (e.errno,e.strerror))
		sys.exit(1)
	os.chdir("/")
	os.umask(0)
	os.setsid()
	try:
		#try second fork
		pid=os.fork()
		if pid>0:
			sys.exit(0)
	except OSError, e:
			sys.stderr.write("fork #2 failed: (%d) %s\n" % (e.errno, e.strerror))
			sys.exit(1)
	for f in sys.stdout, sys.stderr: f.flush()
	si=file(stdin,'r')
	so=file(stdout,'a+')
	se=file(stderr,'a+',0)
	os.dup2(si.fileno(),sys.stdin.fileno())
	os.dup2(so.fileno(),sys.stdout.fileno())
	os.dup2(se.fileno(),sys.stderr.fileno())
	

start_dir = os.getcwd()
 
daemonize('/dev/null',os.path.join(start_dir,d_log),os.path.join(start_dir,d_log))
sys.stdout.close()
os.chdir(start_dir)
temp=time.localtime()
hour,minute,second=temp[3],temp[4],temp[5]
prev_hr=temp[3]
t0=str(hour)+':'+str(minute)+':'+str(second)
log_name=os.path.join(start_dir,d_log)
log=file(log_name,'w')
log.write('Daemon started at %s with pid %d\n' %(t0,os.getpid()))
log.write('To kill this process type "kill %s" at the head node command line\n' % os.getpid())
log.close()
t0=time.time()
master_clock=0



#the business end of the script...
for sub in subs:
	for run in runs:
		cmd = "sh %s.%s %s %s"  % ( scriptname, script_ext, sub, run )
		os.popen2(cmd)
		time.sleep(delayt)
	
		t1=time.time()
		hour=(t1-t0)/3600
		log=file(log_name,'a+')
		log.write('Daemon has been running for %s hours\n' % hour)
		log.close()
		

