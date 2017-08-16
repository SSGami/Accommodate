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
    <h4 align="center">Please select the country you would like to find a hotel in: </h4>
    
    <%

      int CID;
      Customer customer;
      String[] countries;

      boolean customerIsInDatabase = false;
      try {

  	    /** Attempt to get the CID stored for this session. */
        CID = Integer.parseInt(session.getAttribute("CID").toString());	  
    	  
        /** Create a customer object containing the customer's ID */
        customer = new Customer(CID);

	    /** Populate the customer object with details from the SQL server */ 
        customerIsInDatabase = SQLInterface.isCustomerInDatabase(customer);
	    
        /** Get all the countries we have hotes in */
        countries = SQLInterface.getAllCountries();

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

      /** If the customer wasn't in the database */
      if (!customerIsInDatabase) {
    	  
  	    /** Redirect the user to the login page */
  	    session.removeAttribute("CID");
        response.sendRedirect("login.html");
        return;
    	
      }
      
      /** If no countries were returned */
      if (countries == null) {
    	  
        /** Redirect the user to the database error page */
  	    session.removeAttribute("CID");
        response.sendRedirect("databaseError.html");
        
      }

      /** Create the html code that contains the drop down country list */
      out.println("<form name=\"selectCountryForm\" action=\"selectState.jsp\" method=\"post\" onsubmit = \"return validate_form()\">");
      out.println("<div align=\"center\">");
      out.println("<select name=\"selectedCountry\">");
      for(String country : countries) {
        out.println("<option value=\"" + country + "\" >" + country + "</option>");
       }
      
      out.println("</select>");
      out.println("<br>");
      out.println("<br>");
      out.println("<input type=\"submit\" value=\"Select this country\">");
      out.println("</div>");
      out.println("</form>");
      
    %>
    
    <br>
    <div align="center">
      <br>
      <a class="active" href="userProfile.jsp">Go back to my profile</a>
    </div>

    <br>
    <div align="center">
      <br>
      <a class="active" href="logout.jsp">Log me out</a>
    </div>  

  </body>
</html>