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

    /** This function checks if all the fields the user provided are valid */
    function validate_form() {

      var nameLengthLimit = "<%=Customer.NAME_LENGTH_LIMIT%>"; 
      var streetAddressLengthLimit = "<%=Customer.ADDRESS_LENGTH_LIMIT%>"; 
      var emailLengthLimit = "<%=Customer.EMAIL_LENGTH_LIMIT%>"; 
      var phoneNumberLengthLimit = "<%=Customer.PHONE_NUMBER_LENGTH_LIMIT%>"; 

      /** Check if the name provided is not empty and of valid length */
      var nameValue = document.forms["editProfileForm"]["name"].value;
      if (!nameValue || nameValue.length > nameLengthLimit) {
        alert("Please enter a valid name.");
        return false;
      }

      /** Check if the address provided is not empty and of valid length */
      var streetAddressValue = document.forms["editProfileForm"]["streetAddress"].value;
      if (!streetAddressValue || streetAddressValue.length > streetAddressLengthLimit) {
        alert("Please enter a valid street address.");
    	return false;
      }

      /** Check if the email provided is not empty and of valid length */
      var emailValue = document.forms["editProfileForm"]["email"].value;
      var emailRegularExpression = '/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((' +
    		  '\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;'
      if (!emailValue || !emailRegularExpression.test(emailValue) || emailValue.length > emailLengthLimit) {
        alert("Please enter a valid email.");
	    return false;
      }

      /** Check if the phone number provided is not empty and of valid length */
      var phoneValue = document.forms["editProfileForm"]["phone"].value;
	  if (!phoneValue || phoneValue.length != phoneNumberLengthLimit) {
	    alert("Please enter a valid phone number");
	    return false;
	  }

      return true;

    }

  </script>

  <body>
    <div align="center">"<font size="9">Hulton Hotels Booking System</font></div>
    <br>

    <h4 align="center">You may change any of the fields below to update your information.</h4>
    <br>

    <%

      int CID;
      Customer customer;

      try {

    	/** Attempt to get the CID stored for this session. */  
        CID = Integer.parseInt(session.getAttribute("CID").toString());	

        /** Create a customer object containing the customer's ID */
        customer = new Customer(CID);

      /** If there was no CID stored for this sesson or it was not in a valid format */
      } catch (NullPointerException | IllegalArgumentException exception) {
    	  
      	/** Redirect the user to the login page */
    	session.removeAttribute("CID");
        response.sendRedirect("login.html");
        return;
      }

      try {

    	/** Populate the customer object with details from the SQL server */ 
        SQLInterface.getCustomerInformation(customer);

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

      /** Store the customer information into variables so we can access them in the HTML below */
      String customerName = customer.getName();
      String customerAddress = customer.getAddress();
      String customerEmail = customer.getEmailAddress();
      String customerPhoneNumber = customer.getPhoneNumber();

    %>

    <form name="editProfileForm" action="editProfileSaveChanges.jsp" method="post" onsubmit ="return validate_form()">
      <div align="center">
	    <table>
          <tr>
            <td>Name: </td>
		    <td><input name ="name" type = "text" value='<%=customerName%>' maxlength = "<%=Customer.NAME_LENGTH_LIMIT%>"></td>
		  </tr>
          <tr>
            <td>Address: </td>
		    <td><input name ="streetAddress" type = "text" value='<%=customerAddress%>' maxlength = "<%=Customer.ADDRESS_LENGTH_LIMIT%>"></td>
		  </tr>
          <tr>
            <td>Email: </td>
		    <td><input name ="email" type = "text" value='<%=customerEmail%>' maxlength = "<%=Customer.EMAIL_LENGTH_LIMIT%>"></td>
		  </tr>
          <tr>
            <td>Phone Number: </td>
            <td><input name ="phone" type = "number" value='<%=customerPhoneNumber%>'></td>
		  </tr>
        </table>
      </div>
      <div align="center">
        <br>
	    <input type="submit" value="Save changes">
	    <br>
	    <br>
	    <a class="active" href="logout.jsp">Log me out</a>
	  </div>
    </form>
  </body>
</html>