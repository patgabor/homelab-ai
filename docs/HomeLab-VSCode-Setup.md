# HomeLab Visual Studio Code Setup Guide

> **⚠️ IMPORTANT: Arch-Based Linux Only**
> This project and all documentation are designed exclusively for **Arch-based Linux distributions** (e.g., Arch Linux, Manjaro, EndeavourOS). Other distributions are not supported.

This guide covers configuring Visual Studio Code for the HomeLab environment, including development tools, AI model integration with Kilo Code, and optional extensions.

## Table of Contents

1. [Git Configuration](#git-configuration)
2. [Development Tools](#development-tools)
3. [Installed VS Code Extensions](#installed-vs-code-extensions)
4. [Terminal Font Configuration](#terminal-font-configuration)
5. [Kilo Code VS Code Extension](#kilo-code-vs-code-extension)

## Git Configuration

Configure your global Git identity:

```bash
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

## Development Tools

If you have VS Code Insiders installed, remove it first:

```bash
yay -Rns visual-studio-code-insiders-bin
```

Check for leftover directories:

- Config: `~/.config/Code/`
- Local: `~/.local/share/Code/`
- Home: `~/`

Install Visual Studio Code and the .NET SDK:

```bash
yay -S visual-studio-code-bin
sudo pacman -Syu dotnet-sdk
```

## Installed VS Code Extensions

These extensions are currently installed on this system:

```bash
code --list-extensions
```

| Extension | ID | Purpose |
| --------- | -- | ------- |
| Markdown Lint | `davidanson.vscode-markdownlint` | Lints and formats Markdown files |
| EditorConfig | `editorconfig.editorconfig` | Maintains coding standards across editors |
| GitHub Theme | `github.github-vscode-theme` | GitHub VS Code color theme |
| Kilo Code | `kilocode.kilo-code` | AI coding assistant |
| DotENV | `mikestead.dotenv` | Syntax highlighting for .env files |
| .NET Dev Kit | `ms-dotnettools.csdevkit` | .NET development tools |
| C# | `ms-dotnettools.csharp` | C# language support |
| .NET Runtime | `ms-dotnettools.vscode-dotnet-runtime` | .NET runtime support |
| Kubernetes | `ms-kubernetes-tools.vscode-kubernetes-tools` | Kubernetes cluster management |
| Python Debugpy | `ms-python.debugpy` | Python debugger |
| Python | `ms-python.python` | Python language support |
| Pylance | `ms-python.vscode-pylance` | Fast Python language server |
| Python Envs | `ms-python.vscode-envs` | Python virtual environments |
| Hex Editor | `ms-vscode.hexeditor` | Edit files in hexadecimal |
| Indent Rainbow | `oderwat.indent-rainbow` | Colorizes indentation levels |
| XML | `redhat.vscode-xml` | XML document support |
| YAML | `redhat.vscode-yaml` | YAML editing |
| ShellCheck | `timonwong.shellcheck` | Shell script linting |
| Icons | `vscode-icons-team.vscode-icons` | File and folder icons |
| Jinja | `wholroyd.jinja` | Jinja template support |

To install new extensions:

1. Open VS Code
2. Press `Ctrl+Shift+X` (or click the Extensions icon in the Side Bar)
3. Search for the extension by name or ID
4. Click **Install** on the desired extension

To uninstall or manage installed extensions:

1. Go to Extensions view
2. Click the **gear icon** next to an extension
3. Select **Uninstall** or **Disable**

### Optional Extensions (Install Later)

These extensions are not currently installed but may be useful for future needs:

#### Database Extensions

| Extension | ID | Purpose |
| --------- | -- | ------- |
| Oracle SQL Developer | `Oracle.sql-developer` | Oracle database development, PL/SQL, SQL notebooks |
| PostgreSQL | `microsoft.postgres` | PostgreSQL databases, Azure PostgreSQL |
| MySQL | `cweijan.vscode-mysql-client2` | MySQL/MariaDB client |
| SQLTools | `mtxr.sqltools` | Multi-database SQL client (MySQL, PostgreSQL, SQL Server, SQLite, etc.) |
| DBCode | `DBCode.dbcode` | Database management for 50+ databases |

#### Other Recommended Extensions

| Extension | ID | Purpose |
| --------- | -- | ------- |
| GitLens | `eamodio.gitlens` | Enhanced Git integration |
| Live Server | `ritwickdey.LiveServer` | Local dev server for HTML/CSS/JS |
| Docker | `ms-azuretools.vscode-docker` | Docker container management |
| Remote Development | `ms-vscode-remote.vscode-remote-extensionpack` | Remote development (SSH, Containers, WSL) |
| Thunder Client | `rangav.vscode-thunder-client` | REST API testing |
| Remote SSH | `ms-vscode-remote.remote-ssh` | SSH remote development |

To install any of these:

1. Press `Ctrl+Shift+X`
2. Search for the extension name or ID
3. Click **Install**

### Disabling VS Code Built-in Chat

VS Code's built-in Chat can interfere with Kilo Code. Disable it via GUI:

Disable the separate GitHub Copilot extension (if installed):

1. Press `Ctrl+Shift+X`
2. Search for "Copilot"
3. Click the gear icon and select **Disable**

## Terminal Font Configuration

If the integrated terminal renders fonts incorrectly:

1. Open the Command Palette with `Ctrl+Shift+P`
2. Select **Terminal: Configure Terminal Settings**
3. Set the font to **JetBrainsMono Nerd Font**

## Kilo Code VS Code Extension

Kilo Code is an AI coding assistant that integrates directly into VS Code as an extension. It replaces VS Code's built-in Chat with a capable AI agent.

### Installation

1. Open VS Code
2. Go to Extensions (`Ctrl+Shift+X`)
3. Search for "Kilo Code"
4. Click the dropdown and **Install**

### Disabling Kilo Chat (Use Local Model Only)

Kilo Code works with local models by default when using llama.cpp server. No cloud configuration needed.

### Starting llama.cpp Server

Start the llama.cpp server (llama-server) with your model.

### Configuring Kilo for Local llama.cpp

Check model name and ID: `http://<YOUR_LLAMA_SERVER_IP>:8080/v1/models`

Replace `<YOUR_LLAMA_SERVER_IP>` with your llama-server's IP address, or DNS name (e.g., `127.0.0.1` or `localhost` if running locally).

> Go to Kilo extension, click on **gear icon** Settings -> Providers -> Custom provider -> _add_  
> Provider ID: llamacpp  
> Display name: OpenAI Compatible API  
> Base URL: <http://ai.home.arpa:8080/v1>  
> API key: _empty_  
> Models: _Autopopulate using button, or copy model name and ID you previously saved._  

### Getting Started

1. Click the **Kilo Code** icon in the VS Code Side Bar to open the chat panel
2. Type your task (e.g., "Create a function that calculates fibonacci numbers")
3. Press `Enter` to send
4. Review proposed actions and click **Allow** or **Deny**

### Settings UI

Click the **gear icon** in the Kilo Code sidebar to configure:

- **Providers**: AI model provider settings
- **Auto-Approve**: Which actions require confirmation
- **Models**: Default model per agent type
- **Experimental**: Advanced features

### Disable all provider but local LLM

Modify config `~/.config/kilo/kilo.jsonc`

```json
"disabled_providers": ["anthropic", "openai", "kilo"]
```

### MCP Servers

Prerequisites: npx, uvx

```bash
# Install
sudo pacman -Syu uv npm
```

Search Kilo Marketplace: `Settings -> Agent Behaviour -> MCP Servers -> Browse Marketplace -> Install`

There are MCPs readily available for manual installation: [Kilo Marketplace](https://github.com/Kilo-Org/kilo-marketplace)

However you can manually add more, with manual editing of the config file.
MCPs are configured in `~/.config/kilo/kilo.json`.

```json
{
  "$schema": "https://app.kilo.ai/config.json",
  "mcp": {
    "microsoft-learn": {
      "type": "remote",
      "url": "https://learn.microsoft.com/api/mcp"
    },
    "time": {
      "type": "local",
      "command": ["uvx", "mcp-server-time"]
    },
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "ctx7sk-...-..." // <- REPLACE IT WITH KEY
      }
    },
    "deepwiki": {
      "type": "local",
      "command": ["npx","mcp-deepwiki@latest"]
    }
  }
}
```

| MCP | Description |
| --- | ----------- |
| `context7` | Library/framework documentation (React, Next.js, Supabase, etc.) |
| `deepwiki` | GitHub repository documentation and Q&A |
| `microsoft-learn` | Microsoft/Azure documentation lookup |
| `microsoft-learn-code-samples` | Microsoft code snippets and examples |
| `time` | Timezone conversion |

### Auto-Approval

Configure what Kilo can do without asking:

1. Open **Settings** (gear icon)
2. Go to **Auto-Approve**
3. Set each tool to **Allow**, **Ask**, or **Deny**

### Custom Agents

Search Kilo Marketplace: `Settings -> Agent Behaviour -> MCP Servers -> Browse Marketplace -> Modes`

| Agent | Description |
| ----- | ----------- |
| `Code Reviewer` | Senior software engineer conducting thorough code reviews |
| `Documentation Specialist` | Focus on writing documentation, markdown files, and other text-based files |