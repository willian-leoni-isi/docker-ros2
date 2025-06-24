Possuir capacidade de realizar parada emergência quando detectada a existência de obstáculos no percurso do robô, dentro do espaço de trabalho, por meio de sensores de segurança instalados.

Implementar status para overrun de controladores

Implementar trigger para sensores fora de faixa

Gerar alerta em caso de falhas dos sistemas do robô e realizar parada do robô. Exemplos de falhas:
· Registro de logs impossibilitado por problemas de armazenamento
· Falha no controle de velocidade
· Dados dos sensores fora de faixa (integridade dos dados)
· Caso exista sistema de freio ativo independente, efetuar parada de emergência do robô.

Possuir capacidade de disponibilização de dados de operação para um sistema de monitoramento remoto, desenvolvido pela empresa parceira, para registro das seguintes informações coletadas durante as movimentações realizadas pelo robô:
· Status dos sensores (dados e integridade)
· Comandos aplicados aos atuadores
· Posição e orientação
· Distância percorrida

# Diagrama da Arquitetura da Aplicação

```mermaid
%% Direction: Left to Right
graph LR

%% Style Definitions
classDef layer fill:#f9f9f9,stroke:#ddd,stroke-width:2px,rx:10px
classDef sensor fill:#e6f2ff,stroke:#0066cc
classDef process fill:#fff0b3,stroke:#ff9900
classDef safety fill:#ffe6e6,stroke:#cc0000
classDef gateway fill:#e6ffee,stroke:#009933
classDef alert fill:#ffcccc,stroke:#990000,stroke-width:3px,rx:20px
classDef storage fill:#f2e6ff,stroke:#6600cc
classDef actuator fill:#ffd9b3,stroke:#b35900
classDef consumer fill:#d9d9d9,stroke:#333

%% Subgraphs for Layers
subgraph "INPUTS"
    direction LR
    A1["<br>Sensors<br>(IMU, GPS, etc)"]:::sensor
    A2["<br>Safety Sensors<br>(LiDAR, etc)"]:::sensor
    A3["<br>Controller Status<br>"]:::sensor
end

subgraph "LAYER 1: VALIDATION & PROCESSING"
    direction TB
    C1["⚙️<br>EKF Odometry Node"]:::process
    B1["🛡️<br>Safety Monitor"]:::safety
end

subgraph "LAYER 2: BUSINESS LOGIC & ACTION"
    direction TB
    C2["🧠<br>Information Gateway"]:::gateway
    C3["🚨<br>Alert Manager"]:::alert
end

subgraph "LAYER 3: PERSISTENCE & ACTUATION"
    direction TB
    D1["💾<br>Datalogger Node"]:::storage
    A4["🛑<br>Motion Actuator<br>& Brakes"]:::actuator
end

subgraph "OUTPUTS & CONSUMERS"
    direction LR
    A5["<br>Local Storage<br>(DB/Log)"]:::storage
    E1["🖥️<br>Front-end &<br>Remote System"]:::consumer
end


%% Connections
%% Data Flow (Green)
A1 -- Raw Data --> C1
A1 & A2 & A3 -- Raw Data --> B1
C1 -- Filtered Odometry --> B1
B1 -- "Validated Data<br>(/safety/*)" --> C2
C2 -- "Final Telemetry<br>(/telemetry/data)" --> D1
C2 -- "Final Telemetry<br>(/telemetry/data)" --> E1
D1 -- "Writes to" --> A5

%% Faults & Triggers (Red)
linkStyle 6 stroke:red,stroke-width:2px,stroke-dasharray:5 5
linkStyle 7 stroke:red,stroke-width:2px,stroke-dasharray:5 5
B1 -.->|"[ FAULT ]<br>Critical Event"| C3
D1 -.->|"[ FAULT ]<br>Storage Error"| C3

%% Emergency Action (Bold Red)
linkStyle 8 stroke:red,stroke-width:4px
C3 -- "EMERGENCY STOP" --> A4
C3 -- "SYSTEM ALERT" --> E1

%% Assigning classes to nodes
class A1,A2,A3 sensor
class B1 safety
class C1 process
class C2 gateway
class C3 alert
class D1,A5 storage
class A4 actuator
class E1 consumer