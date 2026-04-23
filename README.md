# Helix 配置

这是一份适用于当前 `config.toml` 和 `languages.toml` 的 Helix 配置说明。

## Vim -> Helix 速查

Helix 最需要先适应的一点是 **“选区 -> 动作”**：

- Vim 更像是 `operator + motion`，比如 `diw`、`ci"`。
- Helix 通常是先选中对象，再执行 `d` / `c` / `y`。
- `g` 多半是跳转，`m` 多半是 textobject / surround，`Space` 多半是 picker / LSP。

### 常用基础操作

| Vim | Helix | 说明 |
| --- | --- | --- |
| `h` `j` `k` `l` | `h` `j` `k` `l` | 基本移动 |
| `w` `b` `e` | `w` `b` `e` | 单词移动 |
| `gg` | `gg` | 跳到文件开头 |
| `G` | `ge` | 跳到文件结尾 |
| `0` | `gh` | 跳到行首 |
| `$` | `gl` | 跳到行尾 |
| `v` | `v` | 进入扩展选择模式 |
| `V` | `x` | 选中当前行 |
| `dd` | `xd` | 选中当前行后删除 |
| `yy` | `xy` | 选中当前行后复制 |
| `cc` | `xc` | 选中当前行后修改 |
| `p` | `p` | 在后面粘贴 |
| `P` | `P` | 在前面粘贴 |
| `u` | `u` | undo |
| `Ctrl-r` | `U` | redo |

### textobject / 选择类操作

| Vim | Helix | 说明 |
| --- | --- | --- |
| `viw` | `miw` | 选中当前单词内部 |
| `vaw` | `maw` | 选中整个单词 |
| `diw` | `miwd` | 删除当前单词内部 |
| `ciw` | `miwc` | 修改当前单词内部 |
| `yiw` | `miwy` | 复制当前单词内部 |
| `vi"` | `mi"` | 选中引号内部 |
| `va"` | `ma"` | 选中包含引号的整体 |
| `ci"` | `mi"c` | 修改引号内部 |
| `di(` | `mi(d` | 删除括号内部 |
| `%`（跳配对） | `mm` | 跳到配对括号 |
| `ggVG` | `%` | 选中整个文件 |

### 搜索 / LSP / 窗口

| Vim | Helix | 说明 |
| --- | --- | --- |
| `/pattern` | `/pattern` | 搜索 |
| `n` / `N` | `n` / `N` | 下一个 / 上一个匹配 |
| `*` | `*` | 用当前选区搜索（整词时会自动带词边界） |
| `gd` | `gd` | 跳转到定义 |
| `gr` | `gr` | 跳转到引用 |
| `K` | `Space k` | 查看 hover 文档 |
| `:rename` / LSP rename | `Space r` | 重命名符号 |
| code action | `Space a` | 执行代码动作 |
| `:e` / 文件选择器 | `Space f` | 打开文件 picker |
| `:b` | `Space b` | 打开 buffer picker |
| `Ctrl-w v` | `Ctrl-w v` | 垂直分屏 |
| `Ctrl-w s` | `Ctrl-w s` | 水平分屏 |
| `Ctrl-w h/j/k/l` | `Ctrl-w h/j/k/l` | 在窗口间移动 |
| `Ctrl-w q` | `Ctrl-w q` | 关闭当前窗口 |
| `Ctrl-w o` | `Ctrl-w o` | 只保留当前窗口 |

### 标记 / 跳转（mark 的替代思路）

Helix **没有 Vim 那套命名 mark**：

- 没有 `ma`
- 没有 `'a`
- 没有 `` `a ``

Helix 更推荐用 **jumplist** 做“临时标记再跳回”：

| Vim | Helix | 说明 |
| --- | --- | --- |
| `ma` | `Ctrl-s` | 把当前选区 / 光标位置存进 jumplist |
| `` `a `` / `'a` | `Ctrl-o` | 跳回上一个保存过的位置 |
| 向前跳回去 | `Ctrl-i` | 在 jumplist 里往前走 |
| 查看 marks | `Space j` | 打开 jumplist picker，看最近跳转点 |

心法可以这么记：

- **Vim mark** 更像“手动命名锚点”
- **Helix jumplist** 更像“最近访问 / 手动保存过的位置历史”

如果你的需求是“先记住这里，等会回来”，在 Helix 里通常就是：

```text
Ctrl-s    # 存当前位置
...       # 去别处编辑
Ctrl-o    # 跳回来
```

另外，Helix 里的 `m` 不是 mark 前缀，而是 **match / textobject / surround** 相关模式，比如：

- `mm`：跳到配对括号
- `miw`：选单词内部
- `ma"`：选引号整体

### 剪贴板 / 寄存器

Helix 里有三层常用概念，最好分开记：

1. `y` / `p` / `P` 默认走 **寄存器**
2. `Space y` / `Space p` / `Space P` 直接走 **系统剪贴板**
3. `"` 可以显式指定寄存器，和 Vim 很像

| 场景 | Helix | 说明 |
| --- | --- | --- |
| 复制到默认寄存器 | `y` | 默认写到 `"` 寄存器 |
| 从默认寄存器粘贴 | `p` / `P` | 后贴 / 前贴 |
| 复制到系统剪贴板 | `Space y` | 整个选区复制到系统剪贴板 |
| 只复制主选区到系统剪贴板 | `Space Y` | 多选区时很有用 |
| 从系统剪贴板后贴 | `Space p` | 等价于从 `+` 读并后贴 |
| 从系统剪贴板前贴 | `Space P` | 等价于从 `+` 读并前贴 |
| 用系统剪贴板内容替换选区 | `Space R` | 直接替换当前选区 |
| 复制到寄存器 `a` | `"ay` | 和 Vim 一样，先选寄存器再 yank |
| 从寄存器 `a` 粘贴 | `"ap` | 从指定寄存器后贴 |
| 删除但不保存 | `Alt-d` | 有点像黑洞删除 |
| 明确丢弃到黑洞寄存器 | `"_d` | 和 Vim 的 black hole register 类似 |
| 从系统剪贴板显式读取 | `"+p` | 不想记 `Space p` 时可用 |

常见心法：

- **编辑器内部复制粘贴**：先记 `y` / `p` / `P`
- **和系统其他应用交换内容**：先记 `Space y` / `Space p`
- **想保留多份临时文本**：用 `"a`、`"b` 这类命名寄存器

> 提示：如果你刚从 Vim 过来，最值得先记住的是 `x`（选行）、`m i / a`（选对象）、`Space`（文件/LSP 操作）。

## 需要安装的依赖

| 组件 | 作用 | 安装方式 |
| --- | --- | --- |
| `pylsp` | Python LSP | `uv tool install python-lsp-server` |
| `pyright-langserver` | Python 类型检查 | `uv tool install pyright` |
| `ruff` | Python lint / format / code action | `uv tool install ruff` |
| `gopls` | Go LSP | `go install golang.org/x/tools/gopls@latest` |
| `rust-analyzer` | Rust LSP | 见下方各平台命令 |
| `typescript-language-server` | JS/TS LSP | `npm install -g typescript typescript-language-server` |
| `vue-language-server` | Vue LSP | `npm install -g @vue/language-server` |
| `ngserver` | Angular LSP | `npm install -g @angular/language-server` |
| `vscode-html-language-server` | HTML LSP | `npm install -g vscode-langservers-extracted` |
| `clangd` | C/C++/Objective-C LSP | 见下方各平台命令 |
| `hx-lsp` | Helix 扩展 LSP | `cargo install --git https://github.com/helix-editor/hx-lsp` |
| `helix-assist` | Helix 辅助能力 | `go install github.com/leona/helix-assist/cmd/helix-assist@latest` |

## 安装命令

### Python（推荐使用 `uv`）

```bash
uv tool install python-lsp-server pyright ruff
```

当前 Python 配置里，`pyright` 负责类型分析，`ruff server` 负责 lint、format 和 code action，两者会一起工作。

### Go

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/leona/helix-assist/cmd/helix-assist@latest
```

### Node.js / npm

```bash
npm install -g typescript typescript-language-server @vue/language-server @angular/language-server vscode-langservers-extracted
```

### Rust

```bash
cargo install --git https://github.com/helix-editor/hx-lsp
```

如果你通过 `rustup` 安装了 Rust，但 `~/.cargo/bin/rust-analyzer` 只是一个不可用的代理，Helix 里的 Rust LSP 会直接退出。当前这份配置在 macOS 上固定使用 `/opt/homebrew/bin/rust-analyzer`，因此还需要安装：

```bash
brew install rust-analyzer
```

## 按平台安装

### Windows（Scoop）

```bash
scoop install rust-analyzer llvm
```

### macOS（Homebrew）

```bash
brew install rust-analyzer llvm
```

### Linux（Gentoo / emerge）

```bash
emerge dev-util/rust-analyzer sys-devel/llvm
```

## 可选扩展 / 插件生态

### 先说限制

当前这份配置基于 **Homebrew 的正式版 Helix**。  
像 `oil.hx`、`select-project.hx`、`streal.hx` 这类插件都依赖 **Steel plugin system**，也就是要换成支持插件的 Helix 分支，不能直接在当前这版里开箱即用。

所以可以把它们分成两类来看：

1. **Steel 插件**：需要插件版 Helix
2. **外部工作流工具**：不改 Helix 核心，也能一起用

### Steel 插件（需要插件版 Helix）

#### `oil.hx`

- 定位：像 `oil.nvim` 一样，把目录当成 buffer 来编辑
- 适合：想在 Helix 里直接创建 / 重命名 / 删除文件和目录
- 安装方式（插件版 Helix）：

```bash
forge pkg install --git https://github.com/Ra77a3l3-jar/oil.hx.git
```

`init.scm`：

```scheme
(require "oil/oil.scm")
(oil-configure! #false #false)
```

可选键位思路：

```toml
[keys.normal.space.o]
o = "oil"
e = "oil-enter"
b = "oil-back"
g = "oil-root"
s = "oil-save"
r = "oil-refresh"
q = "oil-close"
h = "oil-toggle-hidden"
i = "oil-toggle-git-ignored"
```

#### `select-project.hx`

- 定位：模糊查找并切换项目根目录
- 适合：经常在多个项目之间切换
- 安装方式（插件版 Helix）：

```bash
git clone https://github.com/godalming123/select-project.hx ~/.config/helix/select-project.hx/
```

`init.scm`：

```scheme
(require "select-project.hx/main.scm")
```

键位示例：

```toml
[keys.normal.g]
p = ":select-project"
```

#### `streal.hx`

- 定位：给常用文件做数字书签，快速跳转
- 适合：在固定几组文件之间反复切换
- 安装方式（插件版 Helix）：

```bash
forge pkg install --git https://github.com/gllms/streal.hx.git
```

`init.scm`：

```scheme
(require "streal/streal.scm")
```

键位示例：

```toml
[keys.normal]
"\\" = ":streal-open --per-branch"

[keys.select]
"\\" = ":streal-open --per-branch"
```

> `--per-branch` 很适合 Git 仓库：不同分支可以保留不同书签列表。

### 外部工作流工具

#### `Yazelix`

- 定位：**Yazi + Zellij + Helix** 的一体化终端工作区
- 适合：想把 Helix 变成 “终端 IDE” 工作流的人
- 优点：
  - 用 Yazi 做侧边栏 / 文件管理
  - 用 Zellij 做 pane / workspace 编排
  - 对 Helix 有一等支持，比如 `yzx reveal`
  - 带 popup、命令菜单、`lazygit` 这类工作流增强
- 安装方式：

```bash
nix profile add github:luccahuguet/yazelix#yazelix
yzx launch
```

它不是 Helix 插件，而是 **外部工作区层**。  
如果你本来就喜欢 tmux / zellij / yazi / lazygit 这套终端工作流，Yazelix 是最值得单独试的一项。

### 推荐顺序

如果只是想小步尝试：

1. **先试 Yazelix**：不需要换 Helix 核心，收益最大
2. **再考虑 `select-project.hx`**：多项目切换最直观
3. **然后是 `streal.hx`**：常用文件跳转很顺
4. **最后再看 `oil.hx`**：前提是你真的想把文件管理搬进 Helix

## 说明

- `llvm` 包提供 `clangd`。
- `vscode-langservers-extracted` 提供 `vscode-html-language-server`。
- 如果某个命令安装后仍不可用，请确认对应目录已经加入 `PATH`。
- 这些依赖安装完成后，Helix 会按 `languages.toml` 中的配置自动使用它们。
