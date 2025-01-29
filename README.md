# 📦 HCP-Packer (Template)
На текущий момент проект предназначен для автоматизированной сборки образа с минимальными настройками Ubuntu 24.04 LTS используя Packer и VirtualBox.

## 🚀 Возможности
Автоматическая загрузка ISO-образа Ubuntu 24.04.
Настройка параметров виртуальной машины (CPU, RAM, диск).
Использование cloud-init для предварительной настройки.
Поддержка VirtualBox Guest Additions.
Экспорт образа в OVA и Vagrant Box.
Автоматическое удаление ВМ после экспорта.

## 📂 Структура проекта
| Каталог/Файл             | Описание                             |
|--------------------------|--------------------------------------|
| `Packer/`                | Корень                               |
| `Packer/ISO/`            | Каталог ISO-образов                  |
| `Packer/output-ubuntu/`  | Выходные файлы Packer                |
| `Packer/packer_cache/`   | Кэш загруженных файлов               |
| `Packer/templates/`      | Сохраненные OVA и Box файлы (шаблоны)|
| `Packer/ubuntu24/`       | Каталог дистрибутива Ubuntu 24.04    |
| `Packer/ubuntu24/nocloud/` | Cloud-init конфигурации            |
| `Packer/ubuntu24/nocloud/meta-data` | Cloud-init meta-data      |
| `Packer/ubuntu24/nocloud/user-data` | Cloud-init user-data      |
| `Packer/ubuntu24/ubuntu24.pkr.hcl` | Основной Packer конфиг     |
| `Packer/README.md`       | Файл документации                    |

## 🛠️ Требования
- Packer >= 1.9
- VirtualBox >= 7.0
- Vagrant (если нужен .box)
- oscdimg (при сборке на Windows)

## 📦 Сборка образа
Запустите команду:

|packer build ./ubuntu24|
|--|

После успешной сборки в каталоге templates/ появятся файлы .ova и .box.

## ⚙️ Учетные данные
hostname: localhost
username: ubuntu
password: Pa$$w0rd

## 📜 Лицензия
Этот проект распространяется под лицензией MIT.

## ✍️ Автор: Bast1ller
