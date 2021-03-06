import {data_keys} from './data_keys'
import './keyboard-notification'
### TODOS: ✅
— ✅ pressed state not working in khmer keyboard language
— ✅ space press is not shown
— ✅ Space does not show pressed state
— ✅ When Shift + character is pressed, and character is released, the keyboard returns to lowercase even if you are still holding shift
— ✅ Delete does not show pressed state
- Make English Font style match Khmer Font Style CHoices
- ✅ Make width of dot match width of space
- ✅ apply .hint class to current letter on keyboard if hint state is true.
- alt + s doesn't register for the third khmer challenge.
- ✅ allow backspace. 
	I think it's better to allow backspace, than not allow backspace.
	It teaches the user to use backspace. We can allow backspace after a certain level.
- TODO: require character's per minute goal
- TODO: Make challenge work with either english or khmer Keyboard Language, right now if I use the english keyboard layout, khmer challenges will not work.
	- Allow for khmer challenges to work with either english or khmer keyboard layout.
	- OR force the keyboard layout to match the language of the challenge.
- TODO: Make challenge work with either english or khmer PC System Keyboard. 
	Right now. If I use a khmer keyboard on mac, it will not work.
- TODO: BUG: if i type command+letter the letter will be stuck with the .pressed class until I press the key again.
- TODO: When choosing English keyboard doesn't show english challenges.
- ✅ Make Enter go to the next unlocked level if passed or repeat level if not passed.
- ✅ Make left arrow go back to the previous level
- ✅ Make right arrow go to the next available level
###



export tag view-keyboard
	letter_index = 0

	def pressed key
		for k in key.english
			if data.pressed_keys.indexOf(k) > -1  
				return yes

		for k in key.khmer
			if data.pressed_keys.indexOf(k) > -1  
				return yes
		return no


	def highlight key
		if not data.keyboard_hints
			return no

		if data.level_finished
			return key.english[0] is 'shift' or key.english[0] is '◀︎' or key.english[0] is  '▶︎' or key.english[0] is 'enter'


		const char = data.challenges[data.level_chosen][data.challenge_character].char

		if key[data.challenge_language].indexOf(char) > -1
			return yes

		if /[A-Za-z]/.test(char)
			if char == char.toUpperCase! && char != ' '
				if key.english[0] == 'shift'
					return yes
		else
			const khmer_char = data_keys.find(do(el) return el[data.challenge_language].indexOf(char) > -1)
			if khmer_char
				const index_of_khmer_char = khmer_char[data.challenge_language].indexOf(char)

				if index_of_khmer_char == 1
					if key.english[0] == 'shift'
						return yes

				elif index_of_khmer_char == 2
					if key.english[0] == 'alt'
						return yes

		return key[data.keyboard_language].indexOf(char) > -1



	def render
		<self>
			<keyboard-message data=data>
			<.board>
				let language = english
				let set = 0
				for key, i in data_keys
					if key.name is 'up-arrow'
						<div[d:none]>
					elif key.name is 'down-arrow'
						<.two-half-keys-wrapper .{key.size}>
							let upkey = data_keys[i - 1]
							let downkey = data_keys[i]
							<.key.half-key .pressed=pressed(key) .hint=highlight(key) .{key.finger}=data.keyboard_colored .disabled=upkey.disabled .{upkey.finger} .action=!upkey.char .{upkey.hand}> <span> upkey.english[0]
							<.key.half-key .pressed=pressed(key) .hint=highlight(key) .{key.finger}=data.keyboard_colored .disabled=downkey.disabled .{downkey.finger} .action=!downkey.char .{downkey.hand}> <span> downkey.english[0]
					else
						<.key .hint=highlight(key) .disabled=key.disabled .{key.finger}=data.keyboard_colored .action=!key.char .{key.size} .name-{key.name} .{key.hand} .pressed=pressed(key)>
							if key.char
								<span.shift-preview>
									if data.shift_pressed
										key[data.keyboard_language][0]
									else
										key[data.keyboard_language][1]

								<span.normal-preview>
									if key.name is 'spacebar'
										"spacebar"
									elif data.shift_pressed and not data.alt_pressed
										key[data.keyboard_language][1]
									elif data.alt_pressed and not data.shift_pressed
										key[data.keyboard_language][2]
									elif data.alt_pressed and data.shift_pressed
										key[data.keyboard_language][3]
									else
										key[data.keyboard_language][0]

							else
								<span.normal-preview>
									key[data.keyboard_language][0]
	
	# ========================
	# STYLES
	# ========================			
	css @keyframes hint
		0% bg:cooler4
		100% bg:red1
	
	css &
		$radius:0.3rem
		$key-shadow:sm, md, md, lg
		p:.5rem
		rd:md 
		d:inline-block 
		bg:cooler8
		bxs:sm,md,md,xl
		.first bg:rose5
		.hint
			animation: hint .5s infinite alternate
		.second bg:pink5
		.third bg:violet5
		.fourth bg:blue5
		.fifth bg:yellow3 
		.sixth bg:yellow3 
		.seventh bg:teal5
		.eighth bg:lime5
		.ninth bg:amber5
		.tenth bg:orange5
		bd:1px solid gray7/50

	css .board
		fs:1em
		d:grid jc:center
		gtc: repeat(30, 1rem)
		grid-gap:.5rem
	
	css .square
		$aspect-ratio:1/1
		grid-column:span 2
		h:2.5rem

	css .pressed
		h:2.4rem
		transform:translateY(.1rem)
		bxs:inset 0 0 0 0 gray9/50, sm, md, md, lg
	
	css .long
		grid-column:span 3

	css .longer
		grid-column:span 4

	css .longest
		grid-column:span 5

	css .key
		rd:$radius
		pos:relative
		us:none
		tween: all .2ms easy-ease
		bg:cooler3 @hover:cooler1
		bxs:inset 0 -.25rem 0 -.10rem gray9/50, sm, md, md, lg
		span
			pos:absolute
			w:100% h:100%
			d:flex
		span.shift-preview
			h:1rem
			lh:100%
			px:.2rem
			py:.15rem
			l:0%
			t:0% 
			fs:.7rem
			c:gray9/60
		span.normal-preview
			w:100% h:100%
			ai:center jc:center
			fs:1.1rem
			t:0%
			r:0%
		&.disabled, & .half-key.disabled
			bxs:lg
			bg:cooler6 @hover:cooler6
		&.pressed:not(.disabled)
			bxs:sm,md,md,lg
			bg:cooler1
			bdb:0rem
		&.action, &.spacebar
			d:flex
			bxs:inset 0 -.25rem 0 -.10rem gray9/50, sm, md, md, lg
			span
				jc:center
				px:.4rem
				fs:.7rem
			&.left span.normal-preview
				jc:left
			&.right span.normal-preview
				jc:right
			&.both span.normal-preview
				jc:center
		
	# Keys with touch anchor for index finger
	css .name-f, .name-j
		pos:relative
		@before
			content:'—'
			d:flex jc:center
			lh:.5rem
			ai:flex-end
			ta:center
			c:blue9
			h:100%
	
	css .two-half-keys-wrapper
		pos:relative
		us:none
		bg:transparent
		d:flex fld:column jc:space-between
		&.disabled
			bxs:lg
			bg:cooler6 @hover:cooler6
			transform:none
		
		.half-key
			h:1.1rem
			grid-column: span 2
			d:flex rd:$radius ai:center ta:center
			w:100%
			us:none
			bxs:inset 0 -.25rem 0 -.10rem gray9/50, sm, md, md, lg
			span
				pos:absolute
				ta:center w:100%
				fs:.7rem
			&.disabled
				bg:cooler6 @hover:cooler6
	# css .up-down-arrows
	# 	rd:$radius
	# 	d:grid
	# 	pos:absolute
	# 	t:0 r:0 b:0 l:0
	# 	d:flex jc:space-between fld:column ai:center
	# 	bxs:none @hover:none
	
	css .name-spacebar 
		grid-column: span 8