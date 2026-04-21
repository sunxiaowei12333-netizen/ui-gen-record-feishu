# ui-gen-record

> 此文件是给没有原生 Skill 机制的 AI Agent（Codex / VS Code Copilot / Cline / Aider 等）准备的约定文件，是 [SKILL.md](./SKILL.md) 的精简版。有原生 Skill 机制的 Agent（Cursor / Claude Code）直接读 SKILL.md 即可。

当用户说 **"整理到表格中 / 归档到多维表格 / 记录这次需求 / 存一下这次花费"** 时，执行以下流程：

1. 若本 skill 目录下没有 `.config.json`，先运行 `scripts/bootstrap.sh` 建表（会在用户自己的飞书账号下创建一张空表，所有权归用户）。
2. 从当前对话上下文里推断：
   - `REQ_NAME`（页面名 / 需求简述）
   - `REQ_DATE`（当前时间或文件 mtime）
   - `PREVIEW_URL` / `DESIGN_URL`
   - `MODEL`（使用的模型，必须命中 `使用模型` select 的选项）
   - `MOD_COUNT` / `TOKEN_USAGE` / `USD_COST`（按 SKILL.md 的估算规则给出，**不允许留空**）
   - 附件路径（源码 `.tsx` + 导出 `.zip`）
3. 尝试调用 vite 工程的 `POST http://localhost:5173/__api/export-html`（或对应项目的导出接口）现场拿 zip；没有接口就扫 `~/Downloads` 里近 7 天同名 zip；再没有就问用户。
4. 执行 `scripts/append.sh` 追加一条记录，把 Base URL 报给用户。

详细规则（字段约定、模型价目表、估算算法、仪表盘结构）见 [SKILL.md](./SKILL.md)。
