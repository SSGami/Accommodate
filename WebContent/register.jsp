<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="Group27.*" %>
<%@ page import="com.mysql.jdbc.Driver" %>

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

      /** Grab the values passed to us by the register html page */
      String name = request.getParameter("name");
	  String address = request.getParameter("streetAddress");
      String email = request.getParameter("email");
      String phoneNumber = request.getParameter("phone");

      Customer customer;
      boolean customerWasAdded = false;
      try {

        /** Create a customer object from the obtained values */
        customer = new Customer(name, email, address, phoneNumber);

        /** Add the customer to the database */
        customerWasAdded = SQLInterface.addNewCustomer(customer);

      /** If there was an error communicating with the SQL server */
      } catch (SQLException sqlException) {

        /** Redirect the user to the database error page */
        session.removeAttribute("CID");
        response.sendRedirect("databaseError.html");
        return;

      /** If there was an issue with the data that the user entered */
      } catch (IllegalArgumentException illegalArgumentException) {

        /** Redirect the user back to the register page */
        response.sendRedirect("register.html");
        return;

      }

      /** If the customer ID was added to the SQL database */
      if (customerWasAdded) {

		/** Display the customers CID and provide them with a button to go back to the login page */
		out.println("<div align=\"center\">");
		out.println("<font size=\"6\">Thank you for taking the time to register " + customer.getName() + "!</font>");
		out.println("<br>");
		out.println("<br>");
		out.println("<font size=\"4\">Your Customer Identification Number (CID) is</font>");
		out.println("<br>");
		out.println("<br>");
		out.println("<b> <font size=\"5\">" + customer.getCustomerID() + "</font></b>");
		out.println("<br>");
		out.println("<br>");
		out.println(" <font size=\"3\">Please keep this number in a safe place.</font>");
		out.println("<br>");
		out.println("<br>");
		out.println("<form action=\"login.html\">");
		out.println("  <div align=\"center\">");
		out.println("    <input type=\"submit\" value=\"You may now login here\" />");
		out.println("  </div>");
		out.println("</form>");

      /** If the customers information was not sucessfully entered into the database */ 
	  } else {

		/** Display to the customer that there was an error with a button to go back to the login page */ 
        out.println("<h3 align= \"center\">Thank you for taking the time to register. </h3>");
		out.println("<br>");
		out.println("<br>");
		out.println("<h4 align= \"center\">We are sorry but unfortunately there was an error. </h4>");
		out.println("<br>");
		out.println("<form action=\"login.html\">");
		out.println("  <div align=\"center\">");
		out.println("    <input type=\"submit\" value=\"Press here to go back to the login page\" />");
		out.println("  </div>");
		out.println("</form>");

	  }

    %>
  </body>
</html>