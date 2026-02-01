#!/bin/bash

# Crypto Intel - 加密货币新闻爬取脚本
# 用法: ./crypto-intel.sh --hours 12 --telegram 5844680524

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
            echo "选项:"
            echo "  --hours N     时间窗口（小时），默认12"
            echo "  --telegram ID Telegram用户ID，必填"
            echo "  --output fmt  输出格式 (text|json|markdown)，默认markdown"
            echo "  --deep bool   是否爬取深度长文，默认true"
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

# 验证必需参数
if [ -z "$TELEGRAM_ID" ]; then
    echo "错误: 必须指定 --telegram 参数"
    exit 1
fi

echo "🚀 Crypto Intel 启动"
echo "📅 时间窗口: 过去 ${HOURS} 小时"
echo "📱 Telegram: $TELEGRAM_ID"
echo "🔍 深度爬取: $DEEP_CRAWL"
echo ""

# 检查依赖工具
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "警告: $1 未安装"
    fi
}

check_tool "python3"
check_tool "curl"

# 主执行逻辑（由OpenClaw agent调用）
echo "✅ 配置验证通过"
echo ""
echo "此脚本设计为由OpenClaw agent调用，"
echo "实际爬取任务请通过OpenClaw cron job执行。"
echo ""
echo "快速开始:"
echo "1. 在OpenClaw中添加cron job"
echo "2. 使用 task-prompt.txt 中的任务提示词"
echo "3. 设置 --telegram $TELEGRAM_ID"
