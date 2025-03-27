### **Les Modules `dnf` et `apt` dans Ansible**

Les modules **`dnf`** et **`apt`** dans Ansible sont utilisés pour gérer les paquets logiciels sur les systèmes Linux. Ces modules sont spécifiques aux gestionnaires de paquets utilisés par les distributions Linux : **`dnf`** est utilisé sur les distributions basées sur **Fedora** et **RedHat** (comme CentOS, RHEL 8+), tandis que **`apt`** est utilisé sur les systèmes basés sur **Debian** (comme Ubuntu, Debian).

---

### **1. Module `dnf` (pour les systèmes basés sur RedHat/Fedora/CentOS/RHEL)**

Le module **`dnf`** permet de gérer les paquets à l’aide du gestionnaire de paquets `dnf`, qui est utilisé sur les distributions RedHat et Fedora.

#### **Exemple d’utilisation du module `dnf` :**

```yaml
- name: Installer un paquet avec dnf
  dnf:
    name: httpd
    state: present
```

- **`name`** : Le nom du paquet à installer ou à gérer (par exemple, `httpd`).
- **`state`** : L'état souhaité pour le paquet :
  - **`present`** : Installe le paquet (si ce n’est pas déjà fait).
  - **`absent`** : Supprime le paquet.
  - **`latest`** : Met à jour le paquet vers la dernière version disponible.
  - **`installed`** : Assure que le paquet est installé.

#### **Exemple avec plus de paramètres :**

```yaml
- name: Installer un paquet avec dnf et spécifier une version
  dnf:
    name: httpd-2.4.6
    state: present
    enablerepo: extras
    disable_gpg_check: yes
```

- **`enablerepo`** : Permet d’activer un dépôt spécifique (par exemple `extras`).
- **`disable_gpg_check`** : Permet de désactiver la vérification de la signature GPG pour le paquet.

#### **Autres paramètres :**

- **`update_cache`** : Permet de mettre à jour le cache des paquets (`yes` ou `no`).
- **`install_recommends`** : Définit si les paquets recommandés doivent être installés ou non.
- **`list`** : Liste les paquets installés (utilisé pour vérifier les paquets installés, mais n’affecte pas leur état).

---

### **2. Module `apt` (pour les systèmes basés sur Debian/Ubuntu)**

Le module **`apt`** est utilisé pour gérer les paquets sur les systèmes utilisant le gestionnaire de paquets **`apt`** (par exemple, **Debian**, **Ubuntu**).

#### **Exemple d’utilisation du module `apt` :**

```yaml
- name: Installer un paquet avec apt
  apt:
    name: nginx
    state: present
```

- **`name`** : Le nom du paquet à gérer.
- **`state`** : L'état du paquet :
  - **`present`** : Installe le paquet.
  - **`absent`** : Supprime le paquet.
  - **`latest`** : Met à jour le paquet vers la dernière version.

#### **Exemple avec plus de paramètres :**

```yaml
- name: Installer un paquet avec apt en forçant la mise à jour
  apt:
    name: nginx
    state: latest
    update_cache: yes
```

- **`update_cache`** : Permet de mettre à jour le cache des paquets avant d'installer ou de mettre à jour des paquets (par défaut, il est à `no`).
- **`cache_valid_time`** : Spécifie combien de temps le cache des paquets reste valide, en secondes (par exemple, `3600` secondes ou 1 heure).

#### **Autres paramètres :**

- **`upgrade`** : Met à jour tous les paquets installés (`dist` pour une mise à niveau complète, `yes` pour une mise à niveau de base).
- **`install_recommends`** : Définit si les paquets recommandés doivent être installés (`yes` ou `no`).
- **`force`** : Installe ou met à jour le paquet, même si une version antérieure est déjà installée.

---

### **3. Comparaison entre `dnf` et `apt`**

| Fonctionnalité       | `dnf` (RedHat/Fedora)           | `apt` (Debian/Ubuntu)            |
|----------------------|---------------------------------|----------------------------------|
| **Commande principale** | `dnf`                          | `apt`                           |
| **Paramètre `state`** | `present`, `absent`, `latest`, `installed` | `present`, `absent`, `latest`    |
| **Mise à jour du cache** | `update_cache`                 | `update_cache`                  |
| **Installation de paquets recommandés** | `install_recommends`            | `install_recommends`            |
| **Vérification GPG**  | `disable_gpg_check`            | -                                |

---

### **4. Exemple d’utilisation de `dnf` et `apt` dans un playbook multi-distributions**

Voici un exemple de playbook qui utilise à la fois les modules **`dnf`** et **`apt`** pour gérer l’installation de paquets, en fonction de la distribution de chaque hôte.

```yaml
---
- name: Installer un paquet sur les hôtes basés sur RedHat ou Debian
  hosts: all
  become: yes

  tasks:
    - name: Installer nginx sur les hôtes basés sur RedHat
      dnf:
        name: nginx
        state: present
      when: ansible_facts['os_family'] == 'RedHat'

    - name: Installer nginx sur les hôtes basés sur Debian
      apt:
        name: nginx
        state: present
        update_cache: yes
      when: ansible_facts['os_family'] == 'Debian'
```

- **`ansible_facts['os_family']`** : Permet de récupérer des informations sur la famille du système d'exploitation de chaque hôte (RedHat, Debian, etc.).
- **`when`** : Condition qui exécute la tâche uniquement si la condition est vraie (par exemple, si l'hôte est basé sur RedHat ou Debian).

---

### **5. Conclusion**

Les modules **`dnf`** et **`apt`** sont des outils puissants dans Ansible pour la gestion des paquets logiciels sur des systèmes basés sur **RedHat** et **Debian**, respectivement. Ils permettent de facilement installer, mettre à jour ou supprimer des paquets sur les hôtes distants, en fonction du système d'exploitation sous-jacent. La compréhension et l'utilisation de ces modules dans un playbook permettent d'automatiser la gestion des paquets sur des infrastructures hétérogènes.