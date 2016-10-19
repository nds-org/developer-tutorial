# Extending Your Personal Catalog

You can also add your applications to Labs Workbench.

1. Log into Labs Workbench
2. Navigate to the Catalog view
3. Select "Create"
4. At a minimum, specify the short name, display name, and Docker image name. Specify ports if appropriate. For example, you could add the official nginx or drupal image, specifying port 80. 
5. Select "Save"
6. Add the application 
7. Navigate to the Applications view and start-up your added applications

## Fair Warning
Please be advised that Labs Workbench is still in beta, and should not be used to house critical or sensitive data.

See [Appectable Use Policy](https://nationaldataservice.atlassian.net/wiki/display/NDSC/Acceptable+Use+Policy) for more details.

## Create from existing Docker image
See a [video](https://nationaldataservice.atlassian.net/wiki/display/NDSC/Feature+Overview#FeatureOverview-Createuser-definedapplications) of this feature in action!

## Share Your New Applications with Other Users
To export (share) your spec with another user:

1. Navigate to the Catalog view
2. Locate the spec you would like to share and choose **View JSON** from the dropdown
3. Click "Copy to Clipboard"
4. Paste the resulting JSON spec into a Slack snippet / GitHub gist / pastebin / e-mail / chat client / wiki page / forum post / etc
5. Send this to the target user

## Import New Applications from Other Users
To import a spec that another user has shared with you:

1. Navigate to the Catalog view
2. Click **Import** at the top-right
3. Paste a [JSON spec](https://github.com/nds-org/ndslabs-specs) describing your application

## Publish Your New Application to the Official Catalog
Once you are happy with a spec, you can submit it to the official catalog to share it with all users:

1. Fork https://github.com/nds-org/ndslabs-specs
2. Add your spec
3. Submit a pull request back to nds-org/ndslabs-specs
