using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllergyTracker
{
    public partial class MedicineReminder : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["AllergyTrackerDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) Response.Redirect("Login.aspx");
            if (!IsPostBack) LoadReminders();
        }

        void LoadReminders()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            int total = 0;

            // Load each time slot separately and show empty label if no data
            DataTable dtMorning = GetReminders(userID, "Morning");
            rptMorning.DataSource = dtMorning;
            rptMorning.DataBind();
            lblNoMorning.Visible = dtMorning.Rows.Count == 0;
            total += dtMorning.Rows.Count;

            DataTable dtAfternoon = GetReminders(userID, "Afternoon");
            rptAfternoon.DataSource = dtAfternoon;
            rptAfternoon.DataBind();
            lblNoAfternoon.Visible = dtAfternoon.Rows.Count == 0;
            total += dtAfternoon.Rows.Count;

            DataTable dtEvening = GetReminders(userID, "Evening");
            rptEvening.DataSource = dtEvening;
            rptEvening.DataBind();
            lblNoEvening.Visible = dtEvening.Rows.Count == 0;
            total += dtEvening.Rows.Count;

            DataTable dtNight = GetReminders(userID, "Night");
            rptNight.DataSource = dtNight;
            rptNight.DataBind();
            lblNoNight.Visible = dtNight.Rows.Count == 0;
            total += dtNight.Rows.Count;

            lblCount.Text = total + " reminder(s)";
        }

        DataTable GetReminders(int userID, string timeOfDay)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT ReminderID, MedicineName, Dosage, TimeOfDay,
                             Frequency, StartDate, EndDate, IsActive, Notes
                      FROM MedicineReminders
                      WHERE UserID = @UID AND TimeOfDay = @Time
                      ORDER BY IsActive DESC, MedicineName", con);
                da.SelectCommand.Parameters.AddWithValue("@UID", userID);
                da.SelectCommand.Parameters.AddWithValue("@Time", timeOfDay);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
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
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO MedicineReminders
                            (UserID, MedicineName, Dosage, TimeOfDay, Frequency, StartDate, EndDate, Notes)
                          VALUES
                            (@UID, @Name, @Dosage, @Time, @Freq, @Start, @End, @Notes)", con);

                    cmd.Parameters.AddWithValue("@UID", userID);
                    cmd.Parameters.AddWithValue("@Name", txtMedName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Dosage", string.IsNullOrEmpty(txtDosage.Text) ? (object)DBNull.Value : txtDosage.Text.Trim());
                    cmd.Parameters.AddWithValue("@Time", ddlTime.SelectedValue);
                    cmd.Parameters.AddWithValue("@Freq", ddlFrequency.SelectedValue);
                    cmd.Parameters.AddWithValue("@Start", string.IsNullOrEmpty(txtStart.Text) ? (object)DBNull.Value : txtStart.Text.Trim());
                    cmd.Parameters.AddWithValue("@End", string.IsNullOrEmpty(txtEnd.Text) ? (object)DBNull.Value : txtEnd.Text.Trim());
                    cmd.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(txtNotes.Text) ? (object)DBNull.Value : txtNotes.Text.Trim());

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMsg.Text = "✅ Reminder saved successfully!";
                lblMsg.CssClass = "alert alert-success";
                lblMsg.Visible = true;

                // Clear form
                txtMedName.Text = ""; txtDosage.Text = "";
                txtStart.Text = ""; txtEnd.Text = ""; txtNotes.Text = "";
                ddlTime.SelectedIndex = 0; ddlFrequency.SelectedIndex = 0;

                LoadReminders();
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.CssClass = "alert alert-error";
                lblMsg.Visible = true;
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int rid = Convert.ToInt32(e.CommandArgument);
            int userID = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                if (e.CommandName == "Delete")
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM MedicineReminders WHERE ReminderID=@RID AND UserID=@UID", con);
                    cmd.Parameters.AddWithValue("@RID", rid);
                    cmd.Parameters.AddWithValue("@UID", userID);
                    cmd.ExecuteNonQuery();
                }
                else if (e.CommandName == "Toggle")
                {
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE MedicineReminders
                          SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END
                          WHERE ReminderID=@RID AND UserID=@UID", con);
                    cmd.Parameters.AddWithValue("@RID", rid);
                    cmd.Parameters.AddWithValue("@UID", userID);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadReminders();
        }
    }
}