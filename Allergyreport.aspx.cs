using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace AllergyTracker
{
    public partial class AllergyReport : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) Response.Redirect("Login.aspx");
            if (!IsPostBack) LoadReport();
        }

        void LoadReport()
        {
            int userID = Convert.ToInt32(Session["UserID"]);

            lblPatientName.Text = Session["FullName"].ToString();
            lblUsername.Text = Session["Username"].ToString();
            lblDate.Text = DateTime.Now.ToString("dd MMM yyyy, hh:mm tt");
            lblFooterDate.Text = DateTime.Now.ToString("dd MMM yyyy");

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Summary counts
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Allergies WHERE UserID=@UID", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                lblTotal.Text = cmd.ExecuteScalar().ToString();

                cmd = new SqlCommand("SELECT COUNT(*) FROM Allergies WHERE UserID=@UID AND SeverityLevel='Severe'", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                lblSevere.Text = cmd.ExecuteScalar().ToString();

                cmd = new SqlCommand("SELECT COUNT(*) FROM Allergies WHERE UserID=@UID AND SeverityLevel='Moderate'", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                lblModerate.Text = cmd.ExecuteScalar().ToString();

                cmd = new SqlCommand("SELECT COUNT(*) FROM Allergies WHERE UserID=@UID AND SeverityLevel='Mild'", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                lblMild.Text = cmd.ExecuteScalar().ToString();

                // Primary emergency contact
                cmd = new SqlCommand(
                    "SELECT TOP 1 ContactName, Relationship, PhoneNumber, Email FROM EmergencyContacts WHERE UserID=@UID AND IsPrimary=1", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                    lblEmergency.Text = $"<div class='ec-row'><strong>{dr["ContactName"]}</strong> ({dr["Relationship"]})</div>" +
                                        $"<div class='ec-row'>📞 {dr["PhoneNumber"]}" +
                                        (!string.IsNullOrEmpty(dr["Email"].ToString()) ? $" &nbsp;|&nbsp; ✉️ {dr["Email"]}" : "") + "</div>";
                else
                    lblEmergency.Text = "<div class='ec-row' style='color:#999;'>No primary emergency contact set. <a href='EmergencyContact.aspx'>Add one</a></div>";
                dr.Close();

                // Allergies
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT a.AllergyName, ac.CategoryName, a.SeverityLevel, a.DiagnosedDate, a.DoctorName
                      FROM Allergies a INNER JOIN AllergyCategories ac ON a.CategoryID=ac.CategoryID
                      WHERE a.UserID=@UID ORDER BY a.SeverityLevel DESC", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                DataTable dt = new DataTable(); da.Fill(dt);
                gvAllergies.DataSource = dt; gvAllergies.DataBind();

                // Symptoms
                da = new SqlDataAdapter(
                    @"SELECT a.AllergyName, s.SymptomName, s.Notes
                      FROM Symptoms s INNER JOIN Allergies a ON s.AllergyID=a.AllergyID
                      WHERE a.UserID=@UID ORDER BY a.AllergyName", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                dt = new DataTable(); da.Fill(dt);
                gvSymptoms.DataSource = dt; gvSymptoms.DataBind();

                // Medications
                da = new SqlDataAdapter(
                    @"SELECT a.AllergyName, m.MedicationName, m.Dosage, m.Frequency, m.PrescribedBy
                      FROM Medications m INNER JOIN Allergies a ON m.AllergyID=a.AllergyID
                      WHERE a.UserID=@UID ORDER BY a.AllergyName", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                dt = new DataTable(); da.Fill(dt);
                gvMeds.DataSource = dt; gvMeds.DataBind();

                // Incidents
                da = new SqlDataAdapter(
                    @"SELECT a.AllergyName, ai.IncidentDate, ai.ReactionDetails, ai.TreatmentTaken, ai.HospitalVisit
                      FROM AllergyIncidents ai INNER JOIN Allergies a ON ai.AllergyID=a.AllergyID
                      WHERE ai.UserID=@UID ORDER BY ai.IncidentDate DESC", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                dt = new DataTable(); da.Fill(dt);
                gvIncidents.DataSource = dt; gvIncidents.DataBind();
            }
        }
    }
}