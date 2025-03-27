### **Les Conditions dans Ansible**

Dans Ansible, les **conditions** permettent d’exécuter une tâche uniquement si un critère spécifique est rempli. Cela permet d’économiser du temps et des ressources en évitant d’exécuter des tâches inutiles sur certains hôtes.

Les conditions sont définies à l’aide du mot-clé **`when`**. Elles peuvent être utilisées avec des variables, des faits système (**facts**), des résultats de tâches précédentes, ou encore des expressions logiques.

---

## **1. Syntaxe de base de `when`**

L’utilisation la plus simple de `when` consiste à tester une condition sur une variable ou un fait système.

```yaml
---
- name: Exécution conditionnelle d'une tâche
  hosts: all
  tasks:
    - name: Créer un fichier si l'hôte est sous Linux
      file:
        path: /tmp/linux_only.txt
        state: touch
      when: ansible_system == "Linux"
```

### **Explication** :
- La condition `ansible_system == "Linux"` signifie que la tâche ne sera exécutée que si le système d'exploitation est **Linux**.
- `ansible_system` est un **fact** recueilli automatiquement par Ansible.

---

## **2. Conditions avec Variables**

On peut utiliser des **variables définies** dans le playbook ou fournies via `vars` ou `extra-vars`.

```yaml
---
- name: Exécution d'une tâche en fonction d'une variable
  hosts: all
  vars:
    install_apache: true
  tasks:
    - name: Installer Apache si la variable est à true
      package:
        name: apache2
        state: present
      when: install_apache
```

### **Explication** :
- Si `install_apache` est **true**, Ansible installe Apache.
- Sinon, la tâche est ignorée.

---

## **3. Utilisation de Plusieurs Conditions (`and`, `or`, `not`)**

Vous pouvez combiner plusieurs conditions avec **`and`**, **`or`** et **`not`**.

```yaml
---
- name: Installer un paquet uniquement si les conditions sont remplies
  hosts: all
  tasks:
    - name: Installer Vim si l'OS est Linux et que la mémoire > 1 Go
      package:
        name: vim
        state: present
      when: ansible_system == "Linux" and ansible_memtotal_mb > 1024
```

### **Explication** :
- Cette tâche ne sera exécutée que si :
  - Le système est **Linux**.
  - La mémoire totale est **supérieure à 1024 Mo**.

Autre exemple avec **`or`** :

```yaml
- name: Supprimer un utilisateur si l'OS est Windows ou macOS
  hosts: all
  tasks:
    - name: Supprimer l’utilisateur 'testuser'
      user:
        name: testuser
        state: absent
      when: ansible_system == "Windows" or ansible_system == "Darwin"
```

### **Explication** :
- L’utilisateur `testuser` sera supprimé si l’OS est soit **Windows**, soit **macOS** (Darwin est le nom du noyau macOS).

---

## **4. Conditions sur une Liste de Valeurs (`in`)**

Si vous voulez vérifier si une valeur appartient à une liste, utilisez **`in`**.

```yaml
---
- name: Exécuter une tâche pour certains systèmes d'exploitation
  hosts: all
  tasks:
    - name: Afficher un message si l'OS est Linux ou macOS
      debug:
        msg: "Cet hôte est pris en charge"
      when: ansible_system in ["Linux", "Darwin"]
```

### **Explication** :
- La tâche s’exécute si le système est **Linux** ou **macOS**.

---

## **5. Conditions avec des Résultats de Tâches Précédentes**

On peut stocker le résultat d’une tâche précédente avec `register` et l’utiliser dans une condition.

```yaml
---
- name: Vérifier et créer un fichier s'il n'existe pas
  hosts: all
  tasks:
    - name: Vérifier si le fichier existe
      stat:
        path: /tmp/testfile.txt
      register: file_stat

    - name: Créer le fichier si inexistant
      file:
        path: /tmp/testfile.txt
        state: touch
      when: not file_stat.stat.exists
```

### **Explication** :
- **`stat`** vérifie si `/tmp/testfile.txt` existe et stocke le résultat dans `file_stat`.
- **`when: not file_stat.stat.exists`** assure que la création ne se fait que si le fichier **n’existe pas**.

---

## **6. Conditions dans une Boucle**

On peut appliquer `when` à chaque élément d’une boucle.

```yaml
---
- name: Installer uniquement les paquets nécessaires
  hosts: all
  tasks:
    - name: Installer des paquets en fonction de l'OS
      package:
        name: "{{ item }}"
        state: present
      loop:
        - vim
        - apache2
        - nginx
      when: (ansible_system == "Linux" and item != "apache2") or (ansible_system == "Windows" and item == "apache2")
```

### **Explication** :
- Sur **Linux**, tous les paquets sont installés sauf `apache2`.
- Sur **Windows**, seul `apache2` est installé.

---

## **7. Conditions avec des Valeurs par Défaut (`default()`)**

Si une variable n'est pas définie, cela peut provoquer une erreur. On peut éviter cela avec **`default()`**.

```yaml
---
- name: Vérifier une variable et utiliser une valeur par défaut
  hosts: all
  tasks:
    - name: Afficher un message si le mode est actif
      debug:
        msg: "Mode activé"
      when: mode|default("off") == "on"
```

### **Explication** :
- Si `mode` n’est pas défini, `default("off")` évite une erreur et prend `"off"` par défaut.

---

## **Résumé des Principaux Concepts**
| Condition | Explication |
|-----------|------------|
| `when: ansible_system == "Linux"` | Exécute la tâche si l’OS est Linux. |
| `when: var1 and var2` | Exécute la tâche si `var1` et `var2` sont vrais (`AND`). |
| `when: var1 or var2` | Exécute la tâche si `var1` ou `var2` est vrai (`OR`). |
| `when: not var1` | Exécute la tâche si `var1` est faux (`NOT`). |
| `when: item in ["Linux", "Darwin"]` | Exécute la tâche si `item` est dans la liste. |
| `when: result.stat.exists` | Vérifie si un fichier existe (`stat`). |
| `when: var | default("off") == "on"` | Définit une valeur par défaut pour `var`. |

---

## **Conclusion**
Les **conditions** sont un élément puissant dans Ansible permettant une exécution flexible et intelligente des tâches. Elles évitent les erreurs et optimisent l'automatisation en ne lançant des commandes que lorsque c'est nécessaire.