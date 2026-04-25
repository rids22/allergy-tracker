using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllergyTracker
{
    public partial class Dashboard : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;
        List<DateTime> incidentDates = new List<DateTime>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) Response.Redirect("Login.aspx");

            int userID = Convert.ToInt32(Session["UserID"]);
            lblWelcome.Text = Session["FullName"].ToString();
            lblNavUser.Text = "👤 " + Session["Username"].ToString();

            if (!IsPostBack)
            {
                LoadSummaryCards(userID);
                LoadAllergies(userID);
                LoadIncidents(userID);
                LoadChartData(userID);
            }
            LoadIncidentDates(userID);
        }

        void LoadSummaryCards(int userID)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd;

                cmd = new SqlCommand("SELECT COUNT(*) FROM Allergies WHERE UserID=@UID", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                lblTotalAllergies.Text = cmd.ExecuteScalar().ToString();

                cmd = new SqlCommand("SELECT COUNT(*) FROM Allergies WHERE UserID=@UID AND SeverityLevel='Severe'", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                lblSevere.Text = cmd.ExecuteScalar().ToString();

                cmd = new SqlCommand("SELECT COUNT(*) FROM AllergyIncidents WHERE UserID=@UID", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                lblIncidents.Text = cmd.ExecuteScalar().ToString();

                cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Medications m INNER JOIN Allergies a ON m.AllergyID=a.AllergyID WHERE a.UserID=@UID", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                lblMedications.Text = cmd.ExecuteScalar().ToString();
            }
        }

        void LoadAllergies(int userID)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("sp_GetUserAllergies", con);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.SelectCommand.Parameters.AddWithValue("@UserID", userID);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvAllergies.DataSource = dt;
                gvAllergies.DataBind();
            }
        }

        void LoadIncidents(int userID)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT TOP 10 a.AllergyName, ai.IncidentDate, ai.ReactionDetails,
                             ai.TreatmentTaken, ai.HospitalVisit
                      FROM AllergyIncidents ai
                      INNER JOIN Allergies a ON ai.AllergyID=a.AllergyID
                      WHERE ai.UserID=@UID ORDER BY ai.IncidentDate DESC", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvIncidents.DataSource = dt;
                gvIncidents.DataBind();
            }
        }

        void LoadChartData(int userID)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT ac.CategoryName, COUNT(*) as Total
                      FROM Allergies a
                      INNER JOIN AllergyCategories ac ON a.CategoryID=ac.CategoryID
                      WHERE a.UserID=@UID
                      GROUP BY ac.CategoryName", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Build JS arrays for Chart.js
                var labels = new System.Text.StringBuilder();
                var values = new System.Text.StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    labels.Append($"'{row["CategoryName"]}',");
                    values.Append($"{row["Total"]},");
                }

                string labelsStr = labels.ToString().TrimEnd(',');
                string valuesStr = values.ToString().TrimEnd(',');

                // Inject into hidden fields for JS to read
                hfChartLabels.Value = labelsStr;
                hfChartValues.Value = valuesStr;
            }
        }

        void LoadIncidentDates(int userID)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT DISTINCT IncidentDate FROM AllergyIncidents WHERE UserID=@UID", con);
                cmd.Parameters.AddWithValue("@UID", userID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                    incidentDates.Add(Convert.ToDateTime(dr["IncidentDate"]));
            }
        }

        protected void calIncidents_DayRender(object sender, DayRenderEventArgs e)
        {
            if (incidentDates.Contains(e.Day.Date))
            {
                e.Cell.BackColor = System.Drawing.Color.FromArgb(248, 215, 218);
                e.Cell.ForeColor = System.Drawing.Color.FromArgb(114, 28, 36);
                e.Cell.Font.Bold = true;
            }
        }

        protected void gvAllergies_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int allergyID = Convert.ToInt32(e.CommandArgument);
            int userID = Convert.ToInt32(Session["UserID"]);

            if (e.CommandName == "ViewDetail")
                Response.Redirect("AllergyDetail.aspx?id=" + allergyID);
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Allergies WHERE AllergyID=@AID AND UserID=@UID", con);
                    cmd.Parameters.AddWithValue("@AID", allergyID);
                    cmd.Parameters.AddWithValue("@UID", userID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadAllergies(userID);
                LoadSummaryCards(userID);
                LoadChartData(userID);
            }
        }
    }
}