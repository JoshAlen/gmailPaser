class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]

  def index
    @emails = Email.all
  end

  def show
    #setting instance vaiables by calling private method to send data into show controller
    @delivered_to = get_delivered_to(@email)
    @message_id = get_message_id(@email)
    @email_subject = get_email_subject(@email)
    @email_from = get_email_from(@email)
    @email_received = get_email_received(@email)
  end

  def new
    @email = Email.new
  end

  def edit
  end

  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
    end
  end

  private

    def set_email
      @email = Email.find(params[:id])
    end

    def email_params
      params.require(:email).permit(:text)
    end

    #Created 5 methods with regular expression with each 
    #Each method return data matching field.
    #I think I could have make it more simple if I could setup variable inside regular expression
    def get_delivered_to(email)
      email.text.match(/Delivered-To: .*/)
    end

    def get_message_id(email)
      email.text.match(/Message-ID: .*/)
    end

    def get_email_subject(email)
      email.text.match(/Subject: .*/)
    end

    def get_email_from(email) 
      email.text.match(/From: .*/)
    end

    def get_email_received(email)
      email.text.match(/(Received: by) .+\n(.+)/)
    end

end
