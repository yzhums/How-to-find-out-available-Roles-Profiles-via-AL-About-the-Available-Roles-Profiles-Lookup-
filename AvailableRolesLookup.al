table 50101 "ZY Users Profiles"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; UserID; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(2; ProfileID; Code[30])
        {
            Caption = 'Profile ID';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                TempAllProfile: Record "All Profile" temporary;
            begin
                PopulateProfiles(TempAllProfile);
                if Page.RunModal(Page::Roles, TempAllProfile) = Action::LookupOK then begin
                    ProfileID := TempAllProfile."Profile ID";
                end;
            end;
        }
    }

    keys
    {
        key(PK; UserID)
        {
            Clustered = true;
        }
    }

    var
        DescriptionFilterTxt: Label 'Navigation menu only.';
        UserCreatedAppNameTxt: Label '(User-created)';

    local procedure PopulateProfiles(var TempAllProfile: Record "All Profile" temporary)
    var
        AllProfile: Record "All Profile";
    begin
        TempAllProfile.Reset();
        TempAllProfile.DeleteAll();
        AllProfile.SetRange(Enabled, true);
        AllProfile.SetFilter(Description, '<> %1', DescriptionFilterTxt);
        if AllProfile.FindSet() then
            repeat
                TempAllProfile := AllProfile;
                if IsNullGuid(TempAllProfile."App ID") then
                    TempAllProfile."App Name" := UserCreatedAppNameTxt;
                TempAllProfile.Insert();
            until AllProfile.Next() = 0;
        TempAllProfile.FindFirst();
    end;
}

page 50103 "ZY Users Profiles"
{
    ApplicationArea = All;
    Caption = 'ZY Users Roles';
    PageType = List;
    SourceTable = "ZY Users Profiles";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(UserID; Rec.UserID)
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(ProfileID; Rec.ProfileID)
                {
                    ToolTip = 'Specifies the value of the Profile ID field.';
                }
            }
        }
    }
}
