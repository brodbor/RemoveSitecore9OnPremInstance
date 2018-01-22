Import-Module WebAdministration

#define parameters
$prefix = "sitecoreTest900xp0"
$SolrRoot = "C:\Solr-6.6.1"
$SqlServer = ".\MSSQLSERVER16"
$SqlAdminUser = "sa"
$SqlAdminPassword="Password1"
$iisRoot = "C:\inetpub\wwwroot"


$dbs = @();
$dbs +=$prefix+'_Processing.Pools'
$dbs +=$prefix+'_MarketingAutomation'
$dbs +=$prefix+'_ReferenceData'
$dbs +=$prefix+'_Xdb.Collection.ShardMapManager'
$dbs +=$prefix+'_Xdb.Collection.Shard0'
$dbs +=$prefix+'_Xdb.Collection.Shard1'
$dbs +=$prefix+'_Core'
$dbs +=$prefix+'_Master'
$dbs +=$prefix+'_Web'
$dbs +=$prefix+'_ExperienceForms'
$dbs +=$prefix+'_EXM.Master'
$dbs +=$prefix+'_Reporting'
$dbs +=$prefix+'_Processing.Tasks'



write-host "[---------------------------------------------------------------------------- SQL : Deleting   -----------------------------------------------------------------------------]" -foregroundcolor "green"

foreach ($db in $dbs)
{
write-host $db
 invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAdminUser  -P $SqlAdminPassword -Query "Drop database [$db];"
}

write-host "[---------------------------------------------------------------------------- Solr : Stop -----------------------------------------------------------------------------]" -foregroundcolor "green"

Invoke-Expression "$SolrRoot\bin\solr.cmd stop -all"

write-host "[---------------------------------------------------------------------------- Solr : Delete $prefix Filels -----------------------------------------------------------------------------]" -foregroundcolor "green"

get-childitem -path "$SolrRoot\server\solr" -filter $prefix* | remove-item -force -recurse

write-host "[---------------------------------------------------------------------------- IIS :  Remove Website/Delete Files -----------------------------------------------------------------------------]" -foregroundcolor "green"
Remove-Website -Name $prefix* 
get-childitem -path "$iisRoot" -filter $prefix* | remove-item -force -recurse

write-host "[---------------------------------------------------------------------------- Solr : Start -----------------------------------------------------------------------------]" -foregroundcolor "green"

Invoke-Expression "$SolrRoot\bin\solr.cmd start"