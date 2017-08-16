package Group27;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;

public class SQLInterface {

	private static final SQLSession sqlSession = new SQLSession();

	public synchronized static boolean isCustomerInDatabase(Customer customer)
			throws SQLException, SQLWarning, IllegalArgumentException {

		// If the customer argument passed in is null throw an exception
		if (customer == null) throw new IllegalArgumentException();

		// Ask the doesCustomerExist function if the given CID exists in the database
		return doesCustomerExist(customer.getCustomerID());

	}

	public synchronized static void getCustomerInformation(Customer customer)
			throws SQLException, SQLWarning, IllegalArgumentException {

		// If the customer argument passed in is null throw an exception
		if (customer == null) throw new IllegalArgumentException();

		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// Create the query to check if the given CID was in the database
		String query = "SELECT * " +
						"FROM Customer " +
						"WHERE CID = '" + customer.getCustomerID() + "';";

		// Execute the query
		ResultSet resultSet = sqlSession.executeQuery(query);

		// If there were no results, that means that there is no matching customer with the given CID
		// so throw an exception
		if (!resultSet.next()) throw new IllegalArgumentException();

		// Populate the customer information object with customer's information
		customer.setName(resultSet.getString("Name"));
		customer.setEmailAddress(resultSet.getString("Email"));
		customer.setAddress(resultSet.getString("Address"));
		customer.setPhoneNumber(resultSet.getString("Phone_no"));
	}

	public synchronized static boolean updateCustomerInformation(Customer customer)
			throws SQLException, SQLWarning, IllegalArgumentException {

		// If the customer argument passed in is null or all the data isn't valid, throw an exception
		if (customer == null || !customer.isAllDataValid()) throw new IllegalArgumentException();

		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// Create the query to update the customers information in the database
	    String query = "UPDATE Customer " +
	    			   "SET Email = '" + customer.getEmailAddress() + "', " +
	    			   "Address = '" + customer.getAddress() + "', " +
	    			   "Phone_no = '" + customer.getPhoneNumber() + "', " +
	    			   "Name = '" + customer.getName() + "' " +
	    			   "WHERE CID = '" + customer.getCustomerID() + "';";

		// Execute the query
	    int returnValue = sqlSession.executeUpdate(query);

	    // If the return value was zero, that means that the CID was not in the database so return false
	    if (returnValue == 0) return false;

	    // Otherwise return true
	    return true;

	}

	public synchronized static boolean addNewCustomer(Customer customer)
			throws SQLException, SQLWarning, IllegalArgumentException {

		// If the customer argument passed in is null, throw an exception
		if (customer == null) throw new IllegalArgumentException();

		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// Loop until we have generated a random CID that is not in the database (if we are using
		// multiple servers to host the web site then this is not concurrency safe)
		int CID;
		while (true) {

			// Generate a random CID
		    CID = Customer.generateRandomCID();

		    // If the generated CID is not in the database, we may break out of the loop
		    if (!doesCustomerExist(CID)) break;

		}
		
		// Insert the newly generated customer ID into the given customer object
		customer.setCustomerID(CID);
		
		// If all the data isn't valid in the customer object, throw an error
		if(!customer.isAllDataValid()) throw new IllegalArgumentException();

		// Create the query to add the customer to the database
		String query = "INSERT " +
					   "INTO Customer " +
				       "VALUES (" + customer.getCustomerID() + ", '" +
					   				customer.getEmailAddress() + "', '" +
					   				customer.getAddress() + "', '" +
					   				customer.getPhoneNumber() + "', '" +
					   				customer.getName() + "');";

		// Execute the query
		int numberOfResultChanged = sqlSession.executeUpdate(query);

		// If the number of results changed is 0 or less, then there was an issue inserting the customer so return false
		if (numberOfResultChanged <= 0) return false;

		// Otherwise return true
		return true;
	}
	
	public static synchronized String[] getAllCountries()
		throws SQLException, SQLWarning {

		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// List of countries
		ArrayList<String> countryList = new ArrayList<>();

		// Create the query to find all distinct countries we have hotels in
	    String query = "SELECT DISTINCT h.Country " +
	    			   "FROM Hotel h;";

		// Execute the query
		ResultSet resultSet = sqlSession.executeQuery(query);

		// Loop through all the results
		while (resultSet.next()) {

			// Add the country to the array list
			countryList.add(resultSet.getString("Country"));

		}

		// If there are no countries in the list, return null
		if (countryList.size() == 0) return null;
		
		// Convert the array list to a string array and return it
		String[] returnArray = new String[countryList.size()];
		returnArray = countryList.toArray(returnArray);
		return returnArray;

	}

	public static synchronized String[] getAllStateWithinCountry(String country)
		throws SQLException, SQLWarning, IllegalArgumentException {

		// Check the parameters if there valid
		if (country == null || country.isEmpty()) throw new IllegalArgumentException("Country is invalid");
		
		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// List of states
		ArrayList<String> stateList = new ArrayList<>();

		// Create the query to find all distinct states for the given country we have hotels in
	    String query = "SELECT DISTINCT h.State " +
	    			   "FROM Hotel h " +
	    			   "WHERE h.Country = '" + country + "';";

		// Execute the query
		ResultSet resultSet = sqlSession.executeQuery(query);

		// Loop through all the results
		while (resultSet.next()) {

			// Add the country to the array list
			stateList.add(resultSet.getString("State"));

		}

		// If there are no states in the list, return null
		if (stateList.size() == 0) return null;
		
		// Convert the array list to a string array and return it
		String[] returnArray = new String[stateList.size()];
		returnArray = stateList.toArray(returnArray);
		return returnArray;

	}
	
	public static synchronized String[] getAllCitiesWithinState(String country, String state)
		throws SQLException, SQLWarning, IllegalArgumentException {

		// Check the parameters if there valid
		if (country == null || country.isEmpty()) throw new IllegalArgumentException("Country is invalid");
		if (state == null || state.isEmpty()) throw new IllegalArgumentException("State is invalid");

		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// List of cities
		ArrayList<String> cityList = new ArrayList<>();

		// Create the query to find all distinct cities for the given country and state we have hotels in
	    String query = "SELECT DISTINCT h.City " +
	    			   "FROM Hotel h " +
	    			   "WHERE h.Country = '" + country +"' AND h.State = '" + state + "';";

		// Execute the query
		ResultSet resultSet = sqlSession.executeQuery(query);

		// Loop through all the results
		while (resultSet.next()) {

			// Add the country to the array list
			cityList.add(resultSet.getString("City"));

		}
		
		// If there are no cities in the list, return null
		if (cityList.size() == 0) return null;

		// Convert the array list to a string array and return it
		String[] returnArray = new String[cityList.size()];
		returnArray = cityList.toArray(returnArray);
		return returnArray;

	}
	
	public static synchronized String[][] getAllHotelsWithinCity(String country, String state, String city)
		throws SQLException, SQLWarning, IllegalArgumentException {

		// Check if the parameters are valid
		if (country == null || country.isEmpty()) throw new IllegalArgumentException("Country is invalid");
		if (state == null || state.isEmpty()) throw new IllegalArgumentException("State is invalid");
		if (city == null || city.isEmpty()) throw new IllegalArgumentException("City is invalid");
		
		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// List of hotels
		ArrayList<String[]> hotelList = new ArrayList<String[]>();

		// Create the query to find all distinct cities for the given country and state we have hotels in
		String query = "SELECT DISTINCT h.HotelID, h.Street " +
		   			   "FROM Hotel h " +
		   			   "WHERE h.Country = '" + country +"' AND h.State = '" + state + "' AND h.City = '" + city + "';";

		// Execute the query
		ResultSet resultSet = sqlSession.executeQuery(query);
		
		// Loop through all the results
		while (resultSet.next()) {

			String hotelString[] = {resultSet.getString("HotelID"), resultSet.getString("Street")};
			hotelList.add(hotelString);
			
		}
		
		// If there are no hotels in the list, return null
		if (hotelList.size() == 0) return null;

		// Convert the array list to a string array and return it
		String[][] returnArray = new String[hotelList.size()][2];
		returnArray = hotelList.toArray(returnArray);
		return returnArray;
	}
	
	public static synchronized boolean isValidHotelID(int hotelID) throws SQLException, SQLWarning {
		
		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// Create the query to find all distinct cities for the given country and state we have hotels in
	    String query = "SELECT h.HotelID " +
	    			   "FROM Hotel h " +
	    			   "WHERE h.HotelID = '" + hotelID +"';";
		
		// Execute the query
		ResultSet resultSet = sqlSession.executeQuery(query);

		// If the result set has data, it's next() function will return true, so we may return that value
		return resultSet.next();
	}
	
	public static synchronized Room[] getRoomsAvailable(int hotelID, String startDate, String endDate) throws SQLException, SQLWarning,
		IllegalArgumentException, ParseException {
		
		// Open the SQL connection if it's closed
		openConnectionIfClosed();
		
		// List of rooms
		ArrayList<Room> roomList = new ArrayList<Room>();
		
		// Format the start and end date strings so they are in the proper format
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date startDateObject = simpleDateFormat.parse(startDate);
		java.util.Date endDateObject = simpleDateFormat.parse(endDate);
		String queryStartDate = simpleDateFormat.format(startDateObject);
		String queryEndDate = simpleDateFormat.format(endDateObject);
		
		String query = "SELECT * " +
					   "FROM hotel h, room_and_offerroom r " +
				       "WHERE h.HotelID = " + hotelID + " AND r.HotelID = h.HotelID AND r.Room_no NOT IN (" +
				       		"SELECT r.Room_no " +
				            "FROM hotel h, room_and_offerroom r, reserves p " +
				       		"WHERE h.HotelID = " + hotelID + " AND r.HotelID = h.HotelID AND p.HotelID = h.HotelID AND p.Room_no = r.Room_no) " +
				       "UNION " + 
				       "SELECT * " +
				       "FROM hotel h, room_and_offerroom r, reserves p " +
				       "WHERE h.HotelID = " + hotelID + " AND r.HotelID = h.HotelID AND p.HotelID = h.HotelID AND r.Room_no = p.Room_no " +
				          "AND NOT ('" + queryStartDate + "' <= p.OutDate AND '" + queryEndDate + "' >= p.InDate) AND NOT ('" + queryStartDate +
				          "' > p.InDate AND '" + queryEndDate + "' < p.OutDate);";
		
		
		/** Execute the SQL query */
	    ResultSet resultSet = sqlSession.executeQuery(query);
	    
	    // Loop through all the results
	    while (resultSet.next()) {
	    	
	    	// Create a new room object and add it to the list
	    	Room newRoom = new Room(resultSet.getInt("Room_no"),
	    							resultSet.getInt("HotelID"),
	    							resultSet.getDouble("price"),
	    							resultSet.getInt("capacity"),
	    							resultSet.getInt("Floor_no"),
	    							resultSet.getString("Description"),
	    							resultSet.getString("Type"),
	    							resultSet.getDouble("Discount"),
	    							resultSet.getDate("SDate"),
	    							resultSet.getDate("EDate"));

	    	roomList.add(newRoom);
	 			
	    }
	 		
	    // If there are no rooms in the list, return null
	    if (roomList.size() == 0) return null;

	    // Sort the room list
	    Collections.sort(roomList);
	    
	    // Convert the array list to a string array and return it
	    Room[] returnArray = new Room[roomList.size()];
	    returnArray = roomList.toArray(returnArray);
	    return returnArray;
	    
	}
	
	
	private static synchronized boolean doesCustomerExist(int CID)
			throws SQLException, SQLWarning {

		// Open the SQL connection if it's closed
		openConnectionIfClosed();

		// Create the query to check if the given CID was in the database
		String query = "SELECT CID " +
						"FROM Customer " +
						"WHERE CID = '" + CID + "';";

		// Execute the query
		ResultSet resultSet = sqlSession.executeQuery(query);

		// If the result set has data, it's next() function will return true, so we may return that value
		return resultSet.next();
	}

	private static void openConnectionIfClosed() throws SQLWarning {

		// Attempt to make a connection to the SQL server if one was not already made
		try {
			if (!sqlSession.isConnected()) sqlSession.connect();

		// If there was an issue making the connection, throw a SQLWarning	
		} catch (SQLException sqlException)	{
			throw new SQLWarning();
		}
	}
}