<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dao.VentaDAO"%>
<%@page import="modelo.Venta"%>
<%@page import="modelo.DetalleVenta"%>

<%
    String fechaSeleccionada = request.getParameter("fecha");
    VentaDAO dao = new VentaDAO();
    List<Venta> ventas = new ArrayList<>();
    double totalDia = 0;
    int ventasEfectivo = 0;
    int ventasTarjeta = 0;

    if (fechaSeleccionada != null && !fechaSeleccionada.isEmpty()) {
        ventas = dao.listarVentasPorFecha(fechaSeleccionada);
        for (Venta v : ventas) {
            totalDia += v.getTotal();
            if("EFECTIVO".equals(v.getMetodoPago())) {
                ventasEfectivo++;
            }
            if("TARJETA".equals(v.getMetodoPago())) {
                ventasTarjeta++;
            }
        }
    }
    SimpleDateFormat formatoHora =
            new SimpleDateFormat("HH:mm:ss");
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
    <title>Reportes</title>
    <style>
        body{
            font-family: Arial;
            margin:50px;
            background-color: #ffcc00;
        }
        .menu{
            margin-bottom:20px;
        }
        .boleta{
            border:1px solid black;
            padding:15px;
            margin-top:20px;
            width:700px;
            background-color: #ffff33;
        }
        table{
            width:100%;
            border-collapse: collapse;
            margin-top:10px;
            background-color: #ffffff
        }
        th, td{
            border:1px solid #ccc;
            padding:8px;
            text-align:left;
        }
        th{
            background-color: #01033b;
            color: #ffffff;
        }
        .menu a{
            padding: 15px;
            text-decoration: none;
            color: black;
            font-weight: bold;
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
<body>
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
    <div class="menu">
        <a href="index.jsp">Productos</a> |
        <a href="compra.jsp">Realizar Venta</a> |
        <a href="reportes.jsp">Reportes</a> |
        <a href="LogoutServlet">Cerrar Sesión</a>
    </div>
    <hr>
    <h2>Reporte de Ventas</h2>

    <form method="get">
        <label>Seleccione una fecha:</label>
        <input type="date"
               name="fecha"
               value="<%= fechaSeleccionada != null ? fechaSeleccionada : "" %>">
        <button type="submit">
            Buscar
        </button>
    </form>

    <%
        if(fechaSeleccionada != null){
    %>

    <h3>
        Fecha consultada:
        <%= fechaSeleccionada %>
    </h3>
    <%
            if(ventas.isEmpty()){
    %>
    <p>No existen ventas para esa fecha.</p>
    <%
            } else {

                for(Venta venta : ventas){

                    List<DetalleVenta> detalles =
                            dao.obtenerDetalle(venta.getId());
    %>
    <div class="boleta">
        <h3>
            BOLETA N° <%= venta.getId() %>
        </h3>
        <p>
            Hora:
            <%= formatoHora.format(venta.getFecha()) %>
        </p>
        <p>
            Estado:
            <%= venta.getEstado() %>
        </p>
        <p>
            Método de Pago:
            <%= venta.getMetodoPago() %>
        </p>
        <table>
            <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio</th>
                <th>Subtotal</th>
            </tr>
            <%
                for(DetalleVenta d : detalles){
            %>

            <tr>
                <td><%= d.getNombreProducto() %></td>
                <td><%= d.getCantidad() %></td>
                <td>
                S/
                <%= String.format(java.util.Locale.US,
                                  "%.2f",
                                  d.getPrecioUnitario()) %>
                </td>
                <td>
                S/
                <%= String.format(java.util.Locale.US,
                                  "%.2f",
                                  d.getSubtotal()) %>
                </td>
            </tr>
            <%
                }
            %>
        </table>
        <h3>
            TOTAL:
            S/
            <%= String.format(java.util.Locale.US,
                              "%.2f",
                              venta.getTotal()) %>
        </h3>
    </div>

    <%
                }
    %>
    <hr>
    <h2>
        TOTAL VENDIDO DEL DÍA
    </h2>
    <h2 style="color:black;">
        S/
        <%= String.format(java.util.Locale.US,
                          "%.2f",
                          totalDia) %>
    </h2>
    <hr>
        <h3>Resumen de Pagos</h3>
    <p>
        Ventas en efectivo:
        <strong><%= ventasEfectivo %></strong>
    </p>

    <p>
        Ventas con tarjeta:
        <strong><%= ventasTarjeta %></strong>
    </p>

    <%
            }
        }
    %>
</body>
</html>