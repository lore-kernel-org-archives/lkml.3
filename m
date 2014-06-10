Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbaFJUNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:13:37 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35487 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaFJUNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1405200141030.20503@skynet.skynet.ie>
References: <CAAfyv347hmSY7y=KEBg=ROOSNGcVpRn9FZS-wzDn=cYvyAtQQg@mail.gmail.com>
	<alpine.DEB.2.00.1405200141030.20503@skynet.skynet.ie>
Date: Tue, 10 Jun 2014 22:13:33 +0200
Message-ID: <CAAfyv34egJMrE8HDugdyYfywmkV-XzDeD0pnwCjqRAAGFyfruQ@mail.gmail.com>
Subject: Re: 3.15-rc5 freeze after wakeup
From: Belisko Marek <marek.belisko@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

any update on this issue? It's still present in 3.15 release.
Thanks.

On Tue, May 20, 2014 at 2:41 AM, Dave Airlie <airlied@linux.ie> wrote:
>
>> Hi,
>
> cc'iong intel-gfx.
>
>>
>> I've upgraded kernel on my PC to 3.15-rc5 and I got today freeze
>> (recovery possibly only by power off/on) when waking from suspend.
>> There is only warning in log but system was completely dead (no keys
>> reaction ....).
>>
>> May 14 15:53:15 nb kernel: [30404.485085] PM: Syncing filesystems ... done.
>> May 14 15:53:15 nb kernel: [30404.711342] PM: Preparing system for mem sleep
>> May 14 15:53:15 nb kernel: [30404.711610] Freezing user space
>> processes ... (elapsed 0.001 seconds) done.
>> May 14 15:53:15 nb kernel: [30404.713305] Freezing remaining freezable
>> tasks ... (elapsed 0.001 seconds) done.
>> May 14 15:53:15 nb kernel: [30404.714431] PM: Entering mem sleep
>> May 14 15:53:15 nb kernel: [30404.714881] Suspending console(s) (use
>> no_console_suspend to debug)
>> May 14 15:53:15 nb kernel: [30405.338766] sd 4:0:0:0: [sda]
>> Synchronizing SCSI cache
>> May 14 15:53:15 nb kernel: [30405.338893] sd 4:0:0:0: [sda] Stopping disk
>> May 14 15:53:15 nb kernel: [30405.361653] nouveau  [     DRM] evicting
>> buffers...
>> May 14 15:53:15 nb kernel: [30405.361654] nouveau  [     DRM] waiting
>> for kernel channels to go idle...
>> May 14 15:53:15 nb kernel: [30405.361679] nouveau  [     DRM]
>> suspending client object trees...
>> May 14 15:53:15 nb kernel: [30405.365746] ------------[ cut here ]------------
>> May 14 15:53:15 nb kernel: [30405.365765] WARNING: CPU: 1 PID: 21060
>> at drivers/gpu/drm/i915/intel_uncore.c:125
>> gen6_gt_check_fifodbg.isra.9+0x38/0x50 [i915]()
>> May 14 15:53:15 nb kernel: [30405.365765] MMIO read or write has been
>> dropped ffffffff
>> May 14 15:53:15 nb kernel: [30405.365782] Modules linked in:
>> cdc_acm(F) mmc_block(F) pl2303(F) usbserial(F) usblp(F) usb_storage(F)
>> ctr(F) ccm(F) rfcomm(F) bnep(F) snd_hda_codec_hdmi(F)
>> x86_pkg_temp_thermal(F) intel_powerclamp(F) coretemp(F) kvm(F)
>> uvcvideo(F) arc4(F) videobuf2_vmalloc(F) videobuf2_memops(F)
>> videobuf2_core(F) crct10dif_pclmul(F) crc32_pclmul(F)
>> ghash_clmulni_intel(F) nfsd(F) aesni_intel(F) iwlmvm(F) videodev(F)
>> i915(F) aes_x86_64(F) lrw(F) gf128mul(F) glue_helper(F) mac80211(F)
>> auth_rpcgss(F) nfs_acl(F) ablk_helper(F) cryptd(F) nouveau(F)
>> snd_hda_codec_realtek(F) snd_hda_intel(F) joydev(F) snd_hda_codec(F)
>> ttm(F) drm_kms_helper(F) snd_hwdep(F) snd_pcm(F) snd_page_alloc(F)
>> snd_seq_midi(F) asus_nb_wmi(F) iwlwifi(F) drm(F) snd_seq_midi_event(F)
>> nfs(F) snd_rawmidi(F) snd_seq(F) asus_wmi(F) sparse_keymap(F)
>> mxm_wmi(F) snd_seq_device(F) btusb(F) i2c_algo_bit(F) mei_me(F)
>> snd_timer(F) bluetooth(F) snd(F) cfg80211(F) lockd(F) sunrpc(F) mei(F)
>> soundcore(F) microcode(F) rtsx_pci_ms(F) memstick(F) binfmt_misc(F)
>> lpc_ich(F) fscache(F) psmouse(F) video(F) wmi(F) mac_hid(F)
>> serio_raw(F) nls_iso8859_1(F) parport_pc(F) ppdev(F) lp(F) parport(F)
>> rtsx_pci_sdmmc(F) ahci(F) r8169(F) libahci(F) rtsx_pci(F) mii(F)
>> May 14 15:53:15 nb kernel: [30405.365795] CPU: 1 PID: 21060 Comm:
>> kworker/u16:16 Tainted: GF       W    3.13.2 #5
>> May 14 15:53:15 nb kernel: [30405.365796] Hardware name: ASUSTeK
>> COMPUTER INC. N56JR/N56JR, BIOS N56JR.204 10/31/2013
>> May 14 15:53:15 nb kernel: [30405.365804] Workqueue: i915
>> gen6_force_wake_work [i915]
>> May 14 15:53:15 nb kernel: [30405.365806]  0000000000000009
>> ffff88032964bd38 ffffffff81715b4e ffff88032964bd80
>> May 14 15:53:15 nb kernel: [30405.365807]  ffff88032964bd70
>> ffffffff8106420d ffff8800363c8020 ffff8800363c8028
>> May 14 15:53:15 nb kernel: [30405.365809]  0000000000000246
>> 0000000000000000 0000000000000200 ffff88032964bdd0
>> May 14 15:53:15 nb kernel: [30405.365809] Call Trace:
>> May 14 15:53:15 nb kernel: [30405.365813]  [<ffffffff81715b4e>]
>> dump_stack+0x45/0x56
>> May 14 15:53:15 nb kernel: [30405.365815]  [<ffffffff8106420d>]
>> warn_slowpath_common+0x7d/0xa0
>> May 14 15:53:15 nb kernel: [30405.365817]  [<ffffffff8106427c>]
>> warn_slowpath_fmt+0x4c/0x50
>> May 14 15:53:15 nb kernel: [30405.365820]  [<ffffffff810125b6>] ?
>> __switch_to+0x126/0x4c0
>> May 14 15:53:15 nb kernel: [30405.365827]  [<ffffffffa06d93d8>]
>> gen6_gt_check_fifodbg.isra.9+0x38/0x50 [i915]
>> May 14 15:53:15 nb kernel: [30405.365834]  [<ffffffffa06d947b>]
>> __gen6_gt_force_wake_mt_put+0x2b/0x30 [i915]
>> May 14 15:53:15 nb kernel: [30405.365840]  [<ffffffffa06d91a7>]
>> gen6_force_wake_work+0x37/0x50 [i915]
>> May 14 15:53:15 nb kernel: [30405.365842]  [<ffffffff8107fef2>]
>> process_one_work+0x182/0x450
>> May 14 15:53:15 nb kernel: [30405.365843]  [<ffffffff81080cb1>]
>> worker_thread+0x121/0x410
>> May 14 15:53:15 nb kernel: [30405.365845]  [<ffffffff81080b90>] ?
>> rescuer_thread+0x3e0/0x3e0
>> May 14 15:53:15 nb kernel: [30405.365846]  [<ffffffff81087962>]
>> kthread+0xd2/0xf0
>> May 14 15:53:15 nb kernel: [30405.365847]  [<ffffffff81087890>] ?
>> kthread_create_on_node+0x190/0x190
>> May 14 15:53:15 nb kernel: [30405.365849]  [<ffffffff817267fc>]
>> ret_from_fork+0x7c/0xb0
>> May 14 15:53:15 nb kernel: [30405.365850]  [<ffffffff81087890>] ?
>> kthread_create_on_node+0x190/0x190
>> May 14 15:53:15 nb kernel: [30405.365851] ---[ end trace 19ed8523f865bf12 ]---
>> May 14 15:53:15 nb kernel: [30405.370091] nouveau  [     DRM]
>> suspending kernel object tree...
>> May 14 15:53:15 nb kernel: [30405.666015]
>> [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register
>> before writing to c7204
>> May 14 15:53:15 nb kernel: [30405.666018]
>> [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to c7204
>> May 14 15:53:15 nb kernel: [30406.422806] PM: suspend of devices
>> complete after 1083.317 msecs
>> May 14 15:53:15 nb kernel: [30406.422960] PM: late suspend of devices
>> complete after 0.153 msecs
>> May 14 15:53:15 nb kernel: [30406.423102] pcieport 0000:00:1c.3:
>> System wakeup enabled by ACPI
>> May 14 15:53:15 nb kernel: [30406.454741] ehci-pci 0000:00:1d.0:
>> System wakeup enabled by ACPI
>> May 14 15:53:15 nb kernel: [30406.458786] ehci-pci 0000:00:1a.0:
>> System wakeup enabled by ACPI
>> May 14 15:53:15 nb kernel: [30406.466683] xhci_hcd 0000:00:14.0:
>> System wakeup enabled by ACPI
>> May 14 15:53:15 nb kernel: [30406.470879] PM: noirq suspend of devices
>> complete after 47.878 msecs
>> May 14 15:53:15 nb kernel: [30406.471095] ACPI: Preparing to enter
>> system sleep state S3
>> May 14 15:53:15 nb kernel: [30406.479514] PM: Saving platform NVS memory
>> May 14 15:53:15 nb kernel: [30406.487171] Disabling non-boot CPUs ...
>> May 14 15:53:15 nb kernel: [30406.590759] smpboot: CPU 1 is now offline
>> May 14 15:53:15 nb kernel: [30406.694832] smpboot: CPU 2 is now offline
>> May 14 15:53:15 nb kernel: [30406.798918] smpboot: CPU 3 is now offline
>> May 14 15:53:15 nb kernel: [30406.903000] smpboot: CPU 4 is now offline
>> May 14 15:53:15 nb kernel: [30406.903325] Broke affinity for irq 45
>> May 14 15:53:15 nb kernel: [30407.007082] smpboot: CPU 5 is now offline
>> May 14 15:53:15 nb kernel: [30407.007366] Broke affinity for irq 23
>> May 14 15:53:15 nb kernel: [30407.111168] smpboot: CPU 6 is now offline
>> May 14 15:53:15 nb kernel: [30407.215250] smpboot: CPU 7 is now offline
>> May 14 15:53:15 nb kernel: [30407.218003] ACPI: Low-level resume complete
>> May 14 15:53:15 nb kernel: [30407.218075] PM: Restoring platform NVS memory
>> May 14 15:53:15 nb kernel: [30407.222985] Enabling non-boot CPUs ...
>> May 14 15:53:15 nb kernel: [30407.223053] x86: Booting SMP configuration:
>> May 14 15:53:15 nb kernel: [30407.223056] smpboot: Booting Node 0
>> Processor 1 APIC 0x2
>> May 14 15:53:15 nb kernel: [30407.238540] Intel pstate controlling: cpu 1
>> May 14 15:53:15 nb kernel: [30407.238632] CPU1 is up
>> May 14 15:53:15 nb kernel: [30407.238683] smpboot: Booting Node 0
>> Processor 2 APIC 0x4
>> May 14 15:53:15 nb kernel: [30407.254230] Intel pstate controlling: cpu 2
>> May 14 15:53:15 nb kernel: [30407.254309] CPU2 is up
>> May 14 15:53:15 nb kernel: [30407.254340] smpboot: Booting Node 0
>> Processor 3 APIC 0x6
>> May 14 15:53:15 nb kernel: [30407.269887] Intel pstate controlling: cpu 3
>> May 14 15:53:15 nb kernel: [30407.269957] CPU3 is up
>> May 14 15:53:15 nb kernel: [30407.269989] smpboot: Booting Node 0
>> Processor 4 APIC 0x1
>> May 14 15:53:15 nb kernel: [30407.285600] Intel pstate controlling: cpu 4
>> May 14 15:53:15 nb kernel: [30407.285682] CPU4 is up
>> May 14 15:53:15 nb kernel: [30407.285716] smpboot: Booting Node 0
>> Processor 5 APIC 0x3
>> May 14 15:53:15 nb kernel: [30407.301231] Intel pstate controlling: cpu 5
>> May 14 15:53:15 nb kernel: [30407.301307] CPU5 is up
>> May 14 15:53:15 nb kernel: [30407.301339] smpboot: Booting Node 0
>> Processor 6 APIC 0x5
>> May 14 15:53:15 nb kernel: [30407.317032] Intel pstate controlling: cpu 6
>> May 14 15:53:15 nb kernel: [30407.317109] CPU6 is up
>> May 14 15:53:15 nb kernel: [30407.317141] smpboot: Booting Node 0
>> Processor 7 APIC 0x7
>> May 14 15:53:15 nb kernel: [30407.332847] Intel pstate controlling: cpu 7
>> May 14 15:53:15 nb kernel: [30407.332927] CPU7 is up
>> May 14 15:53:15 nb kernel: [30407.366387] ACPI: Waking up from system
>> sleep state S3
>> May 14 15:53:15 nb kernel: [30407.398885] xhci_hcd 0000:00:14.0:
>> System wakeup disabled by ACPI
>> May 14 15:53:15 nb kernel: [30407.406891] ehci-pci 0000:00:1a.0:
>> System wakeup disabled by ACPI
>> May 14 15:53:15 nb kernel: [30407.414890] ehci-pci 0000:00:1d.0:
>> System wakeup disabled by ACPI
>> May 14 15:53:15 nb kernel: [30407.494986] PM: noirq resume of devices
>> complete after 118.924 msecs
>> May 14 15:53:15 nb kernel: [30407.495106] PM: early resume of devices
>> complete after 0.100 msecs
>> May 14 15:53:15 nb kernel: [30407.495178] usb usb3: root hub lost
>> power or was reset
>> May 14 15:53:15 nb kernel: [30407.495178] usb usb4: root hub lost
>> power or was reset
>> May 14 15:53:15 nb kernel: [30407.495180] nouveau  [     DRM]
>> re-enabling device...
>> May 14 15:53:15 nb kernel: [30407.495193] nouveau  [     DRM] resuming
>> kernel object tree...
>> May 14 15:53:15 nb kernel: [30407.495198] nouveau  [
>> VBIOS][0000:01:00.0] running init tables
>> May 14 15:53:15 nb kernel: [30407.495221] pcieport 0000:00:1c.3:
>> System wakeup disabled by ACPI
>> May 14 15:53:15 nb kernel: [30407.495229] snd_hda_intel 0000:00:03.0:
>> irq 43 for MSI/MSI-X
>> May 14 15:53:15 nb kernel: [30407.495237] iwlwifi 0000:03:00.0:
>> RF_KILL bit toggled to enable radio.
>> May 14 15:53:15 nb kernel: [30407.495796] xhci_hcd 0000:00:14.0: irq
>> 47 for MSI/MSI-X
>> May 14 15:53:15 nb kernel: [30407.498912] mei_me 0000:00:16.0: irq 49
>> for MSI/MSI-X
>> May 14 15:53:15 nb kernel: [30407.498991] snd_hda_intel 0000:00:1b.0:
>> irq 52 for MSI/MSI-X
>> May 14 15:53:15 nb kernel: [30407.640399] nouveau  [
>> VOLT][0000:01:00.0] GPU voltage: 600000uv
>> May 14 15:53:15 nb kernel: [30407.640401] nouveau  [
>> PTHERM][0000:01:00.0] fan management: automatic
>> May 14 15:53:15 nb kernel: [30407.640479] nouveau  [
>> CLK][0000:01:00.0] --: core 405 MHz memory 405 MHz
>> May 14 15:53:15 nb kernel: [30407.645897] nouveau  [     DRM] resuming
>> client object trees...
>> May 14 15:53:15 nb kernel: [30407.723085] usb 2-1: reset high-speed
>> USB device number 2 using ehci-pci
>> May 14 15:53:15 nb kernel: [30407.819158] ata3: SATA link up 1.5 Gbps
>> (SStatus 113 SControl 300)
>> May 14 15:53:15 nb kernel: [30407.967271] usb 1-1: reset high-speed
>> USB device number 2 using ehci-pci
>> May 14 15:53:15 nb kernel: [30408.211470] usb 3-5: reset full-speed
>> USB device number 5 using xhci_hcd
>> May 14 15:53:15 nb kernel: [30408.228022] xhci_hcd 0000:00:14.0: xHCI
>> xhci_drop_endpoint called with disabled ep ffff880416844840
>> May 14 15:53:15 nb kernel: [30408.228023] xhci_hcd 0000:00:14.0: xHCI
>> xhci_drop_endpoint called with disabled ep ffff880416844880
>> May 14 15:53:15 nb kernel: [30408.228024] xhci_hcd 0000:00:14.0: xHCI
>> xhci_drop_endpoint called with disabled ep ffff8804168448c0
>> May 14 15:53:15 nb kernel: [30408.228026] xhci_hcd 0000:00:14.0: xHCI
>> xhci_drop_endpoint called with disabled ep ffff8800360c9c80
>> May 14 15:53:15 nb kernel: [30408.228027] xhci_hcd 0000:00:14.0: xHCI
>> xhci_drop_endpoint called with disabled ep ffff8800360c9cc0
>> May 14 15:53:15 nb kernel: [30408.236873] ata3.00: configured for UDMA/100
>> May 14 15:53:15 nb kernel: [30408.339607] usb 3-7: reset high-speed
>> USB device number 3 using xhci_hcd
>> May 14 15:53:15 nb kernel: [30408.444647] xhci_hcd 0000:00:14.0: xHCI
>> xhci_drop_endpoint called with disabled ep ffff88041382e040
>> May 14 15:53:15 nb kernel: [30408.791920] [drm] Enabling RC6 states:
>> RC6 on, RC6p off, RC6pp off
>> May 14 15:53:15 nb kernel: [30409.508485] ata5: SATA link up 6.0 Gbps
>> (SStatus 133 SControl 300)
>> May 14 15:53:15 nb kernel: [30409.718603] ata5.00: ACPI cmd
>> ef/10:06:00:00:00:00 (SET FEATURES) succeeded
>> May 14 15:53:15 nb kernel: [30409.718604] ata5.00: ACPI cmd
>> f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
>> May 14 15:53:15 nb kernel: [30409.718606] ata5.00: ACPI cmd
>> b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
>> May 14 15:53:15 nb kernel: [30409.755067] ata5.00: ACPI cmd
>> ef/10:06:00:00:00:00 (SET FEATURES) succeeded
>> May 14 15:53:15 nb kernel: [30409.755068] ata5.00: ACPI cmd
>> f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
>> May 14 15:53:15 nb kernel: [30409.755069] ata5.00: ACPI cmd
>> b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
>> May 14 15:53:15 nb kernel: [30409.759979] ata5.00: configured for UDMA/133
>> May 14 15:53:15 nb kernel: [30409.772791] sd 4:0:0:0: [sda] Starting disk
>> May 14 15:53:15 nb kernel: [30409.786025] PM: resume of devices
>> complete after 2289.069 msecs
>> May 14 15:53:15 nb kernel: [30409.786617] PM: Finishing wakeup.
>> May 14 15:53:15 nb kernel: [30409.786618] Restarting tasks ... done.
>> May 14 15:53:15 nb kernel: [30409.796847] video LNXVIDEO:00: Restoring
>> backlight state
>> May 14 15:53:15 nb kernel: [30409.796850] video LNXVIDEO:01: Restoring
>> backlight state
>> May 14 15:53:15 nb kernel: [30409.803648] Bluetooth: hci0: read Intel
>> version: 370710018002030d00
>> May 14 15:53:15 nb kernel: [30409.803653] Bluetooth: hci0: Intel
>> Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
>> May 14 15:53:15 nb kernel: [30409.954771] Bluetooth: hci0: Intel
>> Bluetooth firmware patch completed and activated
>> May 14 15:53:16 nb kernel: [30410.341420] iwlwifi 0000:03:00.0: L1
>> Disabled; Enabling L0S
>> May 14 15:53:16 nb kernel: [30410.341670] iwlwifi 0000:03:00.0: L1
>> Disabled; Enabling L0S
>> May 14 15:53:16 nb kernel: [30410.353518] IPv6: ADDRCONF(NETDEV_UP):
>> wlan0: link is not ready
>> May 14 15:53:16 nb kernel: [30410.415374] r8169 0000:04:00.0 eth0: link down
>> May 14 15:53:16 nb kernel: [30410.415442] IPv6: ADDRCONF(NETDEV_UP):
>> eth0: link is not ready
>> May 14 15:53:20 nb kernel: [30414.808849] ACPI Warning:
>> \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Buffer],
>> ACPI requires [Package] (20131115/nsarguments-95)
>> May 14 15:53:20 nb kernel: [30414.809147] ACPI Warning:
>> \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Buffer],
>> ACPI requires [Package] (20131115/nsarguments-95)
>> May 14 15:53:23 nb kernel: [30417.496653] wlan0: authenticate with
>> 00:1f:c6:e8:34:e8
>> May 14 15:53:23 nb kernel: [30417.498323] wlan0: send auth to
>> 00:1f:c6:e8:34:e8 (try 1/3)
>> May 14 15:53:23 nb kernel: [30417.500155] wlan0: authenticated
>> May 14 15:53:23 nb kernel: [30417.500276] iwlwifi 0000:03:00.0 wlan0:
>> disabling HT as WMM/QoS is not supported by the AP
>> May 14 15:53:23 nb kernel: [30417.500278] iwlwifi 0000:03:00.0 wlan0:
>> disabling VHT as WMM/QoS is not supported by the AP
>> May 14 15:53:23 nb kernel: [30417.502965] wlan0: associate with
>> 00:1f:c6:e8:34:e8 (try 1/3)
>> May 14 15:53:23 nb kernel: [30417.508008] wlan0: RX AssocResp from
>> 00:1f:c6:e8:34:e8 (capab=0x411 status=0 aid=2)
>> May 14 15:53:23 nb kernel: [30417.509332] wlan0: associated
>> May 14 15:53:23 nb kernel: [30417.509365] IPv6:
>> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> May 14 15:53:23 nb kernel: [30417.532755] wlan0: deauthenticating from
>> 00:1f:c6:e8:34:e8 by local choice (reason=2)
>> May 14 15:53:23 nb kernel: [30417.535435] wlan0: authenticate with
>> 00:1f:c6:e8:34:e8
>> May 14 15:53:23 nb kernel: [30417.537373] wlan0: send auth to
>> 00:1f:c6:e8:34:e8 (try 1/3)
>> May 14 15:53:23 nb kernel: [30417.537616] cfg80211: Calling CRDA to
>> update world regulatory domain
>> May 14 15:53:23 nb kernel: [30417.539571] cfg80211: World regulatory
>> domain updated:
>> May 14 15:53:23 nb kernel: [30417.539573] cfg80211:   (start_freq -
>> end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> May 14 15:53:23 nb kernel: [30417.539574] cfg80211:   (2402000 KHz -
>> 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> May 14 15:53:23 nb kernel: [30417.539575] cfg80211:   (2457000 KHz -
>> 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> May 14 15:53:23 nb kernel: [30417.539576] cfg80211:   (2474000 KHz -
>> 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> May 14 15:53:23 nb kernel: [30417.539577] cfg80211:   (5170000 KHz -
>> 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> May 14 15:53:23 nb kernel: [30417.539577] cfg80211:   (5735000 KHz -
>> 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> May 14 15:53:23 nb kernel: [30417.542460] wlan0: authenticated
>> May 14 15:53:23 nb kernel: [30417.542587] iwlwifi 0000:03:00.0 wlan0:
>> disabling HT as WMM/QoS is not supported by the AP
>> May 14 15:53:23 nb kernel: [30417.542589] iwlwifi 0000:03:00.0 wlan0:
>> disabling VHT as WMM/QoS is not supported by the AP
>> May 14 15:53:23 nb kernel: [30417.542978] wlan0: associate with
>> 00:1f:c6:e8:34:e8 (try 1/3)
>> May 14 15:53:23 nb kernel: [30417.546598] wlan0: RX AssocResp from
>> 00:1f:c6:e8:34:e8 (capab=0x411 status=0 aid=2)
>> May 14 15:53:23 nb kernel: [30417.551141] wlan0: associated
>> May 14 16:27:32 nb kernel: [32470.315421] audit_printk_skb: 57
>> callbacks suppressed
>> May 14 16:27:32 nb kernel: [32470.315424] type=1400
>> audit(1400077652.391:80): apparmor="STATUS"
>> operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf"
>> pid=22382 comm="apparmor_parser"
>> May 14 16:27:32 nb kernel: [32470.315427] type=1400
>> audit(1400077652.391:81): apparmor="STATUS"
>> operation="profile_replace" name="/usr/sbin/cupsd" pid=22382
>> comm="apparmor_parser"
>> May 14 16:27:32 nb kernel: [32470.315658] type=1400
>> audit(1400077652.391:82): apparmor="STATUS"
>> operation="profile_replace" name="/usr/sbin/cupsd" pid=22382
>> comm="apparmor_parser"
>>
>> BR,
>>
>> marek
>>
>>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
