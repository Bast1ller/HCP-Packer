# Переменные
variable "vm_name" {
  default = "ubuntu_server_24.04_lts"
}

variable "iso_path" {
  default = "./ISO/ubuntu-24.04.1-live-server-amd64.iso"
}

variable "iso_checksum" {
  default = "sha256:E240E4B801F7BB68C20D1356B60968AD0C33A41D00D828E74CEB3364A0317BE9"
}

# Плагины VB
packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

# Основной блок сборки
source "virtualbox-iso" "ubuntu" {
  vm_name        = var.vm_name
  iso_url        = var.iso_path
  iso_checksum   = var.iso_checksum

  # Сеть ВМ перед упаковкой
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nic1", "bridged"],
    ["modifyvm", "{{.Name}}", "--bridgeadapter1", "Realtek PCIe GbE Family Controller"]
  ]

  guest_os_type        = "Ubuntu_64"
  guest_additions_mode = "attach"

  # Ресурсы ВМ перед упаковкой
  cpus           = 2
  memory         = 4096
  disk_size      = 20480

  # cloud-init
  cd_files = [
    "./ubuntu24/nocloud/meta-data",
    "./ubuntu24/nocloud/user-data"
  ]
  cd_label = "cidata"

  # GRUB
  boot_wait = "5s"
  boot_command = [
    "e<down><down><down><end>",
    " autoinstall ds=nocloud; ",
    "<wait><F10>",
  ]

  # communicator
  communicator       = "none"  # Отключение использования SSH
  virtualbox_version_file = ""

  keep_registered = true # Сохранение артефактов
  shutdown_command = "echo 'Pa$$w0rd' | sudo -S shutdown -P now"
  shutdown_timeout = "30m"
}

# builder
build {
  name    = "ubuntu-virtualbox"
  sources = ["source.virtualbox-iso.ubuntu"]

  # Post-processor для экспорта .ova
  post-processor "shell-local" {
    inline = [
      "echo 'Exporting OVF to .ova format...'",
      "VBoxManage export ubuntu_server_24.04_lts --output \"./templates/ubuntu-24.04.ova\""
    ]
  }

  # Post-processor для .box
  post-processor "vagrant" {
    output            = "./templates/ubuntu-24.04.box"
    compression_level = 9
  }

  # Post-processor для удаления ВМ
  post-processor "shell-local" {
    inline = [
      "echo 'Removing VM after export...'",
      "VBoxManage unregistervm ubuntu_server_24.04_lts --delete"
    ]
  }
}
