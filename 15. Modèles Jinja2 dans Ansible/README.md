# **Modèles Jinja2 dans Ansible**  

## **📌 Introduction**
Jinja2 est un moteur de templating puissant utilisé par Ansible pour **générer dynamiquement des fichiers** ou **modifier des configurations en fonction des variables**. Il permet d'utiliser des **expressions, des boucles, des conditions, des filtres et des fonctions avancées** dans les playbooks et fichiers de configuration.

👉 **Utilisation principale dans Ansible :**  
- Génération de fichiers de configuration dynamiques.  
- Manipulation avancée des variables.  
- Création de messages conditionnels.  
- Personnalisation des résultats des tâches.  

---

## **📜 1. Syntaxe de base**
La syntaxe Jinja2 repose sur des **délimiteurs spécifiques** :

| Type d'expression | Syntaxe | Description |
|------------------|--------|-------------|
| **Variable** | `{{ variable }}` | Affiche la valeur d’une variable. |
| **Condition** | `{% if ... %} ... {% endif %}` | Évalue une condition et affiche un résultat. |
| **Boucle** | `{% for ... in ... %} ... {% endfor %}` | Itère sur une liste ou un dictionnaire. |
| **Commentaire** | `{# ... #}` | Ajoute un commentaire dans le modèle (non affiché). |

---

## **🔹 2. Exemple simple de variable**
Les variables peuvent être utilisées directement dans les fichiers de templates Jinja2.

Fichier `config.j2` (template Jinja2) :
```jinja2
Serveur: {{ ansible_hostname }}
Adresse IP: {{ ansible_default_ipv4.address }}
```

Playbook `generate_config.yml` :
```yaml
---
- name: Générer un fichier de configuration
  hosts: all
  tasks:
    - name: Générer le fichier à partir du modèle
      template:
        src: config.j2
        dest: /etc/config.txt
```

👉 **Résultat généré sur la machine distante (`/etc/config.txt`)** :
```
Serveur: server01
Adresse IP: 192.168.1.10
```

---

## **🔹 3. Utilisation des Conditions**
Jinja2 permet d’intégrer des **conditions** dans les templates.

Fichier `motd.j2` :
```jinja2
{% if ansible_os_family == "RedHat" %}
Bienvenue sur un serveur RedHat.
{% elif ansible_os_family == "Debian" %}
Bienvenue sur un serveur Debian.
{% else %}
Bienvenue sur un autre type de serveur.
{% endif %}
```

📌 **Explication** :
- Si l'OS est **RedHat**, le message sera : *Bienvenue sur un serveur RedHat.*
- Si l'OS est **Debian**, le message sera : *Bienvenue sur un serveur Debian.*
- Sinon, un message par défaut sera affiché.

---

## **🔹 4. Boucles dans Jinja2**
Les boucles permettent d'**itérer sur des listes et dictionnaires**.

Fichier `users.j2` :
```jinja2
Utilisateurs :
{% for user in users %}
- {{ user }}
{% endfor %}
```

Playbook associé :
```yaml
---
- name: Générer une liste d'utilisateurs
  hosts: localhost
  vars:
    users:
      - alice
      - bob
      - charlie
  tasks:
    - name: Générer le fichier
      template:
        src: users.j2
        dest: /tmp/users.txt
```

👉 **Résultat généré (`/tmp/users.txt`)** :
```
Utilisateurs :
- alice
- bob
- charlie
```

---

## **🔹 5. Filtres Jinja2**
Les filtres permettent de **modifier la sortie des variables**.

| **Filtre** | **Exemple** | **Description** |
|------------|------------|----------------|
| `upper` | `{{ name | upper }}` | Convertit en majuscules |
| `lower` | `{{ name | lower }}` | Convertit en minuscules |
| `replace` | `{{ text | replace('old', 'new') }}` | Remplace une chaîne |
| `join` | `{{ list | join(', ') }}` | Concatène une liste avec un séparateur |
| `default` | `{{ var | default('valeur par défaut') }}` | Définit une valeur par défaut |
| `length` | `{{ list | length }}` | Retourne la taille d'une liste |

📌 **Exemple :**
```jinja2
Nom en majuscules : {{ name | upper }}
Nombre d’utilisateurs : {{ users | length }}
```

---

## **🔹 6. Génération de Fichiers Dynamiques**
Un des cas d’usage principaux de Jinja2 est la génération **automatique de fichiers de configuration**.

### **🔹 Exemple 1 : Configuration d’un fichier Nginx**
Template `nginx.conf.j2` :
```jinja2
server {
    listen 80;
    server_name {{ server_name }};
    
    location / {
        proxy_pass http://{{ backend }};
    }
}
```

Playbook `deploy_nginx.yml` :
```yaml
---
- name: Déployer un fichier de configuration Nginx
  hosts: web
  vars:
    server_name: example.com
    backend: 192.168.1.100
  tasks:
    - name: Générer la configuration Nginx
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
```

**📌 Résultat généré sur le serveur (`/etc/nginx/nginx.conf`) :**
```nginx
server {
    listen 80;
    server_name example.com;
    
    location / {
        proxy_pass http://192.168.1.100;
    }
}
```

---

## **🔹 7. Gestion des Espaces et des Blocs**
Jinja2 peut gérer **les espaces et les blocs** dans les fichiers de configuration.

| **Syntaxe** | **Description** |
|-------------|----------------|
| `{%- ... -%}` | Supprime les espaces blancs autour du bloc. |
| `{{- variable -}}` | Supprime les espaces autour de la variable. |

Exemple avec `nginx.conf.j2` :
```jinja2
server {
    listen 80;
    {% if enable_ssl -%}
    listen 443 ssl;
    {% endif %}
}
```

Si `enable_ssl` est `true`, cela ajoutera `listen 443 ssl;`, sinon, cette ligne sera omise.

---

## **🎯 Conclusion**
✅ **Jinja2 est un outil puissant** pour la génération dynamique de fichiers dans Ansible.  
✅ Il prend en charge **les variables, les boucles, les conditions et les filtres**.  
✅ Son intégration avec **le module `template`** permet de générer facilement des fichiers de configuration.  