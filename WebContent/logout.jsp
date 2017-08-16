<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <title>Hulton Hotels Booking System</title>
  </head>

    <div align="center">"<font size="9">Hulton Hotels Booking System</font></div>
    <br>

    <%

      /** Remove the CID from the session attributes */
      session.removeAttribute("CID");

      /** Redirect the user to the login page */
      response.sendRedirect("login.html");

     %>
  </body>
</html>