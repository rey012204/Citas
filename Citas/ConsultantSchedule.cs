//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Citas
{
    using System;
    using System.Collections.Generic;
    
    public partial class ConsultantSchedule
    {
        public long ConsultantScheduleId { get; set; }
        public long ConsultantId { get; set; }
        public long LocationId { get; set; }
        public short DayOfWeek { get; set; }
        public System.TimeSpan StartTime { get; set; }
        public System.TimeSpan EndTime { get; set; }
    
        public virtual ClientLocation ClientLocation { get; set; }
        public virtual Consultant Consultant { get; set; }
    }
}
