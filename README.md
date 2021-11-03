## Preparation
**You need to install `wget` , and `git` previously**

For **Ubuntu / Debian** : `apt install -y wget git`    

For **CentOS / Rocky** : `yum install -y wget git`
- Install Docker
```bash
wget -qO- get.docker.com | bash
```
- Install Docker-Compose  
( Default install linux-x86_64 binary, for other platform please visit [Release Page](https://github.com/docker/compose/releases) )
```bash
mkdir -p /usr/libexec/docker/cli-plugins
wget -O /usr/libexec/docker/cli-plugins/docker-compose "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64"
chmod +x /usr/libexec/docker/cli-plugins/docker-compose
```
- Clone this Repository
```bash
mkdir -p /etc/naiveproxy /var/www/html /var/log/caddy
git clone https://github.com/bolucat/naive /etc/naiveproxy
chmod +x /etc/naiveproxy/*.sh
cp -r /etc/naiveproxy/naiveproxy.service /etc/systemd/system
```
- Modify the configuration with **Caddyfile**
```bash
cat > /etc/naiveproxy/Caddyfile <<EOF
{
  admin off
  log {
      output file /var/log/caddy/access.log
      level INFO
  }
  servers :443 {
      protocol {
          experimental_http3
      }
  }
}

:80 {
  redir https://{host}{uri} permanent
}

:443, your_domain.com  #Modify to your domain
tls your@email.com  #Modify to your email address
route {
  forward_proxy {
      basic_auth user_name your_password  #Modify to your user name and password
      hide_ip
      hide_via
      probe_resistance rP7uSWkJpZzfg5g2Qr.com  #Modify to a secret domain, like password
  }
  file_server {
      root /var/www/html
  }
}
EOF
```
- Change System UDP-Buffer-Size
```bash
sysctl -w net.core.rmem_max=2500000
```
- Add HTML pages

You need to add some HTML pages under `/var/www/html` for camouflage purpose, I suggest you to find some templates by yourself from Internet. 

But If you don't wanna do that, only one line command will tackle this issue (**Do Not Recommend**)

```bash
git clone -b gh-pages https://github.com/PavelDoGreat/WebGL-Fluid-Simulation /var/www/html
```
- Start Naiveproxy (Start with Linux)
```bash
systemctl start naiveproxy
systemctl enable naiveproxy
```
## Management
- Update Naiveproxy
```bash
systemctl restart naiveproxy
```
- Stop Naiveproxy
```bash
systemctl stop naiveproxy
```

## Windows Users
AKA, Qv2ray has been deprected due to its [internal issues](https://github.com/Qv2ray/Qv2ray/releases/tag/v2.7.0), so we need to use another client sooner or later

Directly use [Naiveproxy Core](https://github.com/klzgrad/naiveproxy/releases) is advisable, collaborate with [V2rayN](https://github.com/2dust/v2rayN) or [Clash For Windows](https://github.com/Fndroid/clash_for_windows_pkg), you can proxy for all windows traffic

- Clone this Repository
```bash
git clone https://github.com/bolucat/naive Naiveproxy
```
- Go to `Naiveproxy\windows` directory, and modify `config.json`
```bash
{
    "listen": "socks://127.0.0.1:10800",
    "proxy": "https://user_name:your_password@your_domain.com"
}
```

Modify `user_name` to your user name, `your_password` to your password, `your_domain.com` to your domain. 

**Do Not** delete `:` or `@`

- Config `V2rayN` or `Clash For Windows`

For instance, set a **socks5** protocol with `V2rayN` listen on `127.0.0.1:10800`

Or add this configuration to `Clash For Windows` to listen on `127.0.0.1:10800`

```yaml
# Start from section "proxies"

proxies:
  - name: "naiveproxy"
    type: socks5
    server: 127.0.0.1
    port: 10800
    udp: true
```

- Start with Windows  

Double Click `start.bat` and press `YES` when asking for **Root** Permission

- Stop with Windows   

Double Click `stop.bat` and press `YES` when asking for **Root** Permission
