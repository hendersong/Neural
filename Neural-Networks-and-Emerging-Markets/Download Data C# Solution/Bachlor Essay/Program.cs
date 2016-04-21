using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Data.Entity;

namespace Bachlor_Essay
{
    class Program
    {
        /* THis program downloads historic India GDP data, historic U.S. Bond Yields, and historic prices for all tickers on the NSE (Indian Stock Exchange). It calculates the RSI, MACD and Signal line
        for the historic prices for each stock, and inserts all the above data into a SQL database.
        Last Edited: 4/21/2016
        Created by: Gabe Henderson
        */

        static void Main(string[] args)
        {
            //connect to database through Entity Relationship
            Bachlor_EssayEntities db = new Bachlor_EssayEntities();
            //url for Quandl Data
            string india_GDP = "https://www.quandl.com/api/v3/datasets/ODA/IND_NGDPD.csv?start_date=2000-01-01?auth_token=B8sK7V6UPsviYsy4pNFF";
            string us_yield = "https://www.quandl.com/api/v3/datasets/USTREASURY/YIELD.csv?start_date=2000-01-01?auth_token=B8sK7V6UPsviYsy4pNFF";

            //actually download
            Download_Macro(india_GDP, db);
            download_us_bond_yields(us_yield, db);
            Download_prices(db);

            
            Console.WriteLine("Done");
            Console.ReadKey();

        }
        static void download_us_bond_yields(string URL, Bachlor_EssayEntities db)
        {
            //connect to quandl
            WebClient streamUrl = new WebClient();
            streamUrl.BaseAddress = URL;
            string URI = URL;
            Stream d = streamUrl.OpenRead(URI);
            StreamReader reader = new StreamReader(d);

            while (reader.Peek() > 0)
            {
                //download the split the returned string
                string s = reader.ReadLine();
                
                string[] data= s.Split(',');
                US_Yield g = new US_Yield();
                double c;
                //make sure you arent getting headers, if its a number push to database
                bool can = double.TryParse(data[1], out c);
                if (!can)
                {
                    continue;
                }
                g.Date_of_Bond = Convert.ToDateTime(data[0]);
                if(!String.IsNullOrEmpty(data[1]))
                    g.one_mo = Convert.ToDouble(data[1]);
                if (!String.IsNullOrEmpty(data[2]))
                    g.three_mo = Convert.ToDouble(data[2]);
                if (!String.IsNullOrEmpty(data[3]))
                    g.six_mo = Convert.ToDouble(data[3]);
                if (!String.IsNullOrEmpty(data[4]))
                    g.one_yr = Convert.ToDouble(data[4]);
                if (!String.IsNullOrEmpty(data[5]))
                    g.two_yr = Convert.ToDouble(data[5]);
                if (!String.IsNullOrEmpty(data[6]))
                    g.three_yr = Convert.ToDouble(data[6]);
                if (!String.IsNullOrEmpty(data[7]))
                    g.five_yr = Convert.ToDouble(data[7]);
                if (!String.IsNullOrEmpty(data[8]))
                    g.seven_yr = Convert.ToDouble(data[8]);
                if (!String.IsNullOrEmpty(data[9]))
                    g.ten_yr = Convert.ToDouble(data[9]);
                if (!String.IsNullOrEmpty(data[10]))
                    g.twenty_yr = Convert.ToDouble(data[10]);
                if (!String.IsNullOrEmpty(data[11]))
                    g.thirty_yr = Convert.ToDouble(data[11]);
                db.US_Yield.Add(g);
                
            }
            d.Close();
            reader.Close();
            db.SaveChanges();
            Console.WriteLine("Us Bond Yields Done");
        }
        static void Download_Macro(string URL, Bachlor_EssayEntities db)
        {
            string India_GDP = URL;
            WebClient streamUrl = new WebClient();
            streamUrl.BaseAddress = India_GDP;
            string URI = India_GDP;
            Stream data = streamUrl.OpenRead(URI);
            StreamReader reader = new StreamReader(data);
            while (reader.Peek() > 0)
            {
                string s = reader.ReadLine();
                string[] data_string = s.Split(',');
                India_GDP g = new India_GDP();
                double c;
                bool can = double.TryParse(data_string[1], out c);
                if (!can)
                {
                    continue;
                }
                g.Date_of_GDP = Convert.ToDateTime(data_string[0]);
                g.GDP = Convert.ToDouble(data_string[1]);
                db.India_GDP.Add(g);
            }
            data.Close();
            reader.Close();
            db.SaveChanges();
            Console.WriteLine("India Yields Done");
        }
        static void Download_prices(Bachlor_EssayEntities db)
        {
                //connect to database
                
                DateTime today = DateTime.Today;
                String error;
                //file with all the tickers on the NSE, split out each ticker individually
                string ticker_file = @"C:\Users\Gabe Henderson\Google Drive\Senior Year\Second Semester\Bachlors Essay\Neural\Neural-Networks-and-Emerging-Markets\Tickers.txt";
                string text = System.IO.File.ReadAllText(ticker_file);
                string[] tickers = text.Split(',');
                foreach (String ticker in tickers) {
                    //build the URL to connect to google and get the data
                    GoogleFinanceDownloader.DownloadURIBuilder a = new GoogleFinanceDownloader.DownloadURIBuilder("NSE", ticker);
                    String URL = a.getGetPricesUrlToDownloadAllData(today);
                    GoogleFinanceDownloader.DataProcessor process = new GoogleFinanceDownloader.DataProcessor();
                    WebClient streamUrl = new WebClient();
                    streamUrl.BaseAddress = URL;
                    String data = process.processStreamMadeOfOneDayLinesToExtractHistoricalData(streamUrl.OpenRead(URL), out error);
                    //split out each day
                    String[] b = data.Split('\n');
                   
                    //used for calculating technicals
                    double previous_price = 1;
                    int j = 1;
                    double Average_up = 0;
                    double Average_down = 0;
                    double SMA = 0;
                    double EMA26 = 0;
                    double EMA12 = 0;
                    double MACD_EMA9 = 0;
                    //formula for multiplier is 2/(timer period+1)
                    double smooth26 = 2.0 / (26 + 1);
                    double smooth12 = 2.0 / (12 + 1);
                    double smooth9 = 2.0 / (9 + 1);
                    double MACD = 0;
                    double Avg_Macd = 0;
                


                //for each day, split out the volume for the day, open and close prices, and date, calculate percent change from the day before
                foreach (String i in b)
                    {
                    MACD m = new MACD();
                    RSI r = new RSI();
                    Historic_NSE_Date g = new Historic_NSE_Date();
                    String[] array = i.Split(',');
                        if (array.Length < 5)
                            continue;
                        double c;
                        bool can = double.TryParse(array[1], out c);
                        if (!can)
                        {
                            continue;
                        }
                        g.Date_of_Price = Convert.ToDateTime(array[0]);
                        g.Ticker = ticker;
                        g.Open_Price = Convert.ToDouble(array[1]);
                        double close= Convert.ToDouble(array[4]);
                        g.Close_Price = close;
                        g.Volume = Convert.ToDouble(array[5]);
                        double percent_change= Convert.ToDouble(g.Close_Price) / previous_price - 1;
                        g.percent_change = percent_change;
                        previous_price = Convert.ToDouble(g.Close_Price);
                      
                    //
                    //
                    //calculating rsi. First 14 periods, simply sum the ups and downs seperately

                    
                    if (j < 15)
                    {
                        if (percent_change < 0)
                            Average_down = (Average_down*(j-1)+Math.Abs(percent_change))/j;
                        else
                            Average_up =(Average_down*(j-1)+ percent_change)/j;
                    }
                    //past the first 14 periods
                    else {                                                
                        if (percent_change < 0)
                        {
                            Average_down= (Average_down*13+Math.Abs(percent_change))/ 14;
                        }
                        else
                        {
                            Average_up = (Average_up * 13 + percent_change) / 14;
                        }
                            }
                    //calculate RSI
                    double RSI = 100-(100/( 1+(Average_up / Average_down)));
                    r.ticker = ticker;
                    r.date_t = Convert.ToDateTime(array[0]);
                    if (!Double.IsNaN(RSI))
                        r.RSI1 = RSI / 1;
                    else
                        r.RSI1 = null;
                    ///
                    ///calculating MACD
                    /// 
                    //MACD, first part just get SMA off the close price
                    SMA += close;
                    if (j == 12)
                        EMA12 = SMA / j;
                    if (j == 26)
                        EMA26 = SMA / j;
                    //calculate EMAS to finally calc macd
                    EMA12 = (close - EMA12) * smooth12 + EMA12;
                    EMA26 = (close - EMA26) * smooth26 + EMA26;
                    MACD = EMA12 - EMA26;
                    //calc signal line
                    Avg_Macd = Avg_Macd + MACD;
                    if (j == 9)
                        MACD_EMA9 = Avg_Macd / j;
                    if (j>9)
                        MACD_EMA9 = (MACD * smooth9) + MACD_EMA9*(1-smooth9);
                    //transfer
                    m.Ticker = ticker;
                    m.Date_of_Price = Convert.ToDateTime(array[0]);
                    m.MACD1 = MACD;
                    m.signal = MACD_EMA9;
                    //
                    //
                    
                    j++;
                    //insert into the database
                    db.Historic_NSE_Date.Add(g);
                    db.RSIs.Add(r);
                    db.MACDs.Add(m);


                }
                try {
                    db.SaveChanges();
                    Console.WriteLine(ticker);
                }
                catch(Exception e)
                {
                    Console.WriteLine("{0} Exception caught.", e);
                }
            }
            Console.WriteLine("India Stock Prices and technicals Done");
        }




        
    }
}
