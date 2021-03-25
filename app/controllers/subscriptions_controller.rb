class SubscriptionsController < AuthenticatedController
  layout false

  def index
    @subscriptions = subscribable.subscriptions.includes(:user)

    # Used for showing/hiding subscribe and unsubscribe links
    @subscription = subscribable.subscription_for(user: current_user)
  end

  def create
    subscription = Subscription.new(subscription_params)
    subscription.user = current_user
    subscription.save

    redirect_back fallback_location: root_path, notice: 'Subscribed!'
  end

  def destroy
    subscription = Subscription.find_by(
      user: current_user,
      subscribable_type: subscription_params[:subscribable_type],
      subscribable_id: subscription_params[:subscribable_id]
    )
    subscription.destroy

    redirect_back fallback_location: root_path, notice: 'Unsubscribed!'
  end

  private

  def subscribable
    @subscribable ||= subscribable_class.find(subscription_params[:subscribable_id])
  end

  def subscribable_class
    if Subscribable.allowed_types.include?(subscription_params[:subscribable_type])
      subscription_params[:subscribable_type].constantize
    else
      raise 'Invalid subscribable'
    end
  end

  def subscription_params
    params.require(:subscription).permit(:subscribable_type, :subscribable_id)
  end
end
