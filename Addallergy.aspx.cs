using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace AllergyTracker
{
    public partial class AddAllergy : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadCategories();
        }

        void LoadCategories()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT CategoryID, CategoryName FROM AllergyCategories ORDER BY CategoryName", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCategory.DataSource = dt;
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataBind();
                ddlCategory.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Category --", "0"));
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userID = Convert.ToInt32(Session["UserID"]);
            int newAllergyID = 0;

            try
            {
                // ── Step 1: Insert Allergy (separate connection, closed before next step) ──
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO Allergies (UserID, CategoryID, AllergyName, Description, SeverityLevel, DiagnosedDate, DoctorName)
                          VALUES (@UserID, @CategoryID, @AllergyName, @Description, @SeverityLevel, @DiagnosedDate, @DoctorName);
                          SELECT CAST(SCOPE_IDENTITY() AS INT);", con);

                    cmd.Parameters.AddWithValue("@UserID", userID);
                    cmd.Parameters.AddWithValue("@CategoryID", Convert.ToInt32(ddlCategory.SelectedValue));
                    cmd.Parameters.AddWithValue("@AllergyName", txtAllergyName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@SeverityLevel", ddlSeverity.SelectedValue);
                    cmd.Parameters.AddWithValue("@DiagnosedDate",
                        string.IsNullOrEmpty(txtDiagnosedDate.Text) ? (object)DBNull.Value : txtDiagnosedDate.Text.Trim());
                    cmd.Parameters.AddWithValue("@DoctorName",
                        string.IsNullOrEmpty(txtDoctorName.Text) ? (object)DBNull.Value : txtDoctorName.Text.Trim());

                    con.Open();
                    // ExecuteScalar returns the new ID — no open reader issue
                    newAllergyID = Convert.ToInt32(cmd.ExecuteScalar());
                }   // ← connection closed here before next steps

                // ── Step 2: Insert Symptoms (new connection) ──
                string[] symptoms = {
                    txtSymptom1.Text.Trim(),
                    txtSymptom2.Text.Trim(),
                    txtSymptom3.Text.Trim()
                };

                foreach (string s in symptoms)
                {
                    if (!string.IsNullOrEmpty(s))
                    {
                        using (SqlConnection con = new SqlConnection(connStr))
                        {
                            SqlCommand cmd = new SqlCommand(
                                "INSERT INTO Symptoms (AllergyID, SymptomName) VALUES (@AID, @SName)", con);
                            cmd.Parameters.AddWithValue("@AID", newAllergyID);
                            cmd.Parameters.AddWithValue("@SName", s);
                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                // ── Step 3: Insert Medication if provided (new connection) ──
                if (!string.IsNullOrEmpty(txtMedName.Text.Trim()))
                {
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        SqlCommand cmd = new SqlCommand(
                            @"INSERT INTO Medications (AllergyID, MedicationName, Dosage, Frequency)
                              VALUES (@AID, @MName, @Dosage, @Freq)", con);

                        cmd.Parameters.AddWithValue("@AID", newAllergyID);
                        cmd.Parameters.AddWithValue("@MName", txtMedName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Dosage",
                            string.IsNullOrEmpty(txtDosage.Text) ? (object)DBNull.Value : txtDosage.Text.Trim());
                        cmd.Parameters.AddWithValue("@Freq",
                            string.IsNullOrEmpty(txtFrequency.Text) ? (object)DBNull.Value : txtFrequency.Text.Trim());
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // ── Step 4: Show success and clear form ──
                lblMessage.Text = "Allergy saved successfully! <a href='Dashboard.aspx'>Go to Dashboard</a>";
                lblMessage.CssClass = "alert-success";
                lblMessage.Visible = true;

                txtAllergyName.Text = "";
                txtDescription.Text = "";
                txtDiagnosedDate.Text = "";
                txtDoctorName.Text = "";
                txtSymptom1.Text = "";
                txtSymptom2.Text = "";
                txtSymptom3.Text = "";
                txtMedName.Text = "";
                txtDosage.Text = "";
                txtFrequency.Text = "";
                ddlSeverity.SelectedIndex = 0;
                ddlCategory.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving allergy: " + ex.Message;
                lblMessage.CssClass = "alert-error";
                lblMessage.Visible = true;
            }
        }
    }
}