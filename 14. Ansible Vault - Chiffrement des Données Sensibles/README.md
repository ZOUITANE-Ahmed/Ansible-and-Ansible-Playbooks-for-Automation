# **Ansible Vault : Chiffrement des Données Sensibles**

## **📌 Introduction**
Ansible Vault est un outil intégré à Ansible permettant de **chiffrer et protéger des données sensibles** (mots de passe, clés SSH, identifiants, variables sensibles…). Cela permet d'éviter d'exposer ces informations dans des fichiers en clair.

Avec **Ansible Vault**, tu peux :
✅ Chiffrer des fichiers YAML contenant des variables.  
✅ Chiffrer des parties spécifiques d'un fichier.  
✅ Déchiffrer les fichiers pour les modifier.  
✅ Fournir un mot de passe pour exécuter un playbook utilisant des fichiers chiffrés.

---

## **🔑 1. Création d'un Fichier Chiffré**
Tu peux créer un fichier sécurisé directement avec la commande :

```bash
ansible-vault create secret.yml
```

1️⃣ Ansible demande un **mot de passe** pour chiffrer le fichier.  
2️⃣ Une fois saisi, un éditeur de texte s’ouvre pour écrire les données.  
3️⃣ Après enregistrement, le fichier sera entièrement chiffré.

**Exemple de fichier `secret.yml` (chiffré) :**
```yaml
$ANSIBLE_VAULT;1.1;AES256
61316339646562346533353032386430353331633234616638316237336132393432323531326331...
```

---

## **🔍 2. Chiffrer un Fichier Existant**
Si tu as déjà un fichier YAML contenant des informations sensibles, tu peux le chiffrer avec :

```bash
ansible-vault encrypt vars.yml
```

Après cette commande, le fichier sera converti en une version chiffrée.

---

## **🔓 3. Déchiffrer un Fichier**
Si tu veux modifier ou voir un fichier chiffré, tu peux soit :
- **Le déchiffrer temporairement** (sans le modifier) :

  ```bash
  ansible-vault view secret.yml
  ```

- **Le déchiffrer complètement** (pour le repasser en clair) :

  ```bash
  ansible-vault decrypt secret.yml
  ```

---

## **✍️ 4. Modifier un Fichier Chiffré**
Si tu veux modifier un fichier sans le déchiffrer manuellement, utilise :

```bash
ansible-vault edit secret.yml
```

Cela ouvre l’éditeur de texte tout en gardant le fichier sécurisé après modification.

---

## **🔄 5. Changer le Mot de Passe**
Si tu veux **changer le mot de passe** d’un fichier Vault, utilise :

```bash
ansible-vault rekey secret.yml
```

Tu devras entrer l’ancien mot de passe, puis saisir un nouveau.

---

## **🛠️ 6. Utiliser un Fichier Chiffré dans un Playbook**
Les fichiers Vault sont souvent utilisés pour **stocker des variables sensibles**.

Exemple de fichier `secret.yml` chiffré :
```yaml
db_password: "super_secret_password"
```

Dans le playbook `playbook.yml` :
```yaml
---
- name: Déployer une application
  hosts: all
  vars_files:
    - secret.yml
  tasks:
    - name: Afficher le mot de passe
      debug:
        msg: "Le mot de passe est {{ db_password }}"
```

📌 Pour exécuter un playbook contenant un fichier chiffré, utilise l’option **`--ask-vault-pass`** :
```bash
ansible-playbook playbook.yml --ask-vault-pass
```
👉 Ansible te demandera alors le mot de passe avant d’exécuter le playbook.

---

## **🔑 7. Utiliser un Fichier de Mot de Passe**
Si tu ne veux pas entrer le mot de passe à chaque fois, crée un fichier contenant le mot de passe :

1️⃣ Crée un fichier texte (ex: `vault_pass.txt`) :
```bash
echo "monmotdepasse" > vault_pass.txt
```

2️⃣ Exécute le playbook avec :
```bash
ansible-playbook playbook.yml --vault-password-file vault_pass.txt
```

⚠️ **Sécurité** : Assure-toi que ce fichier **ne soit pas exposé** en le plaçant dans `.gitignore` pour éviter qu’il soit versionné.

---

## **📌 8. Chiffrement Partiel d’un Fichier**
Tu peux chiffrer **uniquement certaines parties** d’un fichier en utilisant :

```bash
ansible-vault encrypt_string 'mon_mot_de_passe' --name 'db_password'
```

Cela affiche :
```yaml
db_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          356132383835366231396338653538623730633032356234653533643637396661
```

Tu peux directement copier/coller cette sortie dans un fichier de variables.

---

## **🎯 Conclusion**
✅ **Ansible Vault** est essentiel pour la sécurité en automatisation.  
✅ Il permet de **chiffrer les données sensibles** dans les playbooks.  
✅ Son usage est simple avec des commandes comme `encrypt`, `decrypt`, `edit` et `view`.  
