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

      /** Grab the CID value from the login.html page */
	  int CID = 0;

      boolean customerIsInDatabase = false;
      try {

    	/** Grab the CID value from the login.html page */
    	CID = Integer.parseInt(request.getParameter("CID"));

        /** Create a customer object containing the customer's ID */
        Customer customer = new Customer(CID);

  	    /** Populate the customer object with details from the SQL server */ 
        customerIsInDatabase = SQLInterface.isCustomerInDatabase(customer);

      /** If there was an error communicating with the SQL server */
      } catch (SQLException sqlException) {

        /** Redirect the user to the database error page */
	    session.removeAttribute("CID");
        response.sendRedirect("databaseError.html");
        return;

      /** If the session stored CID was not in the database */
      } catch (IllegalArgumentException | NullPointerException exception) {

  	    /** Redirect the user to the login page */
	    session.removeAttribute("CID");
        response.sendRedirect("login.html");
        return;
      }

      /** If the customer was in the database */
      if (customerIsInDatabase) {

        /** Set the customer ID as an attribute for this session */
        session.setAttribute("CID", CID);

        /** Foward the user to the user profile page */
        request.getRequestDispatcher("userProfile.jsp").forward(request, response);

        return;
      }

      /** Display that we couldn't find the customer ID and provide a back button */
      out.println("<h5 align= \"center\">We could not find that Customer ID in the database!</h5>");
      out.println("<form action=\"login.html\">");
      out.println("  <div align=\"center\">");
      out.println("    <input type=\"submit\" value=\"Press here to go back\" />");
      out.println("  </div>");
      out.println("</form>");

    %>
  </body>
</html>