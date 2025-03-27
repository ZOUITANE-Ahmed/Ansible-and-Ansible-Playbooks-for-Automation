### **Définition des Variables dans Ansible**

Les **variables** dans Ansible sont des éléments utilisés pour stocker des valeurs ou des informations que vous souhaitez réutiliser dans vos playbooks, rôles ou dans des fichiers d'inventaire. Elles permettent d'apporter de la flexibilité et de la réutilisabilité à vos configurations, tout en rendant les playbooks plus modulaires et dynamiques.

### **Pourquoi Utiliser des Variables dans Ansible ?**

Les variables permettent de personnaliser l'exécution des playbooks sans avoir besoin de réécrire le code à chaque fois que vous devez changer une valeur. Par exemple, vous pouvez définir une variable pour spécifier un paquet à installer, un service à démarrer, ou une configuration de réseau.

Les variables permettent aussi de rendre les playbooks plus généraux et réutilisables. Elles permettent également de simplifier la gestion des environnements de développement, de test et de production.

---

### **Types de Variables dans Ansible**

Ansible permet de définir des variables de différentes manières, chacune ayant ses avantages et son domaine d'application :

1. **Variables dans les Playbooks**
2. **Variables d'Hôte (Host Variables)**
3. **Variables de Groupe (Group Variables)**
4. **Facteurs (Facts)**
5. **Variables définies par l'utilisateur dans des fichiers ou rôles**
6. **Variables globales dans les rôles**
7. **Variables via la ligne de commande**

---

### **1. Variables dans les Playbooks**

Les variables peuvent être définies directement dans un playbook sous la section `vars`. Voici un exemple :

#### Exemple de Playbook avec des Variables :

```yaml
---
- name: Exemple de Playbook avec des Variables
  hosts: all
  vars:
    serveur_web: nginx
    version_nginx: 1.18.0

  tasks:
    - name: Installer le serveur web
      apt:
        name: "{{ serveur_web }}"
        state: present

    - name: Installer une version spécifique de nginx
      apt:
        name: "{{ serveur_web }}={{ version_nginx }}"
        state: present
```

- **`vars:`** : Définit des variables locales spécifiques à ce playbook. Ici, nous avons deux variables : 
  - **`serveur_web`** : Le nom du serveur web à installer (par exemple `nginx`).
  - **`version_nginx`** : La version spécifique de `nginx` à installer.

Les variables sont ensuite utilisées dans les tâches via la syntaxe **`{{ variable_name }}`**.

---

### **2. Variables d'Hôte (Host Variables)**

Les **variables d'hôte** sont spécifiées pour un hôte particulier dans un fichier d'inventaire ou dans un fichier dédié à l'hôte. Cela permet de définir des valeurs qui sont spécifiques à chaque machine.

#### Exemple d'Inventaire avec des Variables d'Hôte :

```ini
[web_servers]
web1 ansible_host=192.168.1.10
web2 ansible_host=192.168.1.11

[web_servers:vars]
serveur_web=apache
```

Dans cet exemple, **`serveur_web`** est défini pour tous les hôtes dans le groupe **`web_servers`**.

---

### **3. Variables de Groupe (Group Variables)**

Les **variables de groupe** sont définies pour un groupe d'hôtes. Cela permet de définir des variables qui sont communes à tous les hôtes d'un même groupe, évitant ainsi de dupliquer les mêmes valeurs dans plusieurs hôtes.

#### Exemple de fichier `group_vars` :

```yaml
# group_vars/web_servers.yml
serveur_web: apache
```

Dans ce cas, tous les hôtes du groupe **`web_servers`** auront la variable **`serveur_web`** définie comme **`apache`**.

---

### **4. Facteurs (Facts)**

Les **facts** sont des informations collectées automatiquement par Ansible sur chaque hôte avant d'exécuter une tâche. Ces informations peuvent être utilisées comme des variables dans votre playbook. Par exemple, vous pouvez récupérer des informations sur l'architecture du système, la mémoire disponible, le nom d'hôte, etc.

#### Exemple d'utilisation des Facts :

```yaml
- name: Exemple de playbook utilisant les facts
  hosts: all
  tasks:
    - name: Afficher le nom de l'hôte
      debug:
        msg: "L'hôte est {{ ansible_hostname }}"
```

- **`ansible_hostname`** est un fact préexistant qui contient le nom d'hôte de la machine cible.

Les faits sont collectés à l'aide du module **`setup`**, qui peut être explicitement appelé dans le playbook si nécessaire.

---

### **5. Variables Définies par l'Utilisateur**

Les variables peuvent également être définies par l'utilisateur dans des fichiers ou des rôles. Cela permet de structurer votre configuration de manière plus propre et modulaire.

#### Exemple dans un rôle :

```yaml
# roles/myrole/vars/main.yml
mon_paquet: vim
```

Dans ce cas, la variable **`mon_paquet`** est définie dans le rôle **`myrole`**.

---

### **6. Variables Globales dans les Rôles**

Dans les rôles, les variables peuvent être définies dans plusieurs fichiers, tels que **`defaults/main.yml`** ou **`vars/main.yml`**.

- **`defaults/main.yml`** : Variables par défaut, qui peuvent être surchargées par l'utilisateur.
- **`vars/main.yml`** : Variables définies de manière explicite dans le rôle.

#### Exemple dans le fichier **`defaults/main.yml`** :

```yaml
# roles/myrole/defaults/main.yml
paquet_defaut: apache2
```

Cela permet de définir des valeurs par défaut pour les variables utilisées dans le rôle.

---

### **7. Variables via la Ligne de Commande**

Les variables peuvent également être définies via la ligne de commande lors de l'exécution d'un playbook avec l'option **`-e`** (extra-vars).

#### Exemple de commande avec des variables via la ligne de commande :

```bash
ansible-playbook playbook.yml -e "serveur_web=nginx version_nginx=1.18.0"
```

Cela définit les variables **`serveur_web`** et **`version_nginx`** directement depuis la ligne de commande, ce qui est particulièrement utile pour des valeurs dynamiques ou sensibles.

---

### **Autres Méthodes de Définition de Variables**

1. **Variables dans des fichiers YAML ou JSON** : Vous pouvez également stocker vos variables dans des fichiers externes, puis les inclure dans vos playbooks à l'aide de l'option **`vars_files`**.

   Exemple de fichier de variables au format YAML :

   ```yaml
   # vars/mon_fichier_de_variables.yml
   paquet: nginx
   ```

   Et pour inclure ce fichier dans le playbook :

   ```yaml
   - name: Playbook avec un fichier de variables
     hosts: all
     vars_files:
       - vars/mon_fichier_de_variables.yml
   ```

2. **Facteurs Dynamiques** : Vous pouvez collecter des faits dynamiques pour des plateformes spécifiques comme **EC2**, **GCP**, ou autres, et les utiliser comme des variables dans votre playbook.

---

### **Conclusion**

Les **variables** dans Ansible sont essentielles pour rendre vos playbooks modulaires, dynamiques et réutilisables. Elles permettent de définir des paramètres de manière flexible, ce qui simplifie la gestion des configurations et améliore l'automatisation. Que vous utilisiez des variables locales dans les playbooks, des variables d'hôte, ou des facts, vous pouvez adapter votre configuration à différents environnements sans avoir à dupliquer le code.