class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include Open3

  has_metadata 'ffprobe', type: FfmpegDatastream
  has_metadata :name => "descMetadata", :type => MediaAnnotationDatastream
  

  def log_events
    TrackingEvent.where(pid: pid)
  end

  def views
    log_events.where(event: 'view')
  end

  def downloads
    log_events.where(event: 'download')
  end

  def characterize
    super
    ffprobe if video?
  end

  
  def terms_for_editing
    terms_for_display -
     [:part_of, :date_modified, :date_uploaded, :format, :resource_type]
  end

  def terms_for_display
    [ :part_of, :contributor, :creator, :title, :description, 
        :publisher, :date_created, :date_uploaded, :date_modified,:subject, :language, :rights, 
        :resource_type, :identifier, :based_near, :tag, :related_url]
  end
  
  ## Extract the metadata from the content datastream and record it in the characterization datastream
  def characterize
    fits_xml, ffprobe_xml = self.content.extract_metadata
    self.characterization.ng_xml = fits_xml
    self.ffprobe.ng_xml = ffprobe_xml
    self.append_metadata
    self.filename = self.label
    save unless self.new_object?
  end

  private

end
