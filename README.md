# Módulo 3 - Fundamentos de Bases de Datos Relacionales
## Proyecto Nova Wallet 💼💰
¡Bienvenido al repositorio Nova Wallet MySQL DB! En este proyecto, he creado una base de datos
relacional para una wallet virtual, diseñada para que los usuarios gestionen sus fondos de 
manera eficiente y segura. Además, he adjuntado una imagen del modelo entidad-relación para
que puedas visualizar la estructura de la base de datos con mayor claridad.

## Funcionalidades 🚀
- Gestión de Usuarios: Permite registrar usuarios con información como nombre, correo electrónico,
  contraseña y saldo.
- Transacciones Financieras: Permite a los usuarios realizar transacciones entre sí, con importes
  específicos y fechas de transacción registradas.
- Monedas Soportadas: La wallet admite diferentes monedas, cada usuario y cada transacción están
  asociados a una divisa específica, solo se pueden generar transacciones entre usuarios con la
  misma divisa.
- Consultas SQL Incluidas: Hemos implementado consultas SQL para obtener información relevante,
  como el nombre de la moneda elegida por un usuario, todas las transacciones registradas,
  transacciones realizadas por un usuario específico y más.
- Archivo SQL Adjunto: Todas las sentencias SQL necesarias para crear las entidades y manipular
  los datos están incluidas en el archivo nova-wallet.sql
- Modelo entidad-relación: He incluido una imagen con el modelo entidad-relación para un
  mejor entendimiento de la estructura de la db.

## Validaciones 🔍
- [x] Diseñar una Bases de Datos que garantice la coherencia y la integridad de los datos
- [x] Crear una conexión a una Bases de Datos llamada Alke Wallet
- [x] Crear Entidadades:
  - [x] user (PK u_id, u_name, u_lastname, u_email, u_password, u_balance, FK u_currency_id, u_role, u_creation_date)
  - [x] transaction (PK t_id, FK t_sender_id, FK t_receiver_id, FK t_currency_id, t_amount, t_type, t_date)
  - [x] currency (PK c_id, c_name, c_symbol)
- [x] Crear consultas SQL para
  - [x] Obtener el nombre de la moneda elegida por un usuario específico
  - [x] Obtener todas las transacciones registradas
  - [x] Obtener todas las transacciones realizadas por un usuario específico
  - [x] Modificar el campo correo electrónico de un usuario específico
  - [x] Eliminar los datos de una transacción (fila completa)
- [x] Asegurar que el diseño de la base de datos cumpla con los principios ACID y
      garantice la coherencia e integridad de los datos.
     
## Requerimientos técnicos 🛠️
- [x] Utilizar MySQL como Sistema de Gestión de Bases de Datos Relacionales (RDBMS)
- [x] Implementar sentencias SQL para crear la tablas y sus entidades
- [x] Implementar la Integridad referencial utilizando claves primarias y claves externas
- [x] Utilizar DDL para la definición de Tablas
- [x] Utilizar DML para recuperar, modificar, insertar y borrar datos dentro de una base de datos.

---
Este repositorio forma parte del proyecto final del Bootcamp de Desarrollo Fullstack JAVA.

*Desarrollado por ©Sara Rioseco 2024*
