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
      Customer customer;

      try {

    	/** Attempt to get the CID stored for this session. */
        CID = Integer.parseInt(session.getAttribute("CID").toString());	

        /** Create a customer object containing the customer's ID */
        customer = new Customer(CID);
    	  
  	    /** Populate the customer object with details from the SQL server */
        SQLInterface.getCustomerInformation(customer);

      /** If there was an error communicating with the SQL server */
      } catch (SQLException sqlException) {

    	/** Redirect the user to the database error page */
	    session.removeAttribute("CID");
        response.sendRedirect("databaseError.html");
        return;

        /** If there was no session stored CID or it wasn't in the database */
      } catch (NullPointerException | IllegalArgumentException exception) {

  	    /** Redirect the user to the login page */
	    session.removeAttribute("CID");
        response.sendRedirect("login.html");
        return;
      }

      /** Display the page to the customer */
	  out.println("<div align=\"center\">");
      out.println("<font size=\"6\">Welcome " + customer.getName() + "!" + "</font");
      out.println("<br>");
      out.println("<br>");
      out.println("<br>");
      out.println("We have the following information about you on record:");
      out.println("<br>");
      out.println("<br>");
      out.println("  <b>Customer ID:</b> " + customer.getCustomerID());
      out.println("<br>");
      out.println("  <b>Email Address:</b> " + customer.getEmailAddress());
      out.println("<br>");
      out.println("  <b>Address:</b> " + customer.getAddress());
      out.println("<br>");
      out.println("  <b>Phone Number:</b> " + customer.getPhoneNumber());
      out.println("<br>");
      out.println("<br>");
      out.println("If this information is incorrect, you may update it by");
      out.println("<a class=\"active\" href=\"editProfile.jsp\">clicking here!</a>");
      out.println("<br>");
      out.println("<br>");
      out.println("Otherwise, ");
      out.println("<a class=\"active\" href=\"selectCountry.jsp\">click here</a>");
      out.println(" if you would like to make a reservation.");
      out.println("<br>");
      out.println("<br>");
      out.println("<a class=\"active\" href=\"logout.jsp\">Log me out</a>");
      out.println("</div>");

    %>

  </body>
</html>