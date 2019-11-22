# frozen_string_literal: true

module AvatarHelper
  DEFAULT_PROFILE_IMAGE = 'profile'.freeze
  DEFAULT_PROFILE_IMAGE_SIZE = 80

  # Gravatar will use a default image if one is not found. Having gravatar serve
  # the default image is not desired. Instead force an error by using a bad
  # default url and let our fallback image code take effect.
  def avatar_url(user, options = {})
    return image_url(DEFAULT_PROFILE_IMAGE) if user.nil? || !user.email.include?('@')

    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options.fetch(:size, DEFAULT_PROFILE_IMAGE_SIZE).to_i * 2 # Retina displays mean dot density can be higher.
    "https://secure.gravatar.com/avatar/#{gravatar_id}.png?r=PG&s=#{size}&d=#{image_url(DEFAULT_PROFILE_IMAGE)}"
  end

  def avatar_image(user, opt = {})
    opt.reverse_merge!( # Defaults if not provided
      alt: I18n.t(user ? :alt : :removed, name: user.try(:name), scope: 'helpers.avatar_helper'),
      fallback_image: image_url(DEFAULT_PROFILE_IMAGE),
      include_name: false,
      inline_onerror: false,
      size: DEFAULT_PROFILE_IMAGE_SIZE,
      title: user.try(:name)
    ).merge!( # Additive properties
      class: ['gravatar', opt[:class]].compact.join(' '),
      style: ["width: #{opt[:size]}px; height: #{opt[:size]}px;", opt[:style]].compact.join(' '),
    )

    img_properties = {
      alt: opt[:alt],
      data: { fallback_image: opt[:fallback_image] },
      height: opt[:size],
      style: opt[:style],
      title: opt[:title],
      width: opt[:size]
    }

    img_properties.merge!(onerror: "this.src = '#{opt[:fallback_image]}';") if opt[:inline_onerror]

    content_tag :span, class: opt[:class] do
      image_tag(avatar_url(user, size: opt[:size]), img_properties) +
        (opt[:include_name] ? " #{user.try(:name)}" : '')
    end
  end
end