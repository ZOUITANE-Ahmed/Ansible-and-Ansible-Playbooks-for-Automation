### **Commandes Ansible essentielles**  

Ansible propose plusieurs commandes pour interagir avec l'infrastructure, exécuter des tâches et gérer les configurations. Voici une liste des commandes les plus importantes avec des exemples concrets.  

---

## **1. Tester la connectivité avec les hôtes**  
📌 **Commande :**  
```sh
ansible all -m ping
```
✅ Vérifie si Ansible peut se connecter aux machines cibles via SSH.  

📌 **Exemple de sortie :**  
```yaml
webserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
💡 **Astuce** : Remplace `all` par un groupe d'hôtes défini dans l'inventaire, ex. `ansible webservers -m ping`.  

---

## **2. Exécuter des commandes sur les hôtes distants**  
📌 **Commande :**  
```sh
ansible all -m command -a "uptime"
```
✅ Exécute la commande `uptime` sur tous les hôtes définis dans l’inventaire.  

📌 **Autres exemples :**  
```sh
ansible webservers -m command -a "df -h"    # Vérifier l'espace disque
ansible database -m command -a "systemctl restart mysql"  # Redémarrer MySQL
```
💡 **Limitation** : `command` ne prend pas en charge la redirection (`>`, `|`, `&&`). Utilise `shell` à la place :  
```sh
ansible all -m shell -a "echo Hello > /tmp/test.txt"
```

---

## **3. Copier un fichier sur un serveur**  
📌 **Commande :**  
```sh
ansible all -m copy -a "src=/etc/hosts dest=/tmp/hosts mode=0644"
```
✅ Copie le fichier `/etc/hosts` local vers `/tmp/hosts` sur les machines distantes.  

📌 **Paramètres utiles :**  
- `src=` → Fichier source local.  
- `dest=` → Emplacement sur la machine distante.  
- `mode=` → Définit les permissions (ex. `0644`).  

---

## **4. Gérer les packages avec Ansible**  
📌 **Installer un package :**  
```sh
ansible all -m apt -a "name=vim state=present"  # Pour Debian/Ubuntu
ansible all -m yum -a "name=vim state=present"  # Pour CentOS/RHEL
```
📌 **Désinstaller un package :**  
```sh
ansible all -m apt -a "name=vim state=absent"
```
📌 **Mettre à jour tous les packages :**  
```sh
ansible all -m apt -a "update_cache=yes upgrade=yes"
```
💡 **Astuce** : Utiliser `become=yes` pour exécuter la commande avec sudo.  
```sh
ansible all -b -m apt -a "name=nginx state=latest"
```

---

## **5. Gérer les services**  
📌 **Démarrer un service :**  
```sh
ansible all -m service -a "name=apache2 state=started"
```
📌 **Arrêter un service :**  
```sh
ansible all -m service -a "name=apache2 state=stopped"
```
📌 **Redémarrer un service :**  
```sh
ansible all -m service -a "name=apache2 state=restarted"
```
📌 **Vérifier le statut d’un service :**  
```sh
ansible all -m service -a "name=apache2 state=enabled"
```
💡 **Remarque** : Pour `systemd`, utilise `systemctl`:  
```sh
ansible all -m systemd -a "name=nginx state=restarted"
```

---

## **6. Créer des utilisateurs**  
📌 **Commande :**  
```sh
ansible all -m user -a "name=devops password={{ 'mypassword' | password_hash('sha512') }} state=present"
```
✅ Crée un utilisateur `devops` avec un mot de passe sécurisé.  

📌 **Autres options :**  
- `name=` → Nom de l’utilisateur.  
- `password=` → Mot de passe (haché).  
- `state=absent` → Supprime l'utilisateur.  

---

## **7. Exécuter un playbook**  
📌 **Commande :**  
```sh
ansible-playbook site.yml
```
✅ Exécute le playbook `site.yml`.  

📌 **Autres options utiles :**  
- `--syntax-check` → Vérifie la syntaxe du playbook.  
- `--list-tasks` → Affiche la liste des tâches du playbook.  
- `--limit "webservers"` → Exécute uniquement sur les serveurs du groupe `webservers`.  
- `--tags "install"` → Exécute uniquement les tâches avec le tag `install`.  

---

## **8. Afficher les variables d’un hôte**  
📌 **Commande :**  
```sh
ansible all -m setup
```
✅ Affiche toutes les variables système et facts d’un hôte.  

📌 **Exemple pour une variable spécifique :**  
```sh
ansible all -m setup -a "filter=ansible_distribution"
```
💡 **Astuce** : Très utile pour récupérer des informations sur le système cible !  

---

## **9. Vérifier l’inventaire**  
📌 **Commande :**  
```sh
ansible-inventory --list -y
```
✅ Affiche la structure de l’inventaire en YAML.  

📌 **Lister les hôtes d’un groupe :**  
```sh
ansible webservers --list-hosts
```

---

### **💡 Conclusion**  
Ces commandes Ansible permettent d'automatiser efficacement la gestion des serveurs. Elles couvrent les actions essentielles comme la connexion, l’exécution de commandes, la gestion des fichiers, des services et des utilisateurs.