<%@page import="dao.ProductoDAO"%>
<%@page import="modelo.Producto"%>
<%@page import="java.util.List"%>
<%@page import="modelo.ItemCarrito"%>
<%@page import="java.util.List"%>
<%
    ProductoDAO dao = new ProductoDAO();
    List<Producto> lista = dao.listar();
%>
<%if(session.getAttribute("usuario")
        == null){
    response.sendRedirect(
            "login.jsp");
    return;
}%>

<!DOCTYPE html>
<html>
    <head>
    <title>Sistema Bodega</title>     
    <style>
        body{
            font-family: Arial;
            margin:50px;
            background-color: #ffcc00;
        }
        table{
            width:100%;
            border-collapse: collapse;
            margin-top:20px;
            background-color: #ffffff;
        }
        th, td{
            border:1px solid black;
            padding:10px;
        }
        th{
            background-color: #01033b;
            color: #ffffff;
        }
        input{
            padding:5px;
        }
        .menu{
            margin-bottom:20px;
        }
        menu a{
            padding: 15px;
            text-decoration: none;
            background-color: #ffff33;
        }
        .menu a:visited {
            color: black;
        }

        .menu a:hover {
            color: #bc6c07;
        }
    </style>
</head>

<body class="color_fondo">

<h1>Sistema de Bodega</h1>
<%@page import="modelo.Usuario"%>
<%
Usuario usuarioLogueado =
        (Usuario) session.getAttribute("usuario");
%>

<p>
    Bienvenido:
    <strong>
        <%= usuarioLogueado.getNombre() %>
    </strong>
</p>
<div style="margin-bottom:20px;">
    <a href="index.jsp">Productos</a> |
    <a href="compra.jsp">Realizar Venta</a> |
    <a href="reportes.jsp">Reportes</a> |
    <a href="LogoutServlet">Cerrar Sesión</a>
</div>

<h2>Registrar Producto</h2>

<form action="ProductoServlet" method="post">

    <input type="text" name="nombre" placeholder="Nombre" required>
    <input type="number" step="0.01" name="precio" placeholder="Precio" required>
    <input type="number" name="stock" placeholder="Stock" required>
    <input type="text" name="presentacion" placeholder="Presentación" required>

    <button type="submit">Guardar</button>
</form>

<hr>

<h2>Lista de Productos</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Nombre</th>
        <th>Precio</th>
        <th>Stock</th>
        <th>Presentación</th>
        <th>Acción</th>
    </tr>

<%
    for (Producto p : lista) {
%>

<tr>
    <td><%= p.getId() %></td>
    <td><%= p.getNombre() %></td>
    <td><%= p.getPrecio() %></td>
    <td><%= p.getStock() %></td>
    <td><%= p.getPresentacion() %></td>

    <td>
        <a href="ProductoServlet?accion=eliminar&id=<%=p.getId()%>">
            Eliminar
        </a>
        <br><br>

        <a href="ProductoServlet?accion=editar&id=<%=p.getId()%>">
            Editar
        </a>
    </form>

    </td>
</tr>

<%
    }
%>

</table>

</body>
</html>