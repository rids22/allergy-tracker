using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllergyTracker
{
    public partial class EmergencyContact : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadContacts();
        }

        void LoadContacts()
        {
            int userID = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT ContactID, ContactName, Relationship, PhoneNumber,
                             ISNULL(Email,'') AS Email, ISNULL(Address,'') AS Address, IsPrimary
                      FROM EmergencyContacts
                      WHERE UserID = @UID
                      ORDER BY IsPrimary DESC, CreatedAt ASC", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvContacts.DataSource = dt;
                gvContacts.DataBind();
                lblCount.Text = "(" + dt.Rows.Count + " contact" + (dt.Rows.Count != 1 ? "s" : "") + ")";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userID = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    
                    if (chkPrimary.Checked)
                    {
                        SqlCommand clearCmd = new SqlCommand(
                            "UPDATE EmergencyContacts SET IsPrimary = 0 WHERE UserID = @UID", con);
                        clearCmd.Parameters.AddWithValue("@UID", userID);
                        clearCmd.ExecuteNonQuery();
                    }

                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO EmergencyContacts
                            (UserID, ContactName, Relationship, PhoneNumber, Email, Address, IsPrimary)
                          VALUES
                            (@UID, @Name, @Rel, @Phone, @Email, @Address, @Primary)", con);

                    cmd.Parameters.AddWithValue("@UID", userID);
                    cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Rel", ddlRelationship.SelectedValue);
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email",
                        string.IsNullOrEmpty(txtEmail.Text) ? (object)DBNull.Value : txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address",
                        string.IsNullOrEmpty(txtAddress.Text) ? (object)DBNull.Value : txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@Primary", chkPrimary.Checked ? 1 : 0);

                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "✅ Contact saved successfully!";
                lblMessage.CssClass = "alert alert-success";
                lblMessage.Visible = true;

                // Clear form
                txtName.Text = "";
                txtPhone.Text = "";
                txtEmail.Text = "";
                txtAddress.Text = "";
                chkPrimary.Checked = false;
                ddlRelationship.SelectedIndex = 0;

                LoadContacts();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.CssClass = "alert alert-error";
                lblMessage.Visible = true;
            }
        }

        protected void gvContacts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int contactID = Convert.ToInt32(e.CommandArgument);
            int userID = Convert.ToInt32(Session["UserID"]);

            try
            {
                if (e.CommandName == "DeleteContact")
                {
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        SqlCommand cmd = new SqlCommand(
                            "DELETE FROM EmergencyContacts WHERE ContactID = @CID AND UserID = @UID", con);
                        cmd.Parameters.AddWithValue("@CID", contactID);
                        cmd.Parameters.AddWithValue("@UID", userID);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                    lblMessage.Text = "🗑 Contact deleted successfully.";
                    lblMessage.CssClass = "alert alert-success";
                    lblMessage.Visible = true;
                }
                else if (e.CommandName == "SetPrimary")
                {
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        con.Open();
                        // Clear all primary
                        SqlCommand clearCmd = new SqlCommand(
                            "UPDATE EmergencyContacts SET IsPrimary = 0 WHERE UserID = @UID", con);
                        clearCmd.Parameters.AddWithValue("@UID", userID);
                        clearCmd.ExecuteNonQuery();

                        // Set new primary
                        SqlCommand setCmd = new SqlCommand(
                            "UPDATE EmergencyContacts SET IsPrimary = 1 WHERE ContactID = @CID AND UserID = @UID", con);
                        setCmd.Parameters.AddWithValue("@CID", contactID);
                        setCmd.Parameters.AddWithValue("@UID", userID);
                        setCmd.ExecuteNonQuery();
                    }
                    lblMessage.Text = "⭐ Primary contact updated!";
                    lblMessage.CssClass = "alert alert-success";
                    lblMessage.Visible = true;
                }

                LoadContacts();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.CssClass = "alert alert-error";
                lblMessage.Visible = true;
            }
        }
    }
}