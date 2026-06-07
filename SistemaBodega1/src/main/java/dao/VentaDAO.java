package dao;

import conexion.Conexion;
import modelo.Venta;
import modelo.DetalleVenta;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VentaDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public List<Venta> listarVentasPorFecha(String fecha) {

        List<Venta> lista = new ArrayList<>();
        String sql =
            "SELECT * FROM ventas WHERE DATE(fecha)=? ORDER BY fecha";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, fecha);
            rs = ps.executeQuery();
            while(rs.next()) {
                Venta v = new Venta();
                v.setId(rs.getInt("id"));
                v.setFecha(rs.getTimestamp("fecha"));
                v.setTotal(rs.getDouble("total"));
                v.setCantidadProductos(rs.getInt("cantidad_productos"));
                v.setEstado(rs.getString("estado"));
                v.setMetodoPago(rs.getString("metodo_pago"));
                lista.add(v);
            }
        } catch(Exception e) {
            System.out.println("Error listar ventas: " + e);
        }
        return lista;
        
    }

    public List<DetalleVenta> obtenerDetalle(int ventaId) {
        List<DetalleVenta> lista = new ArrayList<>();
        String sql =
            "SELECT p.nombre, d.cantidad, " +
            "d.precio_unitario, d.subtotal " +
            "FROM detalle_venta d " +
            "INNER JOIN productos p " +
            "ON d.producto_id = p.id " +
            "WHERE d.venta_id = ?";

        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, ventaId);
            rs = ps.executeQuery();
            while(rs.next()) {
                DetalleVenta d = new DetalleVenta();

                d.setNombreProducto(
                        rs.getString("nombre"));

                d.setCantidad(
                        rs.getInt("cantidad"));

                d.setPrecioUnitario(
                        rs.getDouble("precio_unitario"));
                
                d.setSubtotal(
                        rs.getDouble("subtotal"));
                lista.add(d);
            }
        } catch(Exception e) {
            System.out.println("Error detalle: " + e);
        }
        return lista;
    }
}
