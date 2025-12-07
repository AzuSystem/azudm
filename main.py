import sys
import os
import pam
import subprocess
from PyQt5.QtCore import QObject, pyqtSlot, QThread, pyqtSignal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

# os.environ["QML_DEBUG"] = "1"

app = QGuiApplication(sys.argv)

xsessions = "/usr/share/xsessions"
waylandsessions = "/usr/share/wayland-sessions"
session_dirs = [xsessions, waylandsessions]

class Backend(QObject): # wth do I call this??
	def __init__(self):
		super().__init__()

		# just set initilise the selected session variable for use
		self.selected_session = None

	@pyqtSlot(result='QVariantMap')
	def get_sessions(self):
		sessions = {}

		# all this nesting is probably bad xd, my bad gng...
		for directory in session_dirs:
			if os.path.exists(directory):
				for file in os.listdir(directory):
					if file.endswith(".desktop"):
						with open(os.path.join(directory, file), "r") as f:
							name, cmd = None, None
							for line in f:
								if line.startswith("Name="):
									name = line.strip().split("=", 1)[1]
								elif line.startswith("Exec="):
									cmd = line.strip().split("=", 1)[1]
								if name and cmd:
									break

						if name and cmd:
							sessions[name] = cmd

		return sessions		
	
	@pyqtSlot(str)
	def select_session(self, name):
		self.selected_session = name
	
	authFinished = pyqtSignal(bool, str)

	@pyqtSlot(str, str)
	def auth_user(self, username, password):
		self.worker = AuthWorker(username, password)
		self.worker.result.connect(self.authFinished)
		self.worker.start()

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
		except Exception as e:
			self.result.emit(False, str(e))

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)

# engine.rootContext().setContextProperty("backend", Backend())

backend = Backend()
engine.rootContext().setContextProperty("backend", backend)
engine.load('layouts/main.qml')

print(Backend.get_sessions(0))
root = engine.rootObjects()[0]
root.showFullScreen()

sys.exit(app.exec())