 locals {
  cores = {
    diplom-stage = 2
    diplom-prod = 4
  }
  disk_size = {
    diplom-stage = 20
    diplom-prod = 40
  }

  memory = {
    diplom-stage = 2
    diplom-prod = 4
  }
  disk_type = {
    # stage = "network-hdd"
    diplom-stage = "network-ssd"
    diplom-prod = "network-ssd"
  }

  subnet-type = {
    diplom-stage = yandex_vpc_subnet.subnet-stage.id
    diplom-prod = yandex_vpc_subnet.subnet-prod.id
  }
  } 