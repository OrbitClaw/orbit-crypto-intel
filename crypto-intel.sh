#!/bin/bash

# Crypto Intel - 加密货币新闻爬取脚本
# 用法: ./crypto-intel.sh [选项]

set -e

# 默认配置
HOURS=12
TELEGRAM_ID=""
OUTPUT_FORMAT="markdown"
DEEP_CRAWL=true

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --hours)
            HOURS="$2"
            shift 2
            ;;
        --telegram)
            TELEGRAM_ID="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        --deep)
            DEEP_CRAWL="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --hours N     时间窗口（小时），默认12"
            echo "  --telegram ID Telegram用户ID，可选（不设置则直接输出到终端）"
            echo "  --output fmt  输出格式 (text|json|markdown)，默认markdown"
            echo "  --deep bool   是否爬取深度长文，默认true"
            echo ""
            echo "示例:"
            echo "  $0                        # 12小时窗口，输出到终端"
            echo "  $0 --hours 24             # 24小时窗口"
            echo "  $0 --telegram 5844680524  # 发送到Telegram"
            echo "  $0 --hours 12 --telegram 5844680524  # 自定义时间+发送"
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

echo "🚀 Crypto Intel 启动"
echo "📅 时间窗口: 过去 ${HOURS} 小时"
echo "📱 Telegram: ${TELEGRAM_ID:-（直接输出到终端）}"
echo "🔍 深度爬取: $DEEP_CRAWL"
echo ""

# 检查依赖工具
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "⚠️ 警告: $1 未安装"
    fi
}

check_tool "python3"
check_tool "curl"

echo "✅ 配置验证通过"
echo ""
echo "此脚本设计为由Open执行爬取Claw agent调用任务。"
echo ""
echo "要在OpenClaw中使用，请复制 task-prompt.txt 的内容到agent配置。"
echo ""
echo "快速开始:"
echo "1. 即时查询: 直接复制 task-prompt.txt 到对话中"
echo "2. Telegram推送: 设置 --telegram 参数或 {{TELEGRAM_ID}} 变量"
