# Crypto Intel - OpenClaw Skill

加密货币新闻爬取与情报收集技能。定时爬取多个新闻源，筛选关键信息并通过Telegram发送报告。

## 功能特性

- **多源爬取**: 10+ 新闻网站和X/Twitter列表
- **智能筛选**: 自动识别6大类关键信息
- **定时执行**: 每天 09:03, 15:03, 22:03 (Asia/Shanghai)
- **Telegram推送**: 完成后直接发送到指定用户

## 安装

```bash
# 通过ClawHub安装（待发布）
claw install orbit-crypto-intel

# 或手动安装
git clone https://github.com/OrbitClaw/orbit-crypto-intel.git
cd orbit-crypto-intel
```

## 使用方法

### 方式1：直接运行

```bash
# 执行爬取任务（12小时窗口）
./crypto-intel.sh --hours 12 --telegram 5844680524

# 完整爬取（24小时窗口）
./crypto-intel.sh --hours 24 --telegram 5844680524
```

### 方式2：配置Cron Job

```bash
# 添加定时任务（OpenClaw cron）
openclaw cron add --name "crypto-news" \
  --schedule "3 9,15,22 * * *" \
  --session isolated \
  --payload '{"kind":"agentTurn","message":"...","to":"5844680524"}'
```

### 方式3：集成到OpenClaw

将任务提示词复制到你的OpenClaw agent配置中。

## 配置选项

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--hours` | 时间窗口（小时） | 12 |
| `--telegram` | Telegram用户ID | 必填 |
| `--output` | 输出格式 (text\|json\|markdown) | markdown |
| `--deep` | 是否爬取深度长文 | true |

## 报告分类

1. **大户动向** - 巨鲸资金流入流出、态度变化
2. **利率事件** - 美联储委员发言、利率政策
3. **监管政策** - 美国政府重大政策调整
4. **安全事件** - 黑客攻击、漏洞披露
5. **新产品** - KOL提及的新项目（排除广告）
6. **市场现象** - 新趋势、新变化

## 已知问题与解决方案

### 问题1：页面加载不完整

**现象**: browser快照只捕获部分内容
**原因**: 动态加载、防爬虫机制
**解决方案**:

```javascript
// 增加等待时间
await browser.snapshot({ timeMs: 3000 });

// 多次滚动加载
await browser.act({ kind: 'scroll', y: 1000 });
await browser.snapshot({ timeMs: 2000 });
await browser.act({ kind: 'scroll', y: 1000 });
await browser.snapshot({ timeMs: 2000 });
```

### 问题2：X平台Cookie失效

**现象**: bird工具返回空、403错误或认证失败
**原因**: X的ct0/auth_token cookie过期（通常1-7天）
**解决方案**:

#### 交互式Cookie检查（v1.2.0+）

任务现在会**在执行前主动询问用户**：

1. **检测到Cookie无效/未设置**
2. **发送消息给用户**：
```
⚠️ X/Twitter Cookie 未设置或已失效

请选择：
1. 提供新的cookie值（推荐）：
   - 在 x.com 登录后，F12 -> Application -> Cookies
   - 复制 ct0 和 auth_token 的值

2. 使用 web_fetch 替代（直接回复这个选择）
```
3. **等待用户回复**
4. **根据回复行动**：
   - 提供cookie → 使用bird
   - 选择fallback → 使用web_fetch

#### 手动更新步骤

```bash
# 1. 在浏览器中登录 x.com
# 2. 打开开发者工具 (F12) -> Application -> Cookies
# 3. 复制 ct0 和 auth_token 的值
# 4. 发送给agent

# 或设置环境变量
export X_CT0="新ct0值"
export X_AUTH_TOKEN="新auth_token值"
```

#### Fallback机制

如果用户选择不使用cookie，任务会使用web_fetch获取X列表：
```javascript
const listPage = await web_fetch({
  url: "https://x.com/i/lists/xxxx",
  extractMode: "text",
  maxChars: 50000
});
```

#### 报告示例

任务完成后会显示：

```
✅ X数据来源: bird（用户提供cookie）

或

⚠️ X数据来源: web_fetch(fallback)
（用户选择不使用cookie）
```

### 问题3：长文内容被截断

**现象**: 深度文章只显示前4096字符  
**原因**: browser快照默认截断  
**解决方案**: 使用 `web_fetch` 获取完整内容

```javascript
// 获取完整文章
const fullArticle = await web_fetch({
  url: "https://foresightnews.pro/article/xxxxx",
  extractMode: "text",
  maxChars: 50000
});
```

## 依赖工具

| 工具 | 用途 | 必需 |
|------|------|------|
| `browser` | 新闻网站爬取 | ✅ |
| `bird` | X/Twitter列表查询 | ⚠️ 可选 |
| `web_fetch` | 完整内容获取 | ✅ |
| `message` | Telegram消息推送 | ✅ |

## 目录结构

```
orbit-crypto-intel/
├── SKILL.md              # 本文件
├── crypto-intel.sh       # 执行脚本
├── task-prompt.txt       # 完整任务提示词
├── README.md             # 英文说明
└── .gitignore
```

## 示例输出

```
# 加密货币新闻摘要报告
**时间窗口**: 2026-02-01 00:28 - 12:28 (UTC)
**信息来源**: 10+个新闻网站 + X平台列表

## 1️⃣ 大户动向
- 🔴 巨鲸向Binance存入10万枚ETH（价值2.4亿美元）

## 2️⃣ 利率事件
- （本次无重大发言）

...

```

## 维护者

- **OrbitClaw** - https://github.com/OrbitClaw

## 许可证

MIT License

## 更新日志

### v1.2.0 (2026-02-01)
- ✨ **新增交互式Cookie确认**
  - Cookie无效/未设置时，**先询问用户**再执行
  - 用户可选择提供cookie或使用web_fetch fallback
  - 等待用户回复后再继续任务

### v1.1.0 (2026-02-01)
- ✨ **新增X Cookie自动检查功能**
  - 执行前先验证cookie有效性
  - 未设置或已失效时提示用户提供/更新
  - 优先使用bird，失败后自动fallback到web_fetch
- 📊 报告中显示cookie状态和数据来源
- 📝 更新任务提示词，增加cookie检查步骤

### v1.0.0 (2026-02-01)
- 初始版本
- 支持10个新闻源爬取
- X/Twitter列表查询
- 深度长文爬取
- Telegram推送功能
