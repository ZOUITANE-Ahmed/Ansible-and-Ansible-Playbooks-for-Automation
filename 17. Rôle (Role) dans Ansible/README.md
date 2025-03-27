### **Rôle (Role) dans Ansible**

Un **rôle** dans Ansible est une structure d'organisation permettant de diviser un playbook en différentes parties fonctionnelles. Les rôles sont utilisés pour rendre les playbooks plus modulaires, réutilisables et mieux organisés. Ils permettent de gérer des configurations complexes en les divisant en sections logiques qui peuvent être exécutées indépendamment.

### **Qu'est-ce qu'un rôle (role) ?**
Un rôle est essentiellement un conteneur pour une collection de tâches, de variables, de fichiers, de gestionnaires, de templates et d'autres ressources nécessaires à une partie spécifique de la gestion de configuration d'un système. Cela peut être utilisé pour des tâches comme l'installation d'un logiciel, la gestion de services, ou la configuration de paramètres de système.

### **Pourquoi utiliser des rôles ?**
1. **Modularité** : Permet de découper les playbooks complexes en composants plus petits et réutilisables.
2. **Réutilisabilité** : Un rôle peut être utilisé dans différents playbooks sans avoir à réécrire le même code.
3. **Lisibilité** : Les rôles permettent une organisation claire du code, ce qui facilite la compréhension et la maintenance des playbooks.
4. **Dépendances** : Les rôles peuvent avoir des dépendances avec d'autres rôles, ce qui permet de structurer des playbooks complexes en chaînes de rôles dépendants.

### **Structure d'un rôle Ansible**

Les rôles dans Ansible suivent une structure de répertoires spécifique pour organiser les différentes ressources nécessaires. Voici la structure de base d'un rôle Ansible :

```
my_role/
├── defaults/
│   └── main.yml       # Variables par défaut
├── files/
│   └── my_file.txt    # Fichiers à déployer sur les hôtes cibles
├── handlers/
│   └── main.yml       # Gestionnaires pour notifier des actions
├── meta/
│   └── main.yml       # Métadonnées, dépendances et informations supplémentaires
├── tasks/
│   └── main.yml       # Tâches à exécuter dans ce rôle
├── templates/
│   └── my_template.j2 # Modèles Jinja2 pour générer des fichiers dynamiques
├── vars/
│   └── main.yml       # Variables spécifiques au rôle
```

### **Détail des répertoires d'un rôle**

1. **`defaults/`** : Ce répertoire contient les variables par défaut. Ces variables peuvent être facilement surchargées par l'utilisateur dans les playbooks ou dans les fichiers de variables d'environnement.

2. **`files/`** : Contient les fichiers qui seront transférés sur les hôtes cibles. Par exemple, des fichiers de configuration ou des scripts.

3. **`handlers/`** : Contient des gestionnaires (handlers) qui sont des tâches spécifiques qui ne sont exécutées que lorsqu'elles sont "notifiées" par d'autres tâches. Par exemple, vous pouvez notifier un gestionnaire pour redémarrer un service après avoir modifié un fichier de configuration.

4. **`meta/`** : Ce répertoire contient des métadonnées sur le rôle, y compris les dépendances avec d'autres rôles, les informations sur les versions, ou des informations supplémentaires comme les plateformes cibles.

5. **`tasks/`** : Contient les tâches principales du rôle. Ces tâches sont exécutées lors du playbook. Il est ici que vous utilisez les modules d'Ansible (comme `apt`, `yum`, `service`, etc.) pour accomplir les actions sur les hôtes.

6. **`templates/`** : Ce répertoire contient des fichiers **Jinja2** qui sont utilisés pour générer des fichiers dynamiques en fonction des variables. Par exemple, vous pourriez utiliser des templates pour générer un fichier de configuration personnalisé pour un service en fonction des paramètres du rôle.

7. **`vars/`** : Ce répertoire contient des variables spécifiques au rôle. Contrairement aux variables dans `defaults/`, celles-ci ne sont pas facilement surchargées. Elles sont utilisées pour des valeurs strictes qui ne doivent pas être modifiées.

### **Exemple d'un rôle Ansible : Installation de Nginx**

Voici un exemple simple d'un rôle Ansible pour installer Nginx sur un serveur.

#### **Structure du rôle**
```
nginx/
├── defaults/
│   └── main.yml
├── tasks/
│   └── main.yml
├── templates/
│   └── nginx.conf.j2
├── vars/
│   └── main.yml
├── handlers/
│   └── main.yml
```

#### **Contenu des fichiers**

1. **`defaults/main.yml` (Variables par défaut)**
```yaml
# defaults/main.yml
nginx_user: www-data
nginx_group: www-data
nginx_port: 80
```

2. **`tasks/main.yml` (Tâches à exécuter)**
```yaml
# tasks/main.yml
---
- name: Installer Nginx
  apt:
    name: nginx
    state: present
  notify:
    - Démarrer Nginx

- name: Copier la configuration de Nginx
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify:
    - Recharger Nginx
```

3. **`templates/nginx.conf.j2` (Template Jinja2)**
```jinja
# templates/nginx.conf.j2
user {{ nginx_user }};
worker_processes auto;
worker_connections 1024;

server {
    listen {{ nginx_port }};
    server_name localhost;
    location / {
        root /var/www/html;
        index index.html;
    }
}
```

4. **`vars/main.yml` (Variables spécifiques au rôle)**
```yaml
# vars/main.yml
nginx_port: 8080
```

5. **`handlers/main.yml` (Gestionnaires)**
```yaml
# handlers/main.yml
---
- name: Démarrer Nginx
  service:
    name: nginx
    state: started
    enabled: yes

- name: Recharger Nginx
  service:
    name: nginx
    state: reloaded
```

### **Utilisation du rôle dans un Playbook**

Une fois que le rôle est créé, il peut être utilisé dans un playbook comme suit :

```yaml
---
- name: Installer et configurer Nginx
  hosts: web_servers
  roles:
    - nginx
```

### **Avantages des Rôles Ansible**

1. **Modularité** : Vous pouvez créer des rôles pour chaque tâche spécifique, ce qui facilite l'organisation et la gestion des configurations complexes.
2. **Réutilisabilité** : Un rôle une fois créé peut être réutilisé dans plusieurs playbooks sans duplication du code.
3. **Lisibilité et Maintenabilité** : Les rôles rendent les playbooks plus lisibles et plus faciles à maintenir en organisant les tâches dans des structures logiques.
4. **Partage et Collaboration** : Les rôles facilitent le partage de configurations entre les équipes et avec la communauté Ansible.

### **Conclusion**

Les **rôles Ansible** sont essentiels pour créer des playbooks bien structurés et modulaires. Ils permettent de gérer des tâches complexes tout en maintenant la lisibilité et la réutilisabilité du code. Les rôles sont un moyen puissant d'automatiser la gestion des systèmes avec Ansible et d'assurer une organisation propre et professionnelle des playbooks.