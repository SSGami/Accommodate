<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="Group27.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
      int hotelID;
      String startDate = null;
      String endDate = null;
      Room[] roomListing;

      /** Get the check in and check out dates requested either from the passed in data or from a session variable */
      try {
    	  startDate = request.getParameter("selectedStreet").toString();
    	  endDate = request.getParameter("selectedStreet").toString();
      } catch (NullPointerException nullPointerException1) {
        try {
          startDate = session.getAttribute("searchStartDateFilter").toString();
    	  endDate = session.getAttribute("searchEndDateFilter").toString();
        /** If the check in/out dates were not in a session variable */  	  
        } catch (NullPointerException nullPointerException2) {
          /** Foward the user to go to the select dates page */
          request.getRequestDispatcher("selectDates.jsp").forward(request, response);
          return;
        }
      }
      if (startDate.isEmpty() || startDate.equals("") || endDate.isEmpty() || endDate.equals("")) {
  		request.getRequestDispatcher("selectDates.jsp").forward(request, response);	
  		return;
      }
      
      boolean customerIsInDatabase = false;
      try {

    	/** Grab the HotelID value from the stored session variable */
    	hotelID = Integer.parseInt(session.getAttribute("searchHotelIDFilter").toString()); 	
    	
  	    /** Grab the CID value from the stored session variable */
  	    CID = Integer.parseInt(session.getAttribute("CID").toString());	

        /** Create a customer object containing the customer's ID */
        Customer customer = new Customer(CID);

	    /** Populate the customer object with details from the SQL server */ 
        customerIsInDatabase = SQLInterface.isCustomerInDatabase(customer);
	    
        /** If the obtained hotelID doesn't exist */
        if (!SQLInterface.isValidHotelID(hotelID)) {
      	  
          /** Foward the user to the select country page */
          request.getRequestDispatcher("selectCountry.jsp").forward(request, response);
          return;
          
        }
        
        /** Get all the room listings for the specified search query */
	    roomListing = SQLInterface.getRoomsAvailable(hotelID, startDate, endDate);

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
      
      if (roomListing == null) {
    	  
        // TODO: No rooms are listed
    	out.println("There were no results!");
        return;

      }

      StringBuffer roomNumberBuffer = new StringBuffer();
      StringBuffer hotelIDBuffer = new StringBuffer();
      StringBuffer priceBuffer = new StringBuffer();
      StringBuffer capacityBuffer = new StringBuffer();
      StringBuffer floorNumberBuffer = new StringBuffer();
      StringBuffer descriptionBuffer = new StringBuffer();
      StringBuffer typeBuffer = new StringBuffer();
      StringBuffer discountPercentageBuffer = new StringBuffer();
      StringBuffer discountStartsOnBuffer = new StringBuffer();
      StringBuffer discountEndsOnBuffer = new StringBuffer();
      

      for (int i = 0; i < roomListing.size(); i++) {
    	  
        if (i != 0) {

          roomNumberBuffer.append(" ,")
          hotelIDBuffer = new StringBuffer();
          priceBuffer = new StringBuffer();
          capacityBuffer = new StringBuffer();
          floorNumberBuffer = new StringBuffer();
          descriptionBuffer = new StringBuffer();
          typeBuffer = new StringBuffer();
          discountPercentageBuffer = new StringBuffer();
          discountStartsOnBuffer = new StringBuffer();
          discountEndsOnBuffer = new StringBuffer();
    		  
        }		  
    	  
      }
      
      
      for (Room room : roomListing) {
    	
    	room
    	 
      }
     
        
     
     
      
    		    /** Add the array to the country list */
    		    roomList.add(resultSet.getInt("Room_no"));
    			
              } while(resultSet.next());
        	
        	  Collections.sort(roomList);

              /** Create the html code that contains the drop down country list */
              out.println("<form name=\"selectRoomForm\" action=\"selectAdditionalOptions.jsp\" method=\"post\" onsubmit = \"return validate_form()\">");
              out.println("<div align=\"center\">");
              out.println("<select name=\"roomNum\">");
              for(Integer roomNum : roomList) {
                out.println("<option value=" + roomNum.intValue() + " >" + roomNum.intValue() + "</option>");
              }
               
              out.println("</select>");
              out.println("<br>");
              out.println("<br>");
              out.println("<input type=\"submit\" value=\"Select this room\">");
              out.println("</div>");
        	  out.println("</form>");
        }
	
      }
	 
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