import bb.cascades 1.0
import bb.system 1.2

NavigationPane
{
    id: navigationPane
    
    onPopTransitionEnded: {
        page.destroy();
    }
    
    Page
    {
        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        
        titleBar: TitleBar {
            title: qsTr("Whitelist") + Retranslate.onLanguageChanged
        }
        
        actions: [
            ActionItem {
                id: addEmailAction
                title: qsTr("Add Email") + Retranslate.onLanguageChanged
                imageSource: "images/ic_add_email.png"
                ActionBar.placement: 'Signature' in ActionBarPlacement ? ActionBarPlacement["Signature"] : ActionBarPlacement.OnBar
                
                onTriggered: {
                    prompt.show();
                }
                
                attachedObjects: [
                    SystemPrompt {
                        id: prompt
                        title: qsTr("Email Address") + Retranslate.onLanguageChanged
                        body: qsTr("Enter the email address to whitelist:") + Retranslate.onLanguageChanged
                        confirmButton.label: qsTr("OK") + Retranslate.onLanguageChanged
                        cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged
                        inputOptions: SystemUiInputOption.None
                        
                        onFinished: {
                            if (value == SystemUiResult.ConfirmButtonSelection)
                            {
                                var inputValue = prompt.inputFieldTextEntry();
                                var added = app.addToWhiteList(inputValue);
                                
                                if (added) {
                                    adm.append( inputValue.toLowerCase() );
                                    tutorial.init( qsTr("'%1' added to the whitelist!").arg( inputValue.toLowerCase() ), "images/ic_add_email.png" );
                                }
                            }
                        }
                    }
                ]
                
                shortcuts: [
                    SystemShortcut {
                        type: SystemShortcuts.CreateNew
                    }
                ]
            },
            
            DeleteActionItem
            {
                id: clearAllAction
                title: qsTr("Clear List") + Retranslate.onLanguageChanged
                imageSource: "images/menu/ic_clear_whitelist.png"
                enabled: listView.visible
                
                onTriggered: {
                    console.log("UserEvent: ClearWhitelist");
                    var ok = persist.showBlockingDialog( qsTr("Confirmation"), qsTr("Are you sure you want to clear the whitelist?") );
                    console.log("UserEvent: ClearWhitelistConfirm", ok);
                    
                    if (ok) {
                        app.clearWhiteList();
                        adm.clear();
                        
                        tutorial.init( qsTr("Cleared all logs!"), "images/menu/ic_clear_whitelist.png" );
                    }
                }
            }
        ]
        
        Container
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            EmptyDelegate
            {
                id: emptyDelegate
                graphic: "images/placeholder/empty_whitelist.png"
                labelText: qsTr("You can restrict who is able to send commands to your device. There are currently no emails in your whitelist. To only accept commands from specific email addresses, click on the Add Contact action below and add them.") + Retranslate.onLanguageChanged
                delegateActive: app.whiteListCount == 0
                
                onImageTapped: {
                    addEmailAction.triggered();
                }
            }
            
            ListView
            {
                id: listView
                visible: app.whiteListCount > 0
                
                dataModel: ArrayDataModel {
                    id: adm
                }
                
                function performDelete(indexPath)
                {
                    var email = adm.data(indexPath);
                    app.removeFromWhiteList(email);

                    tutorial.init( qsTr("Removed %1 from white list!").arg(email), "images/menu/ic_delete_contact.png" );
                }
                
                listItemComponents: [
                    ListItemComponent {
                        StandardListItem
                        {
                            id: rootItem
                            title: ListItemData
                            imageSource: "images/ic_users.png";
                            
                            contextActions: [
                                ActionSet {
                                    title: rootItem.title
                                    subtitle: rootItem.description
                                    
                                    DeleteActionItem
                                    {
                                        imageSource: "images/menu/ic_delete_contact.png"
                                        
                                        onTriggered: {
                                            rootItem.ListItem.view.performDelete(rootItem.ListItem.indexPath);
                                        }
                                    }
                                }
                            ]
                        }
                    }
                ]
                
                onCreationCompleted: {
                    adm.append( app.getWhiteList() );
                }
            }
        }
    }
    
    onCreationCompleted: {
        if ( tutorialToast.tutorial("tutorialWhitelist", qsTr("As a security measure you can specify exactly which email addresses are allowed to send commands to your device here. If you remove all entries, the app will process commands from any email address."), "images/ic_whitelist.png" ) ) {}
    }
}