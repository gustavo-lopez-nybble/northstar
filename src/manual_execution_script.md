[Regresar al índice](../readme.md)

# Como ejecutar un script de updates relacionado a Document Tracking Report Clean Up
> Estos casos son similar a ticket como este [LISO-3404](https://nybblegroup.atlassian.net/browse/LISO-3404) donde el cliente pide algo como "Kindly remove the pending tasks from the Document Tracking Report as the IFIs have already been received."

### ‼️En el ticket debe venir la lista de policies number a actualizar STATES

### Validar en la UI
- Con la lista de polizas, validar con algunos el comportamiento en PP
- Para ello ir a la opcion Reports > Policy > Document Tracking Report ...app/reports/document-tracking"
- Buscar o filtrar por algunos de los policies number que vienen en el ticket, y validar que efectivamente tengan fecha ( o sea, el dato ) en la columna "Pending Illustration Request Date" en la grilla.

### Validar en la DB
- Para validar en db es necesario ejecutar el siguiente query, con el mismo policy number que se validó en la UI:
```sql
SELECT dr.POLICY_ID,
	   dr.STATE 
FROM NYB_DOCUMENTREQUEST dr
WHERE dr.POLICY_ID IN (
	SELECT p.POLICIESID
	FROM sysdba.POLICIES p
	WHERE p.POLICYNUMBER IN ('U320692') -- <-- aqui va la lista de policies number que viene en el ticket
)
``` 
- Aqui vas a ver que algunos STATE no seran COMPLETED, lo cual es el error o el problema que se tiene que solucionar.

### Solucion
- Del siquiente script, se tiene que cambiar la lista de policies number por la que viene en el ticket, y luego ejecutar el siguiente script.
- [script](../db/20260303_Document_Tracking_Report_Clean_Up.sql)

### Validar en la UI
- Luego de ejecutar el script, se puede validar nuevamente en la UI, con el mismo proceso que se hizo antes, y se deberia ver que ahora la columna "Pending Illustration Request Date" esta vacia.
