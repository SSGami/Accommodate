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
    <div align="center">"<font size="9">Hulton Hotels Booking System </font></div>
    <br>
    
    <%

	  int CID;
      Customer customer;
      String country = null;
      String state = null;
      String[] cities;

	  /** Get the country requested from a session variable */
      try {
	    country = session.getAttribute("searchCountryFilter").toString();
	    
	  /** If the country was not in a session variable */  
      } catch (NullPointerException nullPointerException) {

        /** Foward the user to the select country page */
        request.getRequestDispatcher("selectCountry.jsp").forward(request, response);
        
        return;
        
      }

      /** Get the state requested either from the passed in data or from a session variable */
      state = request.getParameter("selectedState");

      /** If we could not get the state from a passed in data */
      if (state == null || state.isEmpty() || state.equals("")) {
        try {
    	  state = session.getAttribute("searchStateFilter").toString();

        /** If the state was not in a session variable */  	  
        } catch (NullPointerException nullPointerException) {

          /** Foward the user to the select state page */
          request.getRequestDispatcher("selectState.jsp").forward(request, response);
          
          return;
          
        }

      }

      boolean customerIsInDatabase = false;
      try {

    	/** Attempt to get the CID stored for this session. */
        CID = Integer.parseInt(session.getAttribute("CID").toString());	  

        /** Create a customer object containing the customer's ID */
        customer = new Customer(CID);

	    /** Populate the customer object with details from the SQL server */ 
        customerIsInDatabase = SQLInterface.isCustomerInDatabase(customer);

        /** Get a list of all the cities within the state, country */
        cities = SQLInterface.getAllCitiesWithinState(country, state);

      /** If there was an error communicating with the SQL server */
      } catch (SQLException sqlException) {

        /** Redirect the user to the database error page */
	    session.removeAttribute("CID");
        response.sendRedirect("databaseError.html");
        return;

      /** If there was no session stored CID or it wasn't in the database */
      } catch (IllegalArgumentException | NullPointerException exception) {

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
      
      /** If no cities were returned */
      if (cities == null) {
  	  
    	// Foward the user to the select state again  
        request.getRequestDispatcher("selectState.jsp").forward(request, response);
      
      }
      
      /** Put the state the user is looking for into a session variable */
      session.setAttribute("searchStateFilter", state);

	  out.println("<h4 align=\"center\">In " + state + ", " + country + " we have hotels in these cities. " +
	        	  "Select one: </h4>");

      /** Create the html code that contains the drop down city list */
      out.println("<form name=\"selectCityForm\" action=\"selectStreet.jsp\" method=\"post\" >");
      out.println("<div align=\"center\">");
      out.println("<select name=\"selectedCity\">");
      for(String city : cities) {
    	  out.println("<option value=\"" + city + "\" >" + city + "</option>");
      }
      out.println("</select>");
      out.println("<br>");
      out.println("<br>");
      out.println("<input type=\"submit\" value=\"Select this city\">");
      out.println("</div>");
      out.println("</form>");
      out.println("<br>");
      out.println("<br>");
      	    
      out.println("<div align=\"center\">");
      out.println("Want to select a different state? <a class=\"active\" href=\"selectState.jsp\">Click here</a>");
      out.println("</div>");
      	    
      out.println("<div align=\"center\">");
      out.println("Want to select a different country? <a class=\"active\" href=\"selectCountry.jsp\">Click here</a>");
      out.println("</div>");

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