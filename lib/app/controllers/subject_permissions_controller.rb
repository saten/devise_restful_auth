class SubjectPermissionsController < ApplicationController
  #before_filter :validate_permissions
  # GET /subject_permissions
  # GET /subject_permissions.xml
  def index
    @subject_permissions = SubjectPermission.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subject_permissions }
    end
  end

  # GET /subject_permissions/1
  # GET /subject_permissions/1.xml
  def show
    @subject_permission = SubjectPermission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subject_permission }
    end
  end

  # GET /subject_permissions/new
  # GET /subject_permissions/new.xml
  def new
    @subject_permission = SubjectPermission.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subject_permission }
    end
  end

  # GET /subject_permissions/1/edit
  def edit
    @subject_permission = SubjectPermission.find(params[:id])
  end

  # POST /subject_permissions
  # POST /subject_permissions.xml
  def create
    @subject_permission = SubjectPermission.new(params[:subject_permission])

    respond_to do |format|
      if @subject_permission.save
        format.html { redirect_to(@subject_permission, :notice => 'SubjectPermission was successfully created.') }
        format.xml  { render :xml => @subject_permission, :status => :created, :location => @subject_permission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subject_permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subject_permissions/1
  # PUT /subject_permissions/1.xml
  def update
    @subject_permission = SubjectPermission.find(params[:id])

    respond_to do |format|
      if @subject_permission.update_attributes(params[:subject_permission])
        format.html { redirect_to(@subject_permission, :notice => 'SubjectPermission was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subject_permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subject_permissions/1
  # DELETE /subject_permissions/1.xml
  def destroy
    @subject_permission = SubjectPermission.find(params[:id])
    @subject_permission.destroy

    respond_to do |format|
      format.html { redirect_to(subject_permissions_url) }
      format.xml  { head :ok }
    end
  end
end
