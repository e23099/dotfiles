# Commands used in setting up my Ubuntu



## Basic tools


### General software
```
sudo apt install git
```

### Neovim

```
sudo snap install --beta nvim --classic
```
see: [](https://github.com/neovim/neovim/wiki/Installing-Neovim#snap)

### Terminal Emulator
```
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt install alacritty
wget https://raw.githubusercontent.com/alacritty/alacritty/master/alacritty.yml --directory-prefix=$HOME/.config/alacritty/
```

You still need to edit the downloaded `alacritty.yml` file to set up the font.

### Fonts

```
sudo add-apt-repository universe
sudo apt install fonts-firacode
```

## Desktop Looks

### Tools

```
sudo apt install gnome-shell-extensions gnome-shell-extension-prefs gnome-tweaks
```

### Extension manager

Use Extension manager to make gnome looks better.

To install Extension manager, we need to install flatpak first:
```
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```
see: [flatpak](https://flatpak.org/setup/Ubuntu)
This will require system reboot.

After installed flatpak, we can manually install Extension manager using these commands:
```
flatpak install flathub com.mattjakeman.ExtensionManager
```

Then we'll have Extension manager sit in our system.
Follow this [Youtube video](https://youtu.be/x7LEHV4LRpU) for more setting.

