describe 'facebook experiments' do
  let(:user) { create :admin_user }

  context 'image on opengraph metadata', js: true, driver: :webkit do
    let(:member) { create :member }
    let(:image ) { 'http://wow.com/image.png' }

    it 'should use the petition`s image if available' do
      login user.email, user.password do
        petition = create_petition(images: [image])
        visit petition_path(petition, { r: member.to_hash })
        opengraph_image.should eq image
      end
    end

    it 'should use a default image when no alternative specified' do
      login user.email, user.password do
        petition = create_petition
        visit petition_path(petition, { r: member.to_hash })
        defaults = Rails.configuration.social_media[:facebook][:images]
        defaults.should include opengraph_image
      end
    end

    def open_graph_image
      element(css: 'meta[property="og:image"]').attribute('content')
    end

  end

  context 'titles' do

    #FIXME: extract this image thing from here?
    it 'should win on a signature from share', js: true, driver: :webkit do
      pending 'work in progress'
      login user.email, user.password do
        create_petition({
          fb_titles: ['fb turtles', 'fb kittens'],
          images: ['placekitten.com/g/200/200','placekitten.com/g/200/220']
        })

        force_result({ 
          'facebook sharing options' => 'facebook_popup', 
          'after share view 2' => 'button_is_most_effective_tool',
          'display countdown to share' => 'false' 
        })

        #test user
        #sign
        #share
        #check results
      end
    end
  end

end