<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        Application.Lock();
        Application["OnLineUserCount"] = 0;
        Application["sum"] = 0;
        Application.UnLock();
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        if((Server!=null)&&(Server.GetLastError()!=null)&&(Server.GetLastError().GetBaseException()!=null))
        {
            System.Exception ex = Server.GetLastError().GetBaseException();
            string strMessage = string.Format("{0},Time:{1:yyyy/mm/dd-hh:mm:ss},Path:{2},UserIP:{3}",
                ex.Message, System.DateTime.Now, Request.PhysicalPath, Request.UserHostAddress);
            Application.Lock();
            System.IO.StreamWriter oStreamWriter = null;
            try
            {
                string strApplicationPath = "~/App_Data/Log/Application.log";
                string strApplicationPathName = Server.MapPath(strApplicationPath);
                oStreamWriter = new System.IO.StreamWriter(strApplicationPathName, true, System.Text.Encoding.UTF8);
                oStreamWriter.WriteLine(strMessage);
            }
            catch
            {
                
              
            }
            finally
            {
                if(oStreamWriter!=null)
                {
                    oStreamWriter.Dispose();
                    oStreamWriter = null;
                }
            }
            Application.UnLock();
        }

    }

    void Session_Start(object sender, EventArgs e) 
    {
        Application.Lock();
        Application["OnLineUserCount"] = Convert.ToInt64(Application["OnLineUserCount"]) + 1;
        Application["sum"] = Convert.ToInt64(Application["sum"]) + 1;
        Application.UnLock();
    }

    void Session_End(object sender, EventArgs e) 
    {

        Application.Lock();
        Application["OnLineUserCount"] = Convert.ToInt64(Application["OnLineUserCount"]) -1;
        Application.UnLock();
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
       
</script>
