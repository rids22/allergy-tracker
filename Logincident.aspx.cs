using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace AllergyTracker
{
    public partial class LogIncident : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadUserAllergies();

                // Pre-select allergy if passed via query string
                if (Request.QueryString["aid"] != null)
                {
                    string aid = Request.QueryString["aid"];
                    if (ddlAllergy.Items.FindByValue(aid) != null)
                        ddlAllergy.SelectedValue = aid;
                }
            }
        }

        void LoadUserAllergies()
        {
            int userID = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT AllergyID, AllergyName FROM Allergies WHERE UserID = @UID ORDER BY AllergyName", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlAllergy.DataSource = dt;
                ddlAllergy.DataTextField = "AllergyName";
                ddlAllergy.DataValueField = "AllergyID";
                ddlAllergy.DataBind();
                ddlAllergy.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Allergy --", "0"));
            }
        }

        protected void btnLog_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userID = Convert.ToInt32(Session["UserID"]);
            int allergyID = Convert.ToInt32(ddlAllergy.SelectedValue);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_LogIncident", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@AllergyID", allergyID);
                cmd.Parameters.AddWithValue("@UserID", userID);
                cmd.Parameters.AddWithValue("@IncidentDate", txtIncidentDate.Text.Trim());
                cmd.Parameters.AddWithValue("@ReactionDetails", txtReaction.Text.Trim());
                cmd.Parameters.AddWithValue("@TreatmentTaken",
                    string.IsNullOrEmpty(txtTreatment.Text) ? (object)DBNull.Value : txtTreatment.Text.Trim());
                cmd.Parameters.AddWithValue("@HospitalVisit", chkHospital.Checked ? 1 : 0);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "✅ Incident logged successfully! <a href='Dashboard.aspx'>Go to Dashboard</a>";
            lblMessage.CssClass = "alert-success";
            lblMessage.Visible = true;

            // Clear form
            txtIncidentDate.Text = "";
            txtReaction.Text = "";
            txtTreatment.Text = "";
            chkHospital.Checked = false;
        }
    }
}