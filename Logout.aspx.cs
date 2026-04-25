using System;
using System.Web.UI;

namespace AllergyTracker
{
    public partial class Logout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear all session data (State Management)
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}