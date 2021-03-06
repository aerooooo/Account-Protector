//+------------------------------------------------------------------+
//|                                            Account Protector.mqh |
//| 				                 Copyright © 2017-2020, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#include "Defines.mqh"
#include <WinUser32.mqh>
#include <Arrays\ArrayLong.mqh>

#import "user32.dll"
  int GetAncestor(int, int);
#import

class CAccountProtector : public CAppDialog
{
private:
   // Tab Buttons
   CButton			   m_BtnTabMain, m_BtnTabFilters, m_BtnTabConditions, m_BtnTabActions;
   
   // Main Tab - Labels
   CLabel  		      m_LblStatus, m_LblSpread, m_LblTimeLeft, m_LblSnapEquity, m_LblSnapMargin, m_LblURL, m_LblCurrentEquityStopLoss, m_LblDayOfWeek;
   // Main Tab - CheckBoxes
   CCheckBox         m_ChkCountCommSwaps, m_ChkUseTimer, m_ChkTrailingStart, m_ChkTrailingStep, m_ChkBreakEven, m_ChkBreakEvenExtra, m_ChkEquityTrailingStop;
   // Main Tab - Edits
   CEdit 		      m_EdtTimer, m_EdtTrailingStart, m_EdtTrailingStep, m_EdtBreakEven, m_EdtBreakEvenExtra, m_EdtEquityTrailingStop;
   // MainTab - Radio Group
   CRadioGroup			m_RgpTimeType;
   // Main Tab - Buttons
   CButton			   m_BtnNewSnapEquity, m_BtnResetEquityStopLoss, m_BtnNewSnapMargin, m_BtnEmergency, m_BtnDayOfWeek;
   
   // Filters Tab - Labels
   CLabel  		      m_LblMagics, m_LblOrderCommentary;
   // Filters Tab - CheckBoxes
   CCheckBox         m_ChkExcludeMagics;
   // Filters Tab - Edits
   CEdit 		      m_EdtMagics, m_EdtOrderCommentary;
   // Filters Tab - Buttons
   CButton			   m_BtnResetFilters;
   // Filters Tab - Radio Group 
   CRadioGroup			m_RgpInstrumentFilter;
   // Filters Tab - ComboBox
   CComboBox			m_CbxOrderCommentaryCondition;
   
   // Conditions Tab - CheckBoxes
   CCheckBox  		   m_ChkLossPerBalance, m_ChkLossQuanUnits, m_ChkLossPips, m_ChkProfPerBalance, m_ChkProfQuanUnits, m_ChkProfPips;
   CCheckBox  		   m_ChkLossPerBalanceReverse, m_ChkLossQuanUnitsReverse, m_ChkLossPipsReverse, m_ChkProfPerBalanceReverse, m_ChkProfQuanUnitsReverse, m_ChkProfPipsReverse;
   CCheckBox         m_ChkEquityLessUnits, m_ChkEquityGrUnits, m_ChkEquityLessPerSnap, m_ChkEquityGrPerSnap;
   CCheckBox         m_ChkMarginLessUnits, m_ChkMarginGrUnits, m_ChkMarginLessPerSnap, m_ChkMarginGrPerSnap;
   // Conditions Tab - Edits
   CEdit  		      m_EdtLossPerBalance, m_EdtLossQuanUnits, m_EdtLossPips, m_EdtProfPerBalance, m_EdtProfQuanUnits, m_EdtProfPips;
   CEdit  		      m_EdtLossPerBalanceReverse, m_EdtLossQuanUnitsReverse, m_EdtLossPipsReverse, m_EdtProfPerBalanceReverse, m_EdtProfQuanUnitsReverse, m_EdtProfPipsReverse;
   CEdit             m_EdtEquityLessUnits, m_EdtEquityGrUnits, m_EdtEquityLessPerSnap, m_EdtEquityGrPerSnap;
   CEdit             m_EdtMarginLessUnits, m_EdtMarginGrUnits, m_EdtMarginLessPerSnap, m_EdtMarginGrPerSnap; 
   
   // Actions Tab - Labels
   CLabel  		      m_LblClosePosSuffix, m_LblClosePosPostfix;
   // Actions Tab - CheckBoxes
   CCheckBox         m_ChkClosePos, m_ChkDeletePend, m_ChkDisAuto, m_ChkSendMails, m_ChkSendNotif, m_ChkClosePlatform, m_ChkEnableAuto, m_ChkRecaptureSnapshots;
   // Actions Tab - Edits
   CEdit 		      m_EdtClosePercentage;
   // Actions Tab - Buttons
   CButton			   m_BtnPositionStatus;
   
   string            m_FileName;
	int 					LogFile, QuantityClosedMarketOrders, QuantityDeletedPendingOrders, magic_array_counter, MagicNumbers_array[];
	bool 					IsANeedToContinueClosingOrders, IsANeedToContinueDeletingPendingOrders;
	bool 					WasAutoTradingDisabled, WasMailSent, WasNotificationSent, WasPlatformClosed, WasAutoTradingEnabled, WasRecapturedSnapshots;
   double				m_DPIScale;
   bool              NoPanelMaximization; // Crutch variable to prevent panel maximization when Maximize() is called at the indicator's initialization.
   CArrayLong       *PartiallyClosedOrders; // Stores order tickets that have been partially closed by Eliminate_Orders().

public:
                     CAccountProtector(void);
                    ~CAccountProtector(void) {delete PartiallyClosedOrders;};
        
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1);
   virtual void      Destroy();
   		  void      ShowSelectedTab();
   virtual bool      SaveSettingsOnDisk();
   virtual bool      LoadSettingsFromDisk();
   virtual bool      DeleteSettingsFile();
   virtual bool      OnEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   virtual bool      RefreshValues();
   virtual void      RefreshPanelControls();
			  void 		CheckAllConditions();
			  void 		Trailing();
			  void 		EquityTrailing();
			  void		MoveToBreakEven();
   virtual void      Logging(const string message);
   		  bool		SilentLogging;
			  void		Logging_Current_Settings();
   virtual void		HideShowMaximize(bool max);

   // Remember the panel's location to have the same location for minimized and maximized states.
           int       remember_top, remember_left;
private:     
   virtual bool      CreateObjects();
   virtual bool      InitObjects();
   virtual void      MoveAndResize();
   virtual bool      ButtonCreate     (CButton&     Btn, const int X1, const int Y1, const int X2, const int Y2, const string Name, const string Text);
   virtual bool      CheckBoxCreate   (CCheckBox&   Chk, const int X1, const int Y1, const int X2, const int Y2, const string Name, const string Text);
   virtual bool      EditCreate       (CEdit&       Edt, const int X1, const int Y1, const int X2, const int Y2, const string Name, const string Text);
   virtual bool      LabelCreate      (CLabel&      Lbl, const int X1, const int Y1, const int X2, const int Y2, const string Name, const string Text);
   virtual bool      RadioGroupCreate (CRadioGroup& Rgp, const int X1, const int Y1, const int X2, const int Y2, const string Name, const string &Text[]);
   virtual bool      ComboBoxCreate   (CComboBox&   Cbx, const int X1, const int Y1, const int X2, const int Y2, const string Name, const string &Text[]);
   virtual void		ShowMain();
   virtual void		ShowFilters();
   virtual void		ShowConditions();
   virtual void		ShowActions();
   virtual void		HideMain();
   virtual void		HideFilters();
   virtual void		HideConditions();
   virtual void		HideActions();
   virtual void      Maximize();
   virtual void      Minimize();
   virtual void      SeekAndDestroyDuplicatePanels();
   
   virtual void      Check_Status();
   virtual bool      No_Condition();
   virtual bool      No_Action();
   		  string		NewTime();
			  bool		CheckFilterSymbol(const string order_symbol);
			  bool		CheckFilterComment(const string order_comment);
			  bool		CheckFilterMagic(const int order_magic, const int j);
   virtual void      Eliminate_Orders(const Type_of_Order order_type);
   virtual int       Eliminate_Current_Order(const int ticket);
			  void		Trigger_Actions(const string title);
			  void		Logging_Condition_Is_Met();
			  void		PrepareSubjectBody(string &subject, string &body, const string title, const datetime timestamp, const int pos_closed, const int pend_deleted, const bool autotrade_dis, const bool push_sent, const bool mail_sent, const bool platf_closed, const bool autotrade_enabled, const bool snapshots_recaptured, const bool short_body = false);
			  void		SendMailFunction(string subject, string body);
			  void		SendNotificationFunction(string subject, string body);
	template<typename T>
			  void		CheckOneCondition(T &SettingsEditValue, bool &SettingsCheckboxValue, const string EventDescription);
   virtual void		ProcessMagicNumbers();
   		  bool		IsDouble(const string value);
   		  bool		IsInteger(const string value);
   		  double    CalculateOrderLots(const double lots, const string symbol);
  
	// Event handlers
   void OnClickBtnTabMain();
   void OnClickBtnTabFilters();
   void OnClickBtnTabConditions();
   void OnClickBtnTabActions();
   void OnChangeChkCountCommSwaps();
   void OnChangeChkUseTimer();
   void OnEndEditTimer();
   void OnChangeRgpTimeType();
   void OnChangeChkTrailingStart();
   void OnChangeChkTrailingStep();
   void OnChangeChkBreakEven();
   void OnChangeChkBreakEvenExtra();
   void OnEndEditTrailingStart();
   void OnEndEditTrailingStep();
   void OnEndEditBreakEven();
   void OnEndEditBreakEvenExtra();
   void OnChangeChkEquityTrailingStop();
   void OnEndEditEquityTrailingStop();
   void OnClickBtnResetEquityStopLoss();
   void OnClickBtnNewSnapEquity();
   void OnClickBtnNewSnapMargin();
   void OnChangeCbxOrderCommentaryCondition();
   void OnEndEditOrderCommentary();
   void OnEndEditMagics();
   void OnChangeChkExcludeMagics();
   void OnChangeRgpInstrumentFilter();
   void OnClickBtnResetFilters();
   void OnChangeChkLossPerBalance();
   void OnChangeChkLossPerBalanceReverse();
   void OnChangeChkLossQuanUnits();
   void OnChangeChkLossQuanUnitsReverse();
   void OnChangeChkLossPips();
   void OnChangeChkLossPipsReverse();
   void OnChangeChkProfPerBalance();
   void OnChangeChkProfPerBalanceReverse();
   void OnChangeChkProfQuanUnits();
   void OnChangeChkProfQuanUnitsReverse();
   void OnChangeChkProfPips();
   void OnChangeChkProfPipsReverse();
   void OnChangeChkEquityLessUnits();
   void OnChangeChkEquityGrUnits();
   void OnChangeChkEquityLessPerSnap();
   void OnChangeChkEquityGrPerSnap();
   void OnChangeChkMarginLessUnits();
   void OnChangeChkMarginGrUnits();
   void OnChangeChkMarginLessPerSnap();
   void OnChangeChkMarginGrPerSnap();
   void OnChangeChkClosePos();
   void OnChangeChkDeletePend();
   void OnChangeChkDisAuto();
   void OnChangeChkSendMails();
   void OnChangeChkSendNotif ();
   void OnChangeChkClosePlatform();
   void OnChangeChkEnableAuto();
   void OnChangeChkRecaptureSnapshots();
   void OnEndEditLossPerBalance();
   void OnEndEditLossPerBalanceReverse();
   void OnEndEditLossQuanUnits();
   void OnEndEditLossQuanUnitsReverse();
   void OnEndEditLossPips();
   void OnEndEditLossPipsReverse();
   void OnEndEditProfPerBalance();
   void OnEndEditProfPerBalanceReverse();
   void OnEndEditProfQuanUnits();
   void OnEndEditProfQuanUnitsReverse();
   void OnEndEditProfPips();
   void OnEndEditProfPipsReverse();
   void OnEndEditEquityLessUnits();
   void OnEndEditEquityGrUnits();
   void OnEndEditEquityLessPerSnap();
   void OnEndEditEquityGrPerSnap();
   void OnEndEditMarginLessUnits();
   void OnEndEditMarginGrUnits();
   void OnEndEditMarginLessPerSnap();
   void OnEndEditMarginGrPerSnap();
   void OnEndEditClosePercentage();
   void OnClickBtnEmergency();
   void OnClickBtnDayOfWeek();
   void OnClickBtnPositionStatus();   
   
   // Supplementary functions:
   void CheckboxChangeMain(bool& SettingsCheckboxValue, CCheckBox& CheckBox);
   void CheckboxChangeConditions(bool& SettingsCheckboxValue, CCheckBox& CheckBox);
   void CheckboxChangeActions(bool& SettingsCheckboxValue, CCheckBox& CheckBox);
	template<typename T>
	void EditChangeConditions(T& SettingsEditValue, CEdit& Edit, const string FieldName, const double RangeMaximum = 0);
	void EditChangeMain(int& SettingsEditValue, CEdit& Edit, const string FieldName);
	void RefreshConditions(const bool SettingsCheckBoxValue, const double SettingsEditValue, CCheckBox& CheckBox, CEdit& Edit, const int decimal_places);
	void UpdateEquitySnapshot();
	void UpdateMarginSnapshot();
};
 
// Event Map
EVENT_MAP_BEGIN(CAccountProtector)
   ON_EVENT(ON_CLICK, m_BtnTabMain, OnClickBtnTabMain)
   ON_EVENT(ON_CLICK, m_BtnTabFilters, OnClickBtnTabFilters)
   ON_EVENT(ON_CLICK, m_BtnTabConditions, OnClickBtnTabConditions)
   ON_EVENT(ON_CLICK, m_BtnTabActions, OnClickBtnTabActions)
   ON_EVENT(ON_CLICK, m_BtnDayOfWeek, OnClickBtnDayOfWeek)
   ON_EVENT(ON_CHANGE, m_ChkCountCommSwaps, OnChangeChkCountCommSwaps)
   ON_EVENT(ON_CHANGE, m_ChkUseTimer, OnChangeChkUseTimer)
   ON_EVENT(ON_END_EDIT, m_EdtTimer, OnEndEditTimer)
   ON_EVENT(ON_CHANGE, m_RgpTimeType, OnChangeRgpTimeType)
   ON_EVENT(ON_CHANGE, m_ChkTrailingStart, OnChangeChkTrailingStart)
   ON_EVENT(ON_CHANGE, m_ChkTrailingStep, OnChangeChkTrailingStep)
   ON_EVENT(ON_CHANGE, m_ChkBreakEven, OnChangeChkBreakEven)
   ON_EVENT(ON_CHANGE, m_ChkBreakEvenExtra, OnChangeChkBreakEvenExtra)
   ON_EVENT(ON_END_EDIT, m_EdtTrailingStart, OnEndEditTrailingStart)
   ON_EVENT(ON_END_EDIT, m_EdtTrailingStep, OnEndEditTrailingStep)
   ON_EVENT(ON_END_EDIT, m_EdtBreakEven, OnEndEditBreakEven)
   ON_EVENT(ON_END_EDIT, m_EdtBreakEvenExtra, OnEndEditBreakEvenExtra)
   ON_EVENT(ON_CHANGE, m_ChkEquityTrailingStop, OnChangeChkEquityTrailingStop)
   ON_EVENT(ON_END_EDIT, m_EdtEquityTrailingStop, OnEndEditEquityTrailingStop)
   ON_EVENT(ON_CLICK, m_BtnResetEquityStopLoss, OnClickBtnResetEquityStopLoss)
   ON_EVENT(ON_CLICK, m_BtnNewSnapEquity, OnClickBtnNewSnapEquity)
   ON_EVENT(ON_CLICK, m_BtnNewSnapMargin, OnClickBtnNewSnapMargin)
   ON_EVENT(ON_CHANGE, m_CbxOrderCommentaryCondition, OnChangeCbxOrderCommentaryCondition)
   ON_EVENT(ON_END_EDIT, m_EdtOrderCommentary, OnEndEditOrderCommentary)
   ON_EVENT(ON_END_EDIT, m_EdtMagics, OnEndEditMagics)
   ON_EVENT(ON_CHANGE, m_ChkExcludeMagics, OnChangeChkExcludeMagics)
   ON_EVENT(ON_CHANGE, m_RgpInstrumentFilter, OnChangeRgpInstrumentFilter)
   ON_EVENT(ON_CLICK, m_BtnResetFilters, OnClickBtnResetFilters)
   ON_EVENT(ON_CHANGE, m_ChkLossPerBalance, OnChangeChkLossPerBalance)
   ON_EVENT(ON_CHANGE, m_ChkLossPerBalanceReverse, OnChangeChkLossPerBalanceReverse)
   ON_EVENT(ON_CHANGE, m_ChkLossQuanUnits, OnChangeChkLossQuanUnits)
   ON_EVENT(ON_CHANGE, m_ChkLossQuanUnitsReverse, OnChangeChkLossQuanUnitsReverse)
   ON_EVENT(ON_CHANGE, m_ChkLossPips, OnChangeChkLossPips)
   ON_EVENT(ON_CHANGE, m_ChkLossPipsReverse, OnChangeChkLossPipsReverse)
   ON_EVENT(ON_CHANGE, m_ChkProfPerBalance, OnChangeChkProfPerBalance)
   ON_EVENT(ON_CHANGE, m_ChkProfPerBalanceReverse, OnChangeChkProfPerBalanceReverse)
   ON_EVENT(ON_CHANGE, m_ChkProfQuanUnits, OnChangeChkProfQuanUnits)
   ON_EVENT(ON_CHANGE, m_ChkProfQuanUnitsReverse, OnChangeChkProfQuanUnitsReverse)
   ON_EVENT(ON_CHANGE, m_ChkProfPips, OnChangeChkProfPips)
   ON_EVENT(ON_CHANGE, m_ChkProfPipsReverse, OnChangeChkProfPipsReverse)
   ON_EVENT(ON_CHANGE, m_ChkEquityLessUnits, OnChangeChkEquityLessUnits)
   ON_EVENT(ON_CHANGE, m_ChkEquityGrUnits, OnChangeChkEquityGrUnits)
   ON_EVENT(ON_CHANGE, m_ChkEquityLessPerSnap, OnChangeChkEquityLessPerSnap)
   ON_EVENT(ON_CHANGE, m_ChkEquityGrPerSnap, OnChangeChkEquityGrPerSnap)
   ON_EVENT(ON_CHANGE, m_ChkMarginLessUnits, OnChangeChkMarginLessUnits)
   ON_EVENT(ON_CHANGE, m_ChkMarginGrUnits, OnChangeChkMarginGrUnits)
   ON_EVENT(ON_CHANGE, m_ChkMarginLessPerSnap, OnChangeChkMarginLessPerSnap)
   ON_EVENT(ON_CHANGE, m_ChkMarginGrPerSnap, OnChangeChkMarginGrPerSnap)
   ON_EVENT(ON_CHANGE, m_ChkClosePos, OnChangeChkClosePos)
   ON_EVENT(ON_CLICK, m_BtnPositionStatus, OnClickBtnPositionStatus)
   ON_EVENT(ON_CHANGE, m_ChkDeletePend, OnChangeChkDeletePend)
   ON_EVENT(ON_CHANGE, m_ChkDisAuto, OnChangeChkDisAuto)
   ON_EVENT(ON_CHANGE, m_ChkSendMails, OnChangeChkSendMails)
   ON_EVENT(ON_CHANGE, m_ChkSendNotif, OnChangeChkSendNotif)
   ON_EVENT(ON_CHANGE, m_ChkClosePlatform, OnChangeChkClosePlatform)
   ON_EVENT(ON_CHANGE, m_ChkEnableAuto, OnChangeChkEnableAuto)
   ON_EVENT(ON_CHANGE, m_ChkRecaptureSnapshots, OnChangeChkRecaptureSnapshots)
   ON_EVENT(ON_END_EDIT, m_EdtLossPerBalance, OnEndEditLossPerBalance)
   ON_EVENT(ON_END_EDIT, m_EdtLossPerBalanceReverse, OnEndEditLossPerBalanceReverse)
   ON_EVENT(ON_END_EDIT, m_EdtLossQuanUnits, OnEndEditLossQuanUnits)
   ON_EVENT(ON_END_EDIT, m_EdtLossQuanUnitsReverse, OnEndEditLossQuanUnitsReverse)
   ON_EVENT(ON_END_EDIT, m_EdtLossPips, OnEndEditLossPips)
   ON_EVENT(ON_END_EDIT, m_EdtLossPipsReverse, OnEndEditLossPipsReverse)
   ON_EVENT(ON_END_EDIT, m_EdtProfPerBalance, OnEndEditProfPerBalance)
   ON_EVENT(ON_END_EDIT, m_EdtProfPerBalanceReverse, OnEndEditProfPerBalanceReverse)
   ON_EVENT(ON_END_EDIT, m_EdtProfQuanUnits, OnEndEditProfQuanUnits)
   ON_EVENT(ON_END_EDIT, m_EdtProfQuanUnitsReverse, OnEndEditProfQuanUnitsReverse)
   ON_EVENT(ON_END_EDIT, m_EdtProfPips, OnEndEditProfPips)
   ON_EVENT(ON_END_EDIT, m_EdtProfPipsReverse, OnEndEditProfPipsReverse)
   ON_EVENT(ON_END_EDIT, m_EdtEquityLessUnits, OnEndEditEquityLessUnits)
   ON_EVENT(ON_END_EDIT, m_EdtEquityGrUnits, OnEndEditEquityGrUnits)
   ON_EVENT(ON_END_EDIT, m_EdtEquityLessPerSnap, OnEndEditEquityLessPerSnap)
   ON_EVENT(ON_END_EDIT, m_EdtEquityGrPerSnap, OnEndEditEquityGrPerSnap)
   ON_EVENT(ON_END_EDIT, m_EdtMarginLessUnits, OnEndEditMarginLessUnits)
   ON_EVENT(ON_END_EDIT, m_EdtMarginGrUnits, OnEndEditMarginGrUnits)
   ON_EVENT(ON_END_EDIT, m_EdtMarginLessPerSnap, OnEndEditMarginLessPerSnap)
   ON_EVENT(ON_END_EDIT, m_EdtMarginGrPerSnap, OnEndEditMarginGrPerSnap)
   ON_EVENT(ON_END_EDIT, m_EdtClosePercentage, OnEndEditClosePercentage)
   ON_EVENT(ON_CLICK, m_BtnEmergency, OnClickBtnEmergency)
EVENT_MAP_END(CAppDialog)

//+-------------------+
//| Class constructor | 
//+-------------------+
CAccountProtector::CAccountProtector()
{
   m_FileName = "AP_" + IntegerToString(ChartID()) + ".txt";
   LogFile = -1;
   QuantityClosedMarketOrders = 0;
   QuantityDeletedPendingOrders = 0;
   IsANeedToContinueClosingOrders = false;
   IsANeedToContinueDeletingPendingOrders = false;
   SilentLogging = false;
   WasAutoTradingDisabled = false;
   WasMailSent = false;
   WasNotificationSent = false;
   WasPlatformClosed = false;
   WasAutoTradingEnabled = false;
   WasRecapturedSnapshots = false;
   NoPanelMaximization = false;
   remember_left = -1;
   remember_top = -1;
   PartiallyClosedOrders = new CArrayLong();
}

//+--------+
//| Button |
//+--------+
bool CAccountProtector::ButtonCreate(CButton &Btn, int X1, int Y1, int X2, int Y2, string Name, string Text)
{
   if (!Btn.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Btn))                                                              return(false);
   if (!Btn.Text(Text))                                                        return(false);

   return(true);
}

//+----------+
//| Checkbox |
//+----------+
bool CAccountProtector::CheckBoxCreate(CCheckBox &Chk, int X1, int Y1, int X2, int Y2, string Name, string Text)
{
   if (!Chk.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Chk))                                                              return(false);
   if (!Chk.Text(Text))                                                        return(false);

   return(true);
} 

//+------+
//| Edit |
//+------+
bool CAccountProtector::EditCreate(CEdit &Edt, int X1, int Y1, int X2, int Y2, string Name, string Text)
{
   if (!Edt.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Edt))                                                              return(false);
   if (!Edt.Text(Text))                                                        return(false);

   return(true);
} 

//+-------+
//| Label |
//+-------+
bool CAccountProtector::LabelCreate(CLabel &Lbl, int X1, int Y1, int X2, int Y2, string Name, string Text)
{
   if (!Lbl.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Lbl))                                                              return(false);
   if (!Lbl.Text(Text))                                                        return(false);

   return(true);
}

//+------------+
//| RadioGroup |
//+------------+
bool CAccountProtector::RadioGroupCreate(CRadioGroup &Rgp, int X1, int Y1, int X2, int Y2, string Name, const string &Text[])
{
   if (!Rgp.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Rgp))                                                              return(false);
   
   int size = ArraySize(Text);
   for (int i = 0; i < size; i++)
   {
   	if (!Rgp.AddItem(Text[i], i))															 return(false);
   }

   return(true);
}

//+----------+
//| ComboBox |
//+----------+
bool CAccountProtector::ComboBoxCreate(CComboBox &Cbx, int X1, int Y1, int X2, int Y2, string Name, const string &Text[])
{
   if (!Cbx.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Cbx))                                                              return(false);
   
   int size = ArraySize(Text);
   Cbx.ListViewItems(size);
   for (int i = 0; i < size; i++)
   {
   	if (!Cbx.AddItem(Text[i], i))															 return(false);
   }

   return(true);
}

//+-----------------------+
//| Create a panel object |
//+-----------------------+
bool CAccountProtector::Create(const long chart, const string name, const int subwin, const int x1, const int y1)
{
	double screen_dpi = (double)TerminalInfoInteger(TERMINAL_SCREEN_DPI);
	m_DPIScale = screen_dpi / 96.0;

   int x2 = x1 + (int)MathRound(390 * m_DPIScale);
   int y2 = y1 + (int)MathRound(300 * m_DPIScale);

   if (!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))               return(false);
   if (!CreateObjects())                                                  		 return(false);
   return(true);
} 

void CAccountProtector::Destroy()
{
   m_chart.Detach();
	// Call parent destroy.
   CDialog::Destroy();
}  

bool CAccountProtector::CreateObjects()
{
	int row_start = (int)MathRound(10 * m_DPIScale);
	int element_height = (int)MathRound(20 * m_DPIScale);
	int v_spacing = (int)MathRound(4 * m_DPIScale);
	int h_spacing = (int)MathRound(10 * m_DPIScale);
	
	int tab_button_width = (int)MathRound(80 * m_DPIScale);
	int tab_button_spacing = (int)MathRound(10 * m_DPIScale);

	int normal_label_width = (int)MathRound(108 * m_DPIScale);
	int normal_edit_width = (int)MathRound(85 * m_DPIScale);
	int narrow_label_width = (int)MathRound(85 * m_DPIScale);
	int narrow_edit_width = (int)MathRound(75 * m_DPIScale);
	int narrowest_edit_width = (int)MathRound(55 * m_DPIScale);
	int shortest_edit_width = (int)MathRound(35 * m_DPIScale);
	int timer_width = (int)MathRound(50 * m_DPIScale);
	int timer_radio_width = (int)MathRound(100 * m_DPIScale);
	int snap_button_width = (int)MathRound(170 * m_DPIScale);

	int first_column_start = (int)MathRound(15 * m_DPIScale);
	int timer_label_start = first_column_start + (int)MathRound(255 * m_DPIScale);
	int second_column_start = first_column_start + (int)MathRound(113 * m_DPIScale);
	int second_column_magic_start = second_column_start - (int)MathRound(15 * m_DPIScale);
	int second_column_magic_end = second_column_magic_start + (int)MathRound(180 * m_DPIScale);
	int second_column_main_start = second_column_start + (int)MathRound(40 * m_DPIScale);
	int third_column_start = second_column_start + (int)MathRound(92 * m_DPIScale);
	int third_column_main_start = third_column_start + (int)MathRound(20 * m_DPIScale);
	int order_commentary_start = third_column_start - (int)MathRound(12 * m_DPIScale);
	int third_column_magic_start = second_column_magic_end + (int)MathRound(5 * m_DPIScale);
	int last_input_start = first_column_start + (int)MathRound(290 * m_DPIScale);
	int last_input_end = last_input_start + (int)MathRound(60 * m_DPIScale);
	int last_big_input_start = first_column_start + (int)MathRound(250 * m_DPIScale);
	
	int panel_end = third_column_start + narrow_label_width;
	int panel_farther_end = panel_end + (int)MathRound(70 * m_DPIScale);
	
	// Start
	int y = row_start;
   if (!LabelCreate(m_LblStatus, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblStatus", "Status:"))             						 	 return(false);

   // Tab Buttons
y += element_height + v_spacing;
	if (!ButtonCreate(m_BtnTabMain, first_column_start, y, first_column_start + tab_button_width, y + element_height, "m_BtnTabMain", "Main")) return(false);
	if (!ButtonCreate(m_BtnTabFilters, first_column_start + tab_button_width + tab_button_spacing, y, first_column_start + tab_button_width * 2 + tab_button_spacing, y + element_height, "m_BtnTabFilters", "Filters")) return(false);
	if (!ButtonCreate(m_BtnTabConditions, first_column_start + tab_button_width * 2 + tab_button_spacing * 2, y, first_column_start + tab_button_width * 3 + tab_button_spacing * 2, y + element_height, "m_BtnTabConditions", "Conditions")) return(false);
	if (!ButtonCreate(m_BtnTabActions, first_column_start + tab_button_width * 3 + tab_button_spacing * 3, y, first_column_start + tab_button_width * 4 + tab_button_spacing * 3, y + element_height, "m_BtnTabActions", "Actions")) return(false);

  // Main Tab Objects
y += element_height + 3 * v_spacing;
   if (!LabelCreate(m_LblSpread, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblSpread", "Spread: " + DoubleToString((double)SymbolInfoInteger(Symbol(), SYMBOL_SPREAD) * SymbolInfoDouble(Symbol(), SYMBOL_POINT), (int)SymbolInfoInteger(Symbol(), SYMBOL_DIGITS))))             						 	 return(false);
   if (!CheckBoxCreate(m_ChkCountCommSwaps, second_column_main_start, y, panel_farther_end, y + element_height, "m_ChkCountCommSwaps", "Count commission/swaps"))    		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkUseTimer, first_column_start, y, second_column_magic_start, y + element_height, "m_ChkUseTimer", "Use timer:"))    		 return(false);
   if (!EditCreate(m_EdtTimer, second_column_magic_start, y, second_column_magic_start + timer_width, y + element_height, "m_EdtTimer", "00:00"))                                    					 		 return(false);
	string m_RgpTimeType_Text[2] = {"Server time", "Local time"};
   if (!RadioGroupCreate(m_RgpTimeType, second_column_main_start, y, second_column_main_start + timer_radio_width, y + element_height * 2, "m_RgpTimeType", m_RgpTimeType_Text))    		 return(false);
   if (!LabelCreate(m_LblTimeLeft, timer_label_start, y, timer_label_start + timer_width, y + element_height, "m_LblTimeLeft", "Time left:"))             						 	 return(false);
y += element_height + v_spacing;
   if (!LabelCreate(m_LblDayOfWeek, first_column_start, y, first_column_start + timer_width, y + element_height, "m_LblDayOfWeek", "Day: "))             						 	 return(false);
   if (!ButtonCreate(m_BtnDayOfWeek, first_column_start + timer_width, y, second_column_magic_start + timer_width, y + element_height, "m_BtnDayOfWeek", "Any")) return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkTrailingStart, first_column_start, y, panel_end, y + element_height, "m_ChkTrailingStart", "Profit value (pips) to start trailing SL:"))    		 return(false);
   if (!EditCreate(m_EdtTrailingStart, last_input_start, y, last_input_end, y + element_height, "m_EdtTrailingStart", "0"))                                    					 		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkTrailingStep, first_column_start, y, panel_end, y + element_height, "m_ChkTrailingStep", "Trailing SL value (pips):"))    		 return(false);
   if (!EditCreate(m_EdtTrailingStep, last_input_start, y, last_input_end, y + element_height, "m_EdtTrailingStep", "0"))                                    					 		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkBreakEven, first_column_start, y, panel_end, y + element_height, "m_ChkBreakEven", "Profit value (pips) to move SL to breakeven:"))    		 return(false);
   if (!EditCreate(m_EdtBreakEven, last_input_start, y, last_input_end, y + element_height, "m_EdtBreakEven", "0"))                                    					 		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkBreakEvenExtra, first_column_start, y, panel_end, y + element_height, "m_ChkBreakEvenExtra", "Breakeven extra profit value (pips):"))    		 return(false);
   if (!EditCreate(m_EdtBreakEvenExtra, last_input_start, y, last_input_end, y + element_height, "m_EdtBreakEvenExtra", "0"))                                    					 		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkEquityTrailingStop, first_column_start, y, panel_end, y + element_height, "m_ChkEquityTrailingStop", "Equity trailing stop (hidden), USD:"))    		 return(false);
   if (!EditCreate(m_EdtEquityTrailingStop, last_input_start, y, last_input_end, y + element_height, "m_EdtEquityTrailingStop", "0"))                                    					 		 return(false);
y += element_height + v_spacing;
   if (!LabelCreate(m_LblCurrentEquityStopLoss, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblCurrentEquityStopLoss", "Current equity stop-loss, USD: "))             						 	 return(false);
	if (!ButtonCreate(m_BtnResetEquityStopLoss, last_input_start, y, last_input_end, y + element_height, "m_BtnResetEquityStopLoss", "Reset SL")) return(false);
y += element_height + v_spacing;
   if (!LabelCreate(m_LblSnapEquity, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblSnapEquity", "Snapshot of equity: "))             						 	 return(false);
y += element_height + v_spacing;
   if (!LabelCreate(m_LblSnapMargin, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblSnapMargin", "Snapshot of free margin: "))             						 	 return(false);
y += element_height + v_spacing;
	if (!ButtonCreate(m_BtnNewSnapEquity, first_column_start, y, first_column_start + snap_button_width, y + element_height, "m_BtnNewSnapEquity", "New snapshot of equity")) return(false);
	if (!ButtonCreate(m_BtnNewSnapMargin, first_column_start + snap_button_width + h_spacing, y, panel_farther_end, y + element_height, "m_BtnNewSnapMargin", "New snapshot of free margin")) return(false);
   if (EnableEmergencyButton == Yes)
   {
y += element_height + 3 * v_spacing;
		if (!ButtonCreate(m_BtnEmergency, first_column_start, y, panel_farther_end, y + (int)(element_height * 2.5), "m_BtnEmergency", "Emergency button")) return(false);
	 	m_BtnEmergency.ColorBackground(clrRed);
	 	m_BtnEmergency.Color(clrWhite);
	 	y += (int)(element_height * 2.5) + v_spacing;
	}	
	else y += element_height + v_spacing;

   if (!LabelCreate(m_LblURL, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblURL", "www.earnforex.com"))             						 	 return(false);
   if (!m_LblURL.FontSize(8)) return(false);
   if (!m_LblURL.Color(C'0,115,66')) return(false); // Green
  	m_LblURL.Show();
  
  // Filters Tab Objects
y = row_start + 2 * element_height + 4 * v_spacing;
   if (!LabelCreate(m_LblMagics, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMagics", "Magic numbers:"))             						 	 return(false);
   if (!EditCreate(m_EdtMagics, second_column_magic_start, y, second_column_magic_end, y + element_height, "m_EdtMagics", ""))                                    					 		 return(false);
   if (!CheckBoxCreate(m_ChkExcludeMagics, third_column_magic_start, y, panel_farther_end, y + element_height, "m_ChkExcludeMagics", "Exclude"))    		 return(false);
y += element_height + v_spacing;
	string m_RgpInstrumentFilter_Text[3] = {"Do not filter by trading instrument", "Use only with current trading instrument", "Exclude current trading instrument"};
   if (!RadioGroupCreate(m_RgpInstrumentFilter, first_column_start, y, second_column_magic_end, y + element_height * 3, "m_RgpInstrumentFilter", m_RgpInstrumentFilter_Text))    		 return(false);
y += element_height * 3 + v_spacing;
   if (!LabelCreate(m_LblOrderCommentary, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblOrderCommentary", "Order commentary"))             						 	 return(false);
	string m_CbxOrderCommentaryCondition_Text[4] = {"contains", "equals", "excludes", "not equal"};
   if (!ComboBoxCreate(m_CbxOrderCommentaryCondition, second_column_start, y, second_column_start + narrow_edit_width, y + element_height, "m_CbxOrderCommentaryCondition", m_CbxOrderCommentaryCondition_Text))             						 	 return(false);
   if (!EditCreate(m_EdtOrderCommentary, order_commentary_start, y, panel_farther_end, y + element_height, "m_EdtOrderCommentary", ""))                                    					 		 return(false);
y += element_height + v_spacing;
	if (!ButtonCreate(m_BtnResetFilters, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_BtnResetFilters", "Reset filters")) return(false);

  // Conditions Tab Objects
y = row_start + 2 * element_height + 2 * v_spacing;
if (!DisableFloatLossRisePerc)
{
   if (!CheckBoxCreate(m_ChkLossPerBalance, first_column_start, y, panel_end, y + element_height, "m_ChkLossPerBalance", "Floating loss rises to % of balance:"))    		 return(false);
   if (!EditCreate(m_EdtLossPerBalance, last_input_start, y, last_input_end, y + element_height, "m_EdtLossPerBalance", "0"))    		 return(false);
y += element_height + v_spacing;
}
if (!DisableFloatLossFallPerc)
{
   if (!CheckBoxCreate(m_ChkLossPerBalanceReverse, first_column_start, y, panel_end, y + element_height, "m_ChkLossPerBalanceReverse", "Floating loss falls to % of balance:"))    		 return(false);
   if (!EditCreate(m_EdtLossPerBalanceReverse, last_input_start, y, last_input_end, y + element_height, "m_EdtLossPerBalanceReverse", "0"))    		 return(false);
y += element_height + v_spacing;
}
if (!DisableFloatLossRiseCurr)
{
   if (!CheckBoxCreate(m_ChkLossQuanUnits, first_column_start, y, panel_end, y + element_height, "m_ChkLossQuanUnits", "Floating loss rises to currency units:"))    		 return(false);
   if (!EditCreate(m_EdtLossQuanUnits, last_big_input_start, y, last_input_end, y + element_height, "m_EdtLossQuanUnits", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatLossFallCurr)
{
   if (!CheckBoxCreate(m_ChkLossQuanUnitsReverse, first_column_start, y, panel_end, y + element_height, "m_ChkLossQuanUnitsReverse", "Floating loss falls to currency units:"))    		 return(false);
   if (!EditCreate(m_EdtLossQuanUnitsReverse, last_big_input_start, y, last_input_end, y + element_height, "m_EdtLossQuanUnitsReverse", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatLossRisePips)
{
   if (!CheckBoxCreate(m_ChkLossPips, first_column_start, y, panel_end, y + element_height, "m_ChkLossPips", "Floating loss rises to pips:"))    		 return(false);
   if (!EditCreate(m_EdtLossPips, last_input_start, y, last_input_end, y + element_height, "m_EdtLossPips", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatLossFallPips)
{
   if (!CheckBoxCreate(m_ChkLossPipsReverse, first_column_start, y, panel_end, y + element_height, "m_ChkLossPipsReverse", "Floating loss falls to pips:"))    		 return(false);
   if (!EditCreate(m_EdtLossPipsReverse, last_input_start, y, last_input_end, y + element_height, "m_EdtLossPipsReverse", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatProfitRisePerc)
{
   if (!CheckBoxCreate(m_ChkProfPerBalance, first_column_start, y, panel_end, y + element_height, "m_ChkProfPerBalance", "Floating profit rises % of balance:"))    		 return(false);
   if (!EditCreate(m_EdtProfPerBalance, last_input_start, y, last_input_end, y + element_height, "m_EdtProfPerBalance", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatProfitFallPerc)
{
   if (!CheckBoxCreate(m_ChkProfPerBalanceReverse, first_column_start, y, panel_end, y + element_height, "m_ChkProfPerBalanceReverse", "Floating profit falls % of balance:"))    		 return(false);
   if (!EditCreate(m_EdtProfPerBalanceReverse, last_input_start, y, last_input_end, y + element_height, "m_EdtProfPerBalanceReverse", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatProfitRiseCurr)
{
   if (!CheckBoxCreate(m_ChkProfQuanUnits, first_column_start, y, panel_end, y + element_height, "m_ChkProfQuanUnits", "Floating profit rises to currency units:"))    		 return(false);
   if (!EditCreate(m_EdtProfQuanUnits, last_big_input_start, y, last_input_end, y + element_height, "m_EdtProfQuanUnits", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatProfitFallCurr)
{
   if (!CheckBoxCreate(m_ChkProfQuanUnitsReverse, first_column_start, y, panel_end, y + element_height, "m_ChkProfQuanUnitsReverse", "Floating profit falls to currency units:"))    		 return(false);
   if (!EditCreate(m_EdtProfQuanUnitsReverse, last_big_input_start, y, last_input_end, y + element_height, "m_EdtProfQuanUnitsReverse", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatProfitRisePips)
{
   if (!CheckBoxCreate(m_ChkProfPips, first_column_start, y, panel_end, y + element_height, "m_ChkProfPips", "Floating profit rises to pips:"))    		 return(false);
   if (!EditCreate(m_EdtProfPips, last_input_start, y, last_input_end, y + element_height, "m_EdtProfPips", "0"))   return(false);
y += element_height + v_spacing;
}
if (!DisableFloatProfitFallPips)
{
   if (!CheckBoxCreate(m_ChkProfPipsReverse, first_column_start, y, panel_end, y + element_height, "m_ChkProfPipsReverse", "Floating profit falls to pips:"))    		 return(false);
   if (!EditCreate(m_EdtProfPipsReverse, last_input_start, y, last_input_end, y + element_height, "m_EdtProfPipsReverse", "0"))   return(false);
y += element_height + v_spacing;
}
   if (!CheckBoxCreate(m_ChkEquityLessUnits, first_column_start, y, panel_end, y + element_height, "m_ChkEquityLessUnits", "Equity <= currency units:"))    		 return(false);
   if (!EditCreate(m_EdtEquityLessUnits, last_big_input_start, y, last_input_end, y + element_height, "m_EdtEquityLessUnits", "0"))   return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkEquityGrUnits, first_column_start, y, panel_end, y + element_height, "m_ChkEquityGrUnits", "Equity >= currency units:"))    		 return(false);
   if (!EditCreate(m_EdtEquityGrUnits, last_big_input_start, y, last_input_end, y + element_height, "m_EdtEquityGrUnits", "0"))   return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkEquityLessPerSnap, first_column_start, y, panel_end, y + element_height, "m_ChkEquityLessPerSnap", "Equity <= % of snapshot:"))    		 return(false);
   if (!EditCreate(m_EdtEquityLessPerSnap, last_input_start, y, last_input_end, y + element_height, "m_EdtEquityLessPerSnap", "0"))  return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkEquityGrPerSnap, first_column_start, y, panel_end, y + element_height, "m_ChkEquityGrPerSnap", "Equity >= % of snapshot:"))    		 return(false);
   if (!EditCreate(m_EdtEquityGrPerSnap, last_input_start, y, last_input_end, y + element_height, "m_EdtEquityGrPerSnap", "0")) return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkMarginLessUnits, first_column_start, y, panel_end, y + element_height, "m_ChkMarginLessUnits", "Free margin <= currency units:"))    		 return(false);
   if (!EditCreate(m_EdtMarginLessUnits, last_big_input_start, y, last_input_end, y + element_height, "m_EdtMarginLessUnits", "0"))   return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkMarginGrUnits, first_column_start, y, panel_end, y + element_height, "m_ChkMarginGrUnits", "Free margin >= currency units:"))    		 return(false);
   if (!EditCreate(m_EdtMarginGrUnits, last_big_input_start, y, last_input_end, y + element_height, "m_EdtMarginGrUnits", "0"))   return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkMarginLessPerSnap, first_column_start, y, panel_end, y + element_height, "m_ChkMarginLessPerSnap", "Free margin <= % of snapshot:"))    		 return(false);
   if (!EditCreate(m_EdtMarginLessPerSnap, last_input_start, y, last_input_end, y + element_height, "m_EdtMarginLessPerSnap", "0"))  return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkMarginGrPerSnap, first_column_start, y, panel_end, y + element_height, "m_ChkMarginGrPerSnap", "Free margin >= % of snapshot:"))    		 return(false);
   if (!EditCreate(m_EdtMarginGrPerSnap, last_input_start, y, last_input_end, y + element_height, "m_EdtMarginGrPerSnap", "0"))   return(false);
  
	// Actions Tab Objects
y = row_start + 2 * element_height + 4 * v_spacing;
   if (!CheckBoxCreate(m_ChkClosePos, first_column_start, y, first_column_start + narrowest_edit_width, y + element_height, "m_ChkClosePos", "Close "))    		 return(false);
   if (!EditCreate(m_EdtClosePercentage, first_column_start + narrowest_edit_width + v_spacing, y, first_column_start + narrowest_edit_width + v_spacing + narrowest_edit_width, y + element_height, "m_EdtClosePercentage", "100"))    		 return(false);
   if (!LabelCreate(m_LblClosePosSuffix, first_column_start + narrowest_edit_width + v_spacing + narrowest_edit_width + v_spacing, y, first_column_start + narrowest_edit_width + v_spacing + narrowest_edit_width + shortest_edit_width, y + element_height, "m_LblClosePosSuffix", "% of "))             						 	 return(false);
   if (!ButtonCreate(m_BtnPositionStatus, first_column_start + narrowest_edit_width + v_spacing + narrowest_edit_width + shortest_edit_width, y, first_column_start + narrowest_edit_width + v_spacing + narrowest_edit_width + shortest_edit_width + narrow_edit_width, y + element_height, "m_BtnPositionStatus", "All")) return(false);
   if (!LabelCreate(m_LblClosePosPostfix, first_column_start + narrowest_edit_width + v_spacing + narrowest_edit_width + shortest_edit_width + narrow_edit_width, y, panel_end, y + element_height, "m_LblClosePosPostfix", " positions' volume."))             						 	 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkDeletePend, first_column_start, y, panel_end, y + element_height, "m_ChkDeletePend", "Delete all pending orders"))    		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkDisAuto, first_column_start, y, panel_end, y + element_height, "m_ChkDisAuto", "Disable autotrading"))    		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkSendMails, first_column_start, y, panel_end, y + element_height, "m_ChkSendMails", "Send e-mail"))    		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkSendNotif, first_column_start, y, panel_end, y + element_height, "m_ChkSendNotif", "Send push notification"))    		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkClosePlatform, first_column_start, y, panel_end, y + element_height, "m_ChkClosePlatform", "Close platform"))    		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkEnableAuto, first_column_start, y, panel_end, y + element_height, "m_ChkEnableAuto", "Enable autotrading"))    		 return(false);
y += element_height + v_spacing;
   if (!CheckBoxCreate(m_ChkRecaptureSnapshots, first_column_start, y, panel_end, y + element_height, "m_ChkRecaptureSnapshots", "Recapture snapshots"))    		 return(false);

   InitObjects();

   return(true);
}

// Initializes all panel objects after they are created.
bool CAccountProtector::InitObjects()
{
   //+-------------------------------------+
   //| Align text from objects all objects |
   //+-------------------------------------+ 
   ENUM_ALIGN_MODE align = ALIGN_RIGHT;
   if (!m_EdtTimer.TextAlign(align)) return(false);
   if (!DisableFloatLossRisePerc) if (!m_EdtLossPerBalance.TextAlign(align)) return(false);
   if (!DisableFloatLossFallPerc) if (!m_EdtLossPerBalanceReverse.TextAlign(align)) return(false);
   if (!DisableFloatLossRiseCurr) if (!m_EdtLossQuanUnits.TextAlign(align)) return(false);
   if (!DisableFloatLossFallCurr) if (!m_EdtLossQuanUnitsReverse.TextAlign(align)) return(false);
   if (!DisableFloatLossRisePips) if (!m_EdtLossPips.TextAlign(align)) return(false);
   if (!DisableFloatLossFallPips) if (!m_EdtLossPipsReverse.TextAlign(align)) return(false);
   if (!DisableFloatProfitRisePerc) if (!m_EdtProfPerBalance.TextAlign(align)) return(false);
   if (!DisableFloatProfitFallPerc) if (!m_EdtProfPerBalanceReverse.TextAlign(align)) return(false);
   if (!DisableFloatProfitRiseCurr) if (!m_EdtProfQuanUnits.TextAlign(align)) return(false);
   if (!DisableFloatProfitFallCurr) if (!m_EdtProfQuanUnitsReverse.TextAlign(align)) return(false);
   if (!DisableFloatProfitRisePips) if (!m_EdtProfPips.TextAlign(align)) return(false);
   if (!DisableFloatProfitFallPips) if (!m_EdtProfPipsReverse.TextAlign(align)) return(false);
   if (!m_EdtEquityLessUnits.TextAlign(align)) return(false);
   if (!m_EdtEquityGrUnits.TextAlign(align)) return(false);
   if (!m_EdtEquityLessPerSnap.TextAlign(align)) return(false);
   if (!m_EdtEquityGrPerSnap.TextAlign(align)) return(false);
   if (!m_EdtMarginLessUnits.TextAlign(align)) return(false);
   if (!m_EdtMarginLessPerSnap.TextAlign(align)) return(false);
   if (!m_EdtMarginGrUnits.TextAlign(align)) return(false);
   if (!m_EdtMarginGrPerSnap.TextAlign(align)) return(false);
   if (!m_EdtTrailingStart.TextAlign(align)) return(false);
   if (!m_EdtTrailingStep.TextAlign(align)) return(false);
   if (!m_EdtBreakEven.TextAlign(align)) return(false);
   if (!m_EdtBreakEvenExtra.TextAlign(align)) return(false);
   if (!m_EdtEquityTrailingStop.TextAlign(align)) return(false);
   if (!m_EdtClosePercentage.TextAlign(align)) return(false);

	ShowSelectedTab();
	
   // Show/hide current equity stop-loss
   if (sets.doubleCurrentEquityStopLoss != 0)
   {
      if (!m_LblCurrentEquityStopLoss.Hide())                           return(false);
      if (!m_BtnResetEquityStopLoss.Hide())                             return(false);
   }

   SeekAndDestroyDuplicatePanels();

	return(true);
}

void CAccountProtector::ShowSelectedTab()
{
   HideMain();
	HideFilters();
	HideConditions();
	HideActions();

	if (!m_minimized)
	{
   	if (sets.SelectedTab == MainTab) ShowMain();
      else if (sets.SelectedTab == FiltersTab) ShowFilters();
   	else if (sets.SelectedTab == ConditionsTab) ShowConditions();
     	else if (sets.SelectedTab == ActionsTab) ShowActions();
   }
   	
   MoveAndResize();
}

// Adjusts panel's height accordingly to the chosen TabButton.
void CAccountProtector::MoveAndResize()
{
   int col_height = (int)MathRound(24 * m_DPIScale);
   int new_height = col_height;
   int ref_point = 0;

	if (sets.SelectedTab == MainTab)
	{
		ref_point = m_ChkEquityTrailingStop.Top();
	   if (sets.doubleCurrentEquityStopLoss != 0)
	   {
	      m_LblCurrentEquityStopLoss.Move(m_LblCurrentEquityStopLoss.Left(), ref_point + 1 * col_height);
	      m_BtnResetEquityStopLoss.Move(m_BtnResetEquityStopLoss.Left(), ref_point + 1 * col_height);
	      m_LblCurrentEquityStopLoss.Show();
	      m_BtnResetEquityStopLoss.Show();
	      ref_point = ref_point + 1 * col_height;
	   }
	   else
	   {
	      m_LblCurrentEquityStopLoss.Hide();
	      m_BtnResetEquityStopLoss.Hide();
	   }
      m_LblSnapEquity.Move(m_LblSnapEquity.Left(), ref_point + 1 * col_height);
      m_LblSnapMargin.Move(m_LblSnapMargin.Left(), ref_point + 2 * col_height);
      m_BtnNewSnapEquity.Move(m_BtnNewSnapEquity.Left(), ref_point + 3 * col_height);
      m_BtnNewSnapMargin.Move(m_BtnNewSnapMargin.Left(), ref_point + 3 * col_height);
	   if (EnableEmergencyButton == Yes)
	   {
	   	m_BtnEmergency.Move(m_BtnEmergency.Left(), ref_point + 4 * col_height);
	   	ref_point = m_BtnEmergency.Top() + (int)MathRound(30 * m_DPIScale);
		}
		else
		{
			ref_point = m_BtnNewSnapMargin.Top();
		}
	}
	else if (sets.SelectedTab == FiltersTab)
	{
		ref_point = m_BtnResetFilters.Top();
	}
	else if (sets.SelectedTab == ConditionsTab)
	{
		ref_point = m_EdtMarginGrPerSnap.Top();
	}
   else if (sets.SelectedTab == ActionsTab)
   {
		ref_point = m_ChkRecaptureSnapshots.Top();
   }
   
	m_LblURL.Move(m_LblURL.Left(), ref_point + col_height);
	new_height = m_LblURL.Top() + col_height - Top();

   if (!m_minimized)
   {
      // Resize window.
      Height(new_height);
      // Needed only in case of initialization when actual panel maximization is avoided.
      if (NoPanelMaximization) Width((int)MathRound(390 * m_DPIScale));
   }
   NoPanelMaximization = false;
}

void CAccountProtector::Minimize()
{
   CAppDialog::Minimize();
   if (remember_left != -1) Move(remember_left, remember_top);
}

// Processes click on the panel's Maximize button of the panel.
void CAccountProtector::Maximize()
{
   if (!NoPanelMaximization) CAppDialog::Maximize();
   else if (m_minimized) CAppDialog::Minimize();

	ShowSelectedTab();

	if (remember_left != -1) Move(remember_left, remember_top);
}

// Refreshes Status, Spread-value, and TimeLeft-value.
bool CAccountProtector::RefreshValues()
{
   Check_Status();
   if (!m_LblSpread.Text("Spread: " + DoubleToString((double)SymbolInfoInteger(Symbol(), SYMBOL_SPREAD) * SymbolInfoDouble(Symbol(), SYMBOL_POINT), (int)SymbolInfoInteger(Symbol(), SYMBOL_DIGITS)))) return(false);
   if (m_ChkUseTimer.Checked())
   {
		sets.TimeLeft = NewTime();
		m_LblTimeLeft.Text("Time left: " + sets.TimeLeft);
   }
   else m_LblTimeLeft.Text("Time left: ---");
   string account_currency = AccountCurrency();
   if (account_currency != "") m_ChkEquityTrailingStop.Text("Equity trailing stop (hidden), " + account_currency + ":");

   if (IsANeedToContinueClosingOrders) Eliminate_Orders(Active);
   if (IsANeedToContinueDeletingPendingOrders) Eliminate_Orders(Pending);
	
	return(true);
} 

// Updates all panel controls depending on the settings in sets struct.
void CAccountProtector::RefreshPanelControls()
{
	// Main tab
	
	// Refresh "Count commission/swaps".
   m_ChkCountCommSwaps.Checked(sets.CountCommSwaps);
   
	// Refresh timer fields.
   if (sets.UseTimer)
   {
		m_ChkUseTimer.Checked(true);
	}
   else
   {
		m_ChkUseTimer.Checked(false);
		m_LblTimeLeft.Text("Time left: ---");
   }
   m_EdtTimer.Text(sets.Timer);
   m_BtnDayOfWeek.Text(EnumToString(sets.TimerDayOfWeek));
   
	// Refresh time type radio group.
	m_RgpTimeType.Value(sets.intTimeType);

	// Refresh trailing stop start fields.
	RefreshConditions(sets.boolTrailingStart, sets.intTrailingStart, m_ChkTrailingStart, m_EdtTrailingStart, 0);
   
	// Refresh trailing stop step fields.
	RefreshConditions(sets.boolTrailingStep, sets.intTrailingStep, m_ChkTrailingStep, m_EdtTrailingStep, 0);

	// Refresh breakeven fields.
	RefreshConditions(sets.boolBreakEven, sets.intBreakEven, m_ChkBreakEven, m_EdtBreakEven, 0);

	// Refresh breakeven extra fields.
	RefreshConditions(sets.boolBreakEvenExtra, sets.intBreakEvenExtra, m_ChkBreakEvenExtra, m_EdtBreakEvenExtra, 0);
    
	// Refresh equity trailing stop fields.
	RefreshConditions(sets.boolEquityTrailingStop, sets.doubleEquityTrailingStop, m_ChkEquityTrailingStop, m_EdtEquityTrailingStop, 2);
    
	// Refresh snapshot of equity.
	if (sets.SnapEquityTime != "") m_LblSnapEquity.Text("Snapshot of equity: " + DoubleToString(sets.SnapEquity, 2) + " (" + sets.SnapEquityTime + ")");
	else m_LblSnapEquity.Text("Snapshot of equity: ");
	
	// Refresh snapshot of margin.
	if (sets.SnapMarginTime != "") m_LblSnapMargin.Text("Snapshot of free margin: " + DoubleToString(sets.SnapMargin, 2) + " (" + sets.SnapMarginTime + ")");
	else m_LblSnapMargin.Text("Snapshot of free margin: ");

	// Filters tab
	
	// Refresh order commentary condition list view.
	m_CbxOrderCommentaryCondition.Select(sets.intOrderCommentaryCondition);
	// Refresh order commentary edit.
	m_EdtOrderCommentary.Text(sets.OrderCommentary);

	// Refresh magic numbers.
   m_EdtMagics.Text(sets.MagicNumbers);
   ProcessMagicNumbers();
   // Refresh "Exclude" checkbox for magic numbers.
   m_ChkExcludeMagics.Checked(sets.boolExcludeMagics);
 
	// Refresh trading instrument radio group.
	m_RgpInstrumentFilter.Value(sets.intInstrumentFilter);

	// Conditions tab
   
	// Refresh "Floating loss rises to % of balance" fields.
	if (!DisableFloatLossRisePerc) RefreshConditions(sets.boolLossPerBalance, sets.doubleLossPerBalance, m_ChkLossPerBalance, m_EdtLossPerBalance);

	// Refresh "Floating loss falls to % of balance" fields.
	if (!DisableFloatLossFallPerc) RefreshConditions(sets.boolLossPerBalanceReverse, sets.doubleLossPerBalanceReverse, m_ChkLossPerBalanceReverse, m_EdtLossPerBalanceReverse);

	// Refresh "Floating loss rises to currency units" fields.
	if (!DisableFloatLossRiseCurr) RefreshConditions(sets.boolLossQuanUnits, sets.doubleLossQuanUnits, m_ChkLossQuanUnits, m_EdtLossQuanUnits);

	// Refresh "Floating loss falls to currency units" fields.
	if (!DisableFloatLossFallCurr) RefreshConditions(sets.boolLossQuanUnitsReverse, sets.doubleLossQuanUnitsReverse, m_ChkLossQuanUnitsReverse, m_EdtLossQuanUnitsReverse);

	// Refresh "Floating loss rises to pips" fields.
	if (!DisableFloatLossRisePips) RefreshConditions(sets.boolLossPips, sets.intLossPips, m_ChkLossPips, m_EdtLossPips, 0);

	// Refresh "Floating loss falls to pips" fields.
	if (!DisableFloatLossFallPips) RefreshConditions(sets.boolLossPipsReverse, sets.intLossPipsReverse, m_ChkLossPipsReverse, m_EdtLossPipsReverse, 0);

	// Refresh "Floating profit rises to % of balance" fields.
	if (!DisableFloatProfitRisePerc) RefreshConditions(sets.boolProfPerBalance, sets.doubleProfPerBalance, m_ChkProfPerBalance, m_EdtProfPerBalance);

	// Refresh "Floating profit falls to % of balance" fields.
	if (!DisableFloatProfitFallPerc) RefreshConditions(sets.boolProfPerBalanceReverse, sets.doubleProfPerBalanceReverse, m_ChkProfPerBalanceReverse, m_EdtProfPerBalanceReverse);

	// Refresh "Floating profit rises to currency units" fields.
	if (!DisableFloatProfitRiseCurr) RefreshConditions(sets.boolProfQuanUnits, sets.doubleProfQuanUnits, m_ChkProfQuanUnits, m_EdtProfQuanUnits);

	// Refresh "Floating profit falls to currency units" fields.
	if (!DisableFloatProfitFallCurr) RefreshConditions(sets.boolProfQuanUnitsReverse, sets.doubleProfQuanUnitsReverse, m_ChkProfQuanUnitsReverse, m_EdtProfQuanUnitsReverse);

	// Refresh "Floating profit rises to pips" fields.
	if (!DisableFloatProfitRisePips) RefreshConditions(sets.boolProfPips, sets.intProfPips, m_ChkProfPips, m_EdtProfPips, 0);

	// Refresh "Floating profit falls to pips" fields.
	if (!DisableFloatProfitFallPips) RefreshConditions(sets.boolProfPipsReverse, sets.intProfPipsReverse, m_ChkProfPipsReverse, m_EdtProfPipsReverse, 0);

	// Refresh "Equity <= currency units" fields.
	RefreshConditions(sets.boolEquityLessUnits, sets.doubleEquityLessUnits, m_ChkEquityLessUnits, m_EdtEquityLessUnits);

	// Refresh "Equity >= currency units" fields.
	RefreshConditions(sets.boolEquityGrUnits, sets.doubleEquityGrUnits, m_ChkEquityGrUnits, m_EdtEquityGrUnits);

	// Refresh "Equity <= % of snapshot" fields.
	RefreshConditions(sets.boolEquityLessPerSnap, sets.doubleEquityLessPerSnap, m_ChkEquityLessPerSnap, m_EdtEquityLessPerSnap);
   if (sets.SnapEquityTime != "") m_ChkEquityLessPerSnap.Text("Equity <= % of snapshot (" + DoubleToString(sets.SnapEquity, 2) + "):");
   else m_ChkEquityLessPerSnap.Text("Equity <= % of snapshot:");

	// Refresh "Equity >= % of snapshot" fields.
	RefreshConditions(sets.boolEquityGrPerSnap, sets.doubleEquityGrPerSnap, m_ChkEquityGrPerSnap, m_EdtEquityGrPerSnap);
   if (sets.SnapEquityTime != "") m_ChkEquityGrPerSnap.Text("Equity >= % of snapshot (" + DoubleToString(sets.SnapEquity, 2) + "):");
   else m_ChkEquityGrPerSnap.Text("Equity >= % of snapshot:");

	// Refresh "Free margin <= currency units" fields.
	RefreshConditions(sets.boolMarginLessUnits, sets.doubleMarginLessUnits, m_ChkMarginLessUnits, m_EdtMarginLessUnits);

	// Refresh "Free margin >= currency units" fields.
	RefreshConditions(sets.boolMarginGrUnits, sets.doubleMarginGrUnits, m_ChkMarginGrUnits, m_EdtMarginGrUnits);

	// Refresh "Free margin <= % of snapshot" fields.
	RefreshConditions(sets.boolMarginLessPerSnap, sets.doubleMarginLessPerSnap, m_ChkMarginLessPerSnap, m_EdtMarginLessPerSnap);
   if (sets.SnapMarginTime != "") m_ChkMarginLessPerSnap.Text("Free margin <= % of snapshot (" + DoubleToString(sets.SnapMargin, 2) + "):");
   else m_ChkMarginLessPerSnap.Text("Free margin <= % of snapshot:");

	// Refresh "Free margin >= % of snapshot" fields.
	RefreshConditions(sets.boolMarginGrPerSnap, sets.doubleMarginGrPerSnap, m_ChkMarginGrPerSnap, m_EdtMarginGrPerSnap);
   if (sets.SnapMarginTime != "") m_ChkMarginGrPerSnap.Text("Free margin >= % of snapshot (" + DoubleToString(sets.SnapMargin, 2) + "):");
   else m_ChkMarginGrPerSnap.Text("Free margin >= % of snapshot:");

	// Actions tab

	// Refresh "Close all positions" checkbox.
	m_ChkClosePos.Checked(sets.ClosePos);
	// Refresh "Close Percentage" field. Not a condition, but works with the same funciton.
	RefreshConditions(sets.ClosePos, (double)sets.intClosePercentage, m_ChkClosePos, m_EdtClosePercentage, 0);
   // Refresh button status (All, Losing, or Profitable).
   m_BtnPositionStatus.Text(EnumToString(sets.CloseWhichPositions));

	// Refresh "Delete all pending orders" checkbox.
	m_ChkDeletePend.Checked(sets.DeletePend);
	
	// Refresh "Disable AutoTrading" checkbox.
	m_ChkDisAuto.Checked(sets.DisAuto);

	// Refresh "Send e-mail" checkbox.
	m_ChkSendMails.Checked(sets.SendMails);

	// Refresh "Send push notification" checkbox.
	m_ChkSendNotif.Checked(sets.SendNotif);

	// Refresh "Close platform" checkbox.
	m_ChkClosePlatform.Checked(sets.ClosePlatform);

	// Refresh "Enable AutoTrading" checkbox.
	m_ChkEnableAuto.Checked(sets.EnableAuto);

	// Refresh "Recapture snapshots" checkbox.
	m_ChkRecaptureSnapshots.Checked(sets.RecaptureSnapshots);

	// Refresh status label.
	if (sets.Triggered) m_LblStatus.Text("Status: Triggered at " + sets.TriggeredTime);
}

// Hides design-elements of TabButton "Main".
void CAccountProtector::HideMain()
{
   m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   m_LblSpread.Hide();
   m_ChkCountCommSwaps.Hide();
   m_ChkUseTimer.Hide();
   m_EdtTimer.Hide();
   m_RgpTimeType.Hide();
   m_LblTimeLeft.Hide();
   m_LblDayOfWeek.Hide();
   m_BtnDayOfWeek.Hide();
   m_ChkTrailingStart.Hide();
   m_ChkTrailingStep.Hide();
   m_ChkBreakEven.Hide();
   m_ChkBreakEvenExtra.Hide();
   m_ChkEquityTrailingStop.Hide();
   m_EdtTrailingStart.Hide();
   m_EdtTrailingStep.Hide();
   m_EdtBreakEven.Hide();
   m_EdtBreakEvenExtra.Hide();
   m_EdtEquityTrailingStop.Hide();
   m_LblSnapEquity.Hide();
   m_LblSnapMargin.Hide();
   m_LblCurrentEquityStopLoss.Hide();
   m_BtnNewSnapEquity.Hide();
   m_BtnNewSnapMargin.Hide();
   m_BtnEmergency.Hide();
   m_BtnResetEquityStopLoss.Hide();
}

// Shows design-elements of TabButton "Main".
void CAccountProtector::ShowMain()
{
   m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   m_LblSpread.Show();
   m_ChkCountCommSwaps.Show();
   m_ChkUseTimer.Show();
   m_EdtTimer.Show();
   m_RgpTimeType.Show();
   m_LblTimeLeft.Show();
   m_LblDayOfWeek.Show();
   m_BtnDayOfWeek.Show();
   m_ChkTrailingStart.Show();
   m_ChkTrailingStep.Show();
   m_ChkBreakEven.Show();
   m_ChkBreakEvenExtra.Show();
   m_ChkEquityTrailingStop.Show();
   m_EdtTrailingStart.Show();
   m_EdtTrailingStep.Show();
   m_EdtBreakEven.Show();
   m_EdtBreakEvenExtra.Show();
   m_EdtEquityTrailingStop.Show();
   m_LblSnapEquity.Show();
   m_LblSnapMargin.Show();
   m_LblCurrentEquityStopLoss.Show();
   m_BtnNewSnapEquity.Show();
   m_BtnNewSnapMargin.Show();
   m_BtnEmergency.Show();
   m_BtnResetEquityStopLoss.Show();
}

// Hides design-elements of TabButton "Filters".
void CAccountProtector::HideFilters()
{
   m_BtnTabFilters.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   m_LblOrderCommentary.Hide();
   m_CbxOrderCommentaryCondition.Hide();
   m_EdtOrderCommentary.Hide();
   m_LblMagics.Hide();
   m_EdtMagics.Hide();
   m_ChkExcludeMagics.Hide();
   m_RgpInstrumentFilter.Hide();
   m_BtnResetFilters.Hide();
}

// Shows design-elements of TabButton "Filters".
void CAccountProtector::ShowFilters()
{
   m_BtnTabFilters.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   m_LblOrderCommentary.Show();
   m_CbxOrderCommentaryCondition.Show();
   m_EdtOrderCommentary.Show();
   m_LblMagics.Show();
   m_EdtMagics.Show();
   m_ChkExcludeMagics.Show();
   m_RgpInstrumentFilter.Show();
   m_BtnResetFilters.Show();
}

// Hides design-elements of TabButton "Conditions".
void CAccountProtector::HideConditions()
{
   m_BtnTabConditions.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   m_ChkLossPerBalance.Hide();
   m_ChkLossPerBalanceReverse.Hide();
   m_ChkLossQuanUnits.Hide();
   m_ChkLossQuanUnitsReverse.Hide();
   m_ChkLossPips.Hide();
   m_ChkLossPipsReverse.Hide();
   m_ChkProfPerBalance.Hide();
   m_ChkProfPerBalanceReverse.Hide();
   m_ChkProfQuanUnits.Hide();
   m_ChkProfQuanUnitsReverse.Hide();
   m_ChkProfPips.Hide();
   m_ChkProfPipsReverse.Hide();
   m_ChkEquityLessUnits.Hide();
   m_ChkEquityLessPerSnap.Hide();
   m_ChkEquityGrUnits.Hide();
   m_ChkEquityGrPerSnap.Hide();
   m_ChkMarginLessUnits.Hide();
   m_ChkMarginLessPerSnap.Hide();
   m_ChkMarginGrUnits.Hide();
   m_ChkMarginGrPerSnap.Hide();
   m_EdtLossPerBalance.Hide();
   m_EdtLossPerBalanceReverse.Hide();
   m_EdtLossQuanUnits.Hide();
   m_EdtLossQuanUnitsReverse.Hide();
   m_EdtLossPips.Hide();
   m_EdtLossPipsReverse.Hide();
   m_EdtProfPerBalance.Hide();
   m_EdtProfPerBalanceReverse.Hide();
   m_EdtProfQuanUnits.Hide();
   m_EdtProfQuanUnitsReverse.Hide();
   m_EdtProfPips.Hide();
   m_EdtProfPipsReverse.Hide();
   m_EdtEquityLessUnits.Hide();
   m_EdtEquityLessPerSnap.Hide();
   m_EdtEquityGrUnits.Hide();
   m_EdtEquityGrPerSnap.Hide();
   m_EdtMarginLessUnits.Hide();
   m_EdtMarginLessPerSnap.Hide();
   m_EdtMarginGrUnits.Hide();
   m_EdtMarginGrPerSnap.Hide();
}

// Shows design-elements of TabButton "Conditions".
void CAccountProtector::ShowConditions()
{
   m_BtnTabConditions.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   m_ChkLossPerBalance.Show();
   m_ChkLossPerBalanceReverse.Show();
   m_ChkLossQuanUnits.Show();
   m_ChkLossQuanUnitsReverse.Show();
   m_ChkLossPips.Show();
   m_ChkLossPipsReverse.Show();
   m_ChkProfPerBalance.Show();
   m_ChkProfPerBalanceReverse.Show();
   m_ChkProfQuanUnits.Show();
   m_ChkProfQuanUnitsReverse.Show();
   m_ChkProfPips.Show();
   m_ChkProfPipsReverse.Show();
   m_ChkEquityLessUnits.Show();
   m_ChkEquityLessPerSnap.Show();
   m_ChkEquityGrUnits.Show();
   m_ChkEquityGrPerSnap.Show();
   m_ChkMarginLessUnits.Show();
   m_ChkMarginLessPerSnap.Show();
   m_ChkMarginGrUnits.Show();
   m_ChkMarginGrPerSnap.Show();
   m_EdtLossPerBalance.Show();
   m_EdtLossPerBalanceReverse.Show();
   m_EdtLossQuanUnits.Show();
   m_EdtLossQuanUnitsReverse.Show();
   m_EdtLossPips.Show();
   m_EdtLossPipsReverse.Show();
   m_EdtProfPerBalance.Show();
   m_EdtProfPerBalanceReverse.Show();
   m_EdtProfQuanUnits.Show();
   m_EdtProfQuanUnitsReverse.Show();
   m_EdtProfPips.Show();
   m_EdtProfPipsReverse.Show();
   m_EdtEquityLessUnits.Show();
   m_EdtEquityLessPerSnap.Show();
   m_EdtEquityGrUnits.Show();
   m_EdtEquityGrPerSnap.Show();
   m_EdtMarginLessUnits.Show();
   m_EdtMarginLessPerSnap.Show();
   m_EdtMarginGrUnits.Show();
   m_EdtMarginGrPerSnap.Show();
}

// Hides design-elements of TabButton "Actions".
void CAccountProtector::HideActions()
{
   m_BtnTabActions.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   m_ChkClosePos.Hide();
   m_EdtClosePercentage.Hide();
   m_LblClosePosSuffix.Hide();
   m_BtnPositionStatus.Hide();
   m_LblClosePosPostfix.Hide();
   m_ChkDeletePend.Hide();
   m_ChkDisAuto.Hide();
   m_ChkSendMails.Hide();
   m_ChkSendNotif.Hide();
   m_ChkClosePlatform.Hide();
   m_ChkEnableAuto.Hide();
   m_ChkRecaptureSnapshots.Hide();
}

// Shows design-elements of TabButton "Actions".
void CAccountProtector::ShowActions()
{
   m_BtnTabActions.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   m_ChkClosePos.Show();
   m_EdtClosePercentage.Show();
   m_LblClosePosSuffix.Show();
   m_BtnPositionStatus.Show();
   m_LblClosePosPostfix.Show();
   m_ChkDeletePend.Show();
   m_ChkDisAuto.Show();
   m_ChkSendMails.Show();
   m_ChkSendNotif.Show();
   m_ChkClosePlatform.Show();
   m_ChkEnableAuto.Show();
   m_ChkRecaptureSnapshots.Show();
}

void CAccountProtector::SeekAndDestroyDuplicatePanels()
{
	int ot = ObjectsTotal(ChartID());
	for (int i = ot - 1; i >= 0; i--)
	{
		string object_name = ObjectName(ChartID(), i);
		if (ObjectGetInteger(ChartID(), object_name, OBJPROP_TYPE) != OBJ_EDIT) continue;
		// Found Caption object.
		if (StringSubstr(object_name, StringLen(object_name) - 7) == "Caption")
		{
			string prefix = StringSubstr(object_name, 0, StringLen(Name()));
			// Found Caption object with prefix different than current.
			if (prefix != Name())
			{
				ObjectsDeleteAll(ChartID(), prefix);
				// Reset object counter.
				ot = ObjectsTotal(ChartID());
				i = ot;
				Print("Deleted duplicate panel objects with prefix = ", prefix, ".");
				continue;
			}
		}
	}
}

//+--------------------------------------------+
//|                                            |         
//|                   EVENTS                   |
//|                                            |
//+--------------------------------------------+

// Click on the Main tab.
void CAccountProtector::OnClickBtnTabMain()
{
   if (sets.SelectedTab == MainTab) return;
	m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
	m_BtnTabFilters.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabConditions.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabActions.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	sets.SelectedTab = MainTab;
	ShowMain();
	HideConditions();
	HideFilters();
	HideActions();
	MoveAndResize();
}

// Click on the Filters tab.
void CAccountProtector::OnClickBtnTabFilters()
{
   if (sets.SelectedTab == FiltersTab) return;
	m_BtnTabFilters.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
	m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabActions.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabConditions.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	sets.SelectedTab = FiltersTab;
	ShowFilters();
	HideMain();
	HideConditions();
	HideActions();
	MoveAndResize();
}

// Click on the Conditions tab.
void CAccountProtector::OnClickBtnTabConditions()
{
   if (sets.SelectedTab == ConditionsTab) return;
	m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabFilters.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabActions.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabConditions.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
	sets.SelectedTab = ConditionsTab;
	ShowConditions();
	HideMain();
	HideFilters();
	HideActions();
	MoveAndResize();
}

// Click on the Actions tab.
void CAccountProtector::OnClickBtnTabActions()
{
   if (sets.SelectedTab == ActionsTab) return;
	m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabFilters.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabConditions.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
	m_BtnTabActions.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
	sets.SelectedTab = ActionsTab;
	HideConditions();
	HideMain();
	HideFilters();
	ShowActions();
	MoveAndResize();
}

// Changes Checkbox "Count Commission/Swaps".
void CAccountProtector::OnChangeChkCountCommSwaps()
{
   if (sets.CountCommSwaps != m_ChkCountCommSwaps.Checked())
   {
	 sets.CountCommSwaps = m_ChkCountCommSwaps.Checked();
    SaveSettingsOnDisk();
	}
}

// Changes Checkbox "Use Timer".
void CAccountProtector::OnChangeChkUseTimer()
{
   if (sets.UseTimer != m_ChkUseTimer.Checked())
   {
		sets.UseTimer = m_ChkUseTimer.Checked();
		if (!m_ChkUseTimer.Checked()) m_LblTimeLeft.Text("Time left: ---");
		sets.Triggered = false;
		sets.TriggeredTime = "";
		SaveSettingsOnDisk();
	}
}

// Edit input field of Timer.
void CAccountProtector::OnEndEditTimer()
{
	string time = m_EdtTimer.Text();

	if (StringLen(time) == 4) time = "0" + time;
	
	if ( 
		// Wrong length.
		(StringLen(time) != 5) ||
		// Wrong separator.
		(time[2] != ':') ||
		// Wrong first number (only 24 hours in a day).
		((time[0] < '0') || (time[0] > '2')) ||
		// 00 to 09 and 10 to 19.
		(((time[0] == '0') || (time[0] == '1')) && ((time[1] < '0') || (time[1] > '9'))) ||
		// 20 to 23.
		((time[0] == '2') && ((time[1] < '0') || (time[1] > '3'))) ||
		// 0M to 5M.
		((time[3] < '0') || (time[3] > '5')) ||
		// M0 to M9.
		((time[4] < '0') || (time[4] > '9'))
		)
	{
		Logging(LOG_TIMER_VALUE_WRONG);
		LoadSettingsFromDisk();
		return;
	} 

	if (sets.Timer != time)
	{
		sets.Timer = time;
		RefreshValues();
		sets.Triggered = false;
		sets.TriggeredTime = "";
		SaveSettingsOnDisk();
	}
}

// Saves input from the time type radio group.
void CAccountProtector::OnChangeRgpTimeType()
{
   if (sets.intTimeType != m_RgpTimeType.Value())
   {
		sets.intTimeType = (int)m_RgpTimeType.Value();
		SaveSettingsOnDisk();
	}
}

// Supplementary function to process checkbox clicks (for Main tab).
void CAccountProtector::CheckboxChangeMain(bool& SettingsCheckboxValue, CCheckBox& CheckBox)
{
   if (SettingsCheckboxValue != CheckBox.Checked())
   {
		SettingsCheckboxValue = CheckBox.Checked();
		SaveSettingsOnDisk();
	}
}

// Changes Checkbox "Profit value (pips) to start Trailing SL".
void CAccountProtector::OnChangeChkTrailingStart()
{
	CheckboxChangeMain(sets.boolTrailingStart, m_ChkTrailingStart);
}

// Changes Checkbox "Trailing SL value (pips)".
void CAccountProtector::OnChangeChkTrailingStep()
{
	CheckboxChangeMain(sets.boolTrailingStep, m_ChkTrailingStep);
}

// Changes Checkbox "Profit value (pips) to move SL to Breakeven".
void CAccountProtector::OnChangeChkBreakEven()
{
	CheckboxChangeMain(sets.boolBreakEven, m_ChkBreakEven);
}

// Changes Checkbox "Breakeven extra profit value (pips)".
void CAccountProtector::OnChangeChkBreakEvenExtra()
{
	CheckboxChangeMain(sets.boolBreakEvenExtra, m_ChkBreakEvenExtra);
}

// Changes Checkbox "Equity trailing stop (hidden)".
void CAccountProtector::OnChangeChkEquityTrailingStop()
{
	CheckboxChangeMain(sets.boolEquityTrailingStop, m_ChkEquityTrailingStop);
	
   // Reset and hide in any case because: unchecking turns equity SL off; checking just turns on, so everything starts anew.
	sets.doubleCurrentEquityStopLoss = 0;
   m_LblCurrentEquityStopLoss.Hide();
   m_BtnResetEquityStopLoss.Hide();
   
	MoveAndResize();
}

// Processes click on the "Reset equity stop-loss" button.
void CAccountProtector::OnClickBtnResetEquityStopLoss()
{
   // Reset and hide in any case because everything starts anew - no need to show 0 equity stop-loss.
	sets.doubleCurrentEquityStopLoss = 0;
   SaveSettingsOnDisk();

   m_LblCurrentEquityStopLoss.Hide();
   m_BtnResetEquityStopLoss.Hide();
   
	MoveAndResize();
}

// Processes click on the "New Snapshot of Equity" button.
void CAccountProtector::OnClickBtnNewSnapEquity()
{
   UpdateEquitySnapshot();
   SaveSettingsOnDisk();
}

// Actual equity snapshot update - can be called from different places.
void CAccountProtector::UpdateEquitySnapshot()
{
   sets.SnapEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   sets.SnapEquityTime = TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES | TIME_SECONDS);
   m_LblSnapEquity.Text("Snapshot of Equity: " + DoubleToString(sets.SnapEquity, 2) + " (" + sets.SnapEquityTime + ")");
   m_ChkEquityLessPerSnap.Text("Equity <= % of Snapshot: (" + DoubleToString(sets.SnapEquity, 2) + ")");
   m_ChkEquityGrPerSnap.Text("Equity >= % of Snapshot: (" + DoubleToString(sets.SnapEquity, 2) + ")");
}

// Processes click on the "New Snapshot of Free Margin" button.
void CAccountProtector::OnClickBtnNewSnapMargin()
{
   UpdateMarginSnapshot();
   SaveSettingsOnDisk();
}

// Actual margin snapshot update - can be called from different places.
void CAccountProtector::UpdateMarginSnapshot()
{
   sets.SnapMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   sets.SnapMarginTime = TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES | TIME_SECONDS);
   m_LblSnapMargin.Text("Snapshot of Free Margin: " + DoubleToString(sets.SnapMargin, 2) + " (" + sets.SnapMarginTime + ")");
   m_ChkMarginLessPerSnap.Text("Free Margin <= % of Snapshot: (" + DoubleToString(sets.SnapMargin, 2) + ")");
   m_ChkMarginGrPerSnap.Text("Free Margin >= % of Snapshot: (" + DoubleToString(sets.SnapMargin, 2) + ")");
}

// Saves input from the order commentary condition list view.
void CAccountProtector::OnChangeCbxOrderCommentaryCondition()
{
   if (sets.intOrderCommentaryCondition != m_CbxOrderCommentaryCondition.Value())
   {
		sets.intOrderCommentaryCondition = (int)m_CbxOrderCommentaryCondition.Value();
		SaveSettingsOnDisk();
	}
}

// Processes edit of input-field of order commentary.
void CAccountProtector::OnEndEditOrderCommentary()
{
	string order_commentary = m_EdtOrderCommentary.Text();
	if (StringCompare(sets.OrderCommentary, order_commentary) != 0)
	{
		sets.OrderCommentary = order_commentary;
		SaveSettingsOnDisk();
	}
}

// Processes edit of input-field of Magic Numbers.
void CAccountProtector::OnEndEditMagics()
{
	string magic = m_EdtMagics.Text();
	int length = StringLen(magic);
	
	// Only allowed characters are digits, commas, spaces, and semicolons. At least one digit should be present.
	
	for (int i = 0; i < length; i++)
	{
		if (((magic[i] < '0') || (magic[i] > '9')) && (magic[i] != ' ') && (magic[i] != ',') && (magic[i] != ';'))
		{
			// Wrong character found.
			int replaced_characters = StringReplace(magic, CharToString((uchar)magic[i]), "");
			length -= replaced_characters;
			i--;
		}
	}

	m_EdtMagics.Text(magic);
	
	if (StringCompare(sets.MagicNumbers, magic) != 0)
	{
		sets.MagicNumbers = magic;
		SaveSettingsOnDisk();
	}
	
	ProcessMagicNumbers();
}

// Saves input from Checkbox "Exclude" for magic numbers.
void CAccountProtector::OnChangeChkExcludeMagics()
{
   if (sets.boolExcludeMagics != m_ChkExcludeMagics.Checked())
   {
		sets.boolExcludeMagics = m_ChkExcludeMagics.Checked();
		SaveSettingsOnDisk();
	}
}

// Saves input from the trading instrument radio group.
void CAccountProtector::OnChangeRgpInstrumentFilter()
{
   if (sets.intInstrumentFilter != m_RgpInstrumentFilter.Value())
   {
		sets.intInstrumentFilter = (int)m_RgpInstrumentFilter.Value();
		SaveSettingsOnDisk();
	}
}

// Click on the "Reset filters" button.
void CAccountProtector::OnClickBtnResetFilters()
{
	bool need_to_save_to_disk = false;
	if (sets.intOrderCommentaryCondition != 0) need_to_save_to_disk = true;
	sets.intOrderCommentaryCondition = 0;
	m_CbxOrderCommentaryCondition.Select(0);
	if (StringCompare(sets.OrderCommentary, "") != 0) need_to_save_to_disk = true;
	sets.OrderCommentary = "";
	m_EdtOrderCommentary.Text("");
	if (StringCompare(sets.MagicNumbers, "") != 0) need_to_save_to_disk = true;
	sets.MagicNumbers = "";
	ProcessMagicNumbers();
	m_EdtMagics.Text("");
	if (sets.boolExcludeMagics != false) need_to_save_to_disk = true;
	sets.boolExcludeMagics = false;
	m_ChkExcludeMagics.Checked(false);
	if (sets.intInstrumentFilter != 0) need_to_save_to_disk = true;
	sets.intInstrumentFilter = 0;
	m_RgpInstrumentFilter.Value(0);
	if (need_to_save_to_disk) SaveSettingsOnDisk();
}

// Supplementary function to process checkbox clicks (for Conditions tab).
void CAccountProtector::CheckboxChangeConditions(bool& SettingsCheckboxValue, CCheckBox& CheckBox)
{
   if (SettingsCheckboxValue != CheckBox.Checked())
   {
		SettingsCheckboxValue = CheckBox.Checked();
		sets.Triggered = false;
		sets.TriggeredTime = "";
		SaveSettingsOnDisk();
	}
}

// Changes Checkbox of Condition "Floating loss rises to % of balance".
void CAccountProtector::OnChangeChkLossPerBalance()
{
   CheckboxChangeConditions(sets.boolLossPerBalance, m_ChkLossPerBalance);
}

// Changes Checkbox of Condition "Floating loss falls to % of balance".
void CAccountProtector::OnChangeChkLossPerBalanceReverse()
{
   CheckboxChangeConditions(sets.boolLossPerBalanceReverse, m_ChkLossPerBalanceReverse);
}

// Changes Checkbox of Condition "Floating loss rises to currency units".
void CAccountProtector::OnChangeChkLossQuanUnits()
{
   CheckboxChangeConditions(sets.boolLossQuanUnits, m_ChkLossQuanUnits);
}

// Changes Checkbox of Condition "Floating loss falls to currency units".
void CAccountProtector::OnChangeChkLossQuanUnitsReverse()
{
   CheckboxChangeConditions(sets.boolLossQuanUnitsReverse, m_ChkLossQuanUnitsReverse);
}

// Changes Checkbox of Condition "Floating loss rises to pips".
void CAccountProtector::OnChangeChkLossPips()
{
   CheckboxChangeConditions(sets.boolLossPips, m_ChkLossPips);
}

// Changes Checkbox of Condition "Floating loss falls to pips".
void CAccountProtector::OnChangeChkLossPipsReverse()
{
   CheckboxChangeConditions(sets.boolLossPipsReverse, m_ChkLossPipsReverse);
}

// Changes Checkbox of Condition "Floating profit rises to % of balance".
void CAccountProtector::OnChangeChkProfPerBalance()
{
   CheckboxChangeConditions(sets.boolProfPerBalance, m_ChkProfPerBalance);
}

// Changes Checkbox of Condition "Floating profit falls to % of balance".
void CAccountProtector::OnChangeChkProfPerBalanceReverse()
{
   CheckboxChangeConditions(sets.boolProfPerBalanceReverse, m_ChkProfPerBalanceReverse);
}

// Changes Checkbox of Condition "Floating profit rises to currency units".
void CAccountProtector::OnChangeChkProfQuanUnits()
{
   CheckboxChangeConditions(sets.boolProfQuanUnits, m_ChkProfQuanUnits);
}

// Changes Checkbox of Condition "Floating profit falls to currency units".
void CAccountProtector::OnChangeChkProfQuanUnitsReverse()
{
   CheckboxChangeConditions(sets.boolProfQuanUnitsReverse, m_ChkProfQuanUnitsReverse);
}

// Changes Checkbox of Condition "Floating profit rises to pips".
void CAccountProtector::OnChangeChkProfPips()
{
   CheckboxChangeConditions(sets.boolProfPips, m_ChkProfPips);
}

// Changes Checkbox of Condition "Floating profit falls to pips".
void CAccountProtector::OnChangeChkProfPipsReverse()
{
   CheckboxChangeConditions(sets.boolProfPipsReverse, m_ChkProfPipsReverse);
}

// Changes Checkbox of Condition "Equity <= currency units".
void CAccountProtector::OnChangeChkEquityLessUnits()
{
   CheckboxChangeConditions(sets.boolEquityLessUnits, m_ChkEquityLessUnits);
}

// Changes Checkbox of Condition "Equity >= currency units".
void CAccountProtector::OnChangeChkEquityGrUnits()
{
   CheckboxChangeConditions(sets.boolEquityGrUnits, m_ChkEquityGrUnits);
}

// Changes Checkbox of Condition "Equity <= % of Snapshot".
void CAccountProtector::OnChangeChkEquityLessPerSnap()
{
   CheckboxChangeConditions(sets.boolEquityLessPerSnap, m_ChkEquityLessPerSnap);
}

// Changes Checkbox of Condition "Equity >= % of Snapshot".
void CAccountProtector::OnChangeChkEquityGrPerSnap()
{
   CheckboxChangeConditions(sets.boolEquityGrPerSnap, m_ChkEquityGrPerSnap);
}

// Changes Checkbox of Condition "Margin <= currency units".
void CAccountProtector::OnChangeChkMarginLessUnits()
{
   CheckboxChangeConditions(sets.boolMarginLessUnits, m_ChkMarginLessUnits);
}

// Changes Checkbox of Condition "Margin >= currency units".
void CAccountProtector::OnChangeChkMarginGrUnits()
{
   CheckboxChangeConditions(sets.boolMarginGrUnits, m_ChkMarginGrUnits);
}

// Changes Checkbox of Condition "Margin <= % of Snapshot".
void CAccountProtector::OnChangeChkMarginLessPerSnap()
{
   CheckboxChangeConditions(sets.boolMarginLessPerSnap, m_ChkMarginLessPerSnap);
}  

// Changes Checkbox of Condition "Margin >= % of Snapshot".
void CAccountProtector::OnChangeChkMarginGrPerSnap()
{
   CheckboxChangeConditions(sets.boolMarginGrPerSnap, m_ChkMarginGrPerSnap);
}  

// Supplementary function to process checkbox clicks (for Actions tab).
void CAccountProtector::CheckboxChangeActions(bool& SettingsCheckboxValue, CCheckBox& CheckBox)
{
   if (SettingsCheckboxValue != CheckBox.Checked())
   {
		SettingsCheckboxValue = CheckBox.Checked();
		sets.Triggered = false;
		sets.TriggeredTime = "";	 
		SaveSettingsOnDisk();
	}
}

// Changes Checkbox of Action "Close All Positions".
void CAccountProtector::OnChangeChkClosePos()
{
	// Acts like a condition checkbox for close percentage edit.
	CheckboxChangeConditions(sets.ClosePos, m_ChkClosePos);
} 

// Changes Checkbox of Action "Delete Pending Orders".
void CAccountProtector::OnChangeChkDeletePend()
{
	CheckboxChangeActions(sets.DeletePend, m_ChkDeletePend);
} 

// Changes Checkbox of Action "Disable AutoTrading".
void CAccountProtector::OnChangeChkDisAuto()
{
	if (m_ChkEnableAuto.Checked())
	{
	   m_ChkEnableAuto.Checked(false);
	   sets.EnableAuto = false;
	}
	CheckboxChangeActions(sets.DisAuto, m_ChkDisAuto);
} 

// Changes Checkbox of Action "Send Mails".
void CAccountProtector::OnChangeChkSendMails()
{
	CheckboxChangeActions(sets.SendMails, m_ChkSendMails);
}

// Changes Checkbox of Action "Send Notification".
void CAccountProtector::OnChangeChkSendNotif ()
{
	CheckboxChangeActions(sets.SendNotif, m_ChkSendNotif);
} 

// Changes Checkbox of Action "Close Platform".
void CAccountProtector::OnChangeChkClosePlatform()
{
	CheckboxChangeActions(sets.ClosePlatform, m_ChkClosePlatform);
} 

// Changes Checkbox of Action "Enable AutoTrading".
void CAccountProtector::OnChangeChkEnableAuto()
{
	if (m_ChkDisAuto.Checked())
	{
	   m_ChkDisAuto.Checked(false);
	   sets.DisAuto = false;
	}
	CheckboxChangeActions(sets.EnableAuto, m_ChkEnableAuto);
}

// Changes Checkbox of Action "Recapture snapshots".
void CAccountProtector::OnChangeChkRecaptureSnapshots()
{
	CheckboxChangeActions(sets.RecaptureSnapshots, m_ChkRecaptureSnapshots);
}

// Supplementary function to process changes to edit fields in the Conditions tab:
// 1. Check emptiness.
// 2. Check and log if double.
// 3. Check and log range validity.
// 4. Save if different from current.
template<typename T>
void CAccountProtector::EditChangeConditions(T& SettingsEditValue, CEdit& Edit, const string FieldName, const double RangeMaximum = 0)
{
	double ValueFromEdit = StringToDouble(Edit.Text());

	if (!IsDouble(Edit.Text()))
	{
		Logging("Value is wrong: " + FieldName + ".");
		LoadSettingsFromDisk();
	}
	else if ((RangeMaximum > 0) && (ValueFromEdit >= RangeMaximum))
	{
		Logging(FieldName + " value must be lower than " + DoubleToString(RangeMaximum, 2) + ".");
		LoadSettingsFromDisk();
	}
	else if (SettingsEditValue != ValueFromEdit)
	{
		SettingsEditValue = (T)ValueFromEdit;
		sets.Triggered = false;
		sets.TriggeredTime = "";
		SaveSettingsOnDisk();
	}
}

// Processes edit of input-field of Condition "Floating loss rises to % of balance".
void CAccountProtector::OnEndEditLossPerBalance()
{
	EditChangeConditions(sets.doubleLossPerBalance, m_EdtLossPerBalance, "Floating loss rises to % of balance", 100);
}

// Processes edit of input-field of Condition "Floating loss falls to % of balance".
void CAccountProtector::OnEndEditLossPerBalanceReverse()
{
	EditChangeConditions(sets.doubleLossPerBalanceReverse, m_EdtLossPerBalanceReverse, "Floating loss falls to % of balance", 100);
}

// Processes edit of input-field of Condition "Floating loss rises to currency units".
void CAccountProtector::OnEndEditLossQuanUnits()
{
	EditChangeConditions(sets.doubleLossQuanUnits, m_EdtLossQuanUnits, "Floating loss rises to currency units", AccountInfoDouble(ACCOUNT_BALANCE));
}

// Processes edit of input-field of Condition "Floating loss falls to currency units".
void CAccountProtector::OnEndEditLossQuanUnitsReverse()
{
	EditChangeConditions(sets.doubleLossQuanUnitsReverse, m_EdtLossQuanUnitsReverse, "Floating loss falls to currency units", AccountInfoDouble(ACCOUNT_BALANCE));
}

// Processes edit of input-field of Condition "Floating loss rises to pips".
void CAccountProtector::OnEndEditLossPips()
{
	EditChangeConditions(sets.intLossPips, m_EdtLossPips, "Floating loss rises to pips");
}

// Processes edit of input-field of Condition "Floating loss falls to pips".
void CAccountProtector::OnEndEditLossPipsReverse()
{
	EditChangeConditions(sets.intLossPipsReverse, m_EdtLossPipsReverse, "Floating loss falls to pips");
}

// Processes edit of input-field of Condition "Floating profit rises to % of balance".
void CAccountProtector::OnEndEditProfPerBalance()
{
	EditChangeConditions(sets.doubleProfPerBalance, m_EdtProfPerBalance, "Floating profit rises to % of balance");
}

// Processes edit of input-field of Condition "Floating profit falls to % of balance".
void CAccountProtector::OnEndEditProfPerBalanceReverse()
{
	EditChangeConditions(sets.doubleProfPerBalanceReverse, m_EdtProfPerBalanceReverse, "Floating profit falls to % of balance");
}

// Processes edit of input-field of Condition "Floating profit rises to currency units".
void CAccountProtector::OnEndEditProfQuanUnits()
{
	EditChangeConditions(sets.doubleProfQuanUnits, m_EdtProfQuanUnits, "Floating profit rises to currency units");
}

// Processes edit of input-field of Condition "Floating profit falls to currency units".
void CAccountProtector::OnEndEditProfQuanUnitsReverse()
{
	EditChangeConditions(sets.doubleProfQuanUnitsReverse, m_EdtProfQuanUnitsReverse, "Floating profit falls to currency units");
}

// Processes edit of input-field of Condition "Floating profit rises pips".
void CAccountProtector::OnEndEditProfPips()
{
	EditChangeConditions(sets.intProfPips, m_EdtProfPips, "Floating profit reaches pips");
}

// Processes edit of input-field of Condition "Floating profit rises to pips".
void CAccountProtector::OnEndEditProfPipsReverse()
{
	EditChangeConditions(sets.intProfPipsReverse, m_EdtProfPipsReverse, "Floating profit falls to pips");
}

// Processes edit of input-field of Condition "Equity <= currency units".
void CAccountProtector::OnEndEditEquityLessUnits()
{
	EditChangeConditions(sets.doubleEquityLessUnits, m_EdtEquityLessUnits, "Equity <= currency units", AccountInfoDouble(ACCOUNT_EQUITY));
}

// Processes edit of input-field of Condition "Equity >= currency units".
void CAccountProtector::OnEndEditEquityGrUnits()
{
	EditChangeConditions(sets.doubleEquityGrUnits, m_EdtEquityGrUnits, "Equity >= currency units");
}

// Processes edit of input-field of Condition "Equity <= % of snapshot".
void CAccountProtector::OnEndEditEquityLessPerSnap()
{
	EditChangeConditions(sets.doubleEquityLessPerSnap, m_EdtEquityLessPerSnap, "Equity <= % of snapshot", 100);
}

// Processes edit of input-field of Condition "Equity >= % of snapshot".
void CAccountProtector::OnEndEditEquityGrPerSnap()
{
	EditChangeConditions(sets.doubleEquityGrPerSnap, m_EdtEquityGrPerSnap, "Equity >= % of snapshot");
}

// Processes edit of input-field of Condition "Free margin <= currency units".
void CAccountProtector::OnEndEditMarginLessUnits()
{
	EditChangeConditions(sets.doubleMarginLessUnits, m_EdtMarginLessUnits, "Free margin <= currency units", AccountInfoDouble(ACCOUNT_MARGIN_FREE));
}

// Processes edit of input-field of Condition "Free margin >= currency units".
void CAccountProtector::OnEndEditMarginGrUnits()
{
	EditChangeConditions(sets.doubleMarginGrUnits, m_EdtMarginGrUnits, "Free margin >= currency units");
}

// Processes edit of input-field of Condition "Free margin <= % of snapshot".
void CAccountProtector::OnEndEditMarginLessPerSnap()
{
	EditChangeConditions(sets.doubleMarginLessPerSnap, m_EdtMarginLessPerSnap, "Free margin <= % of snapshot");
}

// Processes edit of input-field of Condition "Free margin >= % of snapshot".
void CAccountProtector::OnEndEditMarginGrPerSnap()
{
	EditChangeConditions(sets.doubleMarginGrPerSnap, m_EdtMarginGrPerSnap, "Free margin >= % of snapshot");
}

// Processes edit of input-field for percentage of volume to be close in Action "Close Positions".
void CAccountProtector::OnEndEditClosePercentage()
{
	int ValueFromEdit = (int)StringToInteger(m_EdtClosePercentage.Text());

	if (!IsInteger(m_EdtClosePercentage.Text()))
	{
		Logging("Value is wrong: Close Percentage.");
		LoadSettingsFromDisk();
	}
	else if (ValueFromEdit > 100)
	{
		Logging("Close Percentage value must be lower or equal to 100.");
		LoadSettingsFromDisk();
	}
	else if (ValueFromEdit < 0)
	{
		Logging("Close Percentage value must be greater than 0.");
		LoadSettingsFromDisk();
	}
	else if (sets.intClosePercentage != ValueFromEdit)
	{
		sets.intClosePercentage = ValueFromEdit;
		sets.Triggered = false;
		sets.TriggeredTime = "";
		SaveSettingsOnDisk();
	}
}

// Supplementary function to process changes to edit fields in the Main tab:
// 1. Check emptiness.
// 2. Check and log if int.
// 3. Save if different from current.
void CAccountProtector::EditChangeMain(int& SettingsEditValue, CEdit& Edit, const string FieldName)
{
	int ValueFromEdit = (int)StringToInteger(Edit.Text());

	if (!IsInteger(Edit.Text()))
	{
		Logging("Value is wrong: " + FieldName + ".");
		LoadSettingsFromDisk();
	}
	else if (SettingsEditValue != ValueFromEdit)
	{
		SettingsEditValue = ValueFromEdit;
		SaveSettingsOnDisk();
	}
}

// Processes edit of input-field of Trailing Start.
void CAccountProtector::OnEndEditTrailingStart()
{
	EditChangeMain(sets.intTrailingStart, m_EdtTrailingStart, "Profit value (pips) to start trailing SL");
}

// Processes edit of input-field of Trailing Step.
void CAccountProtector::OnEndEditTrailingStep()
{
	EditChangeMain(sets.intTrailingStep, m_EdtTrailingStep, "Trailing SL value (pips)");
}

// Processes edit of input-field of Break Even.
void CAccountProtector::OnEndEditBreakEven()
{
	EditChangeMain(sets.intBreakEven, m_EdtBreakEven, "Profit value (pips) to move SL to breakeven");
}

// Processes edit of input-field of Break Even Extra.
void CAccountProtector::OnEndEditBreakEvenExtra()
{
	EditChangeMain(sets.intBreakEvenExtra, m_EdtBreakEvenExtra, "Breakeven extra profit value (pips)");
}

// Processes edit of input-field of Equity Trailing Stop.
void CAccountProtector::OnEndEditEquityTrailingStop()
{
	double ValueFromEdit = StringToDouble(m_EdtEquityTrailingStop.Text());

	if (!IsDouble(m_EdtEquityTrailingStop.Text()))
	{
		Logging("Value is wrong: Equity trailing stop (hidden).");
		LoadSettingsFromDisk();
	}
	else if (sets.doubleEquityTrailingStop != ValueFromEdit)
	{
		sets.doubleEquityTrailingStop = ValueFromEdit;
		SaveSettingsOnDisk();
   	m_EdtEquityTrailingStop.Text(DoubleToString(ValueFromEdit, 2));
	}
}

// Processes click on Emergency Button.
void CAccountProtector::OnClickBtnEmergency()
{
	Logging("Emergency button pressed!");
	if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
	{
		Eliminate_Orders(Active);
		Eliminate_Orders(Pending);
		// Toggle AutoTrading button. "2" in GetAncestor call is the "root window".
		SendMessageW(GetAncestor(WindowHandle(Symbol(), Period()), 2), WM_COMMAND, 33020, 0);
		sets.Triggered = false;
		sets.TriggeredTime = "";
		Logging("All positions closed, pending orders deleted, autotrading disabled.");
	}
}

void CAccountProtector::OnClickBtnDayOfWeek()
{
   if (!m_BtnDayOfWeek.IsEnabled()) return;
   switch(sets.TimerDayOfWeek)
   {
      case Any:
         sets.TimerDayOfWeek = Monday;
         break;
      case Monday:
         sets.TimerDayOfWeek = Tuesday;
         break;
      case Tuesday:
         sets.TimerDayOfWeek = Wednesday;
         break;
      case Wednesday:
         sets.TimerDayOfWeek = Thursday;
         break;
      case Thursday:
         sets.TimerDayOfWeek = Friday;
         break;
      case Friday:
         sets.TimerDayOfWeek = Saturday;
         break;
      case Saturday:
         sets.TimerDayOfWeek = Sunday;
         break;
      case Sunday:
         sets.TimerDayOfWeek = Any;
         break;
      default:
         sets.TimerDayOfWeek = Any;
         break;
   }
   m_BtnDayOfWeek.Text(EnumToString(sets.TimerDayOfWeek));
	RefreshValues();
}

void CAccountProtector::OnClickBtnPositionStatus()
{
   switch(sets.CloseWhichPositions)
   {
      case All:
         sets.CloseWhichPositions = Losing;
         break;
      case Losing:
         sets.CloseWhichPositions = Profitable;
         break;
      case Profitable:
         sets.CloseWhichPositions = All;
         break;
      default:
         sets.CloseWhichPositions = All;
         break;
   }
   m_BtnPositionStatus.Text(EnumToString(sets.CloseWhichPositions));
	RefreshValues();
}

//+-----------------------+
//| Working with settings |
//|+----------------------+

// Saves settings from the panel into a file.
bool CAccountProtector::SaveSettingsOnDisk()
{
	int fh = FileOpen(m_FileName, FILE_TXT | FILE_WRITE);
	if (fh == INVALID_HANDLE)
	{
		Logging("Failed to open file for writing: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
		return(false);
	}

	// Order does not matter.
	FileWrite(fh, "CountCommSwaps");
	FileWrite(fh, IntegerToString(sets.CountCommSwaps));
	FileWrite(fh, "UseTimer");
	FileWrite(fh, IntegerToString(sets.UseTimer));
	FileWrite(fh, "Timer");
	FileWrite(fh, sets.Timer);
	FileWrite(fh, "TimeLeft");
	FileWrite(fh, sets.TimeLeft);
	FileWrite(fh, "TimeType");
	FileWrite(fh, IntegerToString(sets.intTimeType));
	FileWrite(fh, "boolTrailingStart");
	FileWrite(fh, IntegerToString(sets.boolTrailingStart));
	FileWrite(fh, "intTrailingStart");
	FileWrite(fh, IntegerToString(sets.intTrailingStart)); 
	FileWrite(fh, "boolTrailingStep");
	FileWrite(fh, IntegerToString(sets.boolTrailingStep));
	FileWrite(fh, "intTrailingStep");
	FileWrite(fh, IntegerToString(sets.intTrailingStep)); 
	FileWrite(fh, "boolBreakEven");
	FileWrite(fh, IntegerToString(sets.boolBreakEven));
	FileWrite(fh, "intBreakEven");
	FileWrite(fh, IntegerToString(sets.intBreakEven)); 
	FileWrite(fh, "boolBreakEvenExtra");
	FileWrite(fh, IntegerToString(sets.boolBreakEvenExtra));
	FileWrite(fh, "intBreakEvenExtra");
	FileWrite(fh, IntegerToString(sets.intBreakEvenExtra));
	FileWrite(fh, "boolEquityTrailingStop");
	FileWrite(fh, IntegerToString(sets.boolEquityTrailingStop));
	FileWrite(fh, "doubleEquityTrailingStop");
	FileWrite(fh, DoubleToString(sets.doubleEquityTrailingStop, 2));
	FileWrite(fh, "doubleCurrentEquityStopLoss");
	FileWrite(fh, DoubleToString(sets.doubleCurrentEquityStopLoss, 2));
	FileWrite(fh, "SnapEquity");
	FileWrite(fh, DoubleToString(sets.SnapEquity, 2));
	FileWrite(fh, "SnapEquityTime");
	FileWrite(fh, sets.SnapEquityTime);
	FileWrite(fh, "SnapMargin");
	FileWrite(fh, DoubleToString(sets.SnapMargin, 2));
	FileWrite(fh, "SnapMarginTime");
	FileWrite(fh, sets.SnapMarginTime);
	FileWrite(fh, "intOrderCommentaryCondition");
	FileWrite(fh, IntegerToString(sets.intOrderCommentaryCondition));
	FileWrite(fh, "OrderCommentary");
	FileWrite(fh, sets.OrderCommentary);
	FileWrite(fh, "MagicNumbers");
	FileWrite(fh, sets.MagicNumbers);
	FileWrite(fh, "boolExcludeMagics");
	FileWrite(fh, IntegerToString(sets.boolExcludeMagics));
	FileWrite(fh, "intInstrumentFilter");
	FileWrite(fh, IntegerToString(sets.intInstrumentFilter));
	FileWrite(fh, "boolLossPerBalance");
	FileWrite(fh, IntegerToString(sets.boolLossPerBalance));
	FileWrite(fh, "boolLossPerBalanceReverse");
	FileWrite(fh, IntegerToString(sets.boolLossPerBalanceReverse));
	FileWrite(fh, "boolLossQuanUnits");
	FileWrite(fh, IntegerToString(sets.boolLossQuanUnits));
	FileWrite(fh, "boolLossQuanUnitsReverse");
	FileWrite(fh, IntegerToString(sets.boolLossQuanUnitsReverse));
	FileWrite(fh, "boolLossPips");
	FileWrite(fh, IntegerToString(sets.boolLossPips));
	FileWrite(fh, "boolLossPipsReverse");
	FileWrite(fh, IntegerToString(sets.boolLossPipsReverse));
	FileWrite(fh, "boolProfPerBalance");
	FileWrite(fh, IntegerToString(sets.boolProfPerBalance));
	FileWrite(fh, "boolProfPerBalanceReverse");
	FileWrite(fh, IntegerToString(sets.boolProfPerBalanceReverse));
	FileWrite(fh, "boolProfQuanUnits");
	FileWrite(fh, IntegerToString(sets.boolProfQuanUnits));
	FileWrite(fh, "boolProfQuanUnitsReverse");
	FileWrite(fh, IntegerToString(sets.boolProfQuanUnitsReverse));
	FileWrite(fh, "boolProfPips");
	FileWrite(fh, IntegerToString(sets.boolProfPips));
	FileWrite(fh, "boolProfPipsReverse");
	FileWrite(fh, IntegerToString(sets.boolProfPipsReverse));
	FileWrite(fh, "boolEquityLessUnits");
	FileWrite(fh, IntegerToString(sets.boolEquityLessUnits));
	FileWrite(fh, "boolEquityGrUnits");
	FileWrite(fh, IntegerToString(sets.boolEquityGrUnits));
	FileWrite(fh, "boolEquityLessPerSnap");
	FileWrite(fh, IntegerToString(sets.boolEquityLessPerSnap));
	FileWrite(fh, "boolEquityGrPerSnap");
	FileWrite(fh, IntegerToString(sets.boolEquityGrPerSnap));
	FileWrite(fh, "boolMarginLessUnits");
	FileWrite(fh, IntegerToString(sets.boolMarginLessUnits));
	FileWrite(fh, "boolMarginGrUnits");
	FileWrite(fh, IntegerToString(sets.boolMarginGrUnits));
	FileWrite(fh, "boolMarginLessPerSnap");
	FileWrite(fh, IntegerToString(sets.boolMarginLessPerSnap));
	FileWrite(fh, "boolMarginGrPerSnap");
	FileWrite(fh, IntegerToString(sets.boolMarginGrPerSnap));
	FileWrite(fh, "doubleLossPerBalance");
	FileWrite(fh, DoubleToString(sets.doubleLossPerBalance));
	FileWrite(fh, "doubleLossPerBalanceReverse");
	FileWrite(fh, DoubleToString(sets.doubleLossPerBalanceReverse));
	FileWrite(fh, "doubleLossQuanUnits");
	FileWrite(fh, DoubleToString(sets.doubleLossQuanUnits));
	FileWrite(fh, "doubleLossQuanUnitsReverse");
	FileWrite(fh, DoubleToString(sets.doubleLossQuanUnitsReverse));
	FileWrite(fh, "intLossPips");
	FileWrite(fh, IntegerToString(sets.intLossPips));
	FileWrite(fh, "intLossPipsReverse");
	FileWrite(fh, IntegerToString(sets.intLossPipsReverse));
	FileWrite(fh, "doubleProfPerBalance");
	FileWrite(fh, DoubleToString(sets.doubleProfPerBalance));
	FileWrite(fh, "doubleProfPerBalanceReverse");
	FileWrite(fh, DoubleToString(sets.doubleProfPerBalanceReverse));
	FileWrite(fh, "doubleProfQuanUnits");
	FileWrite(fh, DoubleToString(sets.doubleProfQuanUnits));
	FileWrite(fh, "doubleProfQuanUnitsReverse");
	FileWrite(fh, DoubleToString(sets.doubleProfQuanUnitsReverse));
	FileWrite(fh, "intProfPips");
	FileWrite(fh, IntegerToString(sets.intProfPips)); 
	FileWrite(fh, "intProfPipsReverse");
	FileWrite(fh, IntegerToString(sets.intProfPipsReverse)); 
	FileWrite(fh, "doubleEquityLessUnits");
	FileWrite(fh, DoubleToString(sets.doubleEquityLessUnits));
	FileWrite(fh, "doubleEquityGrUnits");
	FileWrite(fh, DoubleToString(sets.doubleEquityGrUnits));
	FileWrite(fh, "doubleEquityLessPerSnap");
	FileWrite(fh, DoubleToString(sets.doubleEquityLessPerSnap));
	FileWrite(fh, "doubleEquityGrPerSnap");
	FileWrite(fh, DoubleToString(sets.doubleEquityGrPerSnap));
	FileWrite(fh, "doubleMarginLessUnits");
	FileWrite(fh, DoubleToString(sets.doubleMarginLessUnits));
	FileWrite(fh, "doubleMarginGrUnits");
	FileWrite(fh, DoubleToString(sets.doubleMarginGrUnits));
	FileWrite(fh, "doubleMarginLessPerSnap");
	FileWrite(fh, DoubleToString(sets.doubleMarginLessPerSnap));
	FileWrite(fh, "doubleMarginGrPerSnap");
	FileWrite(fh, DoubleToString(sets.doubleMarginGrPerSnap));
	FileWrite(fh, "ClosePos");
	FileWrite(fh, IntegerToString(sets.ClosePos));
	FileWrite(fh, "intClosePercentage");
	FileWrite(fh, IntegerToString(sets.intClosePercentage));
	FileWrite(fh, "CloseWhichPositions");
	FileWrite(fh, IntegerToString(sets.CloseWhichPositions));
	FileWrite(fh, "DeletePend");
	FileWrite(fh, IntegerToString(sets.DeletePend));
	FileWrite(fh, "DisAuto");
	FileWrite(fh, IntegerToString(sets.DisAuto));
	FileWrite(fh, "SendMails");
	FileWrite(fh, IntegerToString(sets.SendMails));
	FileWrite(fh, "SendNotif");
	FileWrite(fh, IntegerToString(sets.SendNotif));
	FileWrite(fh, "ClosePlatform");
	FileWrite(fh, IntegerToString(sets.ClosePlatform));
	FileWrite(fh, "EnableAuto");
	FileWrite(fh, IntegerToString(sets.EnableAuto));
	FileWrite(fh, "RecaptureSnapshots");
	FileWrite(fh, IntegerToString(sets.RecaptureSnapshots));
	FileWrite(fh, "SelectedTab");
	FileWrite(fh, IntegerToString(sets.SelectedTab));
	FileWrite(fh, "Triggered");
	FileWrite(fh, IntegerToString(sets.Triggered));
	FileWrite(fh, "TriggeredTime");
	FileWrite(fh, sets.TriggeredTime);
	FileWrite(fh, "TimerDayOfWeek");
	FileWrite(fh, IntegerToString(sets.TimerDayOfWeek));
	
	FileClose(fh);

	return(true);
}

// Supplementary function to load changes to relevant fields in tabs:
// 1. Check checkbox setting.
// 2. Set checkbox mark, read only state, and background color.
// 3. Fill edit field.
void CAccountProtector::RefreshConditions(const bool SettingsCheckBoxValue, const double SettingsEditValue, CCheckBox& CheckBox, CEdit& Edit, const int decimal_places = 2)
{
   if (SettingsCheckBoxValue)
   {
		CheckBox.Checked(true);
	}
	else
	{
		CheckBox.Checked(false);
	}	        
   Edit.Text(DoubleToString(SettingsEditValue, decimal_places));
}

// Loads settings from a file to the panel.
bool CAccountProtector::LoadSettingsFromDisk()
{
   if (!FileIsExist(m_FileName)) return(false);
   int fh = FileOpen(m_FileName, FILE_TXT | FILE_READ);
	if (fh == INVALID_HANDLE)
	{
		Logging("Failed to open file for reading: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
		return(false);
	}

	while (!FileIsEnding(fh))
	{
	   string var_name = FileReadString(fh);
	   string var_content = FileReadString(fh);
	   if (var_name == "CountCommSwaps")
	   	sets.CountCommSwaps = (bool)StringToInteger(var_content);
	   else if (var_name == "UseTimer")
	   	sets.UseTimer = (bool)StringToInteger(var_content);
	   else if (var_name == "Timer")
	   	sets.Timer = var_content;
	   else if (var_name == "TimeLeft")
	   	sets.TimeLeft = var_content;
	   else if (var_name == "intTimeType")
	   	sets.intTimeType = (int)StringToInteger(var_content);
	   else if (var_name == "boolTrailingStart")
	   	sets.boolTrailingStart = (bool)StringToInteger(var_content);
	   else if (var_name == "intTrailingStart")
	   	sets.intTrailingStart = (int)StringToInteger(var_content);
	   else if (var_name == "boolTrailingStep")
	   	sets.boolTrailingStep = (bool)StringToInteger(var_content);
	   else if (var_name == "intTrailingStep")
	      sets.intTrailingStep = (int)StringToInteger(var_content);
	   else if (var_name == "boolBreakEven")
	   	sets.boolBreakEven = (bool)StringToInteger(var_content);
	   else if (var_name == "intBreakEven")
	   	sets.intBreakEven = (int)StringToInteger(var_content);
	   else if (var_name == "boolBreakEvenExtra")
	   	sets.boolBreakEvenExtra = (bool)StringToInteger(var_content);
	   else if (var_name == "intBreakEvenExtra")
	      sets.intBreakEvenExtra = (int)StringToInteger(var_content);
	   else if (var_name == "boolEquityTrailingStop")
	   	sets.boolEquityTrailingStop = (bool)StringToInteger(var_content);
	   else if (var_name == "doubleEquityTrailingStop")
	      sets.doubleEquityTrailingStop = StringToDouble(var_content);
	   else if (var_name == "doubleCurrentEquityStopLoss")
	      sets.doubleCurrentEquityStopLoss = StringToDouble(var_content);
	   else if (var_name == "SnapEquity")
	   	sets.SnapEquity = StringToDouble(var_content);
	   else if (var_name == "SnapEquityTime")
	   	sets.SnapEquityTime = var_content;
	   else if (var_name == "SnapMargin")
	   	sets.SnapMargin = StringToDouble(var_content);
	   else if (var_name == "SnapMarginTime")
	   	sets.SnapMarginTime = var_content;
	   else if (var_name == "intOrderCommentaryCondition")
	   	sets.intOrderCommentaryCondition = (int)StringToInteger(var_content);
	   else if (var_name == "OrderCommentary")
	   	sets.OrderCommentary = var_content;
	   else if (var_name == "MagicNumbers")
	   	sets.MagicNumbers = var_content;
	   else if (var_name == "boolExcludeMagics")
	   	sets.boolExcludeMagics = (bool)StringToInteger(var_content);
	   else if (var_name == "intInstrumentFilter")
	   	sets.intInstrumentFilter = (int)StringToInteger(var_content);
	   else if (var_name == "boolLossPerBalance")
	   {
	   	if (!DisableFloatLossRisePerc) sets.boolLossPerBalance = (bool)StringToInteger(var_content);
	   	else sets.boolLossPerBalance = false;
	   }
	   else if (var_name == "boolLossPerBalanceReverse")
	   {
	   	if (!DisableFloatLossFallPerc) sets.boolLossPerBalanceReverse = (bool)StringToInteger(var_content);
	   	else sets.boolLossPerBalanceReverse = false;
	   }
	   else if (var_name == "boolLossQuanUnits")
	   {
	   	if (!DisableFloatLossRiseCurr) sets.boolLossQuanUnits = (bool)StringToInteger(var_content);
	   	else sets.boolLossQuanUnits = false;
	   }
	   else if (var_name == "boolLossQuanUnitsReverse")
	   {
	   	if (!DisableFloatLossFallCurr) sets.boolLossQuanUnitsReverse = (bool)StringToInteger(var_content);
	   	else sets.boolLossQuanUnitsReverse = false;
	   }
	   else if (var_name == "boolLossPips")
	   {
	   	if (!DisableFloatLossRisePips) sets.boolLossPips = (bool)StringToInteger(var_content);
	   	else sets.boolLossPips = false;
	   }
	   else if (var_name == "boolLossPipsReverse")
	   {
	   	if (!DisableFloatLossFallPips) sets.boolLossPipsReverse = (bool)StringToInteger(var_content);
	   	else sets.boolLossPipsReverse = false;
	   }
	   else if (var_name == "boolProfPerBalance")
	   {
	   	if (!DisableFloatProfitRisePerc) sets.boolProfPerBalance = (bool)StringToInteger(var_content);
	   	else sets.boolProfPerBalance = false;
	   }
	   else if (var_name == "boolProfPerBalanceReverse")
	   {
	   	if (!DisableFloatProfitFallPerc) sets.boolProfPerBalanceReverse = (bool)StringToInteger(var_content);
	   	else sets.boolProfPerBalanceReverse = false;
	   }
	   else if (var_name == "boolProfQuanUnits")
	   {
	   	if (!DisableFloatProfitRiseCurr) sets.boolProfQuanUnits = (bool)StringToInteger(var_content);
	   	else sets.boolProfQuanUnits = false;
	   }
	   else if (var_name == "boolProfQuanUnitsReverse")
	   {
	   	if (!DisableFloatProfitFallCurr) sets.boolProfQuanUnitsReverse = (bool)StringToInteger(var_content);
	   	else sets.boolProfQuanUnitsReverse = false;
	   }
	   else if (var_name == "boolProfPips")
	   {
	   	if (!DisableFloatProfitRisePips) sets.boolProfPips = (bool)StringToInteger(var_content);
	   	else sets.boolProfPips = false;
	   }
	   else if (var_name == "boolProfPipsReverse")
	   {
	   	if (!DisableFloatProfitFallPips) sets.boolProfPipsReverse = (bool)StringToInteger(var_content);
	   	else sets.boolProfPipsReverse = false;
	   }
	   else if (var_name == "boolEquityLessUnits")
	   	sets.boolEquityLessUnits = (bool)StringToInteger(var_content);
	   else if (var_name == "boolEquityGrUnits")
	   	sets.boolEquityGrUnits = (bool)StringToInteger(var_content);
	   else if (var_name == "boolEquityLessPerSnap")
	   	sets.boolEquityLessPerSnap = (bool)StringToInteger(var_content);
	   else if (var_name == "boolEquityGrPerSnap")
	   	sets.boolEquityGrPerSnap = (bool)StringToInteger(var_content);
	   else if (var_name == "boolMarginLessUnits")
	   	sets.boolMarginLessUnits = (bool)StringToInteger(var_content);
	   else if (var_name == "boolMarginGrUnits")
	   	sets.boolMarginGrUnits = (bool)StringToInteger(var_content);
	   else if (var_name == "boolMarginLessPerSnap")
	   	sets.boolMarginLessPerSnap = (bool)StringToInteger(var_content);
	   else if (var_name == "boolMarginGrPerSnap")
	   	sets.boolMarginGrPerSnap = (bool)StringToInteger(var_content);
	   else if (var_name == "doubleLossPerBalance")
	   {
	   	if (!DisableFloatLossRisePerc) sets.doubleLossPerBalance = StringToDouble(var_content);
	   	else sets.doubleLossPerBalance = 0;
	   }
	   else if (var_name == "doubleLossPerBalanceReverse")
	   {
	   	if (!DisableFloatLossFallPerc) sets.doubleLossPerBalanceReverse = StringToDouble(var_content);
	   	else sets.doubleLossPerBalanceReverse = 0;
	   }
	   else if (var_name == "doubleLossQuanUnits")
	   {
	   	if (!DisableFloatLossRiseCurr) sets.doubleLossQuanUnits = StringToDouble(var_content);
	   	else sets.doubleLossQuanUnits = 0;
	   }
	   else if (var_name == "doubleLossQuanUnitsReverse")
	   {
	   	if (!DisableFloatLossFallCurr) sets.doubleLossQuanUnitsReverse = StringToDouble(var_content);
	   	else sets.doubleLossQuanUnitsReverse = 0;
	   }
	   else if (var_name == "intLossPips")
	   {
	   	if (!DisableFloatLossRisePips) sets.intLossPips = (int)StringToInteger(var_content); 
	   	else sets.intLossPips = 0;
	   }
	   else if (var_name == "intLossPipsReverse")
	   {
	   	if (!DisableFloatLossFallPips) sets.intLossPipsReverse = (int)StringToInteger(var_content); 
	   	else sets.intLossPipsReverse = 0;
	   }
	   else if (var_name == "doubleProfPerBalance")
	   {
	   	if (!DisableFloatProfitRisePerc) sets.doubleProfPerBalance = StringToDouble(var_content);
	   	else sets.doubleProfPerBalance = 0;
	   }
	   else if (var_name == "doubleProfPerBalanceReverse")
	   {
	   	if (!DisableFloatProfitFallPerc) sets.doubleProfPerBalanceReverse = StringToDouble(var_content);
	   	else sets.doubleProfPerBalanceReverse = 0;
	   }
	   else if (var_name == "doubleProfQuanUnits")
	   {
	   	if (!DisableFloatProfitRiseCurr) sets.doubleProfQuanUnits = StringToDouble(var_content);
	   	else sets.doubleProfQuanUnits = 0;
	   }
	   else if (var_name == "doubleProfQuanUnitsReverse")
	   {
	   	if (!DisableFloatProfitFallCurr) sets.doubleProfQuanUnitsReverse = StringToDouble(var_content);
	   	else sets.doubleProfQuanUnitsReverse = 0;
	   }
	   else if (var_name == "intProfPips")
	   {
	   	if (!DisableFloatProfitRisePips) sets.intProfPips = (int)StringToInteger(var_content); 
	   	else sets.intProfPips = 0;
	   }
	   else if (var_name == "intProfPipsReverse")
	   {
	   	if (!DisableFloatProfitFallPips) sets.intProfPipsReverse = (int)StringToInteger(var_content); 
	   	else sets.intProfPipsReverse = 0;
	   }
	   else if (var_name == "doubleEquityLessUnits")
	   	sets.doubleEquityLessUnits = StringToDouble(var_content);
	   else if (var_name == "doubleEquityGrUnits")
	   	sets.doubleEquityGrUnits = StringToDouble(var_content);
	   else if (var_name == "doubleEquityLessPerSnap")
	   	sets.doubleEquityLessPerSnap = StringToDouble(var_content);
	   else if (var_name == "doubleEquityGrPerSnap")
	   	sets.doubleEquityGrPerSnap = StringToDouble(var_content);
	   else if (var_name == "doubleMarginLessUnits")
	   	sets.doubleMarginLessUnits = StringToDouble(var_content);
	   else if (var_name == "doubleMarginGrUnits")
	   	sets.doubleMarginGrUnits = StringToDouble(var_content);
	   else if (var_name == "doubleMarginLessPerSnap")
	   	sets.doubleMarginLessPerSnap = StringToDouble(var_content);
	   else if (var_name == "doubleMarginGrPerSnap")
	   	sets.doubleMarginGrPerSnap = StringToDouble(var_content);
	   else if (var_name == "ClosePos")
	   	sets.ClosePos = (bool)StringToInteger(var_content);
	   else if (var_name == "intClosePercentage")
	   	sets.intClosePercentage = (int)StringToInteger(var_content);
	   else if (var_name == "CloseWhichPositions")
	   	sets.CloseWhichPositions = (Position_Status)StringToInteger(var_content);
	   else if (var_name == "DeletePend")
	   	sets.DeletePend = (bool)StringToInteger(var_content);
	   else if (var_name == "DisAuto")
	   	sets.DisAuto = (bool)StringToInteger(var_content);
	   else if (var_name == "SendMails")
	   	sets.SendMails = (bool)StringToInteger(var_content);
	   else if (var_name == "SendNotif")
	   	sets.SendNotif = (bool)StringToInteger(var_content);
	   else if (var_name == "ClosePlatform")
	   	sets.ClosePlatform = (bool)StringToInteger(var_content);
	   else if (var_name == "EnableAuto")
	   	sets.EnableAuto = (bool)StringToInteger(var_content);
	   else if (var_name == "EnableAuto")
	   	sets.EnableAuto = (bool)StringToInteger(var_content);
	   else if (var_name == "RecaptureSnapshots")
	   	sets.RecaptureSnapshots = (TABS)StringToInteger(var_content);
	   else if (var_name == "Triggered")
	   	sets.Triggered = (bool)StringToInteger(var_content);
	   else if (var_name == "TriggeredTime")
	   	sets.TriggeredTime = var_content;
	   else if (var_name == "TimerDayOfWeek")
	   	sets.TimerDayOfWeek = (Day_of_Week)StringToInteger(var_content);
	}

   FileClose(fh);

	// Refreshing panel controls.
	RefreshPanelControls();
	
	return(true);
} 

// Deletes the settings file.
bool CAccountProtector::DeleteSettingsFile()
{
   if (!FileIsExist(m_FileName)) return(false);
   if (!FileDelete(m_FileName))
   {
   	Logging("Failed to delete file: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
   	return(false);
   }
   return(true);
} 
 
void CAccountProtector::HideShowMaximize(bool max = true)
{
   // Remember the panel's location.
   remember_left = Left();
   remember_top = Top();

	Hide();
	Show();
	if (!max) NoPanelMaximization = true;
	else NoPanelMaximization = false;
	Maximize();
}
 
//+------------------------------------------------+
//|                                                |
//|              Operational Functions             |
//|                                                |
//+------------------------------------------------+

// Checks EA status.
void CAccountProtector::Check_Status()
{
	if (sets.Triggered) return;
	if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED)))
	{
		m_LblStatus.Text("Status: Autotrading is disabled.");
		return;
	} 
	else if ((!MQLInfoInteger(MQL_DLLS_ALLOWED)) && ((sets.DisAuto) || (sets.EnableAuto)))
	{
		m_LblStatus.Text("Status: DLLs are disabled.");
		return;
	} 
	else if (No_Condition())
	{
		m_LblStatus.Text("Status: No condition set.");
		return;
	} 
	else if (No_Action())
	{
		m_LblStatus.Text("Status: No action set.");
		return;
	} 
	m_LblStatus.Text("Status: OK.");
	return;
} 

// Checks if there is no condition set.
bool CAccountProtector::No_Condition()
{
	if ((!sets.UseTimer) &&
	(!sets.boolProfPerBalance) && (!sets.boolProfQuanUnits) && (!sets.boolProfPips) &&
	(!sets.boolLossPerBalance) && (!sets.boolLossQuanUnits) && (!sets.boolLossPips) &&
	(!sets.boolProfPerBalanceReverse) && (!sets.boolProfQuanUnitsReverse) && (!sets.boolProfPipsReverse) &&
	(!sets.boolLossPerBalanceReverse) && (!sets.boolLossQuanUnitsReverse) && (!sets.boolLossPipsReverse) &&
	(!sets.boolEquityLessUnits) && (!sets.boolEquityGrUnits) && (!sets.boolEquityLessPerSnap) && (!sets.boolEquityGrPerSnap) &&
	(!sets.boolMarginLessUnits) && (!sets.boolMarginGrUnits) && (!sets.boolMarginLessPerSnap) && (!sets.boolMarginGrPerSnap)
	) return(true);
	
	return(false);
}

// Checks if there is no action set.
bool CAccountProtector::No_Action()
{
	if ((!sets.ClosePos) && (!sets.DeletePend) && (!sets.DisAuto) && (!sets.SendMails) && (!sets.SendNotif) && (!sets.ClosePlatform) && (!sets.EnableAuto) && (!sets.RecaptureSnapshots)) return(true);

	return(false);
}

// Calculates TimeLeft (to trigger actions "Timeout by Timer").
string CAccountProtector::NewTime()
{
	datetime chosen_time;
	int currtime, timertime, time, mod_time_60;
	string hour, minute;
	MqlDateTime currenttime_struct, timertime_struct;
	
	if (sets.intTimeType == 0) chosen_time = TimeCurrent();
	else chosen_time = TimeLocal();
	
	TimeToStruct(chosen_time, currenttime_struct);
	TimeToStruct(StringToTime(sets.Timer), timertime_struct);
	
	currtime = currenttime_struct.hour * 60 + currenttime_struct.min;
	timertime = timertime_struct.hour * 60 + timertime_struct.min;
	
	if (sets.TimerDayOfWeek == Any)
	{
	   // Disregard day of the week.
   	if (timertime == currtime) return("00:00");
   	
   	// This day or next day.
   	if (timertime > currtime) time = timertime - currtime;
   	else time = 1440 - currtime + timertime; // 1440 - minutes in a day.
	}
	else
	{
	   int currdayofweek = currenttime_struct.day_of_week;
	   if (currdayofweek == 0) currdayofweek = 7; // Make Sunday the 7th day.
	   int timerdayofweek = (int)sets.TimerDayOfWeek;
	   // Same day of the week - either later today or in one week.
	   if (currdayofweek == timerdayofweek)
	   {
      	if (timertime == currtime) return("00:00");
      	
      	// This day or next week.
      	if (timertime > currtime) time = timertime - currtime;
      	else time = 10080 - currtime + timertime; // 10080 - minutes in a week.
	   }
	   else if (currdayofweek < timerdayofweek) // Timer is set to future day of the week.
	   {
      	if (timertime > currtime) // Now is 16:00, timer is for 18:00.
      	{
      	   time = timertime - currtime; 
      	   time += (timerdayofweek - currdayofweek) * 1440; // Add minutes for each day of difference.
      	}
      	else // Now is 23:00, timer is for 1:00.
      	{
      	   time = 1440 - currtime + timertime; // 1440 - minutes in a day.
      	   time += (timerdayofweek - currdayofweek - 1) * 1440; // Add minutes for each day of difference except for the current one.
      	}
	   }
	   else // Timer is set to a previous day of the week and thus should trigger on next week.
	   {
      	if (timertime >= currtime) // Now is 16:00, timer is for 18:00.
      	{
      	   time = timertime - currtime; 
      	   time += 10080 - (currdayofweek - timerdayofweek) * 1440; // Add hours for each day of difference.
      	}
      	else // Now is 23:00, timer is for 1:00.
      	{
      	   time = 1440 - currtime + timertime; // 1440 - minutes in a day.
      	   time += 10080 - (currdayofweek - timerdayofweek + 1) * 1440; // Add minutes for each day of difference except for the current one.
      	}
	   }
	}
	
	string days_string = "";
	int days = time / 1440;
	
   if (days > 0) days_string = IntegerToString(days) + ":";

   time -= days * 1440; // Remove days from the time difference.

	mod_time_60 = (int)MathMod(time, 60);
	
	// Leading zero for hours.
	if ((time - mod_time_60) / 60 < 10) hour = "0" + DoubleToString((time - mod_time_60) / 60, 0);
	else hour = DoubleToString((time - mod_time_60) / 60, 0);
	
	// Leading zero for minutes
	if (mod_time_60 < 10) minute = "0" + DoubleToString(mod_time_60, 0);
	else minute = DoubleToString(mod_time_60, 0);
	
	return(days_string + hour + ":" + minute);
} 

// Returns true if order should be filtered out based on its symbol and filter settings.
bool CAccountProtector::CheckFilterSymbol(const string order_symbol)
{
	// Skip an order if its Symbol is not the current one, and instrument filter is set to 'Use only current trading instrument'.
	if ((order_symbol != Symbol()) && (sets.intInstrumentFilter == 1)) return(true);
	// Skip an order if its Symbol is the same as the current one, and instrument filter is set to 'Exclude current trading instrument'.
	if ((order_symbol == Symbol()) && (sets.intInstrumentFilter == 2)) return(true);
	
	return(false);
}

// Returns true if order should be filtered out based on its comment and filter settings.
bool CAccountProtector::CheckFilterComment(const string order_comment)
{
	// Skip an order if its commentary is not the same as filter value, and list view is set to "Equals".
	if ((order_comment != sets.OrderCommentary) && (sets.intOrderCommentaryCondition == 1)) return(true);
	// Skip an order if its commentary is the same as filter value, and list view is set to "Not equal".
	if ((order_comment == sets.OrderCommentary) && (sets.intOrderCommentaryCondition == 3)) return(true);
	// Skip an order if the filter value was given but was not found in order commentary, and list view is set to "Contains".
	if ((StringCompare(sets.OrderCommentary, "") != 0) && (StringFind(order_comment, sets.OrderCommentary) == -1) && (sets.intOrderCommentaryCondition == 0)) return(true);
	// Skip an order if the filter value was given and was found in order commentary, and list view is set to "Does not contain".
	if ((StringCompare(sets.OrderCommentary, "") != 0) && (StringFind(order_comment, sets.OrderCommentary) >= 0) && (sets.intOrderCommentaryCondition == 2)) return(true);

	return(false);
}

// Returns true if order should be filtered out based on its magic number and filter settings. j - MagicNumbers_array cycle iteration.
bool CAccountProtector::CheckFilterMagic(const int magic, const int j)
{
	if (j == -1)
	{
		// There are some Magic numbers given but we are in a general cycle.
		if (magic_array_counter > 0) return(true);
		// No Magic numbers given but "Exclude" option is checked, and we are in a general cycle.
		if ((magic == 0) && (sets.boolExcludeMagics)) return(true);
	}
	else if (j >= 0)
	{
		// Skip order if its magic number is not in the array, and "Exclude" option is turned off.
		if ((magic != MagicNumbers_array[j]) && (!sets.boolExcludeMagics)) return(true);
		// Skip order if its magic number is in the array, and "Exclude" option is turned on.
		if ((magic == MagicNumbers_array[j]) && (sets.boolExcludeMagics)) return(true);
	}

	return(false);
}

// Closes all orders or deletes all pending orders.
void CAccountProtector::Eliminate_Orders(const Type_of_Order order_type = Active)
{
	int error = -1;
	bool AreAllOrdersEliminated = true;

	if (order_type == Active)
	{
		QuantityClosedMarketOrders = 0;
		IsANeedToContinueClosingOrders = false;
	}
	else
	{
		QuantityDeletedPendingOrders = 0;
		IsANeedToContinueDeletingPendingOrders = false;
	}

	if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!TerminalInfoInteger(TERMINAL_CONNECTED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED))) return;
	
	// Closing market orders.
	for (int i = OrdersTotal() - 1; i >= 0; i--)
	{
		if (!OrderSelect(i, SELECT_BY_POS))
		{
			error = GetLastError();
			Logging("Account Protector: OrderSelect failed " + IntegerToString(error) + ".");
			if (order_type == Active) IsANeedToContinueClosingOrders = true;
			else IsANeedToContinueDeletingPendingOrders = true;
		}
		else if (SymbolInfoInteger(OrderSymbol(), SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED)
		{
			if (order_type == Active) IsANeedToContinueClosingOrders = true;
			else IsANeedToContinueDeletingPendingOrders = true;
			continue;
		}
		else
		{
			if (CheckFilterSymbol(OrderSymbol())) continue;
			if (CheckFilterComment(OrderComment())) continue;
			// Starting from -1 index to check for orders irrespective of their Magic numbers.
			for (int j = -1; j < magic_array_counter; j++)
			{
				if (CheckFilterMagic(OrderMagicNumber(), j)) continue;
				if (order_type == Active)
				{
				   // Skip profitable positions if only losing ones should be closed.
				   if ((OrderProfit() >= 0) && (sets.CloseWhichPositions == Losing)) continue;
				   // Skip losing positions if only profitable ones should be closed.
				   if ((OrderProfit() < 0) && (sets.CloseWhichPositions == Profitable)) continue;
					if (OrderType() == OP_BUY)
					{
						error = Eliminate_Current_Order(OrderTicket());
						if (error != 0) Logging("Account Protector: OrderClose Buy failed. Error #" + IntegerToString(error));
						else
						{
							QuantityClosedMarketOrders++;
						}
					} 
					else if (OrderType() == OP_SELL)
					{
						error = Eliminate_Current_Order(OrderTicket());
						if (error != 0) Logging("Account Protector: OrderClose Sell failed. Error #" + IntegerToString(error));
						else
						{
   						QuantityClosedMarketOrders++;
						}
					}
				}
				// Pending
				else 
				{
					if ((OrderType() == OP_BUYLIMIT) || (OrderType() == OP_SELLLIMIT) || (OrderType() == OP_BUYSTOP) || (OrderType() == OP_SELLSTOP))
					{
						error = Eliminate_Current_Order(OrderTicket());
						if (error != 0) Logging("Account Protector: OrderDelete failed. Error #" + IntegerToString(error));
						else
						{
							Logging("Account Protector: " + OrderSymbol() + " Pending order #" + IntegerToString(OrderTicket()) + "; Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", SL = " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", TP = " + DoubleToString(OrderTakeProfit(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " was deleted.");
							QuantityDeletedPendingOrders++;
						}
					}
				}
			}
		}
	}
	
	// Check if all orders have been eliminated.
	if (((order_type == Active) && (!IsANeedToContinueClosingOrders)) || ((order_type == Pending) && (!IsANeedToContinueDeletingPendingOrders))) return;

	AreAllOrdersEliminated = true;
	
	for (int i = OrdersTotal() - 1; i >= 0; i--)
	{
		if (!OrderSelect(i, SELECT_BY_POS))
		{
			error = GetLastError();
			Logging("Account Protector: OrderSelect failed " + IntegerToString(error));
		} 
		else
		{
			if (CheckFilterSymbol(OrderSymbol())) continue;
			if (CheckFilterComment(OrderComment())) continue;
			// Starting from -1 index to check for orders irrespective of their Magic numbers.
			for (int j = -1; j < magic_array_counter; j++)
			{
				if (CheckFilterMagic(OrderMagicNumber(), j)) continue;

			   if (order_type == Active) // Doesn't make sense for Pending.
			   {
   			   // Skip profitable positions if only losing ones should be closed.
   			   if ((OrderProfit() >= 0) && (sets.CloseWhichPositions == Losing)) continue;
   			   // Skip losing positions if only profitable ones should be closed.
   			   if ((OrderProfit() < 0) && (sets.CloseWhichPositions == Profitable)) continue;
            }
            
            // Check for partial close.
            // Extract previous order ticket from the comment.
            string comment = OrderComment();
            int comment_pos = StringFind(comment, "from #");
            if (comment_pos != -1)
            {
               // Partial close already performed for this order.
               if (PartiallyClosedOrders.Search(StringToInteger(StringSubstr(comment, comment_pos + 6))) != -1) continue;
            }

				if (((order_type == Active) && ((OrderType() == OP_BUY) || (OrderType() == OP_SELL))) ||
					((order_type == Pending) && ((OrderType() == OP_BUYLIMIT) || (OrderType() == OP_SELLLIMIT) || (OrderType() == OP_BUYSTOP) || (OrderType() == OP_SELLSTOP))))
				{
					AreAllOrdersEliminated = false;
					break;
				}
			}    
			if (!AreAllOrdersEliminated) break;
		}  
	}
	
	if (AreAllOrdersEliminated)
	{
		if (order_type == Active) IsANeedToContinueClosingOrders = false;
		else IsANeedToContinueDeletingPendingOrders = false;
	}
}

// Closes an order or deletes a pending order by ticket number.
int CAccountProtector::Eliminate_Current_Order(int ticket)
{
	int error = -1;

	if (!OrderSelect(ticket, SELECT_BY_TICKET))
	{
		error = GetLastError();
		Logging("Account Protector: OrderSelect failed " + IntegerToString(error));
		return(error);
	} 

   // Extract previous order ticket from the comment.
   string comment = OrderComment();
   int comment_pos = StringFind(comment, "from #");
   if (comment_pos != -1)
   {
      // Partial close already performed for this order.
      if (PartiallyClosedOrders.Search(StringToInteger(StringSubstr(comment, comment_pos + 6))) != -1) return(0);
   }
   
	if (OrderType() == OP_BUY)
	{
		double order_lots = OrderLots();
		double calculated_order_lots = CalculateOrderLots(order_lots, OrderSymbol());
		if (!OrderClose(OrderTicket(), calculated_order_lots, MarketInfo(OrderSymbol(), MODE_BID), Slippage, CLR_NONE))
		{
			IsANeedToContinueClosingOrders = true;
			return(GetLastError());
		} 
		else
		{
		   if (calculated_order_lots != order_lots)
		   {
				Logging("Account Protector: " + OrderSymbol() + " Buy order #" + IntegerToString(OrderTicket()) + "; Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", SL = " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", TP = " + DoubleToString(OrderTakeProfit(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " was partially closed (" + IntegerToString(sets.intClosePercentage) + "%) at " + DoubleToString(MarketInfo(OrderSymbol(), MODE_BID), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ".");
		      PartiallyClosedOrders.Add(OrderTicket());
	         PartiallyClosedOrders.Sort();
		   }
		   else
		   {
				Logging("Account Protector: " + OrderSymbol() + " Buy order #" + IntegerToString(OrderTicket()) + "; Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", SL = " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", TP = " + DoubleToString(OrderTakeProfit(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " was closed at " + DoubleToString(MarketInfo(OrderSymbol(), MODE_BID), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ".");
         }
		   return(0);
		}
   }
	if (OrderType() == OP_SELL)
	{
      double order_lots = OrderLots();
      double calculated_order_lots = CalculateOrderLots(order_lots, OrderSymbol());
		if (!OrderClose(OrderTicket(), CalculateOrderLots(OrderLots(), OrderSymbol()), MarketInfo(OrderSymbol(), MODE_ASK), Slippage, CLR_NONE))
		{
			IsANeedToContinueClosingOrders = true;
			return(GetLastError());
		}
		else
		{
		   if (calculated_order_lots != order_lots)
		   {
		      Logging("Account Protector: " + OrderSymbol() + " Sell order #" + IntegerToString(OrderTicket()) + "; Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", SL = " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", TP = " + DoubleToString(OrderTakeProfit(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " was partially closed (" + IntegerToString(sets.intClosePercentage) + "%) at " + DoubleToString(MarketInfo(OrderSymbol(), MODE_ASK), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ".");
		      PartiallyClosedOrders.Add(OrderTicket());
	         PartiallyClosedOrders.Sort();
		   }
         else
         {
            Logging("Account Protector: " + OrderSymbol() + " Sell order #" + IntegerToString(OrderTicket()) + "; Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", SL = " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", TP = " + DoubleToString(OrderTakeProfit(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " was closed at " + DoubleToString(MarketInfo(OrderSymbol(), MODE_ASK), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ".");
		   }
		   return(0);
		}
	}
	if ((OrderType() == OP_BUYLIMIT) || (OrderType() == OP_SELLLIMIT) || (OrderType() == OP_BUYSTOP) || (OrderType() == OP_SELLSTOP))
		if (!OrderDelete(OrderTicket(), clrNONE))
		{
			IsANeedToContinueDeletingPendingOrders = true;
			return(GetLastError());
		}
		else return(0);

	return(-1);
}

// Trails stop-losses for all positions.
void CAccountProtector::Trailing()
{
	double SL, trailing_start = 0;

	if ((!sets.boolTrailingStep) || (sets.intTrailingStep == 0)) return;
	if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!TerminalInfoInteger(TERMINAL_CONNECTED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED))) return;
	
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (!OrderSelect(i, SELECT_BY_POS)) Logging("Account Protector: OrderSelect failed " + IntegerToString(GetLastError()) + ".");
		else if (SymbolInfoInteger(OrderSymbol(), SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED) continue;
		else
		{
			if (CheckFilterSymbol(OrderSymbol())) continue;
			if (CheckFilterComment(OrderComment())) continue;
			// Starting from -1 index to check for orders irrespective of their Magic numbers.
			for (int j = -1; j < magic_array_counter; j++)
			{
				if (CheckFilterMagic(OrderMagicNumber(), j)) continue;
				
				if (sets.boolTrailingStart == 0) trailing_start = 0;
				else trailing_start = sets.intTrailingStart * MarketInfo(OrderSymbol(), MODE_POINT); 
				
				if (OrderType() == OP_BUY)
				{
					if (MarketInfo(OrderSymbol(), MODE_BID) - OrderOpenPrice() >= trailing_start)
					{
						SL = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID) - sets.intTrailingStep * MarketInfo(OrderSymbol(), MODE_POINT), (int)MarketInfo(OrderSymbol(), MODE_DIGITS));
						if (SL > OrderStopLoss())
						{
							if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, OrderTakeProfit(), OrderExpiration()))
								Logging("Account Protector: OrderModify Buy failed " + IntegerToString(GetLastError()) + ".");
							else
								Logging("Account Protector: Trailing stop was applied to position - " + OrderSymbol() + " BUY-order #" + IntegerToString(OrderTicket()) + " Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", Stop-Loss was moved from " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " to " + DoubleToString(SL, (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ".");
						}
					}
				}
				else if (OrderType() == OP_SELL)
				{
					if (OrderOpenPrice() - MarketInfo(OrderSymbol(), MODE_ASK) >= trailing_start)
					{
						SL = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK) + sets.intTrailingStep * MarketInfo(OrderSymbol(), MODE_POINT), (int)MarketInfo(OrderSymbol(), MODE_DIGITS));
						if ((SL < OrderStopLoss()) || (OrderStopLoss() == 0))
						{
							if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, OrderTakeProfit(), OrderExpiration()))
								Logging("Account Protector: OrderModify Sell failed " + IntegerToString(GetLastError()) + ".");
							else
								Logging("Account Protector: Trailing stop was applied to position - " + OrderSymbol() + " SELL-order #" + IntegerToString(OrderTicket()) + " Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS))+", Stop-Loss was moved from " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " to " + DoubleToString(SL, (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ".");
						}
					}
				}
			}
		}
	}
}

// Moves stop-loss to breakeven or breakeven with extra pips of profit.
void CAccountProtector::MoveToBreakEven()
{
	double SL;

	if ((!sets.boolBreakEven) || (sets.intBreakEven == 0)) return; 
	if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!TerminalInfoInteger(TERMINAL_CONNECTED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED))) return;
	
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (!OrderSelect(i, SELECT_BY_POS)) Logging("Account Protector: OrderSelect failed " + IntegerToString(GetLastError()) + ".");
		else if (SymbolInfoInteger(OrderSymbol(), SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED) continue;
		else
		{
			if (CheckFilterSymbol(OrderSymbol())) continue;
			if (CheckFilterComment(OrderComment())) continue;
			// Starting from -1 index to check for orders irrespective of their Magic numbers.
			for (int j = -1; j < magic_array_counter; j++)
			{
				if (CheckFilterMagic(OrderMagicNumber(), j)) continue;
					
				if (OrderType() == OP_BUY)
				{
					if (MarketInfo(OrderSymbol(), MODE_BID) - OrderOpenPrice() >= sets.intBreakEven * MarketInfo(OrderSymbol(), MODE_POINT))
					{
						if (sets.intBreakEvenExtra == 0) SL = OrderOpenPrice();
						else SL = OrderOpenPrice() + sets.intBreakEvenExtra * MarketInfo(OrderSymbol(), MODE_POINT);
						if (SL > OrderStopLoss())
						{
							if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, OrderTakeProfit(),OrderExpiration()))
								Logging("Account Protector: OrderModify Buy failed " + IntegerToString(GetLastError()) + ".");
							else
								Logging("Account Protector: Breakeven was applied to position - " + OrderSymbol() + " BUY-order #" + IntegerToString(OrderTicket()) + " Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", Stop-Loss was moved from " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " to " + DoubleToString(SL, (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ".");
						}
					}
				}     
				else if (OrderType() == OP_SELL)
				{
					if (OrderOpenPrice() - MarketInfo(OrderSymbol(), MODE_ASK) >= sets.intBreakEven * MarketInfo(OrderSymbol(), MODE_POINT))
					{
						if (sets.intBreakEvenExtra == 0) SL = OrderOpenPrice();
						else SL = OrderOpenPrice() - sets.intBreakEvenExtra * MarketInfo(OrderSymbol(), MODE_POINT);
						if ((SL < OrderStopLoss()) || (OrderStopLoss() == 0))
						{
							if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL,OrderTakeProfit(), OrderExpiration()))
								Logging("Account Protector: OrderModify Sell failed " + IntegerToString(GetLastError()) + ".");
							else
								Logging("Account Protector: Breakeven was applied to position - " + OrderSymbol() + " SELL-order #" + IntegerToString(OrderTicket()) + " Lotsize = " + DoubleToString(OrderLots(), 2) + ", OpenPrice = " + DoubleToString(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ", Stop-Loss was moved from " + DoubleToString(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + " to " + DoubleToString(SL, (int)MarketInfo(OrderSymbol(), MODE_DIGITS)) + ".");
						}
					}
				}
			}
		}
	}
}

// Trails equity with a hidden equity stop-loss.
void CAccountProtector::EquityTrailing()
{
	if ((!sets.boolEquityTrailingStop) || (sets.doubleEquityTrailingStop <= 0)) return;
	if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!TerminalInfoInteger(TERMINAL_CONNECTED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED))) return;
	
	double AE = AccountEquity();
	
	// If equity stop-loss has been hit - close all positions.
	if ((AE <= sets.doubleCurrentEquityStopLoss) && (sets.doubleCurrentEquityStopLoss != 0))
	{
      Logging("Account Protector: Equity stop-loss of " + DoubleToString(sets.doubleCurrentEquityStopLoss, 2) + " hit at " + DoubleToString(AE, 2) + ". Closing all positions.");
	   Eliminate_Orders(Active);

	   sets.boolEquityTrailingStop = false;
	   m_ChkEquityTrailingStop.Checked(false);

      m_LblCurrentEquityStopLoss.Hide();
      m_BtnResetEquityStopLoss.Hide();
   
		SaveSettingsOnDisk();
	   MoveAndResize();
   }
	// If equity stop-loss should be trailed - update the stop-loss.
	else if ((AE - sets.doubleEquityTrailingStop > sets.doubleCurrentEquityStopLoss) || (sets.doubleCurrentEquityStopLoss == 0))
	{
	   double old_value = sets.doubleCurrentEquityStopLoss;
	   sets.doubleCurrentEquityStopLoss = AE - sets.doubleEquityTrailingStop;
      SaveSettingsOnDisk();
      string account_currency = AccountCurrency();
      if (account_currency != "") m_LblCurrentEquityStopLoss.Text("Current equity stop-loss: " + DoubleToString(sets.doubleCurrentEquityStopLoss, 2) + " " + account_currency + ".");
   	// There was no equity stop-loss - now there is. The status line should be added after the equity stop-loss setting line on the panel.
   	if (old_value == 0) MoveAndResize();
	}
}

// Logs current settings into the .log file.
void CAccountProtector::Logging_Current_Settings()
{
	SilentLogging = true;
	Logging("Logging Current Parameters:");
	Logging("EnableEmergencyButton = " + EnumToString((Enable)EnableEmergencyButton));
	Logging("sets.CountCommSwaps = " + (string)sets.CountCommSwaps);
	Logging("sets.UseTimer = " + (string)sets.UseTimer);
	Logging("sets.Timer = " + sets.Timer);
	Logging("sets.TimerDayOfWeek = " + EnumToString(sets.TimerDayOfWeek));
	Logging("sets.TimeLeft = " + sets.TimeLeft);
	Logging("sets.intTimeType = " + IntegerToString(sets.intTimeType));
	Logging("sets.boolTrailingStart = " + (string)sets.boolTrailingStart);
	Logging("sets.intTrailingStart = " + IntegerToString(sets.intTrailingStart));
	Logging("sets.boolTrailingStep = " + (string)sets.boolTrailingStep);
	Logging("sets.intTrailingStep = " + IntegerToString(sets.intTrailingStep));
	Logging("sets.boolBreakEven = " + (string)sets.boolBreakEven);
	Logging("sets.intBreakEven = " + IntegerToString(sets.intBreakEven));
	Logging("sets.boolBreakEvenExtra = " + (string)sets.boolBreakEvenExtra);
	Logging("sets.intBreakEvenExtra = " + IntegerToString(sets.intBreakEvenExtra)); 
	Logging("sets.SnapEquity = " + DoubleToString(sets.SnapEquity, 2));
	Logging("sets.SnapEquityTime = " + sets.SnapEquityTime);
	Logging("sets.SnapMargin = " + DoubleToString(sets.SnapMargin, 2));
	Logging("sets.SnapMarginTime = " + sets.SnapMarginTime);
	Logging("sets.intOrderCommentaryCondition = " + IntegerToString(sets.intOrderCommentaryCondition));
	Logging("sets.OrderCommentary = " + sets.OrderCommentary);
	Logging("sets.MagicNumbers = " + sets.MagicNumbers);
	Logging("sets.boolExcludeMagics = " + (string)sets.boolExcludeMagics);
	Logging("sets.intInstrumentFilter = " + IntegerToString(sets.intInstrumentFilter));
	Logging("sets.boolLossPerBalance = " + IntegerToString(sets.boolLossPerBalance));
	Logging("sets.boolLossPerBalancReversee = " + IntegerToString(sets.boolLossPerBalanceReverse));
	Logging("sets.boolLossQuanUnits = " + IntegerToString(sets.boolLossQuanUnits));
	Logging("sets.boolLossQuanUnitsReverse = " + IntegerToString(sets.boolLossQuanUnitsReverse));
	Logging("sets.boolLossPips = " + IntegerToString(sets.boolLossPips));
	Logging("sets.boolLossPipsReverse = " + IntegerToString(sets.boolLossPipsReverse));
	Logging("sets.boolProfPerBalance = " + IntegerToString(sets.boolProfPerBalance));
	Logging("sets.boolProfPerBalanceReverse = " + IntegerToString(sets.boolProfPerBalanceReverse));
	Logging("sets.boolProfQuanUnits = " + IntegerToString(sets.boolProfQuanUnits));
	Logging("sets.boolProfQuanUnitsReverse = " + IntegerToString(sets.boolProfQuanUnitsReverse));
	Logging("sets.boolProfPips = " + IntegerToString(sets.boolProfPips));
	Logging("sets.boolProfPipsReverse = " + IntegerToString(sets.boolProfPipsReverse));
	Logging("sets.boolEquityLessUnits = " + IntegerToString(sets.boolEquityLessUnits));
	Logging("sets.boolEquityGrUnits = " + IntegerToString(sets.boolEquityGrUnits));
	Logging("sets.boolEquityLessPerSnap = " + IntegerToString(sets.boolEquityLessPerSnap));
	Logging("sets.boolEquityGrPerSnap = " + IntegerToString(sets.boolEquityGrPerSnap));
	Logging("sets.boolMarginLessUnits = " + IntegerToString(sets.boolMarginLessUnits));
	Logging("sets.boolMarginGrUnits = " + IntegerToString(sets.boolMarginGrUnits));
	Logging("sets.boolMarginLessPerSnap = " + IntegerToString(sets.boolMarginLessPerSnap));
	Logging("sets.boolMarginGrPerSnap = " + IntegerToString(sets.boolMarginGrPerSnap));
	Logging("sets.doubleLossPerBalance = " + DoubleToString(sets.doubleLossPerBalance, 2));
	Logging("sets.doubleLossPerBalanceReverse = " + DoubleToString(sets.doubleLossPerBalanceReverse, 2));
	Logging("sets.doubleLossQuanUnits = " + DoubleToString(sets.doubleLossQuanUnits, 2));
	Logging("sets.doubleLossQuanUnitsReverse = " + DoubleToString(sets.doubleLossQuanUnitsReverse, 2));
	Logging("sets.intLossPips = " + IntegerToString(sets.intLossPips));
	Logging("sets.intLossPipsReverse = " + IntegerToString(sets.intLossPipsReverse));
	Logging("sets.doubleProfPerBalance = " + DoubleToString(sets.doubleProfPerBalance, 2));
	Logging("sets.doubleProfPerBalanceReverse = " + DoubleToString(sets.doubleProfPerBalanceReverse, 2));
	Logging("sets.doubleProfQuanUnits = " + DoubleToString(sets.doubleProfQuanUnits, 2));
	Logging("sets.doubleProfQuanUnitsReverse = " + DoubleToString(sets.doubleProfQuanUnitsReverse, 2));
	Logging("sets.intProfPips = " + IntegerToString(sets.intProfPips));
	Logging("sets.intProfPipsReverse = " + IntegerToString(sets.intProfPipsReverse));
	Logging("sets.doubleEquityLessUnits = " + DoubleToString(sets.doubleEquityLessUnits, 2));
	Logging("sets.doubleEquityGrUnits = " + DoubleToString(sets.doubleEquityGrUnits, 2));
	Logging("sets.doubleEquityLessPerSnap = " + DoubleToString(sets.doubleEquityLessPerSnap, 2));
	Logging("sets.doubleEquityGrPerSnap = " + DoubleToString(sets.doubleEquityGrPerSnap, 2));
	Logging("sets.doubleMarginLessUnits = " + DoubleToString(sets.doubleMarginLessUnits, 2));
	Logging("sets.doubleMarginGrUnits = " + DoubleToString(sets.doubleMarginGrUnits, 2));
	Logging("sets.doubleMarginLessPerSnap = " + DoubleToString(sets.doubleMarginLessPerSnap, 2));
	Logging("sets.doubleMarginGrPerSnap = " + DoubleToString(sets.doubleMarginGrPerSnap, 2)); 
	Logging("sets.ClosePos = " + IntegerToString(sets.ClosePos));
	Logging("sets.doubleClosePerecentage = " + IntegerToString(sets.intClosePercentage) + "%"); 
	Logging("sets.CloseWhichPositions = " + EnumToString(sets.CloseWhichPositions));
	Logging("sets.DeletePend = " + IntegerToString(sets.DeletePend));
	Logging("sets.DisAuto = " + IntegerToString(sets.DisAuto));
	Logging("sets.SendMails = " + IntegerToString(sets.SendMails));
	Logging("sets.SendNotif = " + IntegerToString(sets.SendNotif));
	Logging("sets.ClosePlatform = " + IntegerToString(sets.ClosePlatform));
	Logging("sets.EnableAuto = " + IntegerToString(sets.EnableAuto));
	Logging("sets.RecaptureSnapshots = " + IntegerToString(sets.RecaptureSnapshots));
	Logging("sets.SelectedTab = " + EnumToString(sets.SelectedTab));
	Logging("sets.Log_file_name = " + LogFileName);
	Logging("------End Logging Current Parameters------");
	SilentLogging = false;
}

// Logs pre-condition values into the .log file.
void CAccountProtector::Logging_Condition_Is_Met()
{
	int i, market = 0, pending = 0;
	double floating_profit = 0;
	if (LogFileName == "") return;
	for (i = 0; i < OrdersTotal(); i++)
		if (!OrderSelect(i, SELECT_BY_POS)) Logging("Account Protector: OrderSelect failed " + IntegerToString(GetLastError()));
		else
		{
			if ((OrderType() == OP_BUY) || (OrderType() == OP_SELL))
			{
				floating_profit += OrderProfit();
				if (sets.CountCommSwaps) floating_profit += OrderCommission() + OrderSwap();
				market++;
			}
			else if ((OrderType() == OP_BUYSTOP) || (OrderType() == OP_SELLSTOP) || (OrderType() == OP_BUYLIMIT) || (OrderType() == OP_SELLLIMIT)) pending++;
		}

	Logging("Account Equity = " + DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY), 2) + " " + AccountInfoString(ACCOUNT_CURRENCY) + ", Account Free Margin = " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_FREE), 2) + " " + AccountInfoString(ACCOUNT_CURRENCY) + ", Account Balance = " + DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE), 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));
	if (floating_profit >= 0) Logging("Floating profit = " + DoubleToString(floating_profit, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));
	else Logging("Floating loss = " + DoubleToString(floating_profit, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));
	Logging("Number of open positions = " + IntegerToString(market) + ", Number of pending orders = " + IntegerToString(pending) + ", Current spread = " + DoubleToString((double)SymbolInfoInteger(Symbol(), SYMBOL_SPREAD) * Point(), Digits()));
}

// Prepares subject and body texts.
void CAccountProtector::PrepareSubjectBody(string &subject, string &body, const string title, const datetime timestamp, const int pos_closed, const int pend_deleted, const bool autotrade_dis, const bool push_sent, const bool mail_sent, const bool platf_closed, const bool autotrade_enabled, const bool snapshots_recaptured, const bool short_body = false)
{
	subject = AccountInfoString(ACCOUNT_COMPANY) + ", Account #" + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + ": " + title;
	body = TimeToString(timestamp, TIME_DATE|TIME_MINUTES|TIME_SECONDS);
	if (!short_body) body = "Account #" + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + " at " + AccountInfoString(ACCOUNT_SERVER) + " of " + AccountInfoString(ACCOUNT_COMPANY) + ": " + title + " on " + body;
	if (pos_closed > 0)
	{
		body += "\r\n" + IntegerToString(pos_closed) + " position";
		if (pos_closed > 1) body += "s";
		body += " closed.";
	}
	if (pend_deleted > 0)
	{
		body += "\r\n" + IntegerToString(pend_deleted) + " pending order";
		if (pend_deleted > 1) body += "s";
		body += " deleted.";
	}
	if (autotrade_dis) body += "\r\nAutotrading disabled.";
	if (push_sent) body += "\r\nPush notifications sent.";
	else if (mail_sent) body += "\r\nEmail sent.";
	if (platf_closed) body += "\r\nPlatform closed.";
	if (autotrade_enabled) body += "\r\nAutotrading enabled.";
	if (snapshots_recaptured) body += "\r\nSnapshots recaptured.";
	if (LogFileName != "") body += "\r\nSee " + LogFileName + " for details.";
	body += "\r\n";
	body += "\r\nGenerated by Account Protector v." + Version + " (https://www.earnforex.com/).";
}

// Sends emails.
void CAccountProtector::SendMailFunction(string subject, string body)
{
	if (!SendMail(subject, body)) Logging("Account Protector failed to send an email.");
	else Logging("Email sent.");
}

// Sends push-notifications.
void CAccountProtector::SendNotificationFunction(string subject, string body)
{
	if (!SendNotification(subject)) Logging("Account Protector failed to send push notification about condition.");
	else Logging("Push notification about condition sent.");

	if (!SendNotification(body)) Logging("Account Protector failed to send push notification about actions.");
	else Logging("Push notification about actions sent.");
}

// Checks one condition.
template<typename T>
void CAccountProtector::CheckOneCondition(T &SettingsEditValue, bool &SettingsCheckboxValue, const string EventDescription)
{
	if (SettingsCheckboxValue)
	{
		Logging("CONDITION IS MET: " + EventDescription);
		Trigger_Actions(EventDescription);
		if (!DoNotResetConditions)
		{
		   SettingsCheckboxValue = false;
		   SettingsEditValue = 0;
		}
		SaveSettingsOnDisk();
		RefreshPanelControls();
	}
}

// Checks if some of the conditions are met.
void CAccountProtector::CheckAllConditions()
{
	double floating_profit = 0, floating_profit_pips = 0;
	
	if (No_Condition() || No_Action()) return;

	// Calculating floating profit/loss.
	for (int i = 0; i < OrdersTotal(); i++)
	{	
		if (!OrderSelect(i, SELECT_BY_POS))
		{
			Logging("Account Protector: OrderSelect failed " + IntegerToString(GetLastError()));
			continue;
		}

		if (CheckFilterSymbol(OrderSymbol())) continue;
		if (CheckFilterComment(OrderComment())) continue;
		// Starting from -1 index to check for orders irrespective of their Magic numbers.
		for (int j = -1; j < magic_array_counter; j++)
		{
			if (CheckFilterMagic(OrderMagicNumber(), j)) continue;

	      floating_profit += OrderProfit();
	      if (sets.CountCommSwaps) floating_profit += OrderCommission() + OrderSwap();

	      if (OrderType() == OP_BUY) floating_profit_pips += NormalizeDouble((MarketInfo(OrderSymbol(), MODE_BID) - OrderOpenPrice()) / MarketInfo(OrderSymbol(), MODE_POINT), 2);
	      if (OrderType() == OP_SELL) floating_profit_pips += NormalizeDouble((OrderOpenPrice() - MarketInfo(OrderSymbol(), MODE_ASK)) / MarketInfo(OrderSymbol(), MODE_POINT), 2);
		}  
	}

	// Floating loss rose to <Actual percentage> % of balance.
	if ((!DisableFloatLossRisePerc) && (floating_profit <= -AccountInfoDouble(ACCOUNT_BALANCE) * sets.doubleLossPerBalance / 100))
		CheckOneCondition(sets.doubleLossPerBalance, sets.boolLossPerBalance, "Floating loss rose to " + DoubleToString(sets.doubleLossPerBalance, 2) + "% of balance");

	// Floating loss fell to <Actual percentage> % of balance.
	if ((!DisableFloatLossFallPerc) && (floating_profit >= -AccountInfoDouble(ACCOUNT_BALANCE) * sets.doubleLossPerBalanceReverse / 100))
		CheckOneCondition(sets.doubleLossPerBalanceReverse, sets.boolLossPerBalanceReverse, "Floating loss fell to " + DoubleToString(sets.doubleLossPerBalanceReverse, 2) + "% of balance");

	// Floating loss rose to <Actual number> <currency ISO code>.
	if ((!DisableFloatLossRiseCurr) && (floating_profit <= -sets.doubleLossQuanUnits))
		CheckOneCondition(sets.doubleLossQuanUnits, sets.boolLossQuanUnits, "Floating loss rose to " + DoubleToString(sets.doubleLossQuanUnits, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));

	// Floating loss fell to <Actual number> <currency ISO code>.
	if ((!DisableFloatLossFallCurr) && (floating_profit >= -sets.doubleLossQuanUnitsReverse))
		CheckOneCondition(sets.doubleLossQuanUnitsReverse, sets.boolLossQuanUnitsReverse, "Floating loss fell to " + DoubleToString(sets.doubleLossQuanUnitsReverse, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));

	// Floating loss rose to <Actual number> pips.
	if ((!DisableFloatLossRisePips) && (floating_profit_pips <= - sets.intLossPips))
		CheckOneCondition(sets.intLossPips, sets.boolLossPips, "Floating loss rose to " + IntegerToString(sets.intLossPips) + " pips");

	// Floating loss fell to <Actual number> pips.
	if ((!DisableFloatLossFallPips) && (floating_profit_pips >= - sets.intLossPipsReverse))
		CheckOneCondition(sets.intLossPipsReverse, sets.boolLossPipsReverse, "Floating loss fell to " + IntegerToString(sets.intLossPipsReverse) + " pips");

	// Floating profit rose to <Actual percentage> % of balance.
	if ((!DisableFloatProfitRisePerc) && (floating_profit >= AccountInfoDouble(ACCOUNT_BALANCE) * sets.doubleProfPerBalance / 100))
		CheckOneCondition(sets.doubleProfPerBalance, sets.boolProfPerBalance, "Floating profit rose to " + DoubleToString(sets.doubleProfPerBalance, 2) + "% of balance");

	// Floating profit fell to <Actual percentage> % of balance.
	if ((!DisableFloatProfitFallPerc) && (floating_profit <= AccountInfoDouble(ACCOUNT_BALANCE) * sets.doubleProfPerBalanceReverse / 100))
		CheckOneCondition(sets.doubleProfPerBalanceReverse, sets.boolProfPerBalanceReverse, "Floating profit fell to " + DoubleToString(sets.doubleProfPerBalanceReverse, 2) + "% of balance");

	// Floating profit rose to <Actual number> <currency ISO code>.
	if ((!DisableFloatProfitRiseCurr) && (floating_profit >= sets.doubleProfQuanUnits))
		CheckOneCondition(sets.doubleProfQuanUnits, sets.boolProfQuanUnits, "Floating profit rose to " + DoubleToString(sets.doubleProfQuanUnits, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));

	// Floating profit fell to <Actual number> <currency ISO code>.
	if ((!DisableFloatProfitFallCurr) && (floating_profit <= sets.doubleProfQuanUnitsReverse))
		CheckOneCondition(sets.doubleProfQuanUnitsReverse, sets.boolProfQuanUnitsReverse, "Floating profit fell to " + DoubleToString(sets.doubleProfQuanUnitsReverse, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));

	// Floating profit rose to <Actual number> pips.
	if ((!DisableFloatProfitRisePips) && (floating_profit_pips >= sets.intProfPips))
		CheckOneCondition(sets.intProfPips, sets.boolProfPips, "Floating profit rose to " + IntegerToString(sets.intProfPips)+ " pips.");

	// Floating profit fell to <Actual number> pips.
	if ((!DisableFloatProfitFallPips) && (floating_profit_pips <= sets.intProfPipsReverse))
		CheckOneCondition(sets.intProfPipsReverse, sets.boolProfPipsReverse, "Floating profit fell to " + IntegerToString(sets.intProfPipsReverse)+ " pips.");

	// Equity fell to <Actual number> <currency ISO code>.
	if (AccountInfoDouble(ACCOUNT_EQUITY) <= sets.doubleEquityLessUnits)
		CheckOneCondition(sets.doubleEquityLessUnits, sets.boolEquityLessUnits, "Equity fell to " + DoubleToString(sets.doubleEquityLessUnits, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));

	// Equity rose to <Actual number> <currency ISO code>.
	if (AccountInfoDouble(ACCOUNT_EQUITY) >= sets.doubleEquityGrUnits)
		CheckOneCondition(sets.doubleEquityGrUnits, sets.boolEquityGrUnits, "Equity rose to " + DoubleToString(sets.doubleEquityGrUnits, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));

	// Equity fell to <Actual percentage>% of previous snapshot (<snapshot value> <currency ISO code>).
	if (AccountInfoDouble(ACCOUNT_EQUITY) <= sets.SnapEquity * sets.doubleEquityLessPerSnap / 100)
		CheckOneCondition(sets.doubleEquityLessPerSnap, sets.boolEquityLessPerSnap, "Equity fell to " + DoubleToString(sets.doubleEquityLessPerSnap, 2) + "% of previous snapshot (" + DoubleToString(sets.SnapEquity, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY) + ")");

	// Equity rose to <Actual percentage>% of previous snapshot (<snapshot value> <currency ISO code>).
	if (AccountInfoDouble(ACCOUNT_EQUITY) >= sets.SnapEquity * sets.doubleEquityGrPerSnap / 100)
		CheckOneCondition(sets.doubleEquityGrPerSnap, sets.boolEquityGrPerSnap, "Equity rose to " + DoubleToString(sets.doubleEquityGrPerSnap, 2) + "% of previous snapshot (" + DoubleToString(sets.SnapEquity, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY) + ")");

	// Free Margin fell to <Actual number> <currency ISO code>.
	if (AccountInfoDouble(ACCOUNT_MARGIN_FREE) <= sets.doubleMarginLessUnits)
		CheckOneCondition(sets.doubleMarginLessUnits, sets.boolMarginLessUnits, "Free Margin fell to " + DoubleToString(sets.doubleMarginLessUnits, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));

	// Free Margin rose to <Actual number> <currency ISO code>.
	if (AccountInfoDouble(ACCOUNT_MARGIN_FREE) >= sets.doubleMarginGrUnits)
		CheckOneCondition(sets.doubleMarginGrUnits, sets.boolMarginGrUnits, "Free Margin rose to " + DoubleToString(sets.doubleMarginGrUnits, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));

	// Free Margin fell to <Actual percentage>% of previous snapshot (<snapshot value> <currency ISO code>).
	if (AccountInfoDouble(ACCOUNT_MARGIN_FREE) <= sets.SnapMargin * sets.doubleMarginLessPerSnap / 100)
		CheckOneCondition(sets.doubleMarginLessPerSnap, sets.boolMarginLessPerSnap, "Free Margin fell to " + DoubleToString(sets.doubleMarginLessPerSnap, 2) + "% of previous snapshot (" + DoubleToString(sets.SnapMargin, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY) + ")");

	// Free Margin rose to <Actual percentage>% of previous snapshot (<snapshot value> <currency ISO code>).
	if (AccountInfoDouble(ACCOUNT_EQUITY) >= sets.SnapMargin * sets.doubleMarginGrPerSnap / 100)
		CheckOneCondition(sets.doubleMarginGrPerSnap, sets.boolMarginGrPerSnap, "Free Margin rose to " + DoubleToString(sets.doubleMarginGrPerSnap, 2) + "% of previous snapshot (" + DoubleToString(sets.SnapMargin, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY) + ")");

	// Timeout by timer.
	if ((sets.UseTimer) && (sets.TimeLeft == "00:00"))
	{
		string EventDescription = "Timeout by timer";
		Logging("CONDITION IS MET: " + EventDescription);
		Trigger_Actions(EventDescription); 
		sets.UseTimer = false;
		SaveSettingsOnDisk();
		RefreshPanelControls();
	}    
}

// Performs actions set by user.
void CAccountProtector::Trigger_Actions(string title)
{
	Logging_Condition_Is_Met();
	Logging_Current_Settings();

	if (sets.DisAuto) WasAutoTradingDisabled = true;
	else WasAutoTradingDisabled = false;

	if (sets.SendMails) WasMailSent = true;
	else WasMailSent = false;
	
	if (sets.SendNotif) WasNotificationSent = true;
	else WasNotificationSent = false;
	
	if (sets.ClosePlatform) WasPlatformClosed = true;
	else WasPlatformClosed = false;
	
	if (sets.EnableAuto) WasAutoTradingEnabled = true;
	else WasAutoTradingEnabled = false;

	if (sets.RecaptureSnapshots) WasRecapturedSnapshots = true;
	else WasRecapturedSnapshots = false;

	// Close all positions.
	if (sets.ClosePos)
	{
		if (!DoNotResetActions) sets.ClosePos = false;
		Logging("ACTION IS TAKEN: Close positions (" + IntegerToString(sets.intClosePercentage) + "% of " + EnumToString(sets.CloseWhichPositions) + ").");
		PartiallyClosedOrders.Clear();
		Eliminate_Orders(Active);
		sets.Triggered = true;
		sets.TriggeredTime = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);
	}

	// Delete all pending orders.
	if (sets.DeletePend)
	{
		if (!DoNotResetActions) sets.DeletePend = false;
		Logging("ACTION IS TAKEN: Delete all pending orders.");
		Eliminate_Orders(Pending);
		sets.Triggered = true;
		sets.TriggeredTime = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);
	}

	// Disable autotrading.
	if (sets.DisAuto)
	{
		if (!DoNotResetActions) sets.DisAuto = false;
		Logging("ACTION IS TAKEN: Disable autotrading.");
		// Toggle AutoTrading button. "2" in GetAncestor call is the "root window".
		if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) SendMessageW(GetAncestor(WindowHandle(Symbol(), Period()), 2), WM_COMMAND, 33020, 0);
		sets.Triggered = true;
		sets.TriggeredTime = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);
	}

	string subject, body;
	// Send emails.
	if (sets.SendMails)
	{
		if (!DoNotResetActions) sets.SendMails = false;
		Logging("ACTION IS TAKEN: Send email.");
		PrepareSubjectBody(subject, body, title, TimeCurrent(), QuantityClosedMarketOrders, QuantityDeletedPendingOrders, WasAutoTradingDisabled, WasNotificationSent, false, WasPlatformClosed, WasAutoTradingEnabled, WasRecapturedSnapshots);
		SendMailFunction(subject, body);
		sets.Triggered = true;
		sets.TriggeredTime = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);
	}
	
	// Send push notifications.
	if (sets.SendNotif)
	{
		if (!DoNotResetActions) sets.SendNotif = false;
		Logging("ACTION IS TAKEN: Send push notifications.");
		PrepareSubjectBody(subject, body, title, TimeCurrent(), QuantityClosedMarketOrders, QuantityDeletedPendingOrders, WasAutoTradingDisabled, false, WasMailSent, WasPlatformClosed, WasAutoTradingEnabled, WasRecapturedSnapshots, true);
		SendNotificationFunction(subject, body);
		sets.Triggered = true;
		sets.TriggeredTime = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);
	}  
	
	// Close platform.
	if (sets.ClosePlatform)
	{
		if (!DoNotResetActions) sets.ClosePlatform = false;
		Logging("ACTION IS TAKEN: Close platform.");
		TerminalClose(0);
	}    

	// Enable autotrading.
	if (sets.EnableAuto)
	{
		if (!DoNotResetActions) sets.EnableAuto = false;
		Logging("ACTION IS TAKEN: Enable autotrading.");
		// Toggle AutoTrading button. "2" in GetAncestor call is the "root window".
		if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) SendMessageW(GetAncestor(WindowHandle(Symbol(), Period()), 2), WM_COMMAND, 33020, 0);
		sets.Triggered = true;
		sets.TriggeredTime = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);
	}

	// Recapture snapshots.
	if (sets.RecaptureSnapshots)
	{
	   if (!DoNotResetActions) sets.RecaptureSnapshots = false;
	   Logging("ACTION IS TAKEN: Recapture snapshots.");
   	UpdateEquitySnapshot();
   	UpdateMarginSnapshot();
		sets.Triggered = true;
		sets.TriggeredTime = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);
   }
   	
	SaveSettingsOnDisk();
	RefreshPanelControls();
}

// Saves information into a .log file and prints it to Experts tab.
void CAccountProtector::Logging(string message)
{
	if (StringLen(LogFileName) > 0)
	{
		string filename = LogFileName + ".log";
		if (LogFile < 0) LogFile = FileOpen(filename, FILE_CSV | FILE_READ | FILE_WRITE, ' ');
		if (LogFile < 1) Alert("Cannot open file for logging: ", filename, ".");
		else if (FileSeek(LogFile, 0, SEEK_END))
		{ 
			FileWrite(LogFile, TimeToString(TimeLocal(), TIME_DATE | TIME_MINUTES | TIME_SECONDS), " ", message);
			FileClose(LogFile);
			LogFile=-1;
		} 
		else Alert("Unexpected error accessing file: ", filename, ".");
	}
	if (!SilentLogging) Print(message);
}

// Creates array of Magic numbers and updates its counter.
void CAccountProtector::ProcessMagicNumbers()
{
	magic_array_counter = 0;

	if (sets.MagicNumbers == "") return;

	// Maximum possible number of Magic Numbers based on string length.
	ArrayResize(MagicNumbers_array, StringLen(sets.MagicNumbers) / 2 + 1);

	// Split string with Magic numbers using all separators, getting an array with clean Magic numbers.
	string result[];
	int n = StringSplit(sets.MagicNumbers, StringGetCharacter(",", 0), result);
	for (int i = 0; i < n; i++)
	{
		string second_result[];
		int m = StringSplit(result[i], StringGetCharacter(";", 0), second_result);
		for (int j = 0; j < m; j++)
		{
			string third_result[];
			// Third result, at this point, holds all the magic numbers (strings) even if there was only one.
			// The problem is that it will vanish on next cycle iteration.
			int l = StringSplit(second_result[j], StringGetCharacter(" ", 0), third_result);
			
			// Fill MagicNumbers_array using magic_array_counter as an absolute counter.
			for (int k = 0; k < l; k++)
			{
				if (third_result[k] == "") continue;
				MagicNumbers_array[magic_array_counter] = (int)StringToInteger(third_result[k]);
				magic_array_counter++;
			}
		}
	}
}

// Checks if value, entered into input field, is of double type.
bool CAccountProtector::IsDouble(const string value)
{
	int i, dot = 0;
	
	for (i = 0; i < StringLen(value); i++)
	{
		if (value[i] == '.') dot++;
		else if ((value[i] < '0') || (value[i] > '9'))	return(false);
	} 
	if (dot > 1) return(false);
	
	return(true);
}

// Checks if value, entered into input field, is of integer type.
bool CAccountProtector::IsInteger(const string value)
{
	int i;

	for (i = 0; i < StringLen(value); i++)
		if ((value[i] < '0') || (value[i] > '9'))	return(false);

	return(true);
}

// Calculate order lots to close based on partial close percentage given.
double CAccountProtector::CalculateOrderLots(const double lots, const string symbol)
{
   if (sets.intClosePercentage == 100) return(lots);

   double vol_min = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
   double vol_step = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);

   double volume = lots * (double)sets.intClosePercentage / 100;
   
   if (volume < vol_min) return(vol_min);
   
   double steps = 0;
   if (vol_step != 0) steps = volume / vol_step;
   if (MathFloor(steps) < steps) volume = MathFloor(steps) * vol_step;
   
   return(volume);   
}