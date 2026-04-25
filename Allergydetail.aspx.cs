using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace AllergyTracker
{
    public partial class AllergyDetail : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                {
                    pnlDetail.Visible = false;
                    pnlError.Visible = true;
                    return;
                }

                int allergyID = Convert.ToInt32(Request.QueryString["id"]);
                int userID = Convert.ToInt32(Session["UserID"]);
                LoadDetail(allergyID, userID);
            }
        }

        void LoadDetail(int allergyID, int userID)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Main allergy details
                SqlCommand cmd = new SqlCommand(
                    @"SELECT a.AllergyName, ac.CategoryName, a.SeverityLevel,
                             a.DiagnosedDate, a.DoctorName, a.Description
                      FROM Allergies a
                      INNER JOIN AllergyCategories ac ON a.CategoryID = ac.CategoryID
                      WHERE a.AllergyID = @AID AND a.UserID = @UID", con);
                cmd.Parameters.AddWithValue("@AID", allergyID);
                cmd.Parameters.AddWithValue("@UID", userID);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblName.Text = dr["AllergyName"].ToString();
                    lblCategory.Text = dr["CategoryName"].ToString();
                    lblSeverity.Text = $"<span class='badge badge-{dr["SeverityLevel"]}'>{dr["SeverityLevel"]}</span>";
                    lblDiagnosed.Text = dr["DiagnosedDate"] == DBNull.Value ? "N/A" :
                                          Convert.ToDateTime(dr["DiagnosedDate"]).ToString("yyyy-MM-dd");
                    lblDoctor.Text = dr["DoctorName"].ToString();
                    lblDescription.Text = dr["Description"].ToString();
                    hlLogIncident.NavigateUrl = "LogIncident.aspx?aid=" + allergyID;
                }
                else
                {
                    pnlDetail.Visible = false;
                    pnlError.Visible = true;
                    return;
                }
                dr.Close();

                // Symptoms
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT SymptomName, Notes FROM Symptoms WHERE AllergyID = @AID", con);
                da.SelectCommand.Parameters.AddWithValue("@AID", allergyID);
                DataTable dtSymp = new DataTable();
                da.Fill(dtSymp);
                gvSymptoms.DataSource = dtSymp;
                gvSymptoms.DataBind();

                // Medications
                da = new SqlDataAdapter(
                    "SELECT MedicationName, Dosage, Frequency, PrescribedBy FROM Medications WHERE AllergyID = @AID", con);
                da.SelectCommand.Parameters.AddWithValue("@AID", allergyID);
                DataTable dtMed = new DataTable();
                da.Fill(dtMed);
                gvMedications.DataSource = dtMed;
                gvMedications.DataBind();

                // Incidents
                da = new SqlDataAdapter(
                    @"SELECT IncidentDate, ReactionDetails, TreatmentTaken, HospitalVisit
                      FROM AllergyIncidents WHERE AllergyID = @AID ORDER BY IncidentDate DESC", con);
                da.SelectCommand.Parameters.AddWithValue("@AID", allergyID);
                DataTable dtInc = new DataTable();
                da.Fill(dtInc);
                gvIncidents.DataSource = dtInc;
                gvIncidents.DataBind();
            }
        }
    }
}