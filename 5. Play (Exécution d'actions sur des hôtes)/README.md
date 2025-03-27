### **Play (Exécution d'actions sur des hôtes)**

Un **play** dans Ansible représente un ensemble d'actions qui sont exécutées sur des hôtes définis dans le playbook. Il permet de cibler un groupe d’hôtes ou des hôtes individuels pour appliquer des configurations spécifiques.

Voici les points importants à comprendre concernant les **plays** dans Ansible :

---

## **1. Structure de base d'un Play**  

Un play dans Ansible suit une structure bien définie, incluant plusieurs sections qui spécifient sur quels hôtes exécuter les actions, quelles actions réaliser, et d'autres paramètres de configuration. Un play se compose généralement de :

- **`name`** : Description du play
- **`hosts`** : Groupe d’hôtes ou hôtes ciblés pour l’exécution
- **`become`** : Utiliser `sudo` pour exécuter des tâches avec des privilèges élevés (facultatif)
- **`tasks`** : Liste des tâches à exécuter sur les hôtes cibles
- **`vars`** : Variables spécifiques à ce play (facultatif)

### Exemple de structure d'un Play :
```yaml
- name: Installer Apache et démarrer le service
  hosts: webservers
  become: yes
  tasks:
    - name: Installer Apache
      package:
        name: apache2
        state: present
    - name: Démarrer Apache
      service:
        name: apache2
        state: started
        enabled: yes
```

---

## **2. Explication des composants d'un Play**

### **`name`** :  
La première ligne de chaque play contient une description textuelle de ce que ce play va faire. Cela permet de mieux organiser et comprendre l’objectif du playbook.  
Exemple :
```yaml
name: Installer Apache et démarrer le service
```

### **`hosts`** :  
Cette directive détermine les hôtes (ou groupes d'hôtes) sur lesquels ce play sera exécuté. Cela peut être un groupe défini dans le fichier d'inventaire ou un ou plusieurs hôtes spécifiques.  
Exemple :
```yaml
hosts: webservers
```

- **`webservers`** : un groupe d'hôtes dans l'inventaire.  
- Si tu veux exécuter ce play sur un seul hôte, tu peux remplacer cela par un nom d'hôte spécifique comme `host1.example.com`.

### **`become`** :  
Cette option est utilisée pour exécuter les tâches avec des privilèges élevés (par exemple, `sudo` ou `root`). Si l'action requiert des privilèges administratifs, ajoute `become: yes`.  
Exemple :
```yaml
become: yes
```

### **`tasks`** :  
Les tâches (ou actions) sont les éléments les plus importants d'un play. Elles indiquent ce que doit être fait sur les hôtes cibles. Chaque tâche utilise un module Ansible pour accomplir une action spécifique.  
Dans l'exemple ci-dessus :
- **Installer Apache** : Utilise le module `package` pour installer le paquet `apache2` et s'assurer qu'il est présent.
- **Démarrer Apache** : Utilise le module `service` pour démarrer le service `apache2` et le rendre actif au démarrage du système.

Exemple de tâche pour installer Apache :
```yaml
- name: Installer Apache
  package:
    name: apache2
    state: present
```

### **`vars`** :  
Tu peux définir des variables spécifiques à ce play sous la clé `vars`. Cela permet de rendre le playbook plus flexible et réutilisable.  
Exemple :
```yaml
vars:
  apache_package: apache2
```

Et ensuite dans la tâche :
```yaml
- name: Installer Apache
  package:
    name: "{{ apache_package }}"
    state: present
```

---

## **3. Exécution d'un Play**

Un play est généralement exécuté au sein d'un **playbook**, qui est un fichier YAML contenant plusieurs plays. Pour exécuter un playbook, utilise la commande suivante dans ton terminal :
```sh
ansible-playbook mon_playbook.yml
```

Cela exécutera tous les plays définis dans `mon_playbook.yml`.

---

## **4. Limiter l'exécution d'un Play**

Ansible permet de limiter l'exécution d'un play à un sous-ensemble d'hôtes avec l'option `--limit`. Par exemple :
```sh
ansible-playbook mon_playbook.yml --limit host1.example.com
```
Cela exécutera uniquement les plays ciblant `host1.example.com`, même si d'autres hôtes sont définis dans le playbook.

---

## **5. Utilisation des Tags**

Les **tags** permettent d'exécuter uniquement certaines tâches d'un playbook, en fonction de leur étiquette. Cela est particulièrement utile pour tester une partie d'un playbook sans avoir à exécuter l'intégralité des tâches.

Exemple avec des tags :
```yaml
- name: Installer Apache
  package:
    name: apache2
    state: present
  tags: install

- name: Démarrer Apache
  service:
    name: apache2
    state: started
  tags: start
```

Exécution avec un tag spécifique :
```sh
ansible-playbook mon_playbook.yml --tags install
```
Cela exécutera uniquement les tâches marquées par le tag `install`.

---

## **6. Variables dans un Play**

Les variables peuvent être définies directement dans le play. Cela rend le playbook plus flexible et permet de personnaliser certaines valeurs.

Exemple avec des variables :
```yaml
- name: Installer Apache et démarrer le service
  hosts: webservers
  become: yes
  vars:
    apache_package: apache2
    apache_service: apache2
  tasks:
    - name: Installer Apache
      package:
        name: "{{ apache_package }}"
        state: present
    - name: Démarrer Apache
      service:
        name: "{{ apache_service }}"
        state: started
        enabled: yes
```
Dans cet exemple, les variables `apache_package` et `apache_service` sont utilisées pour personnaliser le nom du package et du service.

---

## **7. Utilisation de `with_items` pour les Boucles**

Dans les tâches, tu peux utiliser des boucles pour répéter une tâche pour plusieurs éléments. Cela est particulièrement utile lorsque tu as plusieurs éléments à gérer, comme des packages, des fichiers ou des utilisateurs.

Exemple de boucle avec `with_items` :
```yaml
- name: Installer plusieurs packages
  package:
    name: "{{ item }}"
    state: present
  with_items:
    - apache2
    - nginx
    - mysql-server
```

Cela installera les trois packages listés dans `with_items`.

---

### **💡 Conclusion**

Les **plays** dans Ansible sont des blocs essentiels pour organiser les actions que tu souhaites exécuter sur un groupe d'hôtes ou sur des hôtes individuels. Ils te permettent de structurer et d'automatiser efficacement la configuration de ton infrastructure. En utilisant des **tasks**, des **variables**, des **tags** et des **boucles**, tu peux rendre ton playbook plus flexible et puissant.
