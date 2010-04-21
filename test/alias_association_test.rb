require 'test_helper'

class AliasAssociationTest < ActiveSupport::TestCase

  class User < ActiveRecord::Base
    has_one :name, :foreign_key => 'u_id'
    has_many :roles

    alias_association :name_alias, :name
    alias_association :roles_alias, :roles
  end

  class Name < ActiveRecord::Base
    belongs_to :user

    alias_association :user_alias, :user
  end

  class Role < ActiveRecord::Base
    belongs_to :user
    has_and_belongs_to_many :rights

    alias_association :rights_alias, :rights
  end

  class Right < ActiveRecord::Base
  end

  test "User.name alias" do
    assert User.new.respond_to? :name
    assert User.new.respond_to? :name_alias

    assert User.new.respond_to? :build_name
    assert User.new.respond_to? :build_name_alias

    assert User.new.respond_to? :create_name
    assert User.new.respond_to? :create_name_alias

    assert User.new.respond_to? :loaded_name?
    assert User.new.respond_to? :loaded_name_alias?

    assert User.new.respond_to? :set_name_target
    assert User.new.respond_to? :set_name_alias_target
  end

  test "User.roles alias" do
    assert User.new.respond_to? :roles
    assert User.new.respond_to? :roles_alias
  end

  test "Name.user alias" do
    assert Name.new.respond_to? :user
    assert Name.new.respond_to? :user_alias

    assert Name.new.respond_to? :build_user
    assert Name.new.respond_to? :build_user_alias

    assert Name.new.respond_to? :create_user
    assert Name.new.respond_to? :create_user_alias

    assert Name.new.respond_to? :loaded_user?
    assert Name.new.respond_to? :loaded_user_alias?

    assert Name.new.respond_to? :set_user_target
    assert Name.new.respond_to? :set_user_alias_target
  end

  test "Role.rights alias" do
    assert Role.new.respond_to? :rights
    assert Role.new.respond_to? :rights_alias
  end

  test "User.name alias accessors" do
    name = create_name
    user = create_user :name => name
    user.reload; name.reload

    assert_equal name, user.name_alias
    assert_equal user.name, user.name_alias

    new_name = create_name
    user.name_alias = new_name
    assert user.save

    user.reload; new_name.reload

    assert_equal new_name, user.name_alias
    assert_equal user.name, user.name_alias
  end

  test "User.roles alias accessors" do
    role1 = create_role
    role2 = create_role
    user = create_user :roles => [ role1, role2 ]
    user.reload; role1.reload; role2.reload

    assert_equal [ role1, role2 ], user.roles_alias
    assert_equal user.roles, user.roles_alias

    new_role = create_role
    user.roles_alias = [ role1, new_role ]
    assert user.save

    user.reload; new_role.reload

    assert_equal [ role1, new_role ], user.roles_alias
    assert_equal user.roles, user.roles_alias
  end

  private

    def create_user(attrs = {})
      user = User.create(attrs)
      assert user.id, "could not save user: #{user} !"
      user
    end

    def create_name(attrs = {})
      name = Name.create(attrs)
      assert name.id, "could not save name: #{name} !"
      name
    end

    def create_role(attrs = {})
      role = Role.create(attrs)
      assert role.id, "could not save role: #{role} !"
      role
    end

end
