# frozen_string_literal: true

require "test_helper"

module GobiertoAdmin
  class CreateScopeTest < ActionDispatch::IntegrationTest
    def setup
      super
      @path = admin_ordered_vocabulary_terms_path(module: "gobierto_participation", vocabulary: "scopes")
    end

    def admin
      @admin ||= gobierto_admin_admins(:nick)
    end

    def site
      @site ||= sites(:madrid)
    end

    def test_create_scope_errors
      with_javascript do
        with_signed_in_admin(admin) do
          with_current_site(site) do
            visit @path

            click_link "New"
            click_button "Create"

            assert has_alert? "Name can't be blank"
          end
        end
      end
    end

    def test_create_scope
      with_javascript do
        with_signed_in_admin(admin) do
          with_current_site(site) do
            visit @path

            click_link "New"

            fill_in "term_name_translations_en", with: "New scope name"
            fill_in "term_description_translations_en", with: "New scope description"

            click_link "ES"

            fill_in "term_name_translations_es", with: "Nombre del nuevo ámbito"
            fill_in "term_description_translations_es", with: "Descripción del nuevo ámbito"

            click_button "Create"

            assert has_message?("Term created successfully")

            assert has_content?("New scope name")

            scope = site.scopes.order(created_at: :desc).first

            assert_equal "New scope name", scope.name
            assert_equal "New scope description", scope.description

            assert_equal "Nombre del nuevo ámbito", scope.name_es
            assert_equal "Descripción del nuevo ámbito", scope.description_es

            activity = Activity.last

            assert_equal scope, activity.subject
            assert_equal admin, activity.author
            assert_equal site.id, activity.site_id
            assert_equal "scopes.scope_created", activity.action
          end
        end
      end
    end
  end
end
