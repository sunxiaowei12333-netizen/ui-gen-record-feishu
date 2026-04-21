#!/usr/bin/env bash
# ui-gen-record 的跨 AI Agent 安装脚本
#
# 用法：
#   curl -fsSL <raw_url>/scripts/install.sh | bash
#   或 clone 后：bash scripts/install.sh
#
# 它会检测当前机器上存在的 AI Agent（Cursor / Claude Code 等），
# 把本 skill 符号链接到对应的 skills 目录。

set -euo pipefail

SRC="${UI_GEN_RECORD_SRC:-}"

if [[ -z "$SRC" ]]; then
  if [[ -f "$(dirname "$0")/../SKILL.md" ]]; then
    SRC="$(cd "$(dirname "$0")/.." && pwd)"
  else
    echo "[install] 请先 git clone 本仓库，然后在仓库根目录执行 bash scripts/install.sh"
    echo "[install] 或设置 UI_GEN_RECORD_SRC=<仓库本地路径> 再重试"
    exit 1
  fi
fi

[[ -f "$SRC/SKILL.md" ]] || { echo "[install] $SRC 里没有 SKILL.md，路径不对"; exit 2; }

NAME="ui-gen-record"
LINKED=()

link_into() {
  local target_parent="$1"
  [[ -d "$target_parent" ]] || return 0
  local link="$target_parent/$NAME"
  if [[ -L "$link" || -d "$link" ]]; then
    rm -rf "$link"
  fi
  ln -s "$SRC" "$link"
  LINKED+=("$link")
  echo "[install] 已安装到 $link"
}

# Cursor
link_into "$HOME/.cursor/skills"
# Claude Code
link_into "$HOME/.claude/skills"

# 其他 agent（Codex / Copilot / Cline / aider …）没有统一的 skill 目录，
# 让用户在项目级 AGENTS.md 或 .cursorrules 里用 `@include` 或复制指令手动关联。
if [[ ${#LINKED[@]} -eq 0 ]]; then
  cat <<EOF
[install] 没检测到 ~/.cursor/skills 或 ~/.claude/skills。
[install] 如果你用的是 Codex / VS Code Copilot / Cline / aider 等 agent，
[install] 请在你的项目根目录创建 AGENTS.md 并把以下内容加进去：
[install]
[install]   @include $SRC/AGENTS.md
[install]
[install] 或者直接把 AGENTS.md 的内容拷贝到你的项目约定文件（比如 .cursorrules / CLAUDE.md）里。
EOF
fi

echo
echo "[install] 下一步：安装依赖并首次建表"
echo "[install]   1) 安装 lark-cli 并登录：参考 https://github.com/larksuite/lark-cli（或对应公司内部 CLI）"
echo "[install]   2) bash $SRC/scripts/bootstrap.sh"
echo "[install] 脚本会在这台机器上用你自己的飞书账号新建一张表，所有数据属于你。"
