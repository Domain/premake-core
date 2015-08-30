--
-- tests/actions/make/test_default_config.lua
-- Validate generation of default configuration block for makefiles.
-- Copyright (c) 2012 Jason Perkins and the Premake project
--

	T.make_default_config = {}
	local suite = T.make_default_config
	local make = premake.make


--
-- Setup/teardown
--

	local wks, prj

	function suite.setup()
		wks = test.createWorkspace()
	end

	local function prepare()
		prj = premake.workspace.getproject(wks, 1)
		make.defaultconfig(prj)
	end


--
-- Verify the handling of the default setup: Debug and Release, no platforms.
--

	function suite.defaultsToFirstBuildCfg_onNoPlatforms()
		prepare()
		test.capture [[
ifndef config
  config=debug
endif
		]]
	end


--
-- Verify handling of build config/platform combination.
--

	function suite.defaultsToFirstPairing_onPlatforms()
		platforms { "Win32", "Win64" }
		prepare()
		test.capture [[
ifndef config
  config=debug_win32
endif
		]]
	end


--
-- If the project excludes a solution build cfg, it should be skipped
-- over as the default config as well.
--

	function suite.usesFirstValidPairing_onExcludedConfig()
		platforms { "Win32", "Win64" }
		removeconfigurations { "Debug" }
		prepare()
		test.capture [[
ifndef config
  config=release_win32
endif
		]]
	end
