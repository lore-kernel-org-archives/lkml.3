Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3IJFUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:20:37 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:33587 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3IJFUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:20:35 -0400
Message-ID: <522EAC17.9000908@t-online.de>
Date: Tue, 10 Sep 2013 07:20:23 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [BUG kernel 3.11+] i915: pipe state doesn't match
References: <522A5008.6060005@t-online.de> <CAKMK7uHAMr_qzismVMB8m3za8UwogMVknPcj7LsZFuC7L8GnrQ@mail.gmail.com>
In-Reply-To: <CAKMK7uHAMr_qzismVMB8m3za8UwogMVknPcj7LsZFuC7L8GnrQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060603040709010003060901"
X-ID: Xd9sX6ZeohA57GfzfNC9BdFI8G7o5WdoeOnb1ai0OYZb3J-VpTLyaFCGNMOjPLPZXm
X-TOI-MSGID: c6a5c0ed-e280-4db5-9ce9-b83c7c30944c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060603040709010003060901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Addendum: Attached find a log of a suspend / resume cycle, debug level 0xe.
Kernel 26b0332e30c7f93e780aaa054bd84e3437f84354 with added stolen memory patches.

cu,
  Knut

--------------060603040709010003060901
Content-Type: text/plain; charset=UTF-8;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[  638.912073] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[  638.912098] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  638.915291] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  638.969609] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  638.969628] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[  648.992173] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[  648.992200] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  648.995389] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  649.053590] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  649.053608] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[  651.050052] PM: Hibernation mode set to 'suspend'
[  651.101293] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
[  651.101306] PM: Basic memory bitmaps created
[  651.101311] PM: Syncing filesystems ... done.
[  652.044544] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  652.046267] PM: Preallocating image memory... done (allocated 66603 pages)
[  652.245172] PM: Allocated 266412 kbytes in 0.19 seconds (1402.16 MB/s)
[  652.245180] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  652.248316] Suspending console(s) (use no_console_suspend to debug)
[  652.254254] parport_pc 00:07: disabled
[  652.254900] serial 00:06: disabled
[  652.254965] serial 00:06: System wakeup disabled by ACPI
[  652.255486] serial 00:05: disabled
[  652.255523] serial 00:05: System wakeup disabled by ACPI
[  652.269066] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe B
[  652.308041] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  652.308047] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  652.308052] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[  652.308059] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[  652.308065] [drm:i9xx_update_wm], memory self refresh disabled
[  652.313774] PM: freeze of devices complete after 65.352 msecs
[  652.315234] PM: late freeze of devices complete after 1.454 msecs
[  652.317446] PM: noirq freeze of devices complete after 2.207 msecs
[  652.317706] PM: Creating hibernation image:
[  652.320009] PM: Need to copy 66483 pages
[  652.320009] PM: Normal pages needed: 18625 + 1024, available pages: 209592
[  652.320009] PM: Hibernation image created (66483 pages copied)
[  652.320009] Force enabled HPET at resume
[  652.320009] PM: noirq thaw of devices complete after 0.825 msecs
[  652.320068] PM: early thaw of devices complete after 1.048 msecs
[  652.324272] pci 0000:00:1e.0: setting latency timer to 64
[  652.324941] PIIX_IDE 0000:00:1f.1: setting latency timer to 64
[  652.325550] ata_piix 0000:00:1f.2: setting latency timer to 64
[  652.334946] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[  652.334950] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[  652.334964] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[  652.334974] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
[  652.335068] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
[  652.335175] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
[  652.335182] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: disabled
[  652.335191] [drm:intel_modeset_readout_hw_state], [ENCODER:6:DAC-6] hw state readout: disabled, pipe=0
[  652.335213] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.350559] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  652.350566] [drm:intel_modeset_readout_hw_state], [ENCODER:7:TMDS-7] hw state readout: disabled, pipe=0
[  652.350586] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.358797] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.358803] [drm:intel_modeset_readout_hw_state], [ENCODER:9:DAC-9] hw state readout: disabled, pipe=0
[  652.358811] [drm:intel_modeset_readout_hw_state], [ENCODER:63:TV-63] hw state readout: disabled, pipe=0
[  652.358820] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:VGA-1] hw state readout: disabled
[  652.358838] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.366427] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  652.366433] [drm:intel_modeset_readout_hw_state], [CONNECTOR:8:DVI-D-1] hw state readout: disabled
[  652.366451] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.373617] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.373624] [drm:intel_modeset_readout_hw_state], [CONNECTOR:10:SVIDEO-1] hw state readout: disabled
[  652.373642] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.380637] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.380644] [drm:intel_modeset_readout_hw_state], [CONNECTOR:27:SVIDEO-2] hw state readout: disabled
[  652.380662] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.387426] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.387432] [drm:intel_modeset_readout_hw_state], [CONNECTOR:44:SVIDEO-3] hw state readout: disabled
[  652.387450] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.394244] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.394250] [drm:intel_modeset_readout_hw_state], [CONNECTOR:61:VGA-2] hw state readout: disabled
[  652.394258] [drm:intel_modeset_readout_hw_state], [CONNECTOR:62:SVIDEO-4] hw state readout: disabled
[  652.394269] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[  652.394273] [drm:intel_dump_pipe_config], cpu_transcoder: A
[  652.394278] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[  652.394284] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  652.394288] [drm:intel_dump_pipe_config], requested mode:
[  652.394296] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  652.394300] [drm:intel_dump_pipe_config], adjusted mode:
[  652.394307] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  652.394312] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  652.394317] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  652.394321] [drm:intel_dump_pipe_config], ips: 0
[  652.394330] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[  652.394334] [drm:intel_dump_pipe_config], cpu_transcoder: B
[  652.394338] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[  652.394344] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  652.394348] [drm:intel_dump_pipe_config], requested mode:
[  652.394356] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  652.394360] [drm:intel_dump_pipe_config], adjusted mode:
[  652.394367] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  652.394372] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  652.394377] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  652.394381] [drm:intel_dump_pipe_config], ips: 0
[  652.394388] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[  652.394396] [drm:connected_sink_compute_bpp], [CONNECTOR:5:VGA-1] checking for sink bpp constrains
[  652.394403] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[  652.394408] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[  652.394412] [drm:intel_dump_pipe_config], cpu_transcoder: A
[  652.394417] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[  652.394423] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  652.394427] [drm:intel_dump_pipe_config], requested mode:
[  652.394435] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[  652.394439] [drm:intel_dump_pipe_config], adjusted mode:
[  652.394447] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[  652.394452] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  652.394457] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  652.394461] [drm:intel_dump_pipe_config], ips: 0
[  652.394812] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[  652.394825] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  652.394831] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  652.394836] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[  652.394844] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[  652.394850] [drm:i9xx_update_wm], memory self refresh disabled
[  652.394856] [drm:intel_crtc_mode_set], [ENCODER:6:DAC-6] set [MODE:0:1280x1024]
[  652.394865] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  652.394871] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  652.394876] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[  652.394880] [drm:intel_calculate_wm], FIFO watermark level: -14
[  652.394884] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  652.394891] [drm:i9xx_update_wm], self-refresh entries: 80
[  652.394897] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  652.394905] [drm:i9xx_update_wm], memory self refresh enabled
[  652.416068] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 0
[  652.416088] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[  652.416127] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.425302] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  652.425338] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.433845] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.433863] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.440584] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.440602] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.447264] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.447281] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.453939] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.453946] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[  652.453953] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[  652.453971] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.460656] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  652.460661] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[  652.460680] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  652.467331] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  652.467336] [drm:check_encoder_state], [ENCODER:63:TV-63]
[  652.467342] [drm:check_crtc_state], [CRTC:3]
[  652.467369] [drm:check_crtc_state], [CRTC:4]
[  652.467377] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[  652.467411] [drm:intel_resume_hotplug], running encoder hotplug functions
[  652.467429] [drm:intel_sdvo_debug_write], SDVOB: W: 0D 01 00                   (SDVO_CMD_SET_ACTIVE_HOT_PLUG)
[  652.474671] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[  652.474680] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[  652.474686] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[  652.481683] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[  652.508045] hda: UDMA/100 mode selected
[  652.599868] ata1.00: configured for UDMA/133
[  652.601193] PM: thaw of devices complete after 281.115 msecs
[  652.606259] PM: writing image.
[  652.608195] PM: Using 1 thread(s) for compression.
[  652.608195] PM: Compressing and saving image data (66548 pages)...
[  652.608275] PM: Image saving progress:   0%
[  652.900816] PM: Image saving progress:  10%
[  653.131672] PM: Image saving progress:  20%
[  653.328439] PM: Image saving progress:  30%
[  653.594226] PM: Image saving progress:  40%
[  653.812923] PM: Image saving progress:  50%
[  654.046010] PM: Image saving progress:  60%
[  654.240911] PM: Image saving progress:  70%
[  654.536331] PM: Image saving progress:  80%
[  654.673191] sky2 0000:02:00.0 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[  654.955351] PM: Image saving progress:  90%
[  655.321583] PM: Image saving progress: 100%
[  655.461344] PM: Image saving done.
[  655.461360] PM: Wrote 266192 kbytes in 2.85 seconds (93.40 MB/s)
[  655.461976] PM: S|
[  655.573841] Suspending console(s) (use no_console_suspend to debug)
[  655.577230] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  655.612279] sd 0:0:0:0: [sda] Stopping disk
[  656.547424] parport_pc 00:07: disabled
[  656.548754] serial 00:06: disabled
[  656.548859] serial 00:06: System wakeup disabled by ACPI
[  656.549943] serial 00:05: disabled
[  656.550022] serial 00:05: System wakeup disabled by ACPI
[  656.562400] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe B
[  656.600029] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  656.600036] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  656.600040] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[  656.600048] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[  656.600054] [drm:i9xx_update_wm], memory self refresh disabled
[  656.616161] PM: suspend of devices complete after 1040.627 msecs
[  656.619134] PM: late suspend of devices complete after 2.961 msecs
[  656.776616] pcieport 0000:00:1c.1: System wakeup enabled by ACPI
[  656.932493] ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
[  656.948247] uhci_hcd 0000:00:1d.3: System wakeup enabled by ACPI
[  656.948406] uhci_hcd 0000:00:1d.2: System wakeup enabled by ACPI
[  656.948565] uhci_hcd 0000:00:1d.1: System wakeup enabled by ACPI
[  656.948722] uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
[  656.949842] PM: noirq suspend of devices complete after 330.699 msecs
[  656.950847] ACPI: Preparing to enter system sleep state S3
[  656.954874] PM: Saving platform NVS memory
[  656.954874] ACPI: Low-level resume complete
[  656.954874] PM: Restoring platform NVS memory
[  656.954874] Force enabled HPET at resume
[  656.955371] ACPI: Waking up from system sleep state S3
[  656.973326] uhci_hcd 0000:00:1d.0: System wakeup disabled by ACPI
[  656.973481] uhci_hcd 0000:00:1d.1: System wakeup disabled by ACPI
[  656.973632] uhci_hcd 0000:00:1d.2: System wakeup disabled by ACPI
[  656.973784] uhci_hcd 0000:00:1d.3: System wakeup disabled by ACPI
[  656.988265] ehci-pci 0000:00:1d.7: System wakeup disabled by ACPI
[  657.317586] PM: noirq resume of devices complete after 360.722 msecs
[  657.319864] PM: early resume of devices complete after 2.153 msecs
[  657.321346] i915 0000:00:02.0: setting latency timer to 64
[  657.325290] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  657.325335] usb usb2: root hub lost power or was reset
[  657.326382] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  657.326424] usb usb3: root hub lost power or was reset
[  657.328195] pci 0000:00:1e.0: setting latency timer to 64
[  657.328329] pcieport 0000:00:1c.1: System wakeup disabled by ACPI
[  657.332686] [drm:i915_redisable_vga], Something enabled VGA plane, disabling it
[  657.333076] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[  657.333080] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[  657.333093] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[  657.333104] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
[  657.333186] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
[  657.333232] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
[  657.333239] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: disabled
[  657.333248] [drm:intel_modeset_readout_hw_state], [ENCODER:6:DAC-6] hw state readout: disabled, pipe=0
[  657.333270] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.337124] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  657.337153] usb usb5: root hub lost power or was reset
[  657.337663] ehci-pci 0000:00:1d.7: setting latency timer to 64
[  657.338178] PIIX_IDE 0000:00:1f.1: setting latency timer to 64
[  657.338687] ata_piix 0000:00:1f.2: setting latency timer to 64
[  657.340662] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  657.340692] usb usb4: root hub lost power or was reset
[  657.346483] serial 00:05: activated
[  657.351350] serial 00:06: activated
[  657.355913] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  657.355921] [drm:intel_modeset_readout_hw_state], [ENCODER:7:TMDS-7] hw state readout: disabled, pipe=0
[  657.355941] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.358745] parport_pc 00:07: activated
[  657.367501] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.367508] [drm:intel_modeset_readout_hw_state], [ENCODER:9:DAC-9] hw state readout: disabled, pipe=0
[  657.367516] [drm:intel_modeset_readout_hw_state], [ENCODER:63:TV-63] hw state readout: disabled, pipe=0
[  657.367524] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:VGA-1] hw state readout: disabled
[  657.367543] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.374205] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  657.374211] [drm:intel_modeset_readout_hw_state], [CONNECTOR:8:DVI-D-1] hw state readout: disabled
[  657.374229] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.380868] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.380874] [drm:intel_modeset_readout_hw_state], [CONNECTOR:10:SVIDEO-1] hw state readout: disabled
[  657.380892] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.387501] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.387507] [drm:intel_modeset_readout_hw_state], [CONNECTOR:27:SVIDEO-2] hw state readout: disabled
[  657.387524] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.394164] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.394171] [drm:intel_modeset_readout_hw_state], [CONNECTOR:44:SVIDEO-3] hw state readout: disabled
[  657.394189] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.400838] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.400844] [drm:intel_modeset_readout_hw_state], [CONNECTOR:61:VGA-2] hw state readout: disabled
[  657.400852] [drm:intel_modeset_readout_hw_state], [CONNECTOR:62:SVIDEO-4] hw state readout: disabled
[  657.400863] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[  657.400867] [drm:intel_dump_pipe_config], cpu_transcoder: A
[  657.400872] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[  657.400878] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  657.400882] [drm:intel_dump_pipe_config], requested mode:
[  657.400890] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  657.400894] [drm:intel_dump_pipe_config], adjusted mode:
[  657.400901] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  657.400907] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  657.400911] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  657.400915] [drm:intel_dump_pipe_config], ips: 0
[  657.400924] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[  657.400928] [drm:intel_dump_pipe_config], cpu_transcoder: B
[  657.400932] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[  657.400939] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  657.400943] [drm:intel_dump_pipe_config], requested mode:
[  657.400950] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  657.400954] [drm:intel_dump_pipe_config], adjusted mode:
[  657.400961] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  657.400966] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  657.400971] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  657.400975] [drm:intel_dump_pipe_config], ips: 0
[  657.400982] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[  657.400991] [drm:connected_sink_compute_bpp], [CONNECTOR:5:VGA-1] checking for sink bpp constrains
[  657.400997] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[  657.401002] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[  657.401006] [drm:intel_dump_pipe_config], cpu_transcoder: A
[  657.401011] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[  657.401017] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  657.401021] [drm:intel_dump_pipe_config], requested mode:
[  657.401029] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[  657.401033] [drm:intel_dump_pipe_config], adjusted mode:
[  657.401041] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[  657.401046] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  657.401051] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  657.401055] [drm:intel_dump_pipe_config], ips: 0
[  657.401341] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[  657.401354] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  657.401361] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  657.401366] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[  657.401373] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[  657.401379] [drm:i9xx_update_wm], memory self refresh disabled
[  657.401386] [drm:intel_crtc_mode_set], [ENCODER:6:DAC-6] set [MODE:0:1280x1024]
[  657.401394] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  657.401400] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  657.401405] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[  657.401409] [drm:intel_calculate_wm], FIFO watermark level: -14
[  657.401414] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  657.401420] [drm:i9xx_update_wm], self-refresh entries: 80
[  657.401426] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  657.401434] [drm:i9xx_update_wm], memory self refresh enabled
[  657.416088] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 0
[  657.416107] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[  657.416146] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.425212] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  657.425248] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.432842] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.432861] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.439467] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.439485] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.446459] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.446477] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.453125] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.453132] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[  657.453138] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[  657.453158] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.459760] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  657.459765] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[  657.459784] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  657.466410] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  657.466416] [drm:check_encoder_state], [ENCODER:63:TV-63]
[  657.466422] [drm:check_crtc_state], [CRTC:3]
[  657.466448] [drm:check_crtc_state], [CRTC:4]
[  657.466464] [drm:intel_resume_hotplug], running encoder hotplug functions
[  657.466481] [drm:intel_sdvo_debug_write], SDVOB: W: 0D 01 00                   (SDVO_CMD_SET_ACTIVE_HOT_PLUG)
[  657.473303] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[  657.473312] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[  657.473319] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[  657.481881] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[  657.506791] hda: UDMA/100 mode selected
[  659.754926] sky2 0000:02:00.0 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[  662.380055] ata1: link is slow to respond, please be patient (ready=0)
[  665.596294] ata1.00: configured for UDMA/133
[  665.631245] sd 0:0:0:0: [sda] Starting disk
[  665.658198] PM: resume of devices complete after 8338.327 msecs
[  665.953339] Restarting tasks ... done.
[  665.967275] PM: Basic memory bitmaps freed
[  667.488092] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[  667.492084] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[  667.492099] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[  667.492109] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[  667.492118] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[  667.545146] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[  667.545163] [drm:intel_crt_detect_ddc], CRT detected via DDC:0x50 [EDID]
[  667.545174] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from unknown to connected
[  667.545186] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[  667.545197] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  667.547724] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  667.601942] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  667.601959] [drm:output_poll_execute], [CONNECTOR:61:VGA-2] status updated from unknown to disconnected
[  667.601978] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[  667.608119] [drm:drm_fb_helper_hotplug_event], 
[  667.608141] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[  667.608160] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[  667.612132] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[  667.612157] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[  667.612173] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[  667.612187] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[  667.725578] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[  667.725602] [drm:intel_crt_detect_ddc], CRT detected via DDC:0x50 [EDID]
[  667.728093] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[  667.728106] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[  667.728114] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[  667.728121] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[  667.810607] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[  667.810703] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[  667.810759] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] probed modes :
[  667.810767] [drm:drm_mode_debug_printmodeline], Modeline 86:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[  667.810778] [drm:drm_mode_debug_printmodeline], Modeline 78:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[  667.810789] [drm:drm_mode_debug_printmodeline], Modeline 93:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[  667.810799] [drm:drm_mode_debug_printmodeline], Modeline 87:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[  667.810809] [drm:drm_mode_debug_printmodeline], Modeline 88:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[  667.810820] [drm:drm_mode_debug_printmodeline], Modeline 89:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[  667.810830] [drm:drm_mode_debug_printmodeline], Modeline 90:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[  667.810840] [drm:drm_mode_debug_printmodeline], Modeline 91:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[  667.810850] [drm:drm_mode_debug_printmodeline], Modeline 92:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[  667.810861] [drm:drm_mode_debug_printmodeline], Modeline 79:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[  667.810871] [drm:drm_mode_debug_printmodeline], Modeline 80:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[  667.810881] [drm:drm_mode_debug_printmodeline], Modeline 81:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[  667.810891] [drm:drm_mode_debug_printmodeline], Modeline 82:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[  667.810901] [drm:drm_mode_debug_printmodeline], Modeline 83:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[  667.810911] [drm:drm_mode_debug_printmodeline], Modeline 84:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[  667.810922] [drm:drm_mode_debug_printmodeline], Modeline 85:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[  667.810934] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[  667.810942] [drm:intel_sdvo_detect], [CONNECTOR:8:DVI-D-1]
[  667.810951] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  667.817341] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  667.825471] [drm:intel_sdvo_detect], SDVO response 0 0 [1]
[  667.825481] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] disconnected
[  667.825491] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1]
[  667.825499] [drm:intel_sdvo_detect], [CONNECTOR:10:SVIDEO-1]
[  667.825507] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  667.827853] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  667.885590] [drm:intel_sdvo_detect], SDVO response 0 0 [8]
[  667.885608] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1] disconnected
[  667.885627] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2]
[  667.885642] [drm:intel_sdvo_detect], [CONNECTOR:27:SVIDEO-2]
[  667.885659] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  667.891502] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  667.945583] [drm:intel_sdvo_detect], SDVO response 0 0 [4]
[  667.945600] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2] disconnected
[  667.945617] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:SVIDEO-3]
[  667.945632] [drm:intel_sdvo_detect], [CONNECTOR:44:SVIDEO-3]
[  667.945649] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  667.951763] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.005594] [drm:intel_sdvo_detect], SDVO response 0 0 [10]
[  668.005611] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:SVIDEO-3] disconnected
[  668.005628] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:61:VGA-2]
[  668.005643] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[  668.005659] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  668.011452] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.065583] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  668.065600] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:61:VGA-2] disconnected
[  668.065617] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:62:SVIDEO-4]
[  668.065633] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=1
[  668.065650] [drm:intel_get_load_detect_pipe], [CONNECTOR:62:SVIDEO-4], [ENCODER:63:TV-63]
[  668.065702] [drm:intel_get_load_detect_pipe], reusing fbdev for load-detection framebuffer
[  668.065720] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[  668.065742] [drm:connected_sink_compute_bpp], [CONNECTOR:62:SVIDEO-4] checking for sink bpp constrains
[  668.065758] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[  668.065772] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[  668.065788] [drm:intel_dump_pipe_config], [CRTC:4][modeset] config for pipe B
[  668.065802] [drm:intel_dump_pipe_config], cpu_transcoder: B
[  668.065815] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[  668.065828] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  668.065845] [drm:intel_dump_pipe_config], requested mode:
[  668.065858] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[  668.065879] [drm:intel_dump_pipe_config], adjusted mode:
[  668.065891] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[  668.065912] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  668.065927] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  668.065941] [drm:intel_dump_pipe_config], ips: 0
[  668.066614] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[  668.066643] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  668.066661] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  668.066675] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[  668.066689] [drm:intel_calculate_wm], FIFO watermark level: -14
[  668.066702] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  668.066719] [drm:i9xx_update_wm], self-refresh entries: 80
[  668.066734] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  668.066756] [drm:i9xx_update_wm], memory self refresh enabled
[  668.066772] [drm:intel_crtc_mode_set], [ENCODER:63:TV-63] set [MODE:0:NTSC 480i]
[  668.076400] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  668.076419] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  668.076433] [drm:intel_calculate_wm], FIFO watermark level: -8
[  668.076449] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  668.076463] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[  668.076477] [drm:intel_calculate_wm], FIFO watermark level: -14
[  668.076489] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 1
[  668.076507] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 1, C: 2, SR 1
[  668.076525] [drm:i9xx_update_wm], memory self refresh disabled
[  668.100061] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[  668.100086] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.103455] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.109704] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.113303] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.122620] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.128841] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.134582] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.138361] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.144262] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.147556] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.153614] [drm:intel_connector_check_state], [CONNECTOR:62:SVIDEO-4]
[  668.153633] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[  668.153650] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[  668.153670] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.164371] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.170108] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[  668.170129] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.174808] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.180567] [drm:check_encoder_state], [ENCODER:63:TV-63]
[  668.180585] [drm:check_crtc_state], [CRTC:3]
[  668.180637] [drm:check_crtc_state], [CRTC:4]
[  668.180684] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[  668.180696] ------------[ cut here ]------------
[  668.180720] WARNING: CPU: 0 PID: 1256 at drivers/gpu/drm/i915/intel_display.c:8746 check_crtc_state+0x6c5/0x6f9()
[  668.180730] pipe state doesn't match!
[  668.180738] Modules linked in: binfmt_misc ipv6 snd_rme96 snd_pcm snd_timer snd soundcore snd_page_alloc
[  668.180794] CPU: 0 PID: 1256 Comm: kworker/0:4 Tainted: G        W    3.11.0-main+ #69
[  668.180805] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 11/04/2005
[  668.180822] Workqueue: events output_poll_execute
[  668.180835]  00000006 c07045ea eabaf9c4 c053ce62 eabaf9dc c012a920 c03c86e3 00000000
[  668.180877]  f6361000 f635ac48 eabaf9f4 c012a9aa 00000009 eabaf9ec c07045ea eabafa08
[  668.180917]  eabafc5c c03c86e3 c07034b0 0000222a c07045ea f4bd06f8 f634f344 f4bd06fc
[  668.180958] Call Trace:
[  668.180984]  [<c053ce62>] dump_stack+0x16/0x18
[  668.181006]  [<c012a920>] warn_slowpath_common+0x5f/0x76
[  668.181024]  [<c03c86e3>] ? check_crtc_state+0x6c5/0x6f9
[  668.181044]  [<c012a9aa>] warn_slowpath_fmt+0x2b/0x2f
[  668.181063]  [<c03c86e3>] check_crtc_state+0x6c5/0x6f9
[  668.181118]  [<c03d1b57>] intel_modeset_check_state+0x30c/0x58b
[  668.181140]  [<c03d1dfc>] intel_set_mode+0x26/0x2f
[  668.181160]  [<c03d2d2b>] intel_get_load_detect_pipe+0x2b4/0x308
[  668.181183]  [<c015b8d9>] ? vprintk+0x1b/0x1d
[  668.181204]  [<c0398a5a>] ? drm_ut_debug_printk+0x37/0x3b
[  668.181224]  [<c03eca95>] ? intel_tv_detect+0x62/0x444
[  668.181243]  [<c03ecb3b>] intel_tv_detect+0x108/0x444
[  668.181276]  [<c0390d0e>] drm_helper_probe_single_connector_modes+0xa0/0x270
[  668.181302]  [<c038e812>] drm_fb_helper_probe_connector_modes+0x39/0x4c
[  668.181322]  [<c038ffc4>] drm_fb_helper_hotplug_event+0x64/0x9a
[  668.181342]  [<c03ec572>] intel_fb_output_poll_changed+0x19/0x1b
[  668.181360]  [<c0390500>] drm_kms_helper_hotplug_event+0x21/0x24
[  668.181378]  [<c0390618>] output_poll_execute+0x115/0x139
[  668.181401]  [<c013e02d>] process_one_work+0x22a/0x3f1
[  668.181419]  [<c013e706>] ? worker_thread+0x2c/0x28a
[  668.181441]  [<c013e87d>] worker_thread+0x1a3/0x28a
[  668.181462]  [<c013e6da>] ? manage_workers.isra.22+0x19a/0x19a
[  668.181481]  [<c0142bb5>] kthread+0x8e/0x93
[  668.181509]  [<c0547ef7>] ret_from_kernel_thread+0x1b/0x28
[  668.181527]  [<c0142b27>] ? __init_kthread_worker+0x47/0x47
[  668.181542] ---[ end trace 9bb07272eef06f0a ]---
[  668.181553] [drm:intel_dump_pipe_config], [CRTC:4][hw state] config for pipe B
[  668.181568] [drm:intel_dump_pipe_config], cpu_transcoder: B
[  668.181581] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[  668.181595] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  668.181612] [drm:intel_dump_pipe_config], requested mode:
[  668.181625] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[  668.181645] [drm:intel_dump_pipe_config], adjusted mode:
[  668.181657] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[  668.181676] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  668.181692] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  668.181706] [drm:intel_dump_pipe_config], ips: 0
[  668.181719] [drm:intel_dump_pipe_config], [CRTC:4][sw state] config for pipe B
[  668.181733] [drm:intel_dump_pipe_config], cpu_transcoder: B
[  668.181745] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[  668.181759] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  668.181776] [drm:intel_dump_pipe_config], requested mode:
[  668.181789] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[  668.181809] [drm:intel_dump_pipe_config], adjusted mode:
[  668.181822] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[  668.181842] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  668.181858] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  668.181872] [drm:intel_dump_pipe_config], ips: 0
[  668.212031] [drm:intel_tv_detect_type], TV detected: 400c0c07, 7f0000aa
[  668.212041] [drm:intel_tv_detect_type], Unrecognised TV connection
[  668.244060] [drm:intel_release_load_detect_pipe], [CONNECTOR:62:SVIDEO-4], [ENCODER:63:TV-63]
[  668.244083] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[  668.282957] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  668.282979] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  668.282994] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[  668.283008] [drm:intel_calculate_wm], FIFO watermark level: -14
[  668.283021] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  668.283039] [drm:i9xx_update_wm], self-refresh entries: 80
[  668.283054] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  668.283077] [drm:i9xx_update_wm], memory self refresh enabled
[  668.283106] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[  668.283126] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.290454] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.296891] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.301135] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.306868] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.311105] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.316851] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.321147] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.326883] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.331169] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.336922] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[  668.336940] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[  668.336960] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.342263] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.348607] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[  668.348630] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.351922] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.358611] [drm:check_encoder_state], [ENCODER:63:TV-63]
[  668.358629] [drm:check_crtc_state], [CRTC:3]
[  668.358678] [drm:check_crtc_state], [CRTC:4]
[  668.358697] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[  668.358715] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:62:SVIDEO-4] disconnected
[  668.359154] [drm:intel_sdvo_detect], [CONNECTOR:8:DVI-D-1]
[  668.359171] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  668.362461] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.368849] [drm:intel_sdvo_detect], SDVO response 0 0 [1]
[  668.368996] [drm:drm_setup_crtcs], 
[  668.369006] [drm:drm_enable_connectors], connector 5 enabled? yes
[  668.369013] [drm:drm_enable_connectors], connector 8 enabled? no
[  668.369020] [drm:drm_enable_connectors], connector 10 enabled? no
[  668.369027] [drm:drm_enable_connectors], connector 27 enabled? no
[  668.369035] [drm:drm_enable_connectors], connector 44 enabled? no
[  668.369041] [drm:drm_enable_connectors], connector 61 enabled? no
[  668.369048] [drm:drm_enable_connectors], connector 62 enabled? no
[  668.369056] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[  668.369063] [drm:drm_target_preferred], looking for preferred mode on connector 5
[  668.369073] [drm:drm_target_preferred], found mode 1280x1024
[  668.369079] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[  668.369090] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[  668.369124] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[  668.369136] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[  668.369145] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[  668.369156] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[  668.369165] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[  668.369174] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[  668.369356] [drm:intel_sdvo_detect], [CONNECTOR:10:SVIDEO-1]
[  668.369365] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  668.371716] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.425729] [drm:intel_sdvo_detect], SDVO response 0 0 [8]
[  668.425981] [drm:intel_sdvo_detect], [CONNECTOR:27:SVIDEO-2]
[  668.426001] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  668.431081] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.481592] [drm:intel_sdvo_detect], SDVO response 0 0 [4]
[  668.481837] [drm:intel_sdvo_detect], [CONNECTOR:44:SVIDEO-3]
[  668.481856] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  668.487267] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.537583] [drm:intel_sdvo_detect], SDVO response 0 0 [10]
[  668.537834] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=1
[  668.537854] [drm:intel_get_load_detect_pipe], [CONNECTOR:62:SVIDEO-4], [ENCODER:63:TV-63]
[  668.537914] [drm:intel_get_load_detect_pipe], reusing fbdev for load-detection framebuffer
[  668.537932] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[  668.537953] [drm:connected_sink_compute_bpp], [CONNECTOR:62:SVIDEO-4] checking for sink bpp constrains
[  668.537970] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[  668.537983] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[  668.537999] [drm:intel_dump_pipe_config], [CRTC:4][modeset] config for pipe B
[  668.538014] [drm:intel_dump_pipe_config], cpu_transcoder: B
[  668.538026] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[  668.538040] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  668.538057] [drm:intel_dump_pipe_config], requested mode:
[  668.538070] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[  668.538091] [drm:intel_dump_pipe_config], adjusted mode:
[  668.538103] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[  668.538124] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  668.538140] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  668.538154] [drm:intel_dump_pipe_config], ips: 0
[  668.538826] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[  668.538853] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  668.538871] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  668.538885] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[  668.538899] [drm:intel_calculate_wm], FIFO watermark level: -14
[  668.538912] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  668.538930] [drm:i9xx_update_wm], self-refresh entries: 80
[  668.538944] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  668.538966] [drm:i9xx_update_wm], memory self refresh enabled
[  668.538982] [drm:intel_crtc_mode_set], [ENCODER:63:TV-63] set [MODE:0:NTSC 480i]
[  668.548225] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  668.548236] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  668.548243] [drm:intel_calculate_wm], FIFO watermark level: -8
[  668.548251] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  668.548258] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[  668.548265] [drm:intel_calculate_wm], FIFO watermark level: -14
[  668.548271] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 1
[  668.548280] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 1, C: 2, SR 1
[  668.548289] [drm:i9xx_update_wm], memory self refresh disabled
[  668.572095] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[  668.572120] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.575478] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.582282] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.585699] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.589966] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.593024] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.597243] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.599642] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.604341] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.606740] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.611458] [drm:intel_connector_check_state], [CONNECTOR:62:SVIDEO-4]
[  668.611468] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[  668.611477] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[  668.611486] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.615024] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.619221] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[  668.619231] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.622370] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.626559] [drm:check_encoder_state], [ENCODER:63:TV-63]
[  668.626568] [drm:check_crtc_state], [CRTC:3]
[  668.626597] [drm:check_crtc_state], [CRTC:4]
[  668.626623] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[  668.626630] ------------[ cut here ]------------
[  668.626642] WARNING: CPU: 0 PID: 1259 at drivers/gpu/drm/i915/intel_display.c:8746 check_crtc_state+0x6c5/0x6f9()
[  668.626648] pipe state doesn't match!
[  668.626652] Modules linked in: binfmt_misc ipv6 snd_rme96 snd_pcm snd_timer snd soundcore snd_page_alloc
[  668.626681] CPU: 0 PID: 1259 Comm: upowerd Tainted: G        W    3.11.0-main+ #69
[  668.626687] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 11/04/2005
[  668.626692]  00000000 c07045ea eabc9aac c053ce62 eabc9ac4 c012a920 c03c86e3 00000000
[  668.626713]  f6361000 f635ac48 eabc9adc c012a9aa 00000009 eabc9ad4 c07045ea eabc9af0
[  668.626733]  eabc9d44 c03c86e3 c07034b0 0000222a c07045ea f4bd2738 f634f344 f4bd273c
[  668.626754] Call Trace:
[  668.626768]  [<c053ce62>] dump_stack+0x16/0x18
[  668.626780]  [<c012a920>] warn_slowpath_common+0x5f/0x76
[  668.626789]  [<c03c86e3>] ? check_crtc_state+0x6c5/0x6f9
[  668.626799]  [<c012a9aa>] warn_slowpath_fmt+0x2b/0x2f
[  668.626808]  [<c03c86e3>] check_crtc_state+0x6c5/0x6f9
[  668.626836]  [<c03d1b57>] intel_modeset_check_state+0x30c/0x58b
[  668.626847]  [<c03d1dfc>] intel_set_mode+0x26/0x2f
[  668.626857]  [<c03d2d2b>] intel_get_load_detect_pipe+0x2b4/0x308
[  668.626869]  [<c015b8d9>] ? vprintk+0x1b/0x1d
[  668.626881]  [<c0398a5a>] ? drm_ut_debug_printk+0x37/0x3b
[  668.626891]  [<c03eca95>] ? intel_tv_detect+0x62/0x444
[  668.626900]  [<c03ecb3b>] intel_tv_detect+0x108/0x444
[  668.626909]  [<c0127b7a>] ? __kunmap_atomic+0x66/0x7d
[  668.626925]  [<c039b415>] status_show+0x33/0x65
[  668.626934]  [<c039b3e2>] ? dpms_show+0x4d/0x4d
[  668.626945]  [<c0402036>] dev_attr_show+0x18/0x3b
[  668.626957]  [<c0227a38>] sysfs_read_file+0x89/0xf4
[  668.626967]  [<c02279af>] ? sysfs_write_file+0xea/0xea
[  668.626979]  [<c01d9d59>] vfs_read+0x83/0x131
[  668.626989]  [<c01d9f53>] SyS_read+0x4a/0x79
[  668.627001]  [<c0542d95>] syscall_call+0x7/0xb
[  668.627009] ---[ end trace 9bb07272eef06f0b ]---
[  668.627015] [drm:intel_dump_pipe_config], [CRTC:4][hw state] config for pipe B
[  668.627022] [drm:intel_dump_pipe_config], cpu_transcoder: B
[  668.627029] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[  668.627036] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  668.627044] [drm:intel_dump_pipe_config], requested mode:
[  668.627051] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[  668.627060] [drm:intel_dump_pipe_config], adjusted mode:
[  668.627067] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[  668.627076] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  668.627084] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  668.627091] [drm:intel_dump_pipe_config], ips: 0
[  668.627097] [drm:intel_dump_pipe_config], [CRTC:4][sw state] config for pipe B
[  668.627104] [drm:intel_dump_pipe_config], cpu_transcoder: B
[  668.627111] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[  668.627118] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[  668.627126] [drm:intel_dump_pipe_config], requested mode:
[  668.627132] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[  668.627143] [drm:intel_dump_pipe_config], adjusted mode:
[  668.627149] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[  668.627159] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[  668.627167] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[  668.627174] [drm:intel_dump_pipe_config], ips: 0
[  668.660110] [drm:intel_tv_detect_type], TV detected: 400c0c07, 7f0000aa
[  668.660130] [drm:intel_tv_detect_type], Unrecognised TV connection
[  668.676064] [drm:intel_release_load_detect_pipe], [CONNECTOR:62:SVIDEO-4], [ENCODER:63:TV-63]
[  668.676086] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[  668.715540] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  668.715551] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  668.715559] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[  668.715566] [drm:intel_calculate_wm], FIFO watermark level: -14
[  668.715572] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  668.715582] [drm:i9xx_update_wm], self-refresh entries: 80
[  668.715589] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  668.715601] [drm:i9xx_update_wm], memory self refresh enabled
[  668.715616] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[  668.715627] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.722172] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.727467] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.730506] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.734715] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.737636] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.741865] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.744855] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.749090] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.751488] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.756213] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[  668.756223] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[  668.756233] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.758632] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[  668.763736] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[  668.763747] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[  668.766989] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.771187] [drm:check_encoder_state], [ENCODER:63:TV-63]
[  668.771196] [drm:check_crtc_state], [CRTC:3]
[  668.771223] [drm:check_crtc_state], [CRTC:4]
[  668.771233] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[  668.771382] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[  668.773332] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[  668.773344] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[  668.773352] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[  668.773359] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[  668.816616] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[  668.816626] [drm:intel_crt_detect_ddc], CRT detected via DDC:0x50 [EDID]
[  668.816752] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[  668.816762] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  668.819113] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  668.873593] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  678.400081] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[  678.400105] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  678.403299] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  678.457583] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  678.457602] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0

--------------060603040709010003060901--
