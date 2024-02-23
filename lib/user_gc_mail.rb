# class InsertChampUser < Redmine::Hook::ViewListener
class UserGcMail < Redmine::Hook::ViewListener

	def view_users_form(context = {})

		tag = context[:form].text_field :google_cal_mail, :size => 50

		return content_tag(:p, tag)

	end
end