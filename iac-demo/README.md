# Progression d'apprentissage IaC

Ces exemples portent sur les groupes de ressources et les comptes de stockage :

1. **Impératif** — `imperative.azcli` crée des ressources via une séquence de commandes ordonnées.
2. **Idempotent** — relancer `idempotent.azcli` montre que le même groupe de ressources est réutilisé.
3. **Déclaratif** — `declarative.bicep` décrit l'état souhaité du compte de stockage.
4. **Avantages** — `benefits.bicep` ajoute des paramètres, de la validation, un nommage déterministe avec `uniqueString(resourceGroup().id)`, ainsi que des sorties (outputs) utiles.
5. **Environnements** — `environments.bicep` réutilise un même modèle avec des réglages dev/test/prod ; `bicep/vars/` fournit les paramètres pour dev et prod.
6. **Modules** — `bicep/main.bicep` crée un groupe de ressources au niveau de l'abonnement et compose le module de stockage à portée groupe de ressources.
7. **Comparaison Terraform** — compare la ressource de stockage équivalente, prévisualise les changements avec `plan`, les applique, et importe un compte existant dans l'état Terraform.
