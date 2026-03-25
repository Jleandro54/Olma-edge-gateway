# 🚀 Edge Gateway IIoT - Projeto Olma

Este projeto apresenta uma infraestrutura de **Edge Computing** industrial projetada para garantir a resiliência e a persistência de dados no monitoramento da máquina Olma.

## 🛠️ O Problema vs A Solução
Inicialmente, a coleta de dados era realizada de forma remota, o que gerava lacunas nos dashboards devido à latência e instabilidades de rede. 

Para resolver este gargalo, **projetei e implementei** um Edge Gateway local em Linux Debian, trazendo a inteligência para a borda e garantindo 100% de uptime das informações.

## 🏗️ Arquitetura de Infraestrutura (Desenvolvimento Exclusivo)
Como responsável pela camada de infraestrutura e segurança, implementei:
- **Orquestração:** Stack completa via Docker Compose com política de `restart: always`.
- **Resiliência (Self-Healing):** Configuração de BIOS Auto-Power-On para retomada automática pós-falha elétrica.
- **Segurança (Hardening):** USB Lockdown atraves de diretivas de blacklist via Kernel e isolamento de redes (**Dual-Homing**) entre OT e IT.
- **Disaster Recovery (DR):** Script Bash automatizado via ***Cron*** para backup 'Cold Standby' e sincronização segura via SSH/SCP.
- **Proxy Reverso:** Nginx para gestão de acesso aos serviços.

## 📊 Camada de Dados (Desenvolvimento Conjunto)
Em colaboração com **Jhonata Soares**, desenvolvemos:
- Lógica de coleta no **Node-RED**.
- Persistência em **MySQL** e **InfluxDB**.
- Visualização de dados em tempo real no **Grafana**.

---
*Projeto desenvolvido como parte da transição entre Mecatrônica e Análise e Desenvolvimento de Sistemas (ADS).*
*Projeto desenvolvido através da **sinergia técnica** entre a Mecatrônica Industrial e a Análise e Desenvolvimento de Sistemas (ADS).*