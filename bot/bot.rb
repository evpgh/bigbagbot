require 'rubotnik'
require 'byebug'

# require_relative all files in "bot" folder or do it by hand
Rubotnik::Autoloader.load('bot')

# Subscribe your bot to a Facebook Page (put access and verify tokens in .env)
Rubotnik.subscribe(ENV['ACCESS_TOKEN'])

# Set welcome screen, "get started" button and a menu (all optional)
# Edit profile.rb before uncommenting the following lines:

Rubotnik.set_profile(
  Profile::START_BUTTON, Profile::START_GREETING
)

# Generates a location prompt for quick_replies
# LOCATION_PROMPT = UI::QuickReplies.location

####################### HANDLE INCOMING MESSAGES ##############################

Rubotnik.route :message do
  bind 'how', 'big', 'bags', all: true, to: :get_all_bags

  bind 'buy', 'bought', 'acquired', 'received', 'added', to: :parse_buy_transaction, reply_with: {
    text: parse_buy_transaction,
    quick_replies: [['Yes', 'CONFIRM'], ['No', 'CANCEL']]
  }

  bind 'sell', 'sold', 'lost', 'removed', 'given', to: :parse_buy_transaction, reply_with: {
    text: parse_sell_transaction,
    quick_replies: [['Yes', 'CONFIRM'], ['No', 'CANCEL']]
  }

  bind 'delete me' do
    user = User.where(fb_id: get_user_info[:id]).first
    return unless user

    Bag.where(user_id: user.id).delete
    Transaction.where(user_id: user.id).delete
    user.delete
  end
end

  # bind 'what', 'my', 'name', all: true, reply_with:{
  #   text: "Hello, sucker!"
  # }
  # bind 'how', 'big', 'bag', to: :single_bag
  # bind 'how', 'are', 'bags', 'doing', to: :compare_bags

  # Start a thread (and provide an opening message with optional quick replies).
  # You have to define method named as a symbol inside a Command module
  # and treat user's response to your "reply_with" message there.
  # commands/commands.rb already has this start_conversation method
  # defined as an example.

  # bind 'how', 'do', 'you', all: true, to: :start_conversation, reply_with: {
  #    text: "I'm doing fine! You?",
  #    quick_replies: [['Good!', 'OK'], ['Not so well', 'NOT_OK']]
  #    # second item in nested array will be the contents of message.quick_reply,
  #    # once the user makes a selection. Quick reply text in ALL CAPS will be
  #    # used as default values of payloads if you pass strings instead of arrays
  #    # (e.g. quick_replies: ['Yes', 'No'], payloads "YES" and "NO" are inferred)
  #  }

  #  # Use 'all' flag if you want to trigger a command only if all words
  #  # are present in a message (will trigger with each of them by default)
  #  bind 'what', 'my', 'name', all: true do
  #    info = get_user_info#(:first_name) # helper to get fields from Graph API
  #    say info.to_s#[:first_name]
  #  end

  #  # Look for example of an API call with HTTParty in commands/location.rb
  #  bind 'where', 'am', 'I', all: true, to: :lookup_location, reply_with: {
  #     text: 'Let me know your location',
  #     quick_replies: LOCATION_PROMPT
  #   }

  #   # Look for more UI examples in commands/ui_examples.rb
  #   # Rubotnik currently supports Image, Button Template and Carousel
  #   bind 'image', to: :show_image

  #  # Invoked if none of the commands recognized. Has to come last, after all binds
# Rubotnik.route :message do
#  default do
#    say "Sorry I did not get it"
#  end
# end

####################### HANDLE INCOMING POSTBACKS ##############################

Rubotnik.route :postback do
  # postback from "Get Started" button
  bind 'START' do
    message.typing_on
    say "🤖 Hello there!"
    say "👔 I'm your crypto 💰 accounting assistant."
    say "🤓 I don't expose you to any risk by asking for access to your exchanges."
    say "Just tell me 💬 when you buy or sell an asset and I'll calculate your bags' value automatically 💰💰💰"
    say "➕ Add to your bags by messaging me something like 'I bought 5 BTC for 10000 $'"
    say "➖ I know it's not your thing but if you decided to sell just message me something like 'I sold 2 BTC for 20000 $'"
    say "ℹ️ Check out your bags with 'How big are my bags?'"
    message.typing_off    
  end
end

####################### HANDLE OTHER REQUESTS (NON-FB) #########################

get '/' do
  'I can have a landing page too!'
end

############################ TEST ON LOCALHOST #################################

# 0. Have both Heroku CLI and ngrok
# 1. Set up "Messenger" app on Facebook for Developers, fill in .env
# 2. Run 'heroku local' from console, it will load Puma on port 5000
# 3. Expose port 5000 to the Internet with 'ngrok http 5000'
# 4. Provide your ngrok http_s_(!) address in Facebook Developer Dashboard
#    for webhook validation.
# 5. Open Messenger and talk to your bot!

# P.S. While you have DEBUG environment variable set to "true" (default in .env)
# All StandardError exceptions will go to the message dialog instead of
# breaking the server.
