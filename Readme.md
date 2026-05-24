# Опис застосунку webapp

У цьому проєкті реалізовано розгортання багатовузлового веб-застосунку з використанням:

- Terraform
- Ansible
- Libvirt/QEMU
- Ubuntu Cloud Images
- Nginx reverse proxy
- Node.js
- PostgreSQL

Архітектура системи:

```text
client
   ↓
nginx (worker VM)
   ↓
Node.js application
   ↓
PostgreSQL database (db VM)
```

---

# Інфраструктура

Створюються дві віртуальні машини:

| VM        | Призначення                |
| --------- | -------------------------- |
| worker-vm | nginx + Node.js застосунок |
| db-vm     | PostgreSQL база даних      |

---

# Вимоги

Даний застосунок було розгорнуто використовуючи наступні технології:

- Terraform
- Ansible
- Libvirt
- QEMU/KVM
- WSL2 Ubuntu

---

# Як розгорнути?

## Після клонування репозиторію перейдіть до директорії проєкту та виконайте наступні команди:

```bash
cmod +x install-dependencies.sh generate-inventory.sh
./install-dependencies.sh
```

Після встановлення залежностей:

## Terraform

### Ініціалізація Terraform

```bash
cd terraform
terraform init
```

---

### Створення інфраструктури

```bash
terraform apply
```

Terraform:

- створює віртуальні машини
- генерує cloud-init конфігурації
- створює SSH ключ для Ansible

---

### Перевірка статусу VM

```bash
virsh list --all
```

---

### Запуск VM

```bash
virsh start worker-vm
virsh start db-vm
```

---

### Перевірка IP адрес VM

```bash
virsh domifaddr worker-vm
virsh domifaddr db-vm
```

---

Важливо, що залежно від системи, віртуальні машини можуть створюватись повільно, тому ip адреса може ще не бути призначена одразу після їх запуску.

## Ansible

### Inventory

Після успішного отримання ip адрес, перейдіть до директорії ансібл та запустіть файл створення файлу inventory.ini:

```bash
cd ../ansible
./generate-inventory.sh
```

---

### Запуск playbook

```bash
ansible-playbook -i inventory.ini playbook.yml
```

Playbook:

- встановлює PostgreSQL
- налаштовує PostgreSQL
- розгортає Node.js застосунок
- встановлює npm залежності
- генерує Prisma Client
- запускає Prisma migrations
- налаштовує nginx
- створює systemd сервіси
- створює необхідних користувачів
- створює `/home/student/gradebook`

---

# Обмеження доступу до БД

PostgreSQL приймає з’єднання лише:

- з db VM
- з worker VM

Налаштовується через:

- `listen_addresses`
- `pg_hba.conf`

---

# API Endpoints

# Головна HTML сторінка

```http
GET /
```

Відкрити у браузері:

```text
http://<WORKER_IP>/
```

---

# Health Endpoints

## Liveness Probe

```http
GET /health/alive
```

Перевірка:

```bash
curl http://<WORKER_IP>/health/alive
```

Очікувана відповідь:

```text
OK
```

---

## Readiness Probe

```http
GET /health/ready
```

Перевірка:

```bash
curl http://<WORKER_IP>/health/ready
```

Очікувана відповідь:

```text
OK
```

Цей endpoint перевіряє підключення до PostgreSQL.

---

# Tasks API

## Отримати всі задачі

```http
GET /tasks
Accept: application/json
```

Перевірка:

```bash
curl -H "Accept: application/json" http://<WORKER_IP>/tasks
```

---

## Створити задачу

```http
POST /tasks
Content-Type: application/json
```

Приклад:

```bash
curl -X POST http://<WORKER_IP>/tasks \
-H "Content-Type: application/json" \
-d '{"title":"test task"}'
```

---

## Позначити задачу як виконану

```http
PATCH /tasks/:id/1
```

Приклад:

```bash
curl -X PATCH http://<WORKER_IP>/tasks/1/done
```

---

# Тестування HTML інтерфейсу

Відкрити у браузері:

```text
http://<WORKER_IP>/
```

---

# Користувачі системи

| Користувач | Призначення                    |
| ---------- | ------------------------------ |
| ansible    | автоматичне налаштування       |
| teacher    | перевірка роботи               |
| operator   | керування nginx та застосунком |
| app        | запуск застосунку              |

---

# Права користувача operator

Користувач `operator` може:

- запускати застосунок
- зупиняти застосунок
- перезапускати застосунок
- переглядати статус застосунку
- виконувати reload nginx

без введення пароля sudo.
