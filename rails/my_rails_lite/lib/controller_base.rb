require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params, :session

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ||= false
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Render and/or redirect were called multiple times in this action." if already_built_response?
    @already_built_response = true

    res['Location'] = url
    res.status = 302
    session.store_session(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Render and/or redirect were called multiple times in this action." if already_built_response?
    @already_built_response = true

    res['Content-Type'] = content_type
    res.write(content)
    session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name) #ie index
    raise "Render and/or redirect were called multiple times in this action." if already_built_response?

    controller_name = self.class.to_s.underscore
    contents = File.read("views/#{controller_name}/#{template_name}.html.erb")
    template = ERB.new(contents)
    render_content(template.result(binding), 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
