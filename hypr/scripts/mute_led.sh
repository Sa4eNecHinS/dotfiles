#!/bin/bash

LED="/sys/class/leds/platform::mute/brightness"

# Функция проверки и переключения светодиода
update_led() {
  # Проверяем статус Mute у дефолтного выхода
  if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
    echo 1 | sudo tee "$LED" >/dev/null
  else
    echo 0 | sudo tee "$LED" >/dev/null
  fi
}

# Сначала запускаем один раз, чтобы синхронизировать при старте
update_led

# Слушаем события PipeWire и обновляем LED при изменениях
pactl subscribe | while read -r event; do
  if echo "$event" | grep -q "sink"; then
    update_led
  fi
done
