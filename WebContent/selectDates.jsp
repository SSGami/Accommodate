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
  
  <script type="text/javascript">
    
    <!-- This function checks if all the fields the user provided are valid -->
    function validate_form() {
  
    /**Check if the name provided is not empty and is less than 50 characters */
    var checkInValue = document.getElementById("checkInID").value;
    var checkOutValue = document.getElementById("checkOutID").value;

    if((new Date(checkInValue).getTime() < new Date(checkOutValue).getTime())) {
    	alert("Warning: Check-In Date Must Be Less Than The Check-Out Date!");
        return false;
    }
  	return true;  
    }
    
  </script>
  
  <body>
    <div align="center">"<font size="9">Hulton Hotels Booking System </font></div>
    <br>
    
    <%

      int CID;
      int hotelID;
      
      /** Get the hotelID requested either from the passed in data or from a session variable */
      try {
        hotelID = Integer.parseInt(request.getParameter("selectedStreet").toString());
      } catch (NullPointerException nullPointerException1) {
        try {
          hotelID = Integer.parseInt(session.getAttribute("searchHotelIDFilter").toString());
        /** If the hotelID was not in a session variable */  	  
        } catch (NullPointerException nullPointerException2) {

          /** Foward the user to the select city page */
          request.getRequestDispatcher("selectStreet.jsp").forward(request, response);
          return;
        }
      }
      
      /** If the obtained hotelID doesn't exist */
      if (!SQLInterface.isValidHotelID(hotelID)) {
    	  
        /** Foward the user to the select country page */
        request.getRequestDispatcher("selectCountry.jsp").forward(request, response);
        return;
      }
      
      boolean customerIsInDatabase = false;
      try {

    	/** Grab the CID value from the stored session variable */
    	CID = Integer.parseInt(session.getAttribute("CID").toString());	

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

      /** If the customer wasn't in the database */
      if (!customerIsInDatabase) {
    	  
    	/** Redirect the user to the login page */
  	    session.removeAttribute("CID");
        response.sendRedirect("login.html");
        return;
        
      }

      /** Set the customer ID as an attribute for this session */
      session.setAttribute("searchHotelIDFilter", hotelID);

      out.println("<div align=\"center\">");
      out.println("<br>");
      out.println("Please select your check-in and check-out dates below:");
      out.println("</div>");
      out.println("<form name=\"selectDatesForm\" action=\"selectRoom.jsp\" method=\"post\" onsubmit =\"return validate_form()\">");
      out.println("<div align=\"center\">");
      out.println("<br>");
      out.println("<br>");
      out.println("Check-In Date: <input name = \"checkInDate\" id = \"checkOutID\" type= \"date\">");
      out.println("<br>");
      out.println("<br>");
      out.println("Check-Out Date: <input name = \"checkOutDate\" id = \"checkInID\" type= \"date\">");
      out.println("<br>");
      out.println("<br>");
      out.println("<input type=\"submit\" value=\"Select these dates\">");
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