using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace AllergyTracker
{
    public partial class Login : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
                Response.Redirect("Dashboard.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    // Direct SQL query - no stored procedure needed
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT UserID, FullName, Email, Username
                          FROM Users
                          WHERE Username = @Username AND Password = @Password", con);

                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // Store user info in Session (State Management)
                        Session["UserID"] = dr["UserID"].ToString();
                        Session["FullName"] = dr["FullName"].ToString();
                        Session["Username"] = dr["Username"].ToString();

                        dr.Close();
                        Response.Redirect("Dashboard.aspx");
                    }
                    else
                    {
                        dr.Close();
                        lblMessage.Text = "Invalid username or password. Please try again.";
                        lblMessage.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.Visible = true;
            }
        }
    }
}