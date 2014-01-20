import bb.cascades 1.0
import bb.system 1.0
import com.canadainc.data 1.0

Page
{
    titleBar: TitleBar {
        title: qsTr("Settings") + Retranslate.onLanguageChanged
    }
    
    actions: [
        ActionItem
        {
            title: qsTr("Change Password") + Retranslate.onLanguageChanged
            imageSource: "images/ic_password.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                var passwordSheet = definition.createObject();
                passwordSheet.open();
            }
            
            attachedObjects: [
                ComponentDefinition {
                    id: definition
                    source: "SignupSheet.qml"
                }
            ]
        }
    ]
    
    Container
    {
        leftPadding: 10; rightPadding: 10; topPadding: 10
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Container
        {
            horizontalAlignment: HorizontalAlignment.Fill
            
            Label {
                text: qsTr("Subject") + Retranslate.onLanguageChanged
                
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
            }
            
            TextField {
                text: persist.getValueFor("subject");
                input.flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.WordSubstitutionOff | TextInputFlag.PredictionOff
                horizontalAlignment: HorizontalAlignment.Right
                
                onTextChanged: {
                    persist.saveValueFor("subject", text);
                }
            }
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
        }
        
        SettingPair
        {
            topMargin: 20
            title: qsTr("Delete Incoming Request") + Retranslate.onLanguageChanged
            key: "delRequest"
        }
        
        SettingPair
        {
            topMargin: 20
            title: qsTr("Delete Outgoing Response") + Retranslate.onLanguageChanged
            key: "delResponse"
        }
    }
}