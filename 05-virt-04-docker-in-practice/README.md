# Домашнее задание к занятию 5. «Практическое применение Docker»

### Инструкция к выполнению

1. Для выполнения заданий обязательно ознакомьтесь с [инструкцией](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD) по экономии облачных ресурсов. Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
3. **Своё решение к задачам оформите в вашем GitHub репозитории.**
4. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.
5. Сопроводите ответ необходимыми скриншотами.

---
## Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

---

## Задача 0
1. Убедитесь что у вас НЕ(!) установлен ```docker-compose```, для этого получите следующую ошибку от команды ```docker-compose --version```
```
Command 'docker-compose' not found, but can be installed with:

sudo snap install docker          # version 24.0.5, or
sudo apt  install docker-compose  # version 1.25.0-1

See 'snap info docker' for additional versions.
```
В случае наличия установленного в системе ```docker-compose``` - удалите его.  
2. Убедитесь что у вас УСТАНОВЛЕН ```docker compose```(без тире) версии не менее v2.24.X, для это выполните команду ```docker compose version```  

```
alekseykashin@MacBook-Pro-Aleksej 05-virt-04-docker-in-practice % docker compose version
Docker Compose version v2.29.1-desktop.1
```
###  **Своё решение к задачам оформите в вашем GitHub репозитории!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**

---

## Задача 1
1. Сделайте в своем github пространстве fork репозитория ```https://github.com/netology-code/shvirtd-example-python/blob/main/README.md```.   
2. Создайте файл с именем ```Dockerfile.python``` для сборки данного проекта(для 3 задания изучите https://docs.docker.com/compose/compose-file/build/ ). Используйте базовый образ ```python:3.9-slim```. 
Обязательно используйте конструкцию ```COPY . .``` в Dockerfile. Не забудьте исключить ненужные в имадже файлы с помощью dockerignore. Протестируйте корректность сборки.  
```
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % cat Dockerfile.python
FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "main.py"]%  

alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % cat .dockerignore
**/*.pdf
**/.nev
**/Dockerfile*
LICENSE
README.md%  

alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % docker build -f Dockerfile.python -t back_service .
[+] Building 1.0s (9/9) FINISHED                                                                                                                                         docker:desktop-linux
 => [internal] load build definition from Dockerfile.python                                                                                                                              0.0s
 => => transferring dockerfile: 271B                                                                                                                                                     0.0s
 => [internal] load metadata for docker.io/library/python:3.9-slim                                                                                                                       0.9s
 => [internal] load .dockerignore                                                                                                                                                        0.0s
 => => transferring context: 136B                                                                                                                                                        0.0s
 => [1/4] FROM docker.io/library/python:3.9-slim@sha256:1e3437daae1d9cebce372794eacfac254dd108200e47c8b7f56a633ebd3e2a0a                                                                 0.0s
 => [internal] load build context                                                                                                                                                        0.0s
 => => transferring context: 2.69kB                                                                                                                                                      0.0s
 => CACHED [2/4] WORKDIR /app                                                                                                                                                            0.0s
 => CACHED [3/4] COPY . .                                                                                                                                                                0.0s
 => CACHED [4/4] RUN pip install -r requirements.txt                                                                                                                                     0.0s
 => exporting to image                                                                                                                                                                   0.0s
 => => exporting layers                                                                                                                                                                  0.0s
 => => writing image sha256:f7e4ce3832664904ce130509daa2dfd87929c94fa55e54085c031d4210376371                                                                                             0.0s
 => => naming to docker.io/library/back_service                                                                                                                                          0.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/t0nj6plf88reouh4fwhlsvl6a

alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % docker image ls
REPOSITORY                         TAG            IMAGE ID       CREATED         SIZE
back_service                       latest         f7e4ce383266   3 minutes ago   247MB
```

3. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker в venv. (Mysql БД можно запустить в docker run).

### Решение
#### 1 Вариант

1. Создаем сеть 'back_net' 
```
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % docker network create --driver=bridge back_net
665c88ee506a6a6e0d6572cd76680a6220b5336e3ba397a5c23d8ffacb7b3fa4
```
2. Выгружаем обрза mysql 8 из репозитория 
```
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % docker pull mysql:8                           
8: Pulling from library/mysql
86a1ed2ecedf: Pull complete 
cf88b6547cb5: Pull complete 
906b5914950d: Pull complete 
c617af9dc74d: Pull complete 
4e52819b0ae2: Pull complete 
235f6a16f543: Pull complete 
0c6aaf631f1d: Pull complete 
17b83eb9ad50: Pull complete 
1b971475b2b0: Pull complete 
6fa369cdb9f9: Pull complete 
Digest: sha256:ad77a7c4e2031597e0c73a21993f780cdde6cef15d3dae734fe550c6142f8097
Status: Downloaded newer image for mysql:8
docker.io/library/mysql:8

What's next:
    View a summary of image vulnerabilities and recommendations → docker scout quickview mysql:8
```
3. Запускаем контейнер 'mysql' в сети 'back_net
```
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % docker run -d --network='back_net' -v 'db_data:/var/lib/mysql' -e 'MYSQL_ROOT_PASSWORD=root' -e 'MYSQL_DATABASE=example' -e 'MYSQL_USER=user1' -e 'MYSQL_PASSWORD=pass1' --name mysql mysql:8 --mysql-native-password=ON 
9837cd0512eea0703ef8ce057d96a5ab3164952aeb839d76c0c1cfb42fde5534
```

4. Запускаем контейнер с сервисом 'back_app' в сети 'back_net'
```
docker run -d -p 5001:5000 --network='back_net' -e 'DB_HOST=mysql' -e 'DB_USER=user1' -e 'DB_PASSWORD=pass1' -e 'DB_NAME=example' --name back_app back_service 
```

5. Проверяем работу сервиса 

```
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % curl http://localhost:5001
TIME: 2024-08-31 12:55:33, IP: None%  
```

#### 2 Вариант 

1. Запускаем контейнер 'mysql'  
``
docker run -d  -p 3306:3306 -v 'db_data:/var/lib/mysql' -e 'MYSQL_ROOT_PASSWORD=root' -e 'MYSQL_DATABASE=example' -e 'MYSQL_USER=user1' -e 'MYSQL_PASSWORD=pass1' --name mysql mysql:8 --mysql-native-password=ON
```
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % docker run -d  -p 3306:3306 -v 'db_data:/var/lib/mysql' -e 'MYSQL_ROOT_PASSWORD=root' -e 'MYSQL_DATABASE=example' -e 'MYSQL_USER=user1' -e 'MYSQL_PASSWORD=pass1' --name mysql mysql:8 --mysql-native-password=ON
d023848d96a8c09adc601c558114bbeec54c627e67fc59a54544a39beb82d6b9
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                               NAMES
d023848d96a8   mysql:8   "docker-entrypoint.s…"   4 seconds ago   Up 3 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
```

2. Создаем bash скрипт запуска python приложения, добавляем новую переменную для порта, запускать будем приложение на 5001 порту
```
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % cat ./_run.sh
python3 -m venv venv  # on Windows, use "python -m venv venv" instead
. venv/bin/activate   # on Windows, use "venv\Scripts\activate" instead
pip install -r requirements.txt
$ cat $VIRTUAL_ENV/bin/postactivate
#!/bin/bash
# This hook is run after this virtualenv is activated.
export FLASK_RUN_PORT=5001
export DB_HOST=127.0.0.1
export DB_USER=user1
export DB_PASSWORD=pass1
export DB_NAME=example
python main.py%   
```
3. Запускаем приложение чере bash скирпт
```
alekseykashin@MacBook-Pro-Aleksej shvirtd-example-python % sh _run.sh
Requirement already satisfied: flask in ./venv/lib/python3.10/site-packages (from -r requirements.txt (line 1)) (3.0.3)
Requirement already satisfied: mysql-connector-python in ./venv/lib/python3.10/site-packages (from -r requirements.txt (line 2)) (9.0.0)
Requirement already satisfied: itsdangerous>=2.1.2 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (2.2.0)
Requirement already satisfied: Werkzeug>=3.0.0 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (3.0.4)
Requirement already satisfied: Jinja2>=3.1.2 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (3.1.4)
Requirement already satisfied: blinker>=1.6.2 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (1.8.2)
Requirement already satisfied: click>=8.1.3 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (8.1.7)
Requirement already satisfied: MarkupSafe>=2.0 in ./venv/lib/python3.10/site-packages (from Jinja2>=3.1.2->flask->-r requirements.txt (line 1)) (2.1.5)

[notice] A new release of pip is available: 23.0.1 -> 24.2
[notice] To update, run: pip install --upgrade pip
_run.sh: line 4: $: command not found
 * Tip: There are .env or .flaskenv files present. Do "pip install python-dotenv" to use them.
 * Serving Flask app 'main'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5001
 * Running on http://192.168.50.60:5001
Press CTRL+C to quit
 * Restarting with stat
 * Tip: There are .env or .flaskenv files present. Do "pip install python-dotenv" to use them.
 * Debugger is active!
 * Debugger PIN: 602-816-300
 127.0.0.1 - - [31/Aug/2024 16:06:12] "GET / HTTP/1.1" 200 -
```
4. Чтобы не прерывать заходим в новую консоль проверяем работу сервиса

```
Last login: Sat Aug 31 15:38:02 on ttys005
alekseykashin@MBP-Aleksej ~ % curl http://localhost:5001
TIME: 2024-08-31 16:06:12, IP: None%
```

4. (Необязательная часть, *) По образцу предоставленного python кода внесите в него исправление для управления названием используемой таблицы через ENV переменную.

### Решение

1. Добавляем в bash скрипт новую переменную
```
alekseykashin@MBP-Aleksej shvirtd-example-python % cat ./_run.sh
python3 -m venv venv  # on Windows, use "python -m venv venv" instead
. venv/bin/activate   # on Windows, use "venv\Scripts\activate" instead
pip install -r requirements.txt
$ cat $VIRTUAL_ENV/bin/postactivate
#!/bin/bash
# This hook is run after this virtualenv is activated.
export FLASK_RUN_PORT=5001
export DB_HOST=127.0.0.1
export DB_USER=user1
export DB_PASSWORD=pass1
export DB_NAME=example
export DB_TABLE_NAME=requests1
python main.py%
```

2. Добавляем в приложение новую глобавльную переменную и прокидываем по коду создания таблицы и обрщащение к ней (запись в таблицу)
![alt text](image.png)

3. Убеждаемся что приложение работает. Запускаем его
```
alekseykashin@MBP-Aleksej shvirtd-example-python % sh _run.sh
Requirement already satisfied: flask in ./venv/lib/python3.10/site-packages (from -r requirements.txt (line 1)) (3.0.3)
Requirement already satisfied: mysql-connector-python in ./venv/lib/python3.10/site-packages (from -r requirements.txt (line 2)) (9.0.0)
Requirement already satisfied: blinker>=1.6.2 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (1.8.2)
Requirement already satisfied: itsdangerous>=2.1.2 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (2.2.0)
Requirement already satisfied: Jinja2>=3.1.2 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (3.1.4)
Requirement already satisfied: Werkzeug>=3.0.0 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (3.0.4)
Requirement already satisfied: click>=8.1.3 in ./venv/lib/python3.10/site-packages (from flask->-r requirements.txt (line 1)) (8.1.7)
Requirement already satisfied: MarkupSafe>=2.0 in ./venv/lib/python3.10/site-packages (from Jinja2>=3.1.2->flask->-r requirements.txt (line 1)) (2.1.5)

[notice] A new release of pip is available: 23.0.1 -> 24.2
[notice] To update, run: pip install --upgrade pip
_run.sh: line 4: $: command not found
 * Tip: There are .env or .flaskenv files present. Do "pip install python-dotenv" to use them.
 * Serving Flask app 'main'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5001
 * Running on http://192.168.50.60:5001
Press CTRL+C to quit
 * Restarting with stat
 * Tip: There are .env or .flaskenv files present. Do "pip install python-dotenv" to use them.
 * Debugger is active!
 * Debugger PIN: 602-816-300

```

5. Проверяем работу сервиса 
```
alekseykashin@MBP-Aleksej ~ % curl http://localhost:5001
TIME: 2024-08-31 16:36:59, IP: None%   
```

6. Убеждаемся что в базу мы записали в новую таблицу ``requests1`` 
```
alekseykashin@MBP-Aleksej ~ % docker exec -it mysql bash
bash-5.1# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.4.2 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> select * from example.requests1;
+----+---------------------+------------+
| id | request_date        | request_ip |
+----+---------------------+------------+
|  1 | 2024-08-31 16:36:58 | NULL       |
|  2 | 2024-08-31 16:36:59 | NULL       |
+----+---------------------+------------+
2 rows in set (0.00 sec)

mysql> 
```

---
### ВНИМАНИЕ!
!!! В процессе последующего выполнения ДЗ НЕ изменяйте содержимое файлов в fork-репозитории! Ваша задача ДОБАВИТЬ 5 файлов: ```Dockerfile.python```, ```compose.yaml```, ```.gitignore```, ```.dockerignore```,```bash-скрипт```. Если вам понадобилось внести иные изменения в проект - вы что-то делаете неверно!
---

## Задача 2 (*)
1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
4. Просканируйте образ на уязвимости.
5. В качестве ответа приложите отчет сканирования.

### Решение 

1. Cоздаем registry в ya cloud 
```
alekseykashin@MBP-Aleksej shvirtd-example-python % yc container registry create --name test             
done (1s)
id: crpr851ktv8huaqmc41c
folder_id: b1gvqnla1h39vg6o82d0
name: test
status: ACTIVE
created_at: "2024-09-01T07:40:47.930Z"

There is a new yc version '0.132.1' available. Current version: '0.131.1'.
See release notes at https://yandex.cloud/ru/docs/cli/release-notes
You can install it by running the following command in your shell:
        $ yc components update
```

2. Настраиваем аутентификацию вашего локального docker в yandex container registry
```
alekseykashin@MBP-Aleksej shvirtd-example-python % yc container registry configure-docker
docker configured to use yc --profile "default" for authenticating "cr.yandex" container registries
Credential helper is configured in '/Users/alekseykashin/.docker/config.json'
alekseykashin@MBP-Aleksej shvirtd-example-python % cat ~/.docker/config.json 
{
  "auths": {
    "ghcr.io": {},
    "https://index.docker.io/v1/": {}
  },
  "credHelpers": {
    "container-registry.cloud.yandex.net": "yc",
    "cr.cloud.yandex.net": "yc",
    "cr.yandex": "yc"
  },
  "credsStore": "desktop",
  "currentContext": "desktop-linux",
  "features": {
    "hooks": "true"
  },
  "plugins": {
    "debug": {
      "hooks": "exec"
    },
    "scout": {
      "hooks": "pull,buildx build"
    }
  }
}% 
```

3. Загружаем образ в ``test`` registry ya cloud

```
alekseykashin@MBP-Aleksej shvirtd-example-python %  docker tag back_service cr.yandex/crpr851ktv8huaqmc41c/back_service:latest
alekseykashin@MBP-Aleksej shvirtd-example-python % docker image ls                                                            
REPOSITORY                                    TAG       IMAGE ID       CREATED        SIZE
cr.yandex/crpr851ktv8huaqmc41c/back_service   latest    655ff2e905d7   19 hours ago   312MB
back_service                                  latest    655ff2e905d7   19 hours ago   312MB
mysql                                         8         11a5e588a69b   5 weeks ago    591MB
alekseykashin@MBP-Aleksej shvirtd-example-python %  docker push cr.yandex/crpr851ktv8huaqmc41c/back_service:latest
The push refers to repository [cr.yandex/crpr851ktv8huaqmc41c/back_service]
444af3362599: Pushed 
53eccbca1082: Pushed 
945fc808326c: Pushed 
97791036d356: Pushed 
02e8ea41f219: Pushed 
ed79b750b967: Pushed 
91bbafc72e16: Pushed 
07d2ee3f5712: Pushed 
latest: digest: sha256:88542251b69b89b89460ca9138093ca0fd1eb2c62d2257bdf1f0ee3db489ce52 size: 2000
alekseykashin@MBP-Aleksej shvirtd-example-python % 
```

![alt text](image-1.png)

4. Отчет о уязвимостях 

[Отчет](./vulnerabilities.csv)

## Задача 3
1. Изучите файл "proxy.yaml"
2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".
3. Опишите в файле ```compose.yaml``` следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!

2. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ```curl -L http://127.0.0.1:8090``` должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: ```docker ps -a ``` и ```docker logs <container_name>``` . Если вместо IP-адреса вы получаете ```NULL``` --убедитесь, что вы шлете запрос на порт ```8090```, а не 5000.

5. Подключитесь к БД mysql с помощью команды ```docker exec <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT * from requests LIMIT 10;```.

6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.

### Решение

1. Листинг ``compose`` файла 
```
alekseykashin@MBP-Aleksej shvirtd-example-python % cat compose.yaml
version: "3"
# The parser will ignore extension fields prefixed with x-
x-deploy: &deploy-dev
  deploy:
    resources:
      limits:
        cpus: "1"
        memory: 512M
      reservations:
        memory: 256M
x-env_file: &env_file
  env_file:
    - .env
x-restart: &restart
  restart: always #no, on-failure , always(default), unless-stopped 

include:
  - ./proxy.yaml

services:
  db:
    image: mysql:8
    volumes:
      - db_data:/var/lib/mysql
    <<: [*deploy-dev, *env_file, *restart]
    command: "--mysql-native-password=ON" 
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_ROOT_HOST="%" # it's very important!!!
    healthcheck:
      test: mysqladmin ping -u $$MYSQL_USER --password=$$MYSQL_PASSWORD
      start_period: 5s
      interval: 5s
      timeout: 5s
      retries: 10
    networks:
      backend:
        ipv4_address: 172.20.0.10

  web:
    image: cr.yandex/crpr851ktv8huaqmc41c/back_service:latest
    #build:
    #  context: .
    #  dockerfile: ./Dockerfile.python
    depends_on: 
      - db
    <<: [*env_file, *restart]
    environment:
      - DB_NAME=${MYSQL_DATABASE}
      - DB_USER=${MYSQL_USER}
      - DB_PASSWORD=${MYSQL_PASSWORD}
      - DB_HOST=mysql_db
      - DB_TABLE_NAME=${WEB_DB_TABLE_NAME}
    networks:
      backend:
        ipv4_address: 172.20.0.5

volumes:
  db_data: {}

networks:
  local-dns:
    external: true%  
```

2. Стартуем ``compose`` файл

```
alekseykashin@MBP-Aleksej shvirtd-example-python % docker compose up -d
WARN[0000] /Users/alekseykashin/nettology/shvirtd-example-python/proxy.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
WARN[0000] /Users/alekseykashin/nettology/shvirtd-example-python/compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 5/5
 ✔ Network shvirtd-example-python_backend            Created                                                                                                                              0.0s 
 ✔ Container shvirtd-example-python-mysql_db-1       Started                                                                                                                              0.2s 
 ✔ Container shvirtd-example-python-flask-1          Started                                                                                                                              0.3s 
 ✔ Container shvirtd-example-python-reverse-proxy-1  Started                                                                                                                              0.4s 
 ✔ Container shvirtd-example-python-ingress-proxy-1  Started  
```

3. Убеждаемся что сервис возращает ответ 

```
alekseykashin@MBP-Aleksej shvirtd-example-python % curl -L http://127.0.0.1:8090
TIME: 2024-09-01 09:27:09, IP: 192.168.65.1%      
```

4. Подключаемся к серверу ``db`` и проверяем что что схема, таблица и записи присутсвуют

```
alekseykashin@MBP-Aleksej shvirtd-example-python % docker compose exec db mysql -uroot -pYtReWq4321
WARN[0000] /Users/alekseykashin/nettology/shvirtd-example-python/proxy.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
WARN[0000] /Users/alekseykashin/nettology/shvirtd-example-python/compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 8.4.2 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| virtd              |
+--------------------+
5 rows in set (0.00 sec)

mysql> use virtd;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-----------------+
| Tables_in_virtd |
+-----------------+
| web_requests    |
+-----------------+
1 row in set (0.00 sec)

mysql> SELECT * from web_requests LIMIT 10;.
+----+---------------------+--------------+
| id | request_date        | request_ip   |
+----+---------------------+--------------+
|  1 | 2024-09-01 09:50:35 | 192.168.65.1 |
|  2 | 2024-09-01 09:50:37 | 192.168.65.1 |
|  3 | 2024-09-01 09:50:39 | 192.168.65.1 |
+----+---------------------+--------------+
3 rows in set (0.00 sec)

```

## Задача 4
1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).
2. Подключитесь к Вм по ssh и установите docker.
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy. ПРИМЕЧАНИЕ: Приложение весьма вероятно упадет под нагрузкой, но успеет обработать часть запросов - этого достаточно.
5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
6. В качестве ответа повторите  sql-запрос и приложите скриншот с данного сервера, bash-скрипт и ссылку на fork-репозиторий.

## Задача 5 (*)
1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."
2. Протестируйте ручной запуск
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!
4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты  действий .

## Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты  действий .

## Задача 6.2 (**)
Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.  
Предоставьте скриншоты  действий .

## Задача 7 (***)
Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
Предоставьте скриншоты  действий .
