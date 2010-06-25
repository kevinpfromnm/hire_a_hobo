xml.instruct! :xml, :version => "1.0"

xml.rss "version" => "2.0" do
 xml.channel do

   xml.title       "hire-a-hobo jobs postings"
   xml.link        url_for( :only_path => false, :controller => 'jobs' )
   xml.description "job postings on the hire-a-hobo site"

   @jobs.each do |job|
     xml.item do
       xml.title       job.name
       xml.link        url_for( :only_path => false, :controller => 'jobs', :action => 'show', :id => job.id)
       xml.description job.description
       xml.updated_at  job.updated_at
       xml.guid        url_for( :only_path => false, :controller => 'jobs', :action => 'show', :id => job.id)
     end
   end

 end
end

