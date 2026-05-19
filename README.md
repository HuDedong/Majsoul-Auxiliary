# Majsoul-Auxiliary

使用 `mihomo` / `sing-box` 内核将雀魂流量转发至 `MajsoulMax`，实现全角色、皮肤、装扮等本地解锁。

![Platform](https://img.shields.io/badge/Platform-Windows-0078D4?style=flat-square&logo=windows&logoColor=white)
![Core](https://img.shields.io/badge/Core-mihomo%20%7C%20sing--box-E4605E?style=flat-square)
![Status](https://img.shields.io/badge/Unlock-Local%20All%20Items-FF69B4?style=flat-square)

> 📱 **iOS 用户须知**
> iOS 版需要分离部署，我现在太忙了，之后找时间部署个服务器就能打通全平台了。到时候大家直接下个证书就能直连我的服务器，就不用再看这篇教程了。

---

## 📢 用前须知

> [!CAUTION]
> **魔改千万条，安全第一条。**
> **退出不规范，断网两行泪。**
>
> 1. **本地生效**：解锁内容仅在本地生效，其他玩家看到的仍为您的原有角色及表情。
> 2. **仅供学习**：本项目仅供学习参考交流，请使用者于下载后 24 小时内自行删除，不得用于商业用途，否则后果自负。
> 3. **封号风险**：雀魂官方可能会检测并封号，如产生任何后果与我无关。
> 
> **使用本项目则表示您已知悉并同意以上条款。**

---

## 🔌 兼容性与支持

### 支持范围
* 🌐 网页版
* 🎮 客户端 / Steam 端（Windows 平台）

### 兼容性冲突
* **冲突对象**：与所有使用 `mihomo` 或 `sing-box` 内核的代理客户端冲突（如 *Clash Verge*、*Clash Party* 等，以及使用 sing-box 内核的代理客户端）。
* **解决方法**：使用前请**退出**此类客户端，并**关闭所有代理客户端的 TUN 模式**。
* *💡 我实测使用 Clash Verge 可以并存正常使用，能访问国内外网站且不受影响。*

---

## 🛠️ 内核与隧道模式说明

| 内核 (Core) | 模式 (Mode) | 适用范围 | 特点与建议 |
| :--- | :--- | :--- | :--- |
| **mihomo** | `proxy` | 仅网页版 | 资源占用低，配置简单 |
| **mihomo** | `tun` | 网页版 + 客户端/Steam | 代理更底层，需管理员权限 |
| **sing-box** | `proxy` | 仅网页版 | 新一代内核，性能更优异 |
| **sing-box** | `tun` | 网页版 + 客户端/Steam | 完美接管全局流量 |



## 🌐 代理与分流（必须配置）

`MajsoulMax` 默认在本地 `127.0.0.1:23410` 启动一个 HTTPS 代理（基于 mitmproxy）。推荐使用支持规则分流和覆写的代理软件（如 `Mihomo` 系的 `Clash Party` 或 `Clash Verge` / `Surge`），将雀魂相关流量导向该端口，并使用复合规则给 Python 进程做直连以避免回环。

### 信任证书

在配置分流规则前，请先在系统中导入并信任 `~/.mitmproxy/` 下的 `mitmproxy-ca-cert.cer` 证书。这个证书是本地自动生成的，非常安全。否则 HTTPS 流量可能会因为证书校验失败而无法正常工作。

#### Windows 用户

1. 开启文件资源管理器（按下 `Windows 键 + E`）
2. 在上方地址栏输入 `%homepath%\.mitmproxy`（mitmproxy 的默认证书存储路径）然后按 Enter
3. 找到名为 `mitmproxy-ca-cert.cer` 的证书文件
4. 双击该证书文件
5. 点选 `安装证书` 按钮
6. 若出现选项，请选 `本地计算机`，然后点选下一步
7. 选择 `将所有证书放入下列存储`，然后点 `浏览...`
8. 选择 `受信任的根证书颁发机构`，按下确定，再点选下一步与完成
9. 若系统要求权限，请点选是

#### macOS 用户

1. 打开 Finder
2. 按下 `Command + Shift + G` 打开前往文件夹对话框，输入 `~/.mitmproxy` 然后按 Enter
3. 找到名为 `mitmproxy-ca-cert.cer` 的证书文件
4. 双击该证书文件，进入钥匙串访问
5. 点选左边的 `系统钥匙串` 下的 `系统` 标签，右上角搜索 `mitmproxy`，找到导入的证书，此时是未信任状态
6. 右键名为 `mitmproxy` 的证书项，选择 `显示简介`，在弹出的窗口中展开 `信任`
7. 对于 `使用此证书时`，改为 `始终信任`
8. 关闭窗口，在弹出的认证框中完成认证即可。

#### iOS / iPadOS 用户

若你通过分离部署的形式将本项目改为了代理节点，则可以在 iOS / iPadOS 上使用，但此时仍需在对应设备上完成证书信任。

1. 首先将电脑上的 `mitmproxy-ca-cert.cer` 证书通过隔空传送或者其他方式发送到 iPhone/iPad 上，最好是隔空投送，可以自动完成导入。对于其他方式，须先保存到文件中，然后再在文件中点开该证书文件。
2. 进入 `设置-已下载描述文件`，点击安装
3. 前往 `通用-关于本机-证书信任设置`，打开 mitmproxy 的选项

#### Android 用户

无测试环境，可自行搜索。

> [!CAUTION]
>
> 本地客户端 / Steam 端等进程需要在代理软件中开启 `TUN` / 增强模式，才能保证进程流量经过 `python` 启动的代理节点；但请务必注意避免回环代理，即你要保证从 `python` 发出的流量不会被分流回自身。
>
> 网页版（浏览器）一般只要正确配置系统代理或域名规则即可，通常不需要开启增强模式。



### Clash Verge 全局扩展脚本（JS）示例

参考 [官方文档](https://www.clashverge.dev/guide/script.html)，可以按照如下方法进行配置。

在 “订阅” 页面点击 `新建`，类型选择 “Merge”，保存后右键选择启用:

```js
# Merge Template for clash verge
# The `Merge` format used to enhance profile

prepend-rules:
  # 1. 核心防回环：让 Python 和代理本身直接联网，避免死循环
  - PROCESS-NAME,python.exe,DIRECT
  - PROCESS-NAME,pythonw.exe,DIRECT
  - PROCESS-NAME,mitmdump.exe,DIRECT
  - PROCESS-NAME,MajsoulMax.exe,DIRECT

  # 2. 强制让雀魂的 HTTPS 流量【直连】或者【剥离】（不走你的 https 代理节点）
  # 这样才能腾出空间让浏览器或者本地脚本去走 HTTP
  - DOMAIN-KEYWORD,majsoul,🀄 雀魂麻将
  - DOMAIN-KEYWORD,maj-soul,🀄 雀魂麻将

prepend-rule-providers:

prepend-proxies:
  # 注意：这里我们依然保持本地代理。因为你要走 HTTP，我们就用明文的 http 类型去接管它
  - name: MajsoulMax
    type: http
    server: 127.0.0.1
    port: 23410
    # 坚决不加 tls: true，保持纯明文 HTTP 传输

prepend-proxy-providers:

prepend-proxy-groups:
  - name: 🀄 雀魂麻将
    type: select
    proxies:
      - MajsoulMax
      - DIRECT

append-rules:
append-rule-providers:
append-proxies:
append-proxy-providers:
append-proxy-groups:
```



---

## 🚀 使用方法

### Step 1：运行后端基建 MajsoulMax
本工具需配合 `MajsoulMax` 使用。平时正常使用完全不需要看原项目，只有当按照下面的方法操作不生效时，才需要前往 [MajsoulMax 源发布地址](https://github.com/Avenshy/MajsoulMax) 排查。

在终端（PowerShell / 终端）中依次执行以下命令：
```bash
# 1. 下载源码（先 cd 切到你想下载存放的目录）
git clone [https://github.com/Avenshy/MajsoulMax.git](https://github.com/Avenshy/MajsoulMax.git)

# 切换到项目目录（必须进入 requirements.txt 所在的文件夹）
cd MajsoulMax

# 2. 安装依赖（二选一：常规源 / 国内推荐使用清华源）
pip install -r requirements.txt
pip install -r requirements.txt -i [https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple](https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple)

# 3. 启动程序
mitmdump -p 23410 -s addons.py
```

### Step 2：运行隧道脚本（运行）
根据上一节的【内核与模式说明】，在 Assets 中下载对应的版本。你可以选择以下任一方式：

* **方式 A**：直接运行我提供的任一 `.exe` 版本（效果与 `.bat` 完全相同）。
* **方式 B**：右键任一 `MajsoulMax-Tunnel-xxx-xxx.bat`，选择 **“以管理员身份运行”**。

> 💡 **提示**：如果进游戏发现没生效，**注意要先退账号，再重新登录账号**。

### Step 3：启动雀魂
打开网页端或客户端，登录游戏即可。

---

> [!TIP]
> 🔄 **日常后续使用（小白看这里）**
> 首次配置完成后，**以后每次使用只需两步（桌面上会保持 2 个控制台窗口）**：
> 1. 在 `MajsoulMax` 目录下打开终端，直接启动后端：`mitmdump -p 23410 -s addons.py`
> 2. 直接运行我提供的任一 `.exe` 或 `.bat` 隧道脚本。
> 3. 打开游戏，快乐开打。

---

## 💡 退出方式与安全说明

### 1. 退出程序
* **正确退出方式**：在命令行窗口中**连续按任意键 3–4 次**，程序将正常终止。
* **注意**：尽量不要直接点击窗口右上角的 `[X]` 关闭。如果不小心直接点 `[X]` 关闭导致卡代理无法上网，只需**重新打开程序，按照正确步骤退出一次**即可恢复。

### 2. EXE 文件打包
* 压缩包内的可执行文件（EXE）是我通过 `Bat_To_Exe_Converter` 打包生成的。
* 建议大家不要下载来路不明的 exe 文件。如果对安全性有顾虑，可以先用工具提取出源文件检查代码。
* [*Bat_To_Exe_Converter 下载地址*](https://www.azofreeware.com/2009/07/bat-to-exe-converter-1500.html)

---

## 🗑️ 卸载方法

绿色无残留，直接**删除当前程序所在目录**即可彻底卸载。
