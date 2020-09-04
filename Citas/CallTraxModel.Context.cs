﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class CallTraxEntities : DbContext
    {
        public CallTraxEntities()
            : base("name=CallTraxEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Appointment> Appointments { get; set; }
        public virtual DbSet<Call> Calls { get; set; }
        public virtual DbSet<CallAction> CallActions { get; set; }
        public virtual DbSet<CallDirection> CallDirections { get; set; }
        public virtual DbSet<CallFlow> CallFlows { get; set; }
        public virtual DbSet<CallFlowStep> CallFlowSteps { get; set; }
        public virtual DbSet<CallFlowStepDial> CallFlowStepDials { get; set; }
        public virtual DbSet<CallFlowStepGather> CallFlowStepGathers { get; set; }
        public virtual DbSet<CallFlowStepGatherRetry> CallFlowStepGatherRetries { get; set; }
        public virtual DbSet<CallFlowStepOption> CallFlowStepOptions { get; set; }
        public virtual DbSet<CallFlowStepSay> CallFlowStepSays { get; set; }
        public virtual DbSet<CallFlowStepType> CallFlowStepTypes { get; set; }
        public virtual DbSet<CallFromPhoneAddress> CallFromPhoneAddresses { get; set; }
        public virtual DbSet<CallGather> CallGathers { get; set; }
        public virtual DbSet<CallGatherAttempt> CallGatherAttempts { get; set; }
        public virtual DbSet<CallPhoneAddress> CallPhoneAddresses { get; set; }
        public virtual DbSet<CallSurvey> CallSurveys { get; set; }
        public virtual DbSet<CallSurveyAnswer> CallSurveyAnswers { get; set; }
        public virtual DbSet<CallSurveyQuestion> CallSurveyQuestions { get; set; }
        public virtual DbSet<CallToPhoneAddress> CallToPhoneAddresses { get; set; }
        public virtual DbSet<Client> Clients { get; set; }
        public virtual DbSet<ClientLocation> ClientLocations { get; set; }
        public virtual DbSet<ClientUser> ClientUsers { get; set; }
        public virtual DbSet<Consultant> Consultants { get; set; }
        public virtual DbSet<ConsultantSchedule> ConsultantSchedules { get; set; }
        public virtual DbSet<Customer> Customers { get; set; }
        public virtual DbSet<ServiceCategory> ServiceCategories { get; set; }
        public virtual DbSet<SessionTime> SessionTimes { get; set; }
        public virtual DbSet<SurveyQuestionType> SurveyQuestionTypes { get; set; }
        public virtual DbSet<sysdiagram> sysdiagrams { get; set; }
        public virtual DbSet<Tollfree> Tollfrees { get; set; }
    }
}
