class GenericFilesController < ApplicationController
  include Sufia::FilesControllerBehavior

  after_filter :log_visit, :only=>:show

  def log_visit
    @generic_file.views.create!(user: current_user)
  end

  # routed to /files (POST)
  def create
    if params[:local_file].present?
      # Ingest files already on disk
      filename = params[:local_file][0]
      file = File.open(File.join(current_user.directory, filename), 'rb')
      create_and_save_generic_file(file, '1', nil, params[:batch_id], filename)
      if @generic_file
        Sufia.queue.push(ContentDepositEventJob.new(@generic_file.pid, current_user.user_key))
        redirect_to sufia.batch_edit_path(params[:batch_id])
      else
        flash[:alert] = "Error creating generic file."
        render :new
      end
    else
      # They are uploading files.
      super
    end
  end

end
