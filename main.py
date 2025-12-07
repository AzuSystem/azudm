import sys
import os
import pam
import subprocess
import time
import pwd
from PyQt5.QtCore import QObject, pyqtSlot, QThread, pyqtSignal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

# os.environ["QML_DEBUG"] = "1"

app = QGuiApplication(sys.argv)

xsessions = "/usr/share/xsessions"
waylandsessions = "/usr/share/wayland-sessions"
# session_dirs = [xsessions, waylandsessions]

class Backend(QObject): # wth do I call this??
	def __init__(self):
		super().__init__()

		# just set initilise the variables for use
		self.selected_session = None
		self.session_server = 'x11'

	@pyqtSlot(result='QVariantMap')
	def get_sessions(self):
		sessions = {}

		# all this nesting is probably bad xd, my bad gng...
		# anyway, fetches all xsessions content
		if os.path.exists(xsessions):
			for file in os.listdir(xsessions):
				if file.endswith(".desktop"):
					with open(os.path.join(xsessions, file), "r") as f:
						name, cmd = None, None
						for line in f:
							if line.startswith("Name="):
								name = line.strip().split("=", 1)[1]
							elif line.startswith("Exec="):
								cmd = line.strip().split("=", 1)[1]
							if name and cmd:
								break

					if name and cmd:
						sessions[name] = {
							"exec": cmd,
							"server": "x11"
						}

		if os.path.exists(waylandsessions):
			for file in os.listdir(waylandsessions):
				if file.endswith(".desktop"):
					with open(os.path.join(waylandsessions, file), "r") as f:
						name, cmd = None, None
						for line in f:
							if line.startswith("Name="):
								name = line.strip().split("=", 1)[1]
							elif line.startswith("Exec="):
								cmd = line.strip().split("=", 1)[1]
							if name and cmd:
								break

					if name and cmd:
						sessions[name] = {
							"exec": cmd,
							"server": "wayland"
						}
							
		return sessions		
	
	@pyqtSlot(str)
	def select_session(self, name, server):
		self.selected_session = name
		self.session_server = "x11"
	
	authFinished = pyqtSignal(bool, str)

	@pyqtSlot(str, str)
	def auth_user(self, username, password):
		self.worker = AuthWorker(username, password)
		self.worker.result.connect(self.authFinished)
		self.worker.start()

	def start_session(username, password): 
		if not self.selected_session:
			print("No session selected")
			return

		sessions = self.get_sessions()
		session = sessions.get(self.selected_session)
		server = session['server']
		
		# needed to actual start a PAM session
		subprocess.Popen(['login', '-f', username])

		# setting group and user id
		os.setgid(pwd.getpwnam(username).pw_gid)
		os.setuid(pwd.getpwnam(username).pw_uid)

		env = os.environ.copy()
		env["HOME"] = pwd.getpwnam(username).pw_dir
		env["USER"] = username
		env["LOGNAME"] = username
		env["SHELL"] = pwd.getpwnam(username).pw_shell
		env["XDG_RUNTIME_DIR"] = "/run/user/" + pwd.getpwnam(username).pw_uid

		if server == 'x11':
			env['XDG_SESSION_DIR'] = 'x11'
		elif server == 'wayland': # ik i couldve written 'else' but hey xd
			env['XDG_SESSION_DIR'] = 'wayland'

		# replaces DM with your session, u probably wont be able to return but thats fine for now ( probably )
		os.execle('/bin/sh', 'sh', '-c', session_cmd, env)




class AuthWorker(QThread):
	result = pyqtSignal(bool, str)

	def __init__(self, username, password):
		super().__init__()
		self.username = username
		self.password = password

	def run(self):
		try:
			res = pam.authenticate(self.username, self.password)
			self.result.emit(res, "")
			time.sleep(2)
			# print('login')

		except Exception as e:
			self.result.emit(False, str(e))

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)

# engine.rootContext().setContextProperty("backend", Backend())

backend = Backend()
engine.rootContext().setContextProperty("backend", backend)
engine.load('layouts/main.qml')

print(Backend.get_sessions(0))
# print(Backend.get_sessions(0).get('Openbox')['server']) # little test
root = engine.rootObjects()[0]
root.showFullScreen()

sys.exit(app.exec())