package Group27;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import com.mysql.jdbc.Driver;

public class SQLSession {

	private static final String MY_SQL_URL = "jdbc:mysql://localhost:3306/cs336";
	private static final String SQL_USERNAME = "root";
	private static final String SQL_PASSWORD = "xn9KKPz.a7u-8B7k";

	private Connection connection;

	public synchronized void connect()
			throws SQLException {

		try {
			Class.forName("com.mysql.jdbc.Driver");
			connection = DriverManager.getConnection(MY_SQL_URL, SQL_USERNAME, SQL_PASSWORD);
		} catch (ClassNotFoundException classNotFoundException) {
			System.out.println("Error! The JDBC Driver was not found in the class path!");
			System.exit(0);
		}
	}

	public synchronized void disconnect()
			throws IllegalStateException, SQLException {

		if (!isConnected()) throw new IllegalStateException("SQL Session is not connected");
		connection.commit();
		connection.close();
	}

	public synchronized boolean isConnected() throws SQLException {
		boolean returnBoolean = false;
		try {
			returnBoolean = !connection.isClosed();
		} catch (NullPointerException nullPointerException) {
			return false;
		}
		return returnBoolean;
	}

	public synchronized ResultSet executeQuery(String query)
			throws IllegalStateException, SQLException, NullPointerException {

		if (query == null || query.isEmpty()) throw new NullPointerException();
		if (!isConnected()) throw new IllegalStateException("SQL Session is not connected");
		Statement statement = connection.createStatement();
		return statement.executeQuery(query);
	}

	public synchronized int executeUpdate(String query)
		throws IllegalStateException, SQLException, NullPointerException {

		if (query == null || query.isEmpty()) throw new NullPointerException();
		if (!isConnected()) throw new IllegalStateException("SQL Session is not connected");
		Statement statement = connection.createStatement();
		return statement.executeUpdate(query);
	}
}