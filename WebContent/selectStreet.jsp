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
      String city = null;
      String[][] streets;

	  /** Get the country requested from a session variable */
      try {
	    country = session.getAttribute("searchCountryFilter").toString();
	    
	  /** If the country was not in a session variable */  
      } catch (NullPointerException nullPointerException) {

        /** Foward the user to the select country page */
        request.getRequestDispatcher("selectCountry.jsp").forward(request, response);
        
        return;
        
      }
	  
	  /** Get the state requested from a session variable */
      try {
	    state = session.getAttribute("searchStateFilter").toString();
	    
	  /** If the state was not in a session variable */  
      } catch (NullPointerException nullPointerException) {

        /** Foward the user to the select state page */
        request.getRequestDispatcher("selectState.jsp").forward(request, response);
        
        return;
        
      }

      /** Get the city requested either from the passed in data or from a session variable */
      city = request.getParameter("selectedCity");

      /** If we could not get the city from a passed in data */
      if (city == null || city.isEmpty() || city.equals("")) {
        try {
          city = session.getAttribute("searchCityFilter").toString();

        /** If the city was not in a session variable */  	  
        } catch (NullPointerException nullPointerException) {

          /** Foward the user to the select city page */
          request.getRequestDispatcher("selectCity.jsp").forward(request, response);
          
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

        /** Get a list of all the streets within the state, country */
        streets = SQLInterface.getAllHotelsWithinCity(country, state, city);

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
      
      /** If no streets were returned */
      if (streets == null) {
  	  
    	// Foward the user to the select city again  
        request.getRequestDispatcher("selectCity.jsp").forward(request, response);
      
      }
      
      /** Put the city of the user is looking for into a session variable */
      session.setAttribute("searchCityFilter", city);

	  out.println("<h4 align=\"center\">In " + state + ", " + country + ", " + city + " we have hotels on these streets. " +
	        	  "Select one: </h4>");

      /** Create the html code that contains the drop down city list */
      out.println("<form name=\"selectStreetForm\" action=\"selectDates.jsp\" method=\"post\" >");
      out.println("<div align=\"center\">");
      out.println("<select name=\"selectedStreet\">");
      for(String[] street : streets) {
    	  out.println("<option value=\"" + street[0] + "\" >" + street[1] + "</option>");
      }
      out.println("</select>");
      out.println("<br>");
      out.println("<br>");
      out.println("<input type=\"submit\" value=\"Select this street\">");
      out.println("</div>");
      out.println("</form>");
      out.println("<br>");
      out.println("<br>");
      
      out.println("<div align=\"center\">");
      out.println("Want to select a different city? <a class=\"active\" href=\"selectCity.jsp\">Click here</a>");
      out.println("</div>");
      	    
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