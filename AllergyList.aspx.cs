using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllergyTracker
{
    public partial class AllergyList : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadCategoryFilter();
                LoadAllergies("AllergyID", "ASC", "", "", "");
            }
        }

        void LoadCategoryFilter()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT CategoryID, CategoryName FROM AllergyCategories ORDER BY CategoryName", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlFilterCategory.DataSource = dt;
                ddlFilterCategory.DataTextField = "CategoryName";
                ddlFilterCategory.DataValueField = "CategoryID";
                ddlFilterCategory.DataBind();
                ddlFilterCategory.Items.Insert(0, new ListItem("All Categories", ""));
            }
        }

        void LoadAllergies(string sortCol, string sortDir, string search, string severity, string category)
        {
            int userID = Convert.ToInt32(Session["UserID"]);

            string query = @"SELECT a.AllergyID, a.AllergyName, ac.CategoryName,
                                    a.SeverityLevel, a.DiagnosedDate, a.DoctorName
                             FROM Allergies a
                             INNER JOIN AllergyCategories ac ON a.CategoryID = ac.CategoryID
                             WHERE a.UserID = @UID";

            if (!string.IsNullOrEmpty(search))
                query += " AND a.AllergyName LIKE @Search";
            if (!string.IsNullOrEmpty(severity))
                query += " AND a.SeverityLevel = @Severity";
            if (!string.IsNullOrEmpty(category))
                query += " AND ac.CategoryID = @Category";

            query += $" ORDER BY {sortCol} {sortDir}";

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                if (!string.IsNullOrEmpty(search))
                    da.SelectCommand.Parameters.AddWithValue("@Search", "%" + search + "%");
                if (!string.IsNullOrEmpty(severity))
                    da.SelectCommand.Parameters.AddWithValue("@Severity", severity);
                if (!string.IsNullOrEmpty(category))
                    da.SelectCommand.Parameters.AddWithValue("@Category", category);

                DataTable dt = new DataTable();
                da.Fill(dt);
                ViewState["AllergyData"] = dt;
                gvAllergies.DataSource = dt;
                gvAllergies.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvAllergies.PageIndex = 0;
            LoadAllergies("AllergyID", "ASC",
                txtSearch.Text.Trim(),
                ddlFilterSeverity.SelectedValue,
                ddlFilterCategory.SelectedValue);
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlFilterSeverity.SelectedIndex = 0;
            ddlFilterCategory.SelectedIndex = 0;
            gvAllergies.PageIndex = 0;
            LoadAllergies("AllergyID", "ASC", "", "", "");
        }

        protected void gvAllergies_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAllergies.PageIndex = e.NewPageIndex;
            LoadAllergies("AllergyID", "ASC",
                txtSearch.Text.Trim(),
                ddlFilterSeverity.SelectedValue,
                ddlFilterCategory.SelectedValue);
        }

        protected void gvAllergies_Sorting(object sender, GridViewSortEventArgs e)
        {
            string dir = ViewState["SortDir"] != null && ViewState["SortDir"].ToString() == "ASC" ? "DESC" : "ASC";
            ViewState["SortDir"] = dir;
            LoadAllergies(e.SortExpression, dir,
                txtSearch.Text.Trim(),
                ddlFilterSeverity.SelectedValue,
                ddlFilterCategory.SelectedValue);
        }

        protected void gvAllergies_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int allergyID = Convert.ToInt32(e.CommandArgument);
            int userID = Convert.ToInt32(Session["UserID"]);

            if (e.CommandName == "ViewDetail")
            {
                Response.Redirect("AllergyDetail.aspx?id=" + allergyID);
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Allergies WHERE AllergyID = @AID AND UserID = @UID", con);
                    cmd.Parameters.AddWithValue("@AID", allergyID);
                    cmd.Parameters.AddWithValue("@UID", userID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadAllergies("AllergyID", "ASC", "", "", "");
            }
        }
    }
}