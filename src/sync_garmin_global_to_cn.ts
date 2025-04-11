const { BARK_KEY_DEFAULT } = require('./constant');
const { syncGarminGlobal2GarminCN } = require('./utils/garmin_global');

const axios = require('axios');
const core = require('@actions/core');
const fs = require('fs');
const path = require('path');

// 定义日志文件路径
const LOG_FILE_PATH = path.join(__dirname, 'sync_log.txt');

const BARK_KEY = process.env.BARK_KEY ?? BARK_KEY_DEFAULT;

// 定义写入日志的函数
function writeLog(message) {
    const timestamp = new Date().toISOString();
    const logMessage = `[${timestamp}] ${message}\n`;
    fs.appendFileSync(LOG_FILE_PATH, logMessage, 'utf8');
}

try {
    // 执行同步操作
    syncGarminGlobal2GarminCN();

    // 发送成功通知
    axios.get(`https://api.day.app/${BARK_KEY}/Garmin Global->CN 同步数据done`);

    // 记录成功日志
    writeLog('Garmin Global 到 CN 的同步数据已完成成功。');

} catch (e) {
    // 发送失败通知
    axios.get(
        `https://api.day.app/${BARK_KEY}/Garmin CN -> Garmin Global 同步数据运行失败了，快去检查！/${encodeURIComponent(e.message)}`
    );

    // 记录失败日志
    writeLog(`Garmin CN 到 Garmin Global 的同步数据运行失败：${e.message}`);

    // 设置 GitHub Actions 为失败状态
    core.setFailed(e.message);

    // 抛出错误以停止后续执行
    throw e;

} finally {
    // 无论成功还是失败，都会执行的操作
    writeLog('同步操作已完成（无论成功或失败）。');
}

