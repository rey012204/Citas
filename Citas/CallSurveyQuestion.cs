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
    
    public partial class CallSurveyQuestion
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public CallSurveyQuestion()
        {
            this.CallSurveyAnswers = new HashSet<CallSurveyAnswer>();
        }
    
        public long CallSurveyQuestionId { get; set; }
        public long CallSurveyId { get; set; }
        public long CallFlowStepId { get; set; }
        public short QuestionType { get; set; }
    
        public virtual CallFlowStepGather CallFlowStepGather { get; set; }
        public virtual CallSurvey CallSurvey { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CallSurveyAnswer> CallSurveyAnswers { get; set; }
        public virtual SurveyQuestionType SurveyQuestionType { get; set; }
    }
}
