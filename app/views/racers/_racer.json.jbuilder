racer = to_racer(racer)
json.extract! racer, :id, :number, :first_name, :last_name, :gender, :group, :secs, :created_at, :updated_at
json.url racer_url(racer, format: :json)
