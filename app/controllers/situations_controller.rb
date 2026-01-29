class SituationsController < ApplicationController
  def create
    @situation = Current.user.situations.build(situation_params)

    # Handle tag input (comma-separated or space-separated tags)
    if params[:tag_input].present?
      tag_names = params[:tag_input].split(/[,\s]+/).map(&:strip).reject(&:blank?)
      tag_names.each do |name|
        tag = Current.user.tags.find_or_create_by(name: name.downcase) do |t|
          t.category = "custom"
        end
        @situation.tags << tag
      end
    end

    # Handle selected existing tags
    if params[:tag_ids].present?
      params[:tag_ids].each do |tag_id|
        tag = Current.user.tags.find_by(id: tag_id)
        @situation.tags << tag if tag
      end
    end

    if @situation.save
      redirect_to root_path, notice: "Your situation has been updated!"
    else
      redirect_to root_path, alert: "Failed to update situation: #{@situation.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @situation = Current.user.situations.find(params[:id])
    @situation.destroy
    redirect_to root_path, notice: "Situation deleted."
  end

  private

  def situation_params
    params.require(:situation).permit(:message, :visibility)
  end
end
