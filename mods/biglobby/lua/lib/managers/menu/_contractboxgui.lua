-- Not sure what this class refers to? Seems to affect peers only during a UI screen
-- `ContractBoxGui:create_contract_box()` decompiled source appears to have several bugs.
-- 'job_xp_text' and 'total_payout_text' declare local var within conditional statements
-- that don't make much sense. There is also a conditional that does nothing at all.

-- TODO: Might be better to take the modified loop at the end of `ContractBoxGui:create_contract_box()`
-- and undo it after the original function runs, then recreate the loop logic modified afterwards.

-- Modified to support rendering UI text for additional peers.
function ContractBoxGui:create_contract_box()
	local num_player_slots = BigLobbyGlobals:num_player_slots()




	-- Original Code --
	if not managers.network:session() then
		return
	end
	if self._contract_panel and alive(self._contract_panel) then
		self._panel:remove(self._contract_panel)
	end
	if self._contract_text_header and alive(self._contract_text_header) then
		self._panel:remove(self._contract_text_header)
	end
	if alive(self._panel:child("pro_text")) then
		self._panel:remove(self._panel:child("pro_text"))
	end
	self._contract_panel = nil
	self._contract_text_header = nil
	local contact_data = managers.job:current_contact_data()
	local job_data = managers.job:current_job_data()
	local job_chain = managers.job:current_job_chain_data()
	local job_id = managers.job:current_job_id()
	self._contract_panel = self._panel:panel({
		name = "contract_box_panel",
		w = self._panel:w() * 0.35,
		h = 100,
		layer = 0
	})
	self._contract_panel:rect({
		color = Color(0.5, 0, 0, 0),
		layer = -1,
		halign = "grow",
		valign = "grow"
	})
	local font = tweak_data.menu.pd2_small_font
	local font_size = tweak_data.menu.pd2_small_font_size
	if contact_data then
		self._contract_text_header = self._panel:text({
			text = utf8.to_upper(managers.localization:text(contact_data.name_id) .. ": " .. managers.localization:text(job_data.name_id)),
			font_size = tweak_data.menu.pd2_medium_font_size,
			font = tweak_data.menu.pd2_medium_font,
			color = tweak_data.screen_colors.text,
			blend_mode = "add"
		})
		local length_text_header = self._contract_panel:text({
			text = managers.localization:to_upper_text("cn_menu_contract_length_header"),
			font_size = font_size,
			font = font,
			color = tweak_data.screen_colors.text
		})
		local risk_text_header = self._contract_panel:text({
			text = managers.localization:to_upper_text("menu_lobby_difficulty_title"),
			font_size = font_size,
			font = font,
			color = tweak_data.screen_colors.text
		})
		local exp_text_header = self._contract_panel:text({
			text = managers.localization:to_upper_text("menu_experience"),
			font_size = font_size,
			font = font,
			color = tweak_data.screen_colors.text
		})
		local payout_text_header = self._contract_panel:text({
			text = managers.localization:to_upper_text("cn_menu_contract_jobpay_header"),
			font_size = font_size,
			font = font,
			color = tweak_data.screen_colors.text
		})
		do
			local _, _, tw, th = self._contract_text_header:text_rect()
			self._contract_text_header:set_size(tw, th)
		end
		local w = 0
		do
			local _, _, tw, th = length_text_header:text_rect()
			w = math.max(w, tw)
			length_text_header:set_size(tw, th)
		end
		do
			local _, _, tw, th = risk_text_header:text_rect()
			w = math.max(w, tw)
			risk_text_header:set_size(tw, th)
		end
		do
			local _, _, tw, th = exp_text_header:text_rect()
			w = math.max(w, tw)
			exp_text_header:set_size(tw, th)
		end
		do
			local _, _, tw, th = payout_text_header:text_rect()
			w = math.max(w, tw)
			payout_text_header:set_size(tw, th)
		end
		w = w + 10
		length_text_header:set_right(w)
		risk_text_header:set_right(w)
		exp_text_header:set_right(w)
		payout_text_header:set_right(w)
		risk_text_header:set_top(10)
		length_text_header:set_top(risk_text_header:bottom())
		exp_text_header:set_top(length_text_header:bottom())
		payout_text_header:set_top(exp_text_header:bottom())
		local length_text = self._contract_panel:text({
			text = managers.localization:to_upper_text("cn_menu_contract_length", {
				stages = #job_chain
			}),
			align = "left",
			vertical = "top",
			font_size = font_size,
			font = font,
			color = tweak_data.screen_colors.text
		})
		length_text:set_position(length_text_header:right() + 5, length_text_header:top())
		do
			local _, _, tw, th = length_text:text_rect()
			w = math.max(w, tw)
			length_text:set_size(tw, th)
		end
		if managers.job:is_job_ghostable(managers.job:current_job_id()) then
			local ghost_icon = self._contract_panel:bitmap({
				texture = "guis/textures/pd2/cn_minighost",
				w = 16,
				h = 16,
				blend_mode = "add",
				color = tweak_data.screen_colors.ghost_color
			})
			ghost_icon:set_center_y(length_text:center_y())
			ghost_icon:set_left(length_text:right())
		end
		local filled_star_rect = {
			0,
			32,
			32,
			32
		}
		local empty_star_rect = {
			32,
			32,
			32,
			32
		}
		local job_stars = managers.job:current_job_stars()
		local job_and_difficulty_stars = managers.job:current_job_and_difficulty_stars()
		local difficulty_stars = managers.job:current_difficulty_stars()
		local risk_color = tweak_data.screen_colors.risk
		local cy = risk_text_header:center_y()
		local sx = risk_text_header:right() + 5
		local difficulty = tweak_data.difficulties[difficulty_stars + 2] or 1
		local difficulty_string_id = tweak_data.difficulty_name_ids[difficulty]
		local difficulty_text = self._contract_panel:text({
			font = font,
			font_size = font_size,
			text = managers.localization:to_upper_text(difficulty_string_id),
			color = tweak_data.screen_colors.text
		})
		do
			local _, _, tw, th = difficulty_text:text_rect()
			difficulty_text:set_size(tw, th)
		end
		difficulty_text:set_x(math.round(sx))
		difficulty_text:set_center_y(cy)
		difficulty_text:set_y(math.round(difficulty_text:y()))
		if difficulty_stars > 0 then
			difficulty_text:set_color(risk_color)
		end
		local plvl = managers.experience:current_level()
		local player_stars = math.max(math.ceil(plvl / 10), 1)
		local contract_visuals = job_data.contract_visuals or {}
		local total_xp_min, _ = managers.experience:get_contract_xp_by_stars(job_id, job_stars, difficulty_stars, job_data.professional, #job_chain, {
			mission_xp = contract_visuals.min_mission_xp and contract_visuals.min_mission_xp[difficulty_stars + 1]
		})
		local total_xp_max, _ = managers.experience:get_contract_xp_by_stars(job_id, job_stars, difficulty_stars, job_data.professional, #job_chain, {
			mission_xp = contract_visuals.max_mission_xp and contract_visuals.max_mission_xp[difficulty_stars + 1]
		})
		local xp_text_min = managers.money:add_decimal_marks_to_string(tostring(math.round(total_xp_min)))
		local xp_text_max = managers.money:add_decimal_marks_to_string(tostring(math.round(total_xp_max)))
		-- End Original Code --




		--[[
		local job_xp_text --local should be declared here instead of inside the below if statement
		if total_xp_min < total_xp_max then
		else
			job_xp_text = managers.localization:text("menu_number_range", {min = xp_text_min, max = xp_text_max}) or xp_text_min
		end
		]]

		-- Actually I think the if statement might not make any sense to be there? Decompile bug?
		-- Unless they only want to use/update the variable `job_xp_text` when `total_xp_min` is not less than `total_xp_max`?
		-- Have decied to ignore the if statement and just assign always.
		local job_xp_text = managers.localization:text("menu_number_range", {min = xp_text_min, max = xp_text_max}) or xp_text_min




		-- Original Code --
		local job_xp = self._contract_panel:text({
			font = font,
			font_size = font_size,
			text = job_xp_text,
			color = tweak_data.screen_colors.text
		})
		do
			local _, _, tw, th = job_xp:text_rect()
			job_xp:set_size(tw, th)
		end
		job_xp:set_position(math.round(exp_text_header:right() + 5), math.round(exp_text_header:top()))
		local risk_xp = self._contract_panel:text({
			font = font,
			font_size = font_size,
			text = " +" .. tostring(math.round(0)),
			color = risk_color
		})
		do
			local _, _, tw, th = risk_xp:text_rect()
			risk_xp:set_size(tw, th)
		end
		risk_xp:set_position(math.round(job_xp:right()), job_xp:top())
		risk_xp:hide()
		local job_ghost_mul = managers.job:get_ghost_bonus() or 0
		local ghost_xp_text
		if job_ghost_mul ~= 0 then
			local job_ghost = math.round(job_ghost_mul * 100)
			local job_ghost_string = tostring(math.abs(job_ghost))
			local ghost_color = tweak_data.screen_colors.ghost_color
			if job_ghost == 0 and job_ghost_mul ~= 0 then
				job_ghost_string = string.format("%0.2f", math.abs(job_ghost_mul * 100))
			end
			local text_prefix = job_ghost_mul < 0 and "-" or "+"
			local text_string = " (" .. text_prefix .. job_ghost_string .. "%)"
			ghost_xp_text = self._contract_panel:text({
				font = font,
				font_size = font_size,
				text = text_string,
				color = ghost_color,
				blend_mode = "add"
			})
			do
				local _, _, tw, th = ghost_xp_text:text_rect()
				ghost_xp_text:set_size(tw, th)
			end
			ghost_xp_text:set_position(math.round(risk_xp:visible() and risk_xp:right() or job_xp:right()), job_xp:top())
		end
		local job_heat = managers.job:current_job_heat() or 0
		local job_heat_mul = managers.job:heat_to_experience_multiplier(job_heat) - 1
		local heat_xp_text
		if job_heat_mul ~= 0 then
			job_heat = math.round(job_heat_mul * 100)
			local job_heat_string = tostring(math.abs(job_heat))
			local heat_color = managers.job:current_job_heat_color()
			if job_heat == 0 and job_heat_mul ~= 0 then
				job_heat_string = string.format("%0.2f", math.abs(job_heat_mul * 100))
			end
			local text_prefix = job_heat_mul < 0 and "-" or "+"
			local text_string = " (" .. text_prefix .. job_heat_string .. "%)"
			heat_xp_text = self._contract_panel:text({
				font = font,
				font_size = font_size,
				text = text_string,
				color = heat_color,
				blend_mode = "add"
			})
			do
				local _, _, tw, th = heat_xp_text:text_rect()
				heat_xp_text:set_size(tw, th)
			end
			if (not ghost_xp_text or not ghost_xp_text:right()) and (not risk_xp:visible() or not risk_xp:right()) then
				-- TODO: No logic? This can't be good
			end
			heat_xp_text:set_position(math.round((job_xp:right())), job_xp:top())
		end
		local total_payout_min, base_payout_min, risk_payout_min = managers.money:get_contract_money_by_stars(job_stars, difficulty_stars, #job_chain, managers.job:current_job_id(), managers.job:current_level_id())
		local total_payout_max, base_payout_max, risk_payout_max = managers.money:get_contract_money_by_stars(job_stars, difficulty_stars, #job_chain, managers.job:current_job_id(), managers.job:current_level_id(), {
			mandatory_bags_value = contract_visuals.mandatory_bags_value and contract_visuals.mandatory_bags_value[difficulty_stars + 1],
			bonus_bags_value = contract_visuals.bonus_bags_value and contract_visuals.bonus_bags_value[difficulty_stars + 1],
			small_value = contract_visuals.small_value and contract_visuals.small_value[difficulty_stars + 1],
			vehicle_value = contract_visuals.vehicle_value and contract_visuals.vehicle_value[difficulty_stars + 1]
		})
		local payout_text_min = managers.experience:cash_string(math.round(total_payout_min))
		local payout_text_max = managers.experience:cash_string(math.round(total_payout_max))
		-- End Original Code --




		--[[
		local total_payout_text --local should be declared here instead of inside the below if statement
		if total_payout_min < total_payout_max then
		else
			total_payout_text = managers.localization:text("menu_number_range", {min = payout_text_min, max = payout_text_max}) or payout_text_min
		end
		]]

		-- Actually I think the if statement might not make any sense to be there? Decompile bug?
		-- Unless they only want to use/update the variable `total_payout_text` when `payout_text_min` is not less than `payout_text_max`?
		-- Have decied to ignore the if statement and just assign always.
		local total_payout_text = managers.localization:text("menu_number_range", {min = payout_text_min, max = payout_text_max}) or payout_text_min




		-- Original Code --
		local job_money = self._contract_panel:text({
			font = font,
			font_size = font_size,
			text = total_payout_text,
			color = tweak_data.screen_colors.text
		})
		do
			local _, _, tw, th = job_money:text_rect()
			job_money:set_size(tw, th)
		end
		job_money:set_position(math.round(payout_text_header:right() + 5), math.round(payout_text_header:top()))
		local risk_money = self._contract_panel:text({
			font = font,
			font_size = font_size,
			text = " +" .. managers.experience:cash_string(math.round(risk_payout_min)),
			color = risk_color
		})
		do
			local _, _, tw, th = risk_money:text_rect()
			risk_money:set_size(tw, th)
		end
		risk_money:set_position(math.round(job_money:right()), job_money:top())
		risk_money:hide()
		self._contract_panel:set_h(payout_text_header:bottom() + 10)
	elseif managers.menu:debug_menu_enabled() then
		local debug_start = self._contract_panel:text({
			text = "Use DEBUG START to start your level",
			font_size = font_size,
			font = font,
			color = tweak_data.screen_colors.text,
			x = 10,
			y = 10,
			wrap = true,
			word_wrap = true
		})
		debug_start:grow(-debug_start:x() - 10, debug_start:y() - 10)
	end
	self._contract_panel:set_rightbottom(self._panel:w() - 0, self._panel:h() - 60)
	if self._contract_text_header then
		self._contract_text_header:set_bottom(self._contract_panel:top())
		self._contract_text_header:set_left(self._contract_panel:left())
		local wfs_text = self._panel:child("wfs")
		if wfs_text and not managers.menu:is_pc_controller() then
			wfs_text:set_rightbottom(self._panel:w() - 20, self._contract_text_header:top())
		end
	end
	local wfs = self._panel:child("wfs")
	if wfs then
		self._contract_panel:grow(0, wfs:h() + 5)
		self._contract_panel:move(0, -(wfs:h() + 5))
		if self._contract_text_header then
			self._contract_text_header:move(0, -(wfs:h() + 5))
		end
		wfs:set_world_rightbottom(self._contract_panel:world_right() - 5, self._contract_panel:world_bottom())
	end
	if self._contract_text_header and managers.job:is_current_job_professional() then
		local pro_text = self._panel:text({
			name = "pro_text",
			text = managers.localization:to_upper_text("cn_menu_pro_job"),
			font_size = tweak_data.menu.pd2_medium_font_size,
			font = tweak_data.menu.pd2_medium_font,
			color = tweak_data.screen_colors.pro_color,
			blend_mode = "add"
		})
		local x, y, w, h = pro_text:text_rect()
		pro_text:set_size(w, h)
		pro_text:set_position(self._contract_text_header:right() + 10, self._contract_text_header:y())
	end
	BoxGuiObject:new(self._contract_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})
	-- End Original Code --



	-- Only code changed was replacing hardcoded 4 with variable num_player_slots
	for i = 1, num_player_slots do
		local peer = managers.network:session():peer(i)
		if peer then
			local peer_pos = managers.menu_scene:character_screen_position(i)
			local peer_name = peer:name()
			if peer_pos then
				self:create_character_text(i, peer_pos.x, peer_pos.y, peer_name)
			end
		end
	end
	self._enabled = true
end


-- Modified to support rendering UI text for additional peers.
function ContractBoxGui:update(t, dt)
	local num_player_slots = BigLobbyGlobals:num_player_slots()

	-- Only code changed was replacing hardcoded 4 with variable num_player_slots
	for i = 1, num_player_slots do
		self:update_character(i)
	end
end
