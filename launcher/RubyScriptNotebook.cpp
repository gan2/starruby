#include "RubyScriptNotebook.hpp"
#include "RubyScriptEditor.hpp"

BEGIN_EVENT_TABLE(RubyScriptNotebook, wxPanel)

EVT_TEXT(wxID_ANY, RubyScriptNotebook::OnEdit)

END_EVENT_TABLE()

RubyScriptNotebook::RubyScriptNotebook(wxWindow* parent)
     : wxPanel(parent, wxID_ANY)
{
  wxBoxSizer* sizer = new wxBoxSizer(wxVERTICAL);
  this->SetSizer(sizer);

  this->auiNotebook = new wxAuiNotebook(this, wxID_ANY);
  sizer->Add(this->auiNotebook, 1, wxEXPAND, 0);
}

void RubyScriptNotebook::AddNewPage()
{
  RubyScriptEditor* page = new RubyScriptEditor(this->auiNotebook);
  this->auiNotebook->AddPage(page, wxEmptyString, true);
  this->Update();
}

void RubyScriptNotebook::AddPage(const wxString& path)
{
  RubyScriptEditor* page = new RubyScriptEditor(this->auiNotebook, path);
  this->auiNotebook->AddPage(page, wxEmptyString, true);
  this->Update();
}

void RubyScriptNotebook::OnEdit(wxCommandEvent& event)
{
  this->Update();
}

void RubyScriptNotebook::Update()
{
  int count = this->auiNotebook->GetPageCount();
  for (int i = 0; i < count; i++) {
    RubyScriptEditor* editor = (RubyScriptEditor*)this->auiNotebook->GetPage(i);
    wxString title;
    if (editor->GetPath() != wxEmptyString)
      title += wxFileNameFromPath(editor->GetPath());
    else
      title += wxT("(No Title)");
    if (editor->IsModified())
      title += wxT(" (*)");
    this->auiNotebook->SetPageText(i, title);
  }
}
