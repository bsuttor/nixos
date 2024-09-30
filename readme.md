# Nix config on ubuntu
First copy id_ed25519 and id_rsa keys to your ~/.ssh folder and install utilies libs to install computer
```bash
cp /media/../* ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_ed25519
sudo apt install curl git
```


## Install nix and home manager

mutli user:

```
sh <(curl -L https://nixos.org/nix/install) --daemon

sudo -i
echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
echo "trusted-users = root bsuttor" >> /etc/nix/nix.conf
exit

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## Sops
Generate age key from ssh key
```
mkdir -p ~/.config/sops/age/
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/key.txt
```


## Clone nix repo, clean files managed by nix and start nix home manager
```
rm ~/.profile
rm ~/.bachrc
git clone git@github.com:bsuttor/nix-home.git ~/nix

home-manager switch --flake ~/nix/#$USER
```

### Add secret to sops

```bash
cd ~/nix && sops secrets/secrets.yaml
```

### Use secret with home manager


## Install with my hand
- chrome + gnome shell

install deb from google and after: sudo apt-get install chrome-gnome-shell

- bitwarden desktop
```
sudo snap install bitwarden
```
- vscode
```
sudo snap install code --classic
```
- dropbox
```
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
```
## To do after install
- synchro firefox/chrome with my user
- synchro vscode
- install vpn ("import from file" works with wireguard on 24.04)
- install docker engine: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
docker daemon can't connect when installing it via home-manager.
```
sudo usermod -aG docker $USER
```
