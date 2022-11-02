## Notes
From [Caddy v2.6.0](https://github.com/caddyserver/caddy/releases/tag/v2.6.0), The `experimental_http3` option has been deprecated, please update your configuration
## Preparation
**You need to install `wget` and `git` at first**

For **Ubuntu / Debian** : `apt install -y wget git`    

For **CentOS / Rocky** : `yum install -y wget git`

**Note : Please Avoid using stale Linux distribution (Like CentOS 7, Debian 9, Ubuntu 18.04 or even lower), this will lead to some unexpected errors. Recommended System : `Debian 10 / 11` `Ubuntu 20.04 / 22.04` `Rocky Linux 8 / 9`**
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
      protocols h1 h2 h3
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
## Supported Clients
|  Clients  |  Platform  |  Supported Protocols  |  Status  |  Home Page  |
|  :----:  | :----:  |  :----:  | :----:  | :----:  |
| Qv2ray | Windows/MacOS/Linux | https/quic | Inactive | [Client](https://github.com/Qv2ray/Qv2ray) && [Naive Plugin](https://github.com/Qv2ray/QvPlugin-NaiveProxy) |
| Nekoray | Windows/MacOS/Linux | https/quic | Maintained | [Link](https://github.com/MatsuriDayo/nekoray) |
| V2rayN | Windows | https/quic | Maintained | [Link](https://github.com/2dust/v2rayN) |
| SagerNet | Android | https/quic | Maintained | [Client](https://github.com/SagerNet/SagerNet) && [Naive Plugin](https://github.com/SagerNet/SagerNet/releases/tag/naive-plugin-106.0.5249.91-1) |
| Shadowrocket | iOS | https | Maintained | [Link](https://apps.apple.com/us/app/shadowrocket/id932747118) |

## v2rayN Users
Since v2rayN release its [5.16](https://github.com/2dust/v2rayN/releases/tag/5.16) version, Naiveproxy has been supported natively, please switch to [v2rayN](https://github.com/2dust/v2rayN) to use Naiveproxy further 🎉🎉🎉

For this project, I will only maintain the server side part (Linux Based) 

### v2rayN usage explain
- download pre-build binaries from official repository  
v2rayN : https://github.com/2dust/v2rayN/releases  

![v2rayN](./pics/1.png)

naiveproxy : https://github.com/klzgrad/naiveproxy/releases 

![naiveproxy](./pics/2.png)

- extract binaries from zip archive

![extract](./pics/3.png)

- enter into **naiveproxy-v100.0.4896.60-1-win-x64** folder, and rename **config.json** to **naive.json**

![rename](./pics/4.png)

- edit **naive.json**, the sample configuration showed below
```json
{
  "listen": "http://127.0.0.1:10809",
  "proxy": "https://user_name:password@your_domain.com",
  "log": "naive-log.txt"
}
```

*If you want to change listen port from **10809** to your specific port, please read **Tips** at the end of this article* 

- move **naive.exe** and **naive.json** to folder **v2rayN-Core**, make sure **naive.exe** and **naive.json** are both located with **v2rayN.exe** in the same folder

![move-naive](./pics/5.png)

- open v2rayN, click **Servers** option and click **Add a custom configuration server**

![open-v2rayN](./pics/6.png)

- input **Alias** (it's totally up to you), and click **Browse** under Address

![browse](./pics/7.png)

- select **naive.json** in your **v2rayN-Core** folder

![select](./pics/8.png)

- and a successful pop-up will prompt here

![pop-up](./pics/9.png)

- then, choose **naiveproxy** at **Core Type** field, and click **OK** to finish setup

![finish](./pics/10.png)

- you should open v2rayN **Set system proxy** setting by right-clicking the v2rayN logo at Windows Taskbar and toggle it

![set-system-proxy](./pics/11.png)

- enjoy it!

### Tips : change listen port
for example, if you want to change your port from **10809** to **20000**, you should modify two areas
- modify **naive.json** in **v2rayN-Core** folder like this:
```json
{
  "listen": "http://127.0.0.1:20000",
  "proxy": "https://user_name:password@your_domain.com",
  "log": "naive-log.txt"
}
```
- modify v2rayN setting   
open **Settings --> OptionSetting**

![open-setting](./pics/12.png)

change **Listening port** to **19999** (Please Note That This Port Should Be Set to **Your Port** - 1 )

![change-port](./pics/13.png)

after confirm, please make sure the **http port** displayed at the lower left corner is **20000**

![check](./pics/14.png)

- and finally, Do Not Forget to refresh your configuration by **Browse** your **naive.json** and reconfirm again

- enjoy
