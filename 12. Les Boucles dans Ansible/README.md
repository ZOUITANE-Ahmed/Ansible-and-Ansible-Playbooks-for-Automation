### **Les Boucles dans Ansible**

Les **boucles** dans Ansible permettent d'exécuter une tâche plusieurs fois pour un ensemble d'éléments, comme une liste de fichiers, des utilisateurs, ou toute autre collection de données. Cela permet d'automatiser des actions répétitives de manière plus compacte et efficace, sans avoir à répéter chaque tâche dans le playbook.

### **Syntaxe des Boucles dans Ansible**

Ansible offre plusieurs moyens pour créer des boucles, y compris en utilisant les mots-clés **`loop`**, **`with_items`**, **`with_dict`**, etc. Cependant, **`loop`** est la méthode la plus moderne et recommandée pour les boucles.

### **Utilisation de `loop` dans un Playbook**

L'exemple suivant montre comment utiliser **`loop`** pour répéter une tâche pour chaque élément d'une liste :

```yaml
---
- name: Exemple de boucle avec 'loop'
  hosts: all
  tasks:
    - name: Créer plusieurs fichiers
      file:
        path: "/tmp/{{ item }}"
        state: touch
      loop:
        - file1.txt
        - file2.txt
        - file3.txt
```

#### Explication de l'exemple :
- La tâche "Créer plusieurs fichiers" crée des fichiers dans le répertoire `/tmp/` pour chaque élément de la liste spécifiée dans `loop` (`file1.txt`, `file2.txt`, `file3.txt`).
- La variable `item` représente chaque élément de la liste pendant l'exécution de la boucle.
- La tâche sera exécutée une fois pour chaque fichier spécifié dans la liste.

### **Boucles avec des Dictionnaires**

Si vous avez un dictionnaire (une paire clé-valeur) que vous souhaitez utiliser dans une boucle, vous pouvez également le faire avec `loop`. Voici un exemple où un dictionnaire est utilisé pour ajouter des utilisateurs avec des groupes associés :

```yaml
---
- name: Créer des utilisateurs avec des groupes
  hosts: all
  tasks:
    - name: Créer un utilisateur
      user:
        name: "{{ item.name }}"
        group: "{{ item.group }}"
        state: present
      loop:
        - { name: "alice", group: "admin" }
        - { name: "bob", group: "developers" }
        - { name: "carol", group: "marketing" }
```

#### Explication :
- **`item.name`** et **`item.group`** font référence aux clés du dictionnaire dans chaque itération de la boucle.
- La boucle crée un utilisateur pour chaque élément du dictionnaire avec un groupe spécifique.

### **Utilisation de `loop` avec une Variable**

Les boucles peuvent aussi être utilisées avec des variables. Par exemple, si vous avez une variable contenant une liste, vous pouvez utiliser cette variable dans votre boucle :

```yaml
---
- name: Installer plusieurs paquets
  hosts: all
  vars:
    packages:
      - vim
      - git
      - curl
  tasks:
    - name: Installer les paquets
      package:
        name: "{{ item }}"
        state: present
      loop: "{{ packages }}"
```

#### Explication :
- La variable `packages` contient une liste de paquets à installer.
- La boucle passe par chaque élément de la variable `packages` et installe chaque paquet.

### **Utilisation de `with_items` (Ancienne Méthode)**

Avant l'introduction de **`loop`**, **`with_items`** était la méthode standard pour créer des boucles dans Ansible. Bien qu'elle soit encore prise en charge, elle est désormais considérée comme moins flexible que `loop`.

```yaml
---
- name: Installer des paquets avec 'with_items'
  hosts: all
  tasks:
    - name: Installer plusieurs paquets
      package:
        name: "{{ item }}"
        state: present
      with_items:
        - vim
        - git
        - curl
```

Bien que ce soit une méthode fonctionnelle, **`loop`** est préférée car elle offre plus de flexibilité (par exemple, avec des dictionnaires ou des variables complexes).

### **Boucles imbriquées (Loop imbriqué)**

Si vous avez une liste de listes ou un dictionnaire de listes, vous pouvez utiliser des boucles imbriquées pour parcourir tous les éléments.

#### Exemple avec une liste de listes :

```yaml
---
- name: Exemple de boucle imbriquée
  hosts: all
  tasks:
    - name: Créer des fichiers dans des répertoires
      file:
        path: "/tmp/{{ item[0] }}/{{ item[1] }}"
        state: touch
      loop:
        - [ "dir1", "file1.txt" ]
        - [ "dir1", "file2.txt" ]
        - [ "dir2", "file1.txt" ]
```

#### Explication :
- La boucle parcourt chaque sous-liste et utilise `item[0]` pour le répertoire et `item[1]` pour le fichier.
- Cela crée des fichiers dans des répertoires spécifiques en fonction de la liste imbriquée.

### **Conditions dans les Boucles**

Les boucles peuvent également être utilisées avec des conditions pour n’exécuter certaines tâches que si un critère est rempli. Vous pouvez utiliser **`when`** avec une boucle pour appliquer des conditions à chaque élément de la boucle.

Exemple de condition dans une boucle :

```yaml
---
- name: Exemple de boucle avec condition
  hosts: all
  tasks:
    - name: Créer un fichier si la mémoire est suffisante
      file:
        path: "/tmp/{{ item }}.txt"
        state: touch
      loop:
        - file1
        - file2
        - file3
      when: ansible_memtotal_mb > 1024
```

#### Explication :
- La tâche crée un fichier pour chaque élément de la liste, mais uniquement si la mémoire totale de l'hôte est supérieure à 1 Go (1024 Mo).

### **Boucles avec des Filtres**

Vous pouvez également utiliser des filtres dans les boucles pour modifier ou manipuler les données avant de les utiliser. Par exemple, vous pouvez filtrer une liste de paquets pour ne traiter que ceux qui ne sont pas déjà installés :

```yaml
---
- name: Installer des paquets uniquement s'ils ne sont pas déjà installés
  hosts: all
  tasks:
    - name: Installer les paquets
      package:
        name: "{{ item }}"
        state: present
      loop: "{{ packages | difference(installed_packages) }}"
```

#### Explication :
- **`difference(installed_packages)`** filtre les paquets déjà installés pour ne traiter que ceux qui ne le sont pas encore.

### **Résumé des Points Clés**
- **Boucles avec `loop`** : Utilisation moderne pour itérer sur des listes ou des dictionnaires.
- **Boucles avec `with_items`** : Ancienne méthode, encore supportée mais moins flexible que `loop`.
- **Conditions avec `when`** : Applique des conditions spécifiques sur chaque élément de la boucle.
- **Filtres dans les boucles** : Manipulez les données avant de les utiliser dans la boucle avec des filtres Ansible comme `difference`, `selectattr`, etc.
- **Boucles imbriquées** : Utilisation de boucles dans des structures plus complexes (listes de listes ou dictionnaires).

Les boucles permettent de rendre les playbooks plus concis et modulaires, en automatisant des tâches répétitives de manière élégante.