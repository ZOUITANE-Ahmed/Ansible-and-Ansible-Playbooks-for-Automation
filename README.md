### **Les étapes d’apprentissage d’Ansible, de débutant à expert**  

![Ansible Linux](image/ansible-linux.jpg)

## **🔹 Niveau 1 : Débutant (Fondations d’Ansible)**  
### **Comprendre les bases d’Ansible**  
- **Qu’est-ce qu’Ansible ?** Pourquoi l’utiliser ?  
- **Architecture d’Ansible** (nœud de contrôle, nœuds gérés, inventaire, playbooks)  
- **Comment fonctionne Ansible ?** (Sans agent, automatisation basée sur push)  

### **Installation et configuration**  
- Installer **Ansible** sur **Red Hat, Debian, macOS**  
- Configurer l’authentification SSH sans mot de passe  
- Créer un **fichier d’inventaire** et tester la connectivité :  
  ```bash
  ansible all -m ping
  ```

---

## **🔹 Niveau 2 : Intermédiaire (Automatisation et Playbooks)**  
### **Écriture et exécution de Playbooks**  
- **Syntaxe YAML** pour écrire des playbooks  
- Utilisation des **modules Ansible** (`file`, `service`, `package`, `user`, `command`, etc.)  
- Définition des **variables & facts** (`vars`, `vars_files`, `ansible_facts`)  
- Utilisation des **handlers** (actions déclenchées en cas de changement)  
- **Modèles Jinja2** pour générer des fichiers dynamiques  

### **Organisation avec les rôles**  
- Création et utilisation des **rôles** (`ansible-galaxy init`)  
- Structuration de projets Ansible à grande échelle  

---

## **🔹 Niveau 3 : Avancé (Optimisation et Bonnes Pratiques)**  
### **Optimisation des Playbooks**  
- Utilisation des **conditions et boucles**  
- Gestion des erreurs avec `ignore_errors` et `failed_when`  
- Filtrage avec **tags** pour exécuter des parties spécifiques  
- **Chiffrement avec Ansible Vault** pour sécuriser les données sensibles  
- Gestion des **inventaires dynamiques** pour les environnements cloud  

### **Personnalisation et extensions**  
- Création de **modules Ansible personnalisés** en Python  
- Développement de **plugins Ansible**  
- Utilisation des **Lookup Plugins et filtres Jinja2**  