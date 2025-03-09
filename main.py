from PyQt5.QtWidgets import (QApplication, QWidget, QLabel, QLineEdit, QPushButton, 
                            QGraphicsBlurEffect, QMainWindow, QVBoxLayout)
from PyQt5.QtCore import Qt, QTimer, QDateTime, QFile, QTextStream
from PyQt5.QtGui import QPixmap, QFont, QFontDatabase
import sys

class AzuOSLogin(QMainWindow):
    def __init__(self):
        super().__init__()

        inter_regular_font_file = QFontDatabase.addApplicationFont("assets/Inter-Regular.ttf")
        inter_thin_font_file = QFontDatabase.addApplicationFont("assets/Inter-Thin.ttf")

        if inter_regular_font_file != -1:
            inter_regular = QFontDatabase.applicationFontFamilies(inter_regular_font_file)[0]
        else:
            print("Failed to load Inter Regular")

        if inter_thin_font_file != -1:
            inter_thin = QFontDatabase.applicationFontFamilies(inter_thin_font_file)[0]
        else:
            print("Failed to load Inter Thin")

        self.setWindowTitle("AzuOS Login")
        self.setGeometry(100, 100, 1280, 720)

        # Login Status
        self.login_status_icon = QLabel(self)
        self.login_status_icon.setPixmap(QPixmap("assets/login-status-icon.png").scaled(40, 40))  # Add a valid icon path
        self.login_status_icon.move(20, 20)

        self.login_status_name = QLabel("Status", self)
        self.login_status_name.move(70, 20)

        # Status Bar
        self.status_bar = QWidget(self)
        self.status_bar.setGeometry(0, 0, self.width(), 40)
        self.status_bar.setStyleSheet('''
            background-color: rgba(0, 0, 0, 0.4);
            display: flex;
            flex-direction: row;
            padding: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.9);
        ''')

        self.status_text = QLabel("Login to AzuOS", self.status_bar)
        self.status_text.move(20, 10)
        self.status_text.setFont(QFont(inter_regular, 12))

        self.status_title = QLabel("AzuOS", self.status_bar)
        self.status_title.move(self.status_bar.width() // 2 - 50, 10)  # Centering the title
        self.status_title.setFont(QFont(inter_regular, 12))

        self.status_time = QLabel("03:00", self.status_bar)
        self.status_time.move(self.status_bar.width() - 120, 10)
        self.status_time.setFont(QFont(inter_regular, 12))

        # Login Panel
        self.login_panel = QWidget(self)
        self.login_panel.setObjectName('login_panel')
        self.login_panel.setGeometry(0, (self.height() // 2) - 210 , (self.width() * 30) // 100, 210)  # Set size and position directly
        self.login_panel.setStyleSheet('''
            #login_panel {
                background-color: rgba(0, 0, 0, 0.67);
                box-shadow: 0px 0px 50px rgba(0, 0, 0, 0.8);
                display: flex;
                flex-direction: column;
                border-top-right-radius: 24px;
                border-bottom-right-radius: 24px;
                border: 1px solid rgba(255, 255, 255, 0.125);
                padding: 20px;
            }

            #login_panel QLineEdit {
                background-color: rgba(0, 0, 0, 0.2);
                color: white;
                font-family: 'Inter';
                border: 1px solid rgba(255, 255, 255, 0.5);
                border-radius: 20px;
                outline: none;
                padding: 5px;
                height: 30px;
            }

            #login_panel QPushButton {
                background-color: transparent;
                color: white;
                font-family: 'Inter';
                border: 1px solid rgba(255, 255, 255, 0.5);
                border-radius: 20px;
                outline: none;
                padding: 5px;
                height: 40px;
                transition-duration: 0.2s;
            }

            #login_panel QPushButton:hover {
                background: rgba(255, 255, 255, 0.063)
                transform: scale(1.05);
            }
        ''')

        self.login_panel.move(0, (self.height() // 2) - self.login_panel.height() // 2)

        self.login_panel_layout = QVBoxLayout()
        self.login_panel.setLayout(self.login_panel_layout)
        self.login_panel_layout.setContentsMargins(20, 8, 20, 8)

        self.login_title = QLabel("Login")
        self.login_title.move(100, 20)
        self.login_title.setFont(QFont(inter_regular, 18))

        self.username_input = QLineEdit()
        self.username_input.setPlaceholderText("Username")
        self.username_input.setGeometry(50, 70, 200, 30)  # Set position and size
        self.username_input.setFont(QFont(inter_regular, 10))

        self.password_input = QLineEdit()
        self.password_input.setPlaceholderText("Password")
        self.password_input.setEchoMode(QLineEdit.Password)
        self.password_input.setGeometry(50, 120, 200, 30)  # Set position and size
        self.password_input.setFont(QFont(inter_regular, 10))


        self.login_button = QPushButton("Login")
        self.login_button.setGeometry(50, 170, 200, 40)  # Set position and size
        self.login_button.clicked.connect(self.login)
        self.login_button.setFont(QFont(inter_regular, 10))

        self.login_panel_layout.addWidget(self.login_title)
        self.login_panel_layout.addWidget(self.username_input)
        self.login_panel_layout.addWidget(self.password_input)
        self.login_panel_layout.addWidget(self.login_button)

        self.date_widget = QWidget(self)
        self.date_layout = QVBoxLayout()
        # Date & Time Display
        self.time_label = QLabel("00:00")
        # self.time_label.move(50, 0)
        self.time_label.setFont(QFont(inter_regular, 50, QFont.Bold))
        self.time_label.adjustSize()

        self.date_label = QLabel("January 1, 2000")
        self.date_label.setFont(QFont(inter_thin, 50))

        self.date_layout.addWidget(self.time_label)
        self.date_layout.addWidget(self.date_label)
        self.date_widget.setLayout(self.date_layout)
        self.date_widget.adjustSize()
        self.date_widget.move(int(self.width() - (self.width() * 0.18) - self.date_widget.width()), int((self.height() - self.date_widget.height()) // 2))


        # self.date_label.move(50, self.height() - 30)  # Below the time label

        # Set up timer to update time
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_datetime)
        self.timer.start(1000)  # Update every second

        self.update_datetime()

        self.load_stylesheet("login.css")

    def load_stylesheet(self, path):
        """Load a CSS file and apply the stylesheet."""
        file = QFile(path)
        if file.open(QFile.ReadOnly | QFile.Text):
            stylesheet = QTextStream(file)
            self.setStyleSheet(stylesheet.readAll())
            file.close()
        else:
            print(f"Failed to load stylesheet: {path}")

    def login(self):
        """Handle login button click."""
        username = self.username_input.text()
        password = self.password_input.text()
        print(f"Login Attempt: {username}, {password}")
        # Add actual login logic here

    def update_datetime(self):
        """Update the time and date."""
        now = QDateTime.currentDateTime()
        self.time_label.setText(now.toString("HH:mm"))
        self.date_label.setText(now.toString("MMMM d, yyyy"))

    def resizeEvent(self, event):
        self.date_widget.move(int(self.width() - (self.width() * 0.18) - self.date_widget.width()), int((self.height() - self.date_widget.height()) // 2))
        self.login_panel.move(0, (self.height() // 2) - self.login_panel.height() // 2)
        self.status_bar.setGeometry(0, 0, self.width(), 40)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = AzuOSLogin()
    window.show()
    sys.exit(app.exec_())
