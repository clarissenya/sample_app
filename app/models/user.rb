# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default(FALSE)
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#  avatar            :string
#  description       :text
#

class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_microposts, through: :likes, source: :likeable, source_type: "Micropost"
  has_many :liked_comments, through: :likes, source: :likeable, source_type: "Comment"

  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy                               
  has_many :following, through: :active_relationships, source: :followed                                
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  mount_uploader :avatar, AvatarUploader
  before_save   :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password                
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validate  :avatar_size

  # 返回指定字符串的哈希摘要
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 返一個隨機令牌
  def User.new_token
    SecureRandom.urlsafe_base64   
  end

  # 爲了持久保持會話，在數據庫中記住用戶
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 如果指定的令牌和摘要匹配，返回true
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 激活账户
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 发送激活邮件
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # 忘记用户
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 设置密码重设相关的属性
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # 发送密码重设邮件
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # 如果密码重设请求超时了，返回 true
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end 
  
   # 返回用户的动态流
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # 关注另一个用户
  def follow(other_user)
    following << other_user
  end

  # 取消关注另一个用户
  def unfollow(other_user)
    following.delete(other_user)
  end

   # 如果当前用户关注了指定的用户，返回 true
  def following?(other_user)
    following.include?(other_user)
  end

  # 判断是否已喜欢
  def liked?(likeable_obj)
    send("liked_#{downcase_class_name(likeable_obj)}s").include?(likeable_obj)
  end

  # 点赞
  def add_like(likeable_obj)
    send("liked_#{downcase_class_name(likeable_obj)}s") << likeable_obj
  end

  #取消赞
  def remove_like(likeable_obj)
    send("liked_#{downcase_class_name(likeable_obj)}s").delete(likeable_obj)
  end

  

  # 返回有图片的微博
  def media
    Micropost.where("picture is not null AND user_id = ?", id)
  end

  # 随机返回用户
  def people_to_follow(number)
    User.where.not(id: following_ids + [self.id]).limit(number).order("RANDOM()")
  end
    

  private

    # 把电子邮件地址转换成小写
    def downcase_email
      self.email = email.downcase
    end

    # 小写类名
    def downcase_class_name(obj)
      obj.class.to_s.downcase
    end

     # 创建并赋值激活令牌和摘要
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    # 验证上传的图像大小
    def avatar_size
      if avatar.size > 5.megabytes
        errors.add(:avatar, "should be less than 5MB")
      end
    end
end

