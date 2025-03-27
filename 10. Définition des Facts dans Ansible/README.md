### **Définition des Facts dans Ansible**

Les **facts** dans Ansible sont des informations dynamiques collectées automatiquement à partir des hôtes cibles (les machines sur lesquelles vous appliquez les playbooks). Ces informations couvrent une grande variété de détails système, tels que des informations sur l'OS, le matériel, les réseaux, les utilisateurs, etc.

Les facts sont des variables **prêtes à l'emploi** qui peuvent être utilisées dans les playbooks pour ajuster les actions en fonction de l'état actuel des systèmes. Par exemple, vous pouvez utiliser un fact pour déterminer si un hôte est sous Linux ou Windows, ou vérifier combien de mémoire est disponible avant d'installer un logiciel.

### **Types de Facts**
Les facts collectés couvrent plusieurs aspects du système, dont :
- **Système d'exploitation** : informations sur la distribution, la version, et le nom de l'OS.
- **Matériel** : détails sur le processeur, la mémoire RAM, et les disques.
- **Réseau** : adresses IP, interfaces réseau, et configurations liées au réseau.
- **Utilisateurs et groupes** : informations sur les utilisateurs et les groupes présents sur l'hôte.
- **Informations sur les interfaces** : comme les adresses MAC, les ports réseau, etc.

### **Exemples de Facts**
Voici quelques exemples de facts couramment collectés par Ansible :

- **`ansible_hostname`** : Le nom de l'hôte.
- **`ansible_fqdn`** : Le nom de domaine complet (FQDN).
- **`ansible_distribution`** : La distribution de l'OS (ex. Ubuntu, CentOS).
- **`ansible_memtotal_mb`** : La quantité totale de mémoire en Mo.
- **`ansible_processor_cores`** : Le nombre de cœurs du processeur.
- **`ansible_interfaces`** : Les interfaces réseau sur l'hôte.
- **`ansible_ip_addresses`** : Les adresses IP de l'hôte.
- **`ansible_os_family`** : La famille de l'OS (par exemple, Linux, Windows).

### **Collecte des Facts dans Ansible**

#### Collecte Automatique
Par défaut, Ansible collecte des facts automatiquement lors de l'exécution d'un playbook. Cette collecte se fait via le module **`setup`** qui récupère une large gamme d'informations sur l'hôte. Ces facts sont ensuite stockés dans des variables d'Ansible que vous pouvez utiliser dans vos playbooks.

#### Exemple de collecte automatique :
Lorsque vous exécutez un playbook, les facts sont récupérés automatiquement, et vous pouvez les utiliser avec une tâche comme `debug` pour les afficher :

```yaml
---
- name: Collecter et afficher les facts
  hosts: all
  tasks:
    - name: Afficher tous les facts collectés
      debug:
        var: ansible_facts
```

### **Collecte Manuelle avec le Module `setup`**

Vous pouvez également collecter manuellement les facts à l'aide du module `setup`. Voici un exemple d'utilisation dans un playbook :

```yaml
---
- name: Collecter des facts avec setup
  hosts: all
  tasks:
    - name: Collecter tous les facts
      setup:
```

Si vous souhaitez limiter la collecte à des facts spécifiques, vous pouvez utiliser un filtre. Par exemple, pour ne récupérer que les informations réseau :

```yaml
---
- name: Collecter uniquement des facts réseau
  hosts: all
  tasks:
    - name: Collecter des facts réseau
      setup:
        filter: "ansible_*.network*"
```

### **Utilisation des Facts dans un Playbook**

Une fois les facts collectés, vous pouvez les utiliser dans vos tâches pour prendre des décisions ou personnaliser l'exécution des tâches en fonction de l'état du système cible.

#### Exemple : Utiliser les Facts pour vérifier l'OS

Supposons que vous souhaitez exécuter une tâche uniquement si l'OS cible est Ubuntu :

```yaml
---
- name: Exécuter une tâche sur Ubuntu seulement
  hosts: all
  tasks:
    - name: Vérifier si l'hôte est Ubuntu
      debug:
        msg: "Cet hôte est sous Ubuntu"
      when: ansible_distribution == "Ubuntu"
```

#### Exemple : Vérifier la mémoire avant d'installer un logiciel

```yaml
---
- name: Installer un paquet si la mémoire est suffisante
  hosts: all
  tasks:
    - name: Vérifier la mémoire
      debug:
        msg: "Suffisamment de mémoire pour installer le paquet."
      when: ansible_memtotal_mb > 1024
```

### **Désactivation de la Collecte Automatique des Facts**

Si vous préférez ne pas collecter les facts automatiquement à chaque exécution, vous pouvez désactiver cette collecte dans le fichier de configuration `ansible.cfg` :

```ini
[defaults]
gathering = explicit
```

Avec cette configuration, vous devrez utiliser explicitement le module `setup` pour collecter les facts.

### **Avantages de l'Utilisation des Facts**

- **Personnalisation** : Vous pouvez ajuster le comportement des playbooks en fonction des caractéristiques de chaque hôte (par exemple, un système avec 4 Go de RAM aura peut-être besoin de configurations différentes d'un autre avec 8 Go).
- **Optimisation** : Vous pouvez éviter des erreurs ou des configurations inappropriées en vérifiant les caractéristiques du système avant d'effectuer des actions.
- **Maintenance** : Les facts permettent de diagnostiquer rapidement des problèmes en fournissant des informations complètes sur l'hôte.

### **Résumé**

Les **facts** dans Ansible sont des informations cruciales pour la gestion des hôtes cibles. Ils vous permettent de prendre des décisions dynamiques dans vos playbooks en fonction des caractéristiques système des hôtes. Les facts sont collectés automatiquement, mais peuvent aussi être récupérés manuellement à l'aide du module `setup`. L'utilisation des facts aide à personnaliser les configurations et à automatiser efficacement les tâches sur des systèmes hétérogènes.