## Pruebas de API con Thunder Client

Este proyecto utiliza la extensión **Thunder Client** para Visual Studio Code para las pruebas de integración y validación de endpoints. A continuación, se detalla la configuración y los puntos de acceso disponibles.

---

### Endpoints Documentados (Pedidos API)

A continuación se detallan las pruebas realizadas con **Thunder Client** para la gestión de pedidos. La URL base utilizada es: `http://localhost:3001/api/v1/pedidos`.

| Método | Endpoint | Descripción |
| :--- | :--- | :--- |
| `GET` | `/` | Listar todos los pedidos |
| `GET` | `?nombre=Juan...` | Filtrar pedidos por nombre de cliente |
| `GET` | `?pagado=NO PAGADO` | Filtrar pedidos por estado de pago |
| `GET` | `/:id` | Obtener un pedido específico por ID |
| `POST` | `/` | Crear un nuevo pedido |
| `PATCH` | `/:id` | Actualizar parcialmente un pedido |
| `DELETE` | `/:id` | Eliminar un pedido del sistema |
| `POST` | `/usuario/singup` | Crear un nuevo usuario |
| `POST` | `/usuario/login` | Inicio de sesión |

---

###  Evidencia de Pruebas

#### 1. Obtener todos los pedidos
<img width="1354" height="635" alt="image" src="https://github.com/user-attachments/assets/e58aa6b5-8a65-4540-8056-3acc2c389daf" />
*Prueba del método GET para traer la colección completa.*

#### 2. Filtro por Nombre
<img width="1333" height="630" alt="image" src="https://github.com/user-attachments/assets/be4ec9f5-003d-4c21-9e59-621933d050a9" />
*Búsqueda específica para: `Juan Gabriel Lopez Beltran`.*

#### 3. Filtro por Estado de Pago
<img width="1346" height="631" alt="image" src="https://github.com/user-attachments/assets/67b95980-b2d2-4b37-8377-089def3b4781" />
*Filtrado de registros con estado `NO PAGADO`.*

#### 4. Obtener pedido por ID
<img width="1333" height="637" alt="image" src="https://github.com/user-attachments/assets/f9bc3192-1401-4670-a3c0-8120664f0cc5" />
*Consulta del ID específico: `69af7799f145bfe457f269ca`.*

#### 5. Crear Nuevo Pedido (POST)
<img width="1359" height="572" alt="image" src="https://github.com/user-attachments/assets/b2c87cac-51e3-4024-b013-fad745e0a1b6" />
*Envío de JSON para registrar un nuevo pedido en la base de datos.*

#### 6. Actualizar Pedido (PATCH)
<img width="1376" height="579" alt="image" src="https://github.com/user-attachments/assets/e033716f-8258-425b-abc7-7083c38cc23a" />
*Modificación del pedido ID: `69af7799f145bfe457f269ca`.*

#### 7. Eliminar Pedido (DELETE)
<img width="1339" height="579" alt="image" src="https://github.com/user-attachments/assets/ccef3f08-32ae-4604-85d7-6aa0775d6db1" />
*Borrado del registro ID: `69af7799f145bfe457f269ca`.*

---
###  Evidencia de Pruebas JWT
#### 1. Crear Usuario
<img width="1477" height="837" alt="image" src="https://github.com/user-attachments/assets/8863c484-2017-40b5-944a-e075898a94d5" />

#### 1. Ruta Login
<img width="1472" height="791" alt="image" src="https://github.com/user-attachments/assets/28531be1-ab58-4874-860b-2f53350de537" />


