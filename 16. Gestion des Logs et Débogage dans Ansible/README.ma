# **📌 Gestion des Logs et Débogage dans Ansible**

La gestion des logs et le débogage sont **essentiels** pour comprendre le comportement des playbooks Ansible et résoudre les éventuels problèmes.  
Ansible offre plusieurs outils et méthodes pour **suivre l'exécution des tâches**, **capturer les erreurs** et **afficher des informations détaillées** sur les processus.

---

## **🔹 1. Activer le mode verbeux (-v, -vv, -vvv, -vvvv)**
Ansible permet d’augmenter le niveau de détail des logs en ajoutant l’option `-v` lors de l’exécution d’un playbook :

| Option | Niveau de détail |
|--------|----------------|
| `-v`   | Affiche des informations générales sur l’exécution. |
| `-vv`  | Affiche plus de détails sur les tâches exécutées. |
| `-vvv` | Affiche les détails des connexions SSH et des modules. |
| `-vvvv`| Affiche des informations très détaillées, y compris le débogage des requêtes JSON. |

**Exemple :**
```bash
ansible-playbook mon_playbook.yml -vvv
```
Cela permet de voir **les commandes exécutées, leurs sorties, et les erreurs éventuelles**.

---

## **🔹 2. Activer la journalisation (Logging)**
Ansible permet d’enregistrer l’exécution des playbooks dans un fichier de log en utilisant la variable `ANSIBLE_LOG_PATH`.

**Méthode 1 : Définition dans l’environnement**
```bash
export ANSIBLE_LOG_PATH=/var/log/ansible.log
ansible-playbook mon_playbook.yml
```

**Méthode 2 : Configuration dans `ansible.cfg`**
Ajoutez cette ligne dans le fichier `ansible.cfg` :
```ini
[defaults]
log_path = /var/log/ansible.log
```
📌 **Attention** : Assurez-vous que l'utilisateur a les permissions d'écriture sur ce fichier.

---

## **🔹 3. Utilisation du module `debug`**
Le module `debug` permet d'afficher des informations spécifiques pendant l’exécution d’un playbook.

### **📌 Exemple : Affichage d’une variable**
```yaml
- name: Afficher la valeur d'une variable
  debug:
    msg: "L'adresse IP du serveur est {{ ansible_default_ipv4.address }}"
```

### **📌 Exemple : Affichage d’un dictionnaire complet**
```yaml
- name: Afficher toutes les variables disponibles
  debug:
    var: ansible_facts
```
Cela **imprime toutes les facts** collectées par Ansible, ce qui est utile pour le diagnostic.

---

## **🔹 4. Gestion des erreurs avec `ignore_errors` et `failed_when`**
### **📌 `ignore_errors` : Continuer l’exécution même en cas d’erreur**
Par défaut, une erreur arrête l’exécution du playbook. Si vous souhaitez **ignorer une erreur**, utilisez `ignore_errors: yes`.

```yaml
- name: Essayer d’arrêter un service (même s’il n’existe pas)
  service:
    name: apache2
    state: stopped
  ignore_errors: yes
```

📌 **Attention** : Cela **ne signifie pas que l’erreur est corrigée**, elle est juste ignorée.

### **📌 `failed_when` : Personnaliser la gestion des échecs**
Si une commande réussit mais que **vous considérez son résultat comme un échec**, vous pouvez utiliser `failed_when`.

```yaml
- name: Vérifier l'espace disque
  shell: df -h / | awk 'NR==2 {print $5}' | tr -d '%'
  register: disk_usage
  failed_when: disk_usage.stdout | int > 90
```
📌 **Explication** :
- Cette tâche exécute `df -h` pour récupérer l’espace disque utilisé.
- Si l’espace utilisé dépasse **90%**, Ansible considère cela comme un échec.

---

## **🔹 5. Capture de sortie avec `register`**
Le mot-clé `register` permet de **stocker la sortie d’une commande** pour une utilisation ultérieure.

### **📌 Exemple : Enregistrer la sortie d'une commande**
```yaml
- name: Vérifier la version d’Apache
  shell: apache2 -v
  register: apache_version

- name: Afficher la sortie
  debug:
    var: apache_version.stdout
```
Cela affiche la version d’Apache.

---

## **🔹 6. Utiliser `ANSIBLE_DEBUG` pour voir les erreurs détaillées**
Si Ansible ne donne pas assez de détails sur une erreur, vous pouvez activer le mode `debug` globalement :

```bash
export ANSIBLE_DEBUG=True
ansible-playbook mon_playbook.yml
```
Cela affichera **les traces complètes** en cas d’erreur.

---

## **🔹 7. Désactiver les messages de dépréciation**
Si vous voyez trop de **warnings** (avertissements) inutiles, vous pouvez les désactiver en ajoutant cette ligne dans `ansible.cfg` :

```ini
[defaults]
deprecation_warnings = False
```

---

## **🎯 Conclusion**
✅ **Le mode verbeux** (`-v`, `-vv`, `-vvv`, `-vvvv`) permet de voir plus de détails sur l’exécution.  
✅ **Les logs** peuvent être activés en définissant `ANSIBLE_LOG_PATH`.  
✅ **Le module `debug`** permet d’afficher des messages et des variables.  
✅ **`ignore_errors` et `failed_when`** permettent de mieux gérer les erreurs.  
✅ **`register`** est utile pour capturer et analyser les sorties de commande.  
