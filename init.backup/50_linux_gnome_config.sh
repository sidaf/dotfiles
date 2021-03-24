# Linux-only stuff. Abort if not Linux.
is_linux || return 1

if [[ $(which gnome-shell) ]]; then
  e_info "Configuring GNOME desktop environment"

  # Disable screensaver
  gsettings set org.gnome.desktop.session idle-delay 0
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

  # Show date in top bar
  gsettings set org.gnome.desktop.interface clock-show-date true

  # change fonts
  gsettings set org.gnome.desktop.interface document-font-name 'Sans 10'
  gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 10.5'
  gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 10'

  # Set font antialiasing and hinting
  gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'grayscale'
  gsettings set org.gnome.settings-daemon.plugins.xsettings rgba-order 'rgb'
  gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'slight'

  # Hide notifications in lock screen
  gsettings set org.gnome.desktop.notifications show-in-lock-screen false

  # Disable Usage & History
  gsettings set org.gnome.desktop.privacy remember-recent-files false

  # Disable NetworkManager Notifications
  #gsettings set org.gnome.nm-applet disable-connected-notifications true
  gsettings set org.gnome.nm-applet disable-disconnected-notifications true

  # Set dock to use the full height
  #gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
  # Set dock to be always visible
  #gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
  # Set dock to the bottom
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

  # change keyboard layout
  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'gb')]"

  # Gnome extension
  # Enable "Alternate-tab"
  gnome-shell-extension-tool -e alternate-tab@gnome-shell-extensions.gcampax.github.com
  # Disable "Applications menu" extension
  gnome-shell-extension-tool -d apps-menu@gnome-shell-extensions.gcampax.github.com
  # Disable "Places status indicator"
  gnome-shell-extension-tool -d places-menu@gnome-shell-extensions.gcampax.github.com
  # Disable "Workspace Indicator"
  gnome-shell-extension-tool -d workspace-indicator@gnome-shell-extensions.gcampax.github.com
  # Disable "Easy Screen Cast"
  gnome-shell-extension-tool -d EasyScreenCast@iacopodeenosee.gmail.com

  # Configure GNOME terminal
  gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
  #gconftool-2 -t bool -s /apps/gnome-terminal/profiles/Default/login_shell true

  # Files
  gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'
  gsettings set org.gnome.nautilus.desktop volumes-visible false
  gsettings set org.gnome.nautilus.icon-view captions "['size', 'None', 'None']"

  # Enable gdm auto login if a virtual machine
  if [[ $(dmidecode | grep -i virtual) ]]; then
    file=/etc/gdm3/daemon.conf; [ -e "${file}" ] && cp -n $file{,.bkup}
    sed -i 's/^.*AutomaticLoginEnable = .*/AutomaticLoginEnable = true/' "${file}"
    sed -i 's/^.*AutomaticLogin = .*/AutomaticLogin = root/' "${file}"
  fi
else
  e_warn "GNOME does not appear to be installed, skipping..."
fi
