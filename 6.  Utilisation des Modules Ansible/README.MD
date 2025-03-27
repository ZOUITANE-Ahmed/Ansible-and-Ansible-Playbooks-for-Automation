### **Utilisation des Modules Ansible**

Les modules Ansible sont des unités de code qui effectuent des actions spécifiques sur des hôtes distants, qu’il s’agisse de manipuler des fichiers, d'installer des packages, de configurer des services ou de gérer des utilisateurs. Chaque tâche dans un playbook utilise un module pour effectuer une action spécifique. Ces modules permettent à Ansible de gérer une grande variété d'infrastructure sans nécessiter d'agents ou de configurations complexes sur les hôtes distants.

---

### **1. Qu’est-ce qu’un module Ansible ?**

Un **module Ansible** est un petit script autonome conçu pour accomplir une tâche précise sur un ou plusieurs hôtes distants. Par exemple, un module peut :
- Installer un logiciel.
- Gérer des fichiers et répertoires.
- Modifier des configurations système.
- Manipuler des utilisateurs et des groupes.

Les modules sont exécutés lors de l'exécution d'un playbook, et chaque tâche dans un playbook appelle un module spécifique. Ansible dispose de centaines de modules pour couvrir tous les aspects de la gestion d’infrastructure.

---

### **2. Structure d’un module Ansible dans un Playbook**

Un module est appelé au sein d’une tâche dans un playbook. La syntaxe de base pour appeler un module dans une tâche est la suivante :

```yaml
- name: Nom de la tâche
  module_name:
    paramètre1: valeur1
    paramètre2: valeur2
    paramètre3: valeur3
```

- **`name`** : Une description de la tâche exécutée.
- **`module_name`** : Le nom du module (par exemple `package`, `service`, `copy`, etc.).
- **Paramètres** : Les options spécifiques au module, définies sous forme de clés et de valeurs.

---

### **3. Exemples de modules courants**

#### **3.1. Le module `package` (Gestion des Paquets)**

Le module `package` permet de gérer l’installation, la suppression et la mise à jour des packages logiciels.

**Exemple :**
```yaml
- name: Installer Apache
  package:
    name: apache2
    state: present
```
- **`name`** : Le nom du paquet à installer.
- **`state`** : Indique l'état du paquet. `present` signifie que le paquet doit être installé. `absent` permet de supprimer le paquet. `latest` permet de mettre à jour le paquet à la dernière version.

#### **3.2. Le module `service` (Gestion des Services)**

Le module `service` permet de gérer l'état des services sur un hôte distant (démarrer, arrêter, redémarrer, etc.).

**Exemple :**
```yaml
- name: Démarrer le service Apache
  service:
    name: apache2
    state: started
    enabled: yes
```
- **`name`** : Le nom du service à gérer (par exemple `apache2`).
- **`state`** : Indique l'état souhaité du service (`started`, `stopped`, `restarted`).
- **`enabled`** : Définit si le service doit être activé au démarrage (`yes` ou `no`).

#### **3.3. Le module `file` (Gestion des fichiers et répertoires)**

Le module `file` permet de gérer les fichiers, répertoires et leurs permissions.

**Exemple :**
```yaml
- name: Créer un répertoire
  file:
    path: /tmp/example
    state: directory
    mode: '0755'
```
- **`path`** : Le chemin du fichier ou répertoire à gérer.
- **`state`** : Définit si l’objet est un fichier ou un répertoire (`file` ou `directory`).
- **`mode`** : Définit les permissions du fichier ou répertoire.

#### **3.4. Le module `copy` (Copie de fichiers)**

Le module `copy` permet de copier un fichier depuis l’hôte local vers un hôte distant.

**Exemple :**
```yaml
- name: Copier un fichier de configuration
  copy:
    src: /path/to/local/file.conf
    dest: /etc/apache2/file.conf
    owner: root
    group: root
    mode: '0644'
```
- **`src`** : Le chemin du fichier local.
- **`dest`** : Le chemin de destination sur l'hôte distant.
- **`owner`** et **`group`** : Définit le propriétaire et le groupe du fichier.
- **`mode`** : Définit les permissions du fichier.

#### **3.5. Le module `user` (Gestion des utilisateurs)**

Le module `user` permet de créer, modifier ou supprimer des utilisateurs sur un hôte distant.

**Exemple :**
```yaml
- name: Ajouter un utilisateur
  user:
    name: john
    state: present
    groups: sudo
    password: "{{ 'mypassword' | password_hash('sha512') }}"
```
- **`name`** : Le nom de l'utilisateur à créer ou modifier.
- **`state`** : Indique si l'utilisateur doit être ajouté (`present`) ou supprimé (`absent`).
- **`groups`** : Définit les groupes auxquels l'utilisateur appartient.
- **`password`** : Définit le mot de passe de l'utilisateur, crypté avec la méthode spécifiée.

#### **3.6. Le module `git` (Gestion des dépôts Git)**

Le module `git` permet de cloner ou de mettre à jour un dépôt Git sur l'hôte distant.

**Exemple :**
```yaml
- name: Cloner un dépôt Git
  git:
    repo: https://github.com/example/repository.git
    dest: /opt/myrepo
    version: master
```
- **`repo`** : L'URL du dépôt Git.
- **`dest`** : Le chemin où le dépôt doit être cloné.
- **`version`** : La branche ou le commit à cloner (par exemple, `master`).

---

### **4. Découverte de nouveaux modules**

Ansible offre des centaines de modules pour une grande variété de tâches. Pour découvrir tous les modules disponibles, tu peux utiliser la commande suivante :

```sh
ansible-doc -l
```

Cela affiche une liste de tous les modules disponibles. Pour obtenir des détails supplémentaires sur un module spécifique, utilise la commande suivante :

```sh
ansible-doc <module_name>
```

Exemple :
```sh
ansible-doc package
```

Cela te donnera des informations détaillées sur le module `package`, ses paramètres, ses options, et des exemples d’utilisation.

---

### **5. Création de modules personnalisés**

Si les modules fournis par Ansible ne répondent pas entièrement à tes besoins, tu peux créer des modules personnalisés. Un module personnalisé peut être écrit en Python, en PowerShell ou même en Bash, selon l’environnement d’exécution. Un module personnalisé doit être structuré de manière à prendre des entrées et renvoyer une sortie au format JSON.

Voici un exemple simple d'un module personnalisé en Python :

```python
#!/usr/bin/python

from ansible.module_utils.basic import AnsibleModule

def main():
    module = AnsibleModule(
        argument_spec=dict(
            name=dict(type='str', required=True),
            state=dict(type='str', choices=['present', 'absent'], default='present')
        )
    )

    name = module.params['name']
    state = module.params['state']
    
    if state == 'present':
        result = dict(changed=True, message="User {} added.".format(name))
    else:
        result = dict(changed=True, message="User {} removed.".format(name))
    
    module.exit_json(**result)

if __name__ == '__main__':
    main()
```

Ce module personnalisé ajoute ou supprime un utilisateur en fonction de l'état spécifié.

---

### **6. Conclusion**

Les modules Ansible sont des composants essentiels pour automatiser les tâches sur des hôtes distants. Ils offrent une grande flexibilité pour gérer l’infrastructure, qu’il s’agisse de la gestion des fichiers, des utilisateurs, des paquets ou des services. Ansible permet également de créer des modules personnalisés pour répondre à des besoins spécifiques.