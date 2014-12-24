class AdminController < ApplicationController
	layout "../admin/layout/layout.html.erb"

	def index
        if !user_signed_in?
            render :text => "<h2>User not authenticated.Please <a href='/index/index' >login</a></h2>"
              
        end
            
	end
	
	def user_details
        	if !user_signed_in?
            	render :text => "<h2>User not authenticated.Please <a href='/index/index' >login</a></h2>"
        	else      
		@user_all = User.all.map{|u| [ u.id, u.id ] }
		@users = User.new	
			if params[:id]
				@user=User.find(params[:id])
			end
		end
	end
	
	def stockmanipulator
		if !user_signed_in?
            	render :text => "<h2>User not authenticated.Please <a href='/index/index' >login</a></h2>"
        	else      
		@stock= Stock.new
		@stocks_list = Stock.all
   		     if params[:stock] 
  			       @stock=Stock.new(id:params[:stock][:stock_id],stockname:params[:stock][:stockname],currentprice:params[:stock][:currentprice], stocksinexchange:params[:stock][:stocksinexchange],daylow:params[:stock][:daylow],dayhigh:params[:stock][:dayhigh],alltimelow:params[:stock][:alltimelow],alltimehigh:params[:stock][:alltimehigh],stocksinmarket:params[:stock][:stocksinmarket])
	                        if @stock.save
		                    flash[:queryStatus] = "Saved Successfully"
		                    redirect_to action:'stockmanipulator'
		                end
        	    end	
		    if params[:update_id]
    			 @updatestock=Stock.find(params[:update_id])  
	            end

 		    if params[:up_id]
     			@updatestock=Stock.find(params[:up_id])
			if @updatestock.update(stock_params)
				@updatestock=Stock.delete
				redirect_to action:'stockmanipulator'
	                 
			end
		    end

		    if params[:delete_id]
     			@deletestock=Stock.find(params[:delete_id]).delete  
		    end

		end
	end 
    
    def market_events
        if !user_signed_in?
            render :text => "<h2>User not authenticated.Please <a href='/index/index' >login</a></h2>"
        else
            @market_event=MarketEvent.new
            # creating new event
            if params[:market_event] 
                @market_event=MarketEvent.new(stock_id:params[:market_event][:stock_id],eventname:params[:market_event][:eventname],event_type:params[:market_event][:event_type],event:params[:market_event][:event],event_turn:params[:market_event][:event_turn],event_done:params[:market_event][:event_done])
                if @market_event.save
                    flash[:queryStatus] = "Saved Successfully"
                    redirect_to action:'market_events'
                end
            end
            # showing all events
            if !MarketEvent.all.empty?
                @stock= Stock.paginate(:page => params[:page], :per_page => 5)
                @allEvent = MarketEvent.paginate(:page => params[:page], :per_page => 5)
                
            else
                @allEvent="Event Empty. Please add new Events"    
            end    
        end
        
    end
    
    def company_events
        if !user_signed_in?
            render :text => "<h2>User not authenticated.Please <a href='/index/index' >login</a></h2>"
            
        end
        
        
    end
    
    def bank_rates
         if !user_signed_in?
                render :text => "<h2>User not authenticated.Please <a href='/index/index' >login</a></h2>"
           else
                @banks_list = Bank.all
           end    
    end

	private
	def stock_params
 		params.require(:updatestock).permit(:stock_id, :stockname, :currentprice, :stocksinexchange, :daylow, :dayhigh, :alltimelow, :alltimehigh , :stocksinmarket)
	end

end
