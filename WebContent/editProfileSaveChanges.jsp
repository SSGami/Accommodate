<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="Group27.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <title>Hulton Hotels Booking System</title>
  </head>

  <body>
    <div align="center">"<font size="9">Hulton Hotels Booking System</font></div>
    <br>

    <%

      int CID;

      try {

        /** Attempt to get the CID stored for this session. */  
        CID = Integer.parseInt(session.getAttribute("CID").toString());

      /** If there was no CID stored for this sesson */
      } catch (NullPointerException | IllegalArgumentException exception) {

      	/** Redirect the user to the login page */
    	session.removeAttribute("CID");
        response.sendRedirect("login.html");
        return;
      }

      /** Grab the values passed to us by the edit profile page */
      String name = request.getParameter("name");
	  String address = request.getParameter("streetAddress");
      String email = request.getParameter("email");
      String phoneNumber = request.getParameter("phone");

      Customer customer;
      boolean customerIDExists;

      try {

        /** Create a customer object from the obtained values */
        customer = new Customer(CID, name, email, address, phoneNumber);

        /** Update the customer in the database */
        customerIDExists = SQLInterface.updateCustomerInformation(customer);

      /** If there was an error communicating with the SQL server */
      } catch (SQLException sqlException) {

        /** Redirect the user to the database error page */
        session.removeAttribute("CID");
        response.sendRedirect("databaseError.html");
        return;

      /** If there was an issue with the data that the user entered */
      } catch (IllegalArgumentException illegalArgumentException) {

        /** Redirect the user back to the edit profile page */
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
        return;

      }

      /** If the customer ID did not exist, redirect the user to the login page */
      if (!customerIDExists) {

      	/** Redirect the user to the login page */
  	    session.removeAttribute("CID");
        response.sendRedirect("login.html");
        return;
      }

      /** Return the user to the user profile page */
      request.getRequestDispatcher("userProfile.jsp").forward(request, response);

    %>
  </body>
</html>