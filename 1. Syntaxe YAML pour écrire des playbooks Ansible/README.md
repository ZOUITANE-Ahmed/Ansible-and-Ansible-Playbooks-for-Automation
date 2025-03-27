### **Syntaxe YAML pour écrire des playbooks Ansible**  

#### **1. Introduction à YAML**  
YAML (**YAML Ain’t Markup Language**) est un format de fichier lisible par l’humain, utilisé par Ansible pour définir les **playbooks**. Il repose sur une structure **hiérarchique** et utilise l'**indentation** pour organiser les données.  

✅ **Pourquoi YAML pour Ansible ?**  
- Facile à lire et écrire.  
- Basé sur une hiérarchie claire (pas de balises comme en XML).  
- Utilisé pour structurer les tâches et les configurations d'Ansible.  

---

#### **2. Structure de base d’un playbook Ansible**  
Un **playbook** est une liste d’instructions écrites en YAML et exécutées sur un ou plusieurs serveurs.  

📌 **Exemple simple :**  
```yaml
- name: Exemple de playbook
  hosts: all
  become: yes
  tasks:
    - name: Créer un fichier
      file:
        path: /tmp/fichier.txt
        state: touch
```
🔍 **Explication des éléments clés :**  
- `- name:` → Nom du playbook ou des tâches (optionnel mais recommandé).  
- `hosts:` → Liste des machines cibles définies dans l’inventaire.  
- `become: yes` → Exécute les commandes avec les privilèges administrateurs (`sudo`).  
- `tasks:` → Liste des actions à exécuter.  
- `file:` → Module utilisé pour manipuler les fichiers.  
- `path:` → Spécifie le chemin du fichier à créer.  
- `state: touch` → Assure que le fichier existe (le crée s’il n’existe pas).  

---

#### **3. Principes fondamentaux de YAML**  

📌 **1. Indentation**  
L'**indentation** est essentielle en YAML. Elle doit être **constante** et utiliser **des espaces** (pas de tabulations).  
```yaml
tasks:
  - name: Première tâche
    command: echo "Hello, World!"
  - name: Deuxième tâche
    command: date
```
⚠ **Erreur fréquente :**  
❌ Mauvaise indentation (mélange de tabulations et d’espaces)  
```yaml
tasks:
  - name: Mauvaise indentation
	  command: echo "Erreur"
```
✔ **Correction :**  
```yaml
tasks:
  - name: Bonne indentation
    command: echo "Correct"
```

📌 **2. Clés et valeurs**  
Les données sont structurées sous forme de **clé: valeur**.  
```yaml
nom: "Serveur Web"
version: 1.0
actif: true
```

📌 **3. Listes (séquences)**  
Les listes sont définies avec un tiret (`-`).  
```yaml
serveurs:
  - web1
  - web2
  - web3
```
✔ **Exemple avec un playbook :**  
```yaml
tasks:
  - name: Créer plusieurs fichiers
    file:
      path: "{{ item }}"
      state: touch
    loop:
      - /tmp/fichier1.txt
      - /tmp/fichier2.txt
      - /tmp/fichier3.txt
```

📌 **4. Dictionnaires (associations clé-valeur)**  
On peut regrouper plusieurs valeurs sous une même clé.  
```yaml
utilisateur:
  nom: "admin"
  uid: 1001
  shell: "/bin/bash"
```

📌 **5. Valeurs booléennes**  
YAML accepte plusieurs façons d’écrire `true` et `false`.  
```yaml
actif: yes   # Équivalent à 'true'
debug: no    # Équivalent à 'false'
```

---

#### **4. Bonnes pratiques avec YAML dans Ansible**  
✅ Toujours utiliser **2 espaces** pour l’indentation.  
✅ Éviter les tabulations (`TAB` est interdit en YAML).  
✅ Toujours entourer les chaînes de caractères contenant des caractères spéciaux avec `"` ou `'`.  
✅ Vérifier la syntaxe avec :  
```sh
ansible-playbook playbook.yml --syntax-check
```

---

💡 **Conclusion**  
YAML est un langage simple mais structuré qui permet d’écrire des playbooks clairs et lisibles. Une bonne maîtrise de sa syntaxe est essentielle pour automatiser efficacement les tâches avec Ansible.  
