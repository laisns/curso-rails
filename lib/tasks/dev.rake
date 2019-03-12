namespace :dev do
	desc "Configura o ambiente de desenvolvimento"
	task setup: :environment do
	  	if Rails.env.development?
	  		spinner = TTY::Spinner.new("[:spinner] Executando tarefas....", format: :pulse_2)
	  		spinner.auto_spin
	  		#puts %x(rails db:drop db:create db:migrate db:seed)
	  		show_spinner("Apagando BD......"){%x(rails db:drop)}
	  		show_spinner("Criando BD......"){%x(rails db:create)}
	  		show_spinner("Migrando BD......"){%x(rails db:migrate)}
	  		%x(rails dev:add_mining_types)
	  		%x(rails dev:add_coins)
	  		
	  		spinner.success("concluido com sucesso!")
	  	else
	  		puts "Você não está em ambiente de desenvolvimento!"
	  	end
	end

	desc "Cadastra as moedas"
	task add_coins: :environment do
		show_spinner("Cadastrando moedas....") do
			coins = [
				{
				description: "Bitcoin",
				acronym: "BTC",
				url_image: "https://imagepng.org/wp-content/uploads/2017/06/moeda-bitcoin-coin.png",
				mining_type: MiningType.find_by(acronym: "PoW")
				},
				{
				description: "Ethereum",
				acronym: "ETH",
				url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1027.png",
				mining_type: MiningType.all.sample
				},
				{
				description: "Dash",
				acronym: "DASH",
				url_image: "data:image/jpeg;base64,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",
				mining_type: MiningType.all.sample
				},

				{
				description: "ZCash",
				acronym: "ZEC",
				url_image: "https://z.cash/wp-content/uploads/2018/09/zcash-icon-fullcolor.png",
				mining_type: MiningType.all.sample
				}
			]
			coins.each do |coin|
				Coin.find_or_create_by!(coin)
			end
		end		
	end

	desc "Cadastro dos tipos de mineração"
	task add_mining_types: :environment do
		show_spinner("Cadastrando moedas....") do
			mining_types = [
				{description: "Proof of Work", acronym: "PoW"},
				{description: "Proof of Stake", acronym: "PoS"},
				{description: "Proof of Capacity", acronym: "PoC"}
			]

			mining_types.each do |mining_type|
					MiningType.find_or_create_by!(mining_type)
			end
		end
	end
	
private	
	def show_spinner(msg_start, msg_end="Concluido!")
		spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
		spinner.auto_spin
		yield
		spinner.success("(#{msg_end})")
	end
end
