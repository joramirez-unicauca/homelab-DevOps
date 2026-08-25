const { app, BrowserWindow } = require('electron');
const path = require('path');

app.disableHardwareAcceleration();

function createWindow() {
	const win = new BrowserWindow({
		width: 1000,
		height: 700,
		webPreferences: {
			contextIsolation: true,
			nodeIntegration: false
		}
	});

	win.loadFile(path.join(__dirname, 'index.html'));
	win.webContents.openDevTools();
}

app.whenReady().then(() => {
	createWindow();

	app.on('activate', () => {
		if (BrowserWindow.getAllWindows().length === 0) {
			createWindow();
		}
	});
});

app.on('window-all-closed', () => {
	if (process.platform !== 'darwin') {
		app.quit();
	}
});
