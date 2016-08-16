require 'httparty'
require 'json'
require 'kele/roadmap'

class Kele
  include HTTParty
  include Roadmap

  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: {"email": email, "password": password})
    raise InvalidStudentCodeError.new() if response.code == 401
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url("users/me"), headers: { "authorization" => @auth_token })
    body = JSON.parse(response.body)
  end
  
  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    body = JSON.parse(response.body)
  end
  
  private
  
    def api_url(endpoint)
      "https://www.bloc.io/api/v1/#{endpoint}"
    end
  
end
