xml.instruct! :xml, :version => "1.0"

xml.rss "version" => "2.0" do
 xml.channel do

   xml.title       "hire-a-hobo project listings"
   xml.link        url_for( :only_path => false, :controller => 'projects' )
   xml.description "project listings on the hire-a-hobo site"

   @projects.each do |project|
     xml.item do
       xml.title       project.name
       xml.link        url_for( :only_path => false, :controller => 'projects', :action => 'show', :id => project.id)
       xml.description project.description
       xml.updated_at  project.updated_at
       xml.guid        url_for( :only_path => false, :controller => 'projects', :action => 'show', :id => project.id)
     end
   end

 end
end

