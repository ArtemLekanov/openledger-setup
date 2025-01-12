#!/bin/bash

# Обновление системы
echo "Обновление системы..."
sudo apt update && sudo apt upgrade -y || { echo "Ошибка обновления системы!"; exit 1; }

# Установка основных зависимостей
echo "Установка основных зависимостей..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common unzip screen || { echo "Ошибка установки зависимостей!"; exit 1; }

# Настройка Docker
echo "Настройка Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || { echo "Ошибка загрузки GPG ключа Docker!"; exit 1; }
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce || { echo "Ошибка установки Docker!"; exit 1; }

# Установка дополнительных библиотек
echo "Установка дополнительных библиотек..."
sudo apt install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0 desktop-file-utils libasound2t64 || { echo "Ошибка установки дополнительных библиотек!"; exit 1; }

# Установка OpenLedger Node
echo "Загрузка и установка OpenLedger Node..."
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip || { echo "Ошибка загрузки OpenLedger Node!"; exit 1; }
unzip -o openledger-node-1.0.0-linux.zip || { echo "Ошибка распаковки OpenLedger Node!"; exit 1; }
sudo dpkg -i openledger-node-1.0.0.deb || { echo "Ошибка установки OpenLedger Node!"; exit 1; }

# Устранение проблем с зависимостями
echo "Устранение проблем с зависимостями..."
sudo apt-get install -f -y || { echo "Ошибка исправления зависимостей!"; exit 1; }
sudo dpkg --configure -a || { echo "Ошибка настройки пакетов!"; exit 1; }

# Создание и запуск screen-сессии
echo "Создание screen-сессии..."
screen -dmS openledger_node bash -c "openledger-node --no-sandbox; exec bash"
echo "Установка завершена успешно!"
