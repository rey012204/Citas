using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Citas.Helpers
{
    public class HelperFormat
    {
        public static string FormatPhoneNumberForLabel(string phoneNumber)
        {
            string ext;
            bool returnFormatted = false;

            // The countryCode parameter is not being used. It is included for future use in case
            // formatting of phone numbers from other countries is necessary

            if (string.IsNullOrEmpty(phoneNumber))
                phoneNumber = "";
            else
                phoneNumber = phoneNumber.Trim();

            try
            {
                // Here the length of the phone number is checked
                if (phoneNumber == "")
                    // It must not be null
                    return phoneNumber; // we return what was passed in without touching it
                else if (phoneNumber.IndexOf(" ", 0) == -1)
                {
                    // If it DOES NOT contains a "space" (chr(32)) then we check the length of the number
                    // to make sure it is 10 characters long and that it consists of numbers only
                    if (phoneNumber.Length != 10 | !phoneNumber.All(char.IsDigit))
                        return phoneNumber; // we return what was passed in without touching it
                    else
                        returnFormatted = true;
                }
                else if (phoneNumber.IndexOf(" ", 0) > -1)
                {
                    // If it DOES contain a "space" (chr(32)) then we check the length of the number
                    // up to the first space to make sure it is 10 characters long and that it consists of
                    // numbers only
                    if (phoneNumber.Substring(0, phoneNumber.IndexOf(" ", 0)).Length != 10 | !phoneNumber.Substring(0, phoneNumber.IndexOf(" ", 0)).All(char.IsDigit))
                        return phoneNumber; // we return what was passed in without touching it
                    else
                        returnFormatted = true;
                }

                if (returnFormatted)
                {
                    return string.Format("{0:(###) ###-####}", decimal.Parse(phoneNumber.Substring(0, 10)));
                }
                else
                {
                    return phoneNumber;
                }
            }
            catch (Exception ex)
            {
                return phoneNumber;
            }
        }
        public static string FormatPhoneNumberForDB(string phoneNumber)
        {
            string result = "";
            try
            {
                string phoneNumberOnly;
                if (phoneNumber == null)
                    phoneNumber = "";

                if (phoneNumber.Trim() == string.Empty)
                    return string.Empty;

                phoneNumberOnly = phoneNumber;

                // The phone number and extension, if any, are separated.
                if (phoneNumber.IndexOf("x") > -1)
                    phoneNumberOnly = phoneNumber.Substring(0, phoneNumber.IndexOf("x") - 1);
                
                for (int i = 0; i <= phoneNumberOnly.Length-1; i++)
                {
                    if (phoneNumberOnly[i].ToString().All(char.IsDigit)) result += phoneNumberOnly[i].ToString();
                }

                return result;
            }
            catch (Exception ex)
            {
                return phoneNumber;
            }
        }
    }
}