# == Schema Information
#
# Table name: chats
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  history    :json
#  q_and_a    :string           default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Chat < ApplicationRecord
  belongs_to :user

  attr_accessor :message

  def message=(message)
    messages = [
      { 'role' => 'system', 'content' => message }
    ]
    q_and_a.each do |question, answer|
      messages << { 'role' => 'user', 'content' => question }
      messages << { 'role' => 'assistant', 'content' => answer }
    end
    messages << { 'role' => 'user', 'content' => message } if messages.size > 1
  
    response_raw = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: messages,
        temperature: 0.7,
        max_tokens: 500,  # Corrected parameter name
        top_p: 1,
        frequency_penalty: 0.0,  # Corrected parameter name
        presence_penalty: 0.6
      }
    )
  
    # Rest of your code...
  end
  

  private

  def client
    OpenAI::Client.new
  end
end
