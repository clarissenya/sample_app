module UsersHelper

  def avatar_for(user, options = { size: 80 })
    size = options[:size]
    style = options[:style]
    if user.avatar?
      if size <= 80
        image_tag user.avatar.url(:thumb), width: size, height: size, alt: user.name, class: 'avatar', style: style
      else
        image_tag user.avatar.url, width: size, height: size, alt: user.name, class: 'avatar', style: style
      end
    else
      image_tag 'default-avatar.svg', width: size, height: size, alt: 'avatar image', class: 'avatar', style: style
    end
  end
end