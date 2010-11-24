module DeviseRestfulAuth
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    def act_as_restful_auth
      send :include, InstanceMethods
    end
  
    
  end
 
  module InstanceMethods
    # any method placed here will apply to instaces, like @hickwall
    
    
    #@role_id cerca di abbreviare la ricerca, nel caso i permessi siano dati in base al ruolo, si prova a desumere dai nomi delle classi coinvolte
    #@item_type serve per sapere per quale classe si valida. se vuoto si prova a desumere dai nomi delle classi coinvolte
    #@subject_type serve per sapere chi è l'oggetto per il quale si cerca il permesso
    #se item o subject sono qualsiasi, si specifica 'any' nel controller e viene settato il valore nil per la ricerca sul db
    #se item e subject sono la stessa classe, la convenzione è di chiamare il model che mappa i ruoli come SubjectSubjectRole. verrà usata la chiave subject_id per il soggetto indipendentemente dalla classe. 
    def validate_permissions
      @subject_id=current_user.id if current_user
      controller= self.request.params[:controller]
      action= self.request.params[:action]
      if @item_type.nil?
	@item_type=controller.singularize.camelize
      elsif @item_type.eql?'any'
	@item_type=nil
      end
      #try to infer @item_id if nil (nil means any here and will be considered)
      if @item_id.nil?
	if eval(@item_type).is_a? Class
	  begin
	    @item=eval(@item_type).find(params[:id]) if params[:id]
	    @item_id=@item.id unless @item.nil?
	  rescue => e
	    
	    @item_id=nil
	  end
	end
      end
      if @subject_type.nil?
	@subject_type="User"
      elsif @subject_type.eql?'any'
	@subject_type=nil
      end
      
      if @role_id.nil?
	begin
	  @permission_model=(eval("#{@subject_type}"+"#{@item_type}"+"Role").is_a? Class)
	rescue =>e
# 	  logger debug.e
	end
	
	if @subject_type and @item_type and @permission_model 
	  
	  if @subject_type.eql?@item_type
	    
	    @roles=eval("#{@subject_type}"+"#{@item_type}"+"Role").all
	    
	    if !@roles.empty?
	      @subject_roles=@roles.find_all { |e| [nil,@subject_id].include? e[:subject_id] }
	    end
	    
	  else
	    
	    begin
	      @subject_roles=eval("#{@subject_type}"+"#{@item_type}"+"Role").all(:conditions=>{"#{@subject_type.parameterize}_id".to_sym=>@subject_id})
	    rescue => e
	      
	    end
	  end
	  @subject_roles||=[]
	  
	  begin
	    if !@subject_roles.empty?
	      
	      @sr=@subject_roles.find_all { |i| [nil,@item_id].include? i[:item_id] }
	      
	      @role_ids=@sr
	    end
	  rescue => e
	    
	  end
	  @role_type="Role"
	end
	@role_ids||=[]
      end
      
      if "Permission".is_a? Class
	p=Permission.first(:conditions=>{:controller=>controller,:action=>action})
	if p
	  
	  @role_ids.each do |user_role|
	    
	    @role_permissions=SubjectPermission.all(:conditions=>{:subject_id=>user_role.role.id,:subject_type=>@role_type,:permission_id=>p.id,:item_type=>@item_type})
	    if !@role_permissions.empty?
	      
	      @rps=@role_permissions.find_all { |rp| [nil,@item_id].include? rp[:item_id]}
	    end
	    @rps||=[]  
	    
	    @rps.each do |sp|
	      
	    end
	    if !@rps.empty? 
	      
	      
	    end
	  end
	  
	    @subject_permissions_on_items=SubjectPermission.all(:conditions=>{:item_type=>@item_type,:permission_id=>p.id,:subject_id=>@subject_id,:subject_type=>@subject_type})
	  
	  if !@subject_permissions_on_items.empty?
	    @ups=@subject_permissions_on_items.find_all { |u| [nil,@item_id].include? u[:item_id]}
	  end
	  if @ups
	    flash[:notice]="access granted because of #{@subject_type}:#{@subject_id} permission on #{@item_type}:#{@item_id} " and return
	  else
	    
	    flash[:error]="accesso negato perché non esiste un permesso né per l'utente, né per il suo ruolo, su #{controller}/#{action} per #{@item_type}:#{@item_id}"
	    redirect_to root_url and return
	  end
	else
	  
	  
	  flash[:error]="accesso negato perché è presente la validazione per questa operazione (<strong>#{controller}/#{action}</strong>), ma non esistono permessi associati"
	  redirect_to root_url and return
	end
      end
    end
  end
  ActionController::Base.send(:include,DeviseRestfulAuth)
end
