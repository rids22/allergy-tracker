using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace AllergyTracker
{
    public partial class Register : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
                Response.Redirect("Dashboard.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Step 1: Check if username or email already exists
                    SqlCommand checkCmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Users WHERE Username = @Username OR Email = @Email", con);
                    checkCmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                    checkCmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                    int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (exists > 0)
                    {
                        lblMessage.Text = "Username or Email already exists. Please try a different one.";
                        lblMessage.CssClass = "alert-error";
                        lblMessage.Visible = true;
                        return;
                    }

                    // Step 2: Insert new user directly with ADO.NET
                    SqlCommand insertCmd = new SqlCommand(
                        @"INSERT INTO Users (FullName, Email, Username, Password, DateOfBirth, Gender)
                          VALUES (@FullName, @Email, @Username, @Password, @DateOfBirth, @Gender)", con);

                    insertCmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                    insertCmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    insertCmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                    insertCmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());
                    insertCmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);

                    // Handle optional date of birth
                    if (string.IsNullOrEmpty(txtDOB.Text.Trim()))
                        insertCmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);
                    else
                        insertCmd.Parameters.AddWithValue("@DateOfBirth", txtDOB.Text.Trim());

                    insertCmd.ExecuteNonQuery();

                    // Step 3: Show success and redirect
                    lblMessage.Text = "Registration successful! Redirecting to login...";
                    lblMessage.CssClass = "alert-success";
                    lblMessage.Visible = true;

                    Response.AddHeader("Refresh", "2;URL=Login.aspx");
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.CssClass = "alert-error";
                lblMessage.Visible = true;
            }
        }
    }
}