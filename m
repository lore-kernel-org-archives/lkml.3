Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3BCOym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:54:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34046 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab3BCOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:38 -0500
Message-Id: <20130203144644.035172954@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [ 000/128] 3.2.38-stable review
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.38 release.
There are 128 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Feb  5 21:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.37 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Alan Cox (2):
      ahci: Add identifiers for ASM106x devices
         [7b4f6ecacb14f384adc1a5a67ad95eb082c02bd1]
      x86/msr: Add capabilities check
         [c903f0456bc69176912dee6dd25c6a66ee1aed00]

Alan Stern (1):
      USB: UHCI: fix IRQ race during initialization
         [0f815a0a700bc10547449bde6c106051a035a1b9]

Alexander Graf (2):
      KVM: PPC: Emulate dcbf
         [d3286144c92ec876da9e30320afa875699b7e0f1]
      virtio-blk: Don't free ida when disk is in use
         [f4953fe6c4aeada2d5cafd78aa97587a46d2d8f9]

Alexandre SIMON (1):
      printk: fix buffer overflow when  calling log_prefix function from call_console_drivers
         [not upstream; bug was fixed in mainline by refactoring in commit
          7ff9554bb578]

Amitkumar Karwar (1):
      mwifiex: handle association failure case correctly
         [b7097eb75fa11c302dcdec83f1dbfa874e0af0d1]

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()
         [0a9ab9bdb3e891762553f667066190c1d22ad62b]

Andreas Fleig (1):
      USB: Add device quirk for Microsoft VX700 webcam
         [bc009eca8d539162f7271c2daf0ab5e9e3bb90a0]

Andrew Cooper (1):
      xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS guests.
         [9174adbee4a9a49d0139f5d71969852b36720809]

Avinash Patil (2):
      mwifiex: fix typo in PCIe adapter NULL check
         [83f0c6d1f502bd75bb4a9e31e8d64e59c6894ad1]
      mwifiex: wakeup and stop multiple tx queues in net_device
         [bbea3bc432dc5c08d09ca5c80afdd82515470688]

Axel Lin (2):
      regulator: max8997: Use uV in voltage_map_desc
         [bc3b7756b5ff66828acf7bc24f148d28b8d61108]
      regulator: max8998: Ensure enough delay time for max8998_set_voltage_buck_time_sel
         [81d0a6ae7befb24c06f4aa4856af7f8d1f612171]

Bart Westgeest (1):
      staging: usbip: changed function return type to void
         [ac2b41acfa3efe4650102067a99251587a806d70]

Ben Hutchings (1):
      staging: vt6656: Fix inconsistent structure packing
         [1ee4c55fc9620451b2a825d793042a7e0775391b]

Betty Dall (1):
      PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()
         [a82b6af37d20bfe6e99a4d890f1cf1d89059929f]

Bing Zhao (1):
      mwifiex: check wait_event_interruptible return value
         [9c969d8ccb1e17bd20742f4ac9f00c1a64487234]

Bjorn Helgaas (2):
      PCI: shpchp: Handle push button event asynchronously
         [d347e75847c1fb299c97736638f45e6ea39702d4]
      PCI: shpchp: Use per-slot workqueues to avoid deadlock
         [f652e7d2916fe2fcf9e7d709aa5b7476b431e2dd]

Bjørn Mork (4):
      USB: option: add TP-LINK HSUPA Modem MA180
         [99beb2e9687ffd61c92a9875141eabe6f57a71b9]
      USB: option: add Telekom Speedstick LTE II
         [5ec0085440ef8c2cf50002b34d5a504ee12aa2bf]
      USB: option: blacklist network interface on ONDA MT8205 4G LTE
         [2291dff02e5f8c708a46a7c4c888f2c467e26642]
      USB: option: blacklist network interface on ZTE MF880
         [fab38246f318edcd0dcb8fd3852a47cf8938878a]

Chao Bi (1):
      serial:ifx6x60:Delete SPI timer when shut down port
         [014b9b4ce84281ccb3d723c792bed19815f3571a]

Chris Wilson (4):
      drm/i915: Disable AsyncFlip performance optimisations
         [1c8c38c588ea91f8deeae21284840459d1bb58e3]
      drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline waits
         [f05bb0c7b624252a5e768287e340e8e45df96e42]
      drm/i915: Invalidate the relocation presumed_offsets along the slow path
         [262b6d363fcff16359c93bd58c297f961f6e6273]
      drm/i915; Only increment the user-pin-count after successfully pinning the bo
         [93be8788e648817d62fda33e2998eb6ca6ebf3a3]

Clemens Ladisch (1):
      ALSA: usb-audio: fix invalid length check for RME and other UAC 2 devices
         [d56268fb108c7c21e19933588ca4d94652585183]

Colin Ian King (1):
      PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported
         [9e16721498b0c3d3ebfa0b503c63d35c0a4c0642]

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
         [10b8c7dff5d3633b69e77f57d404dab54ead3787]

Dan Carpenter (1):
      EDAC: Test correct variable in ->store function
         [8024c4c0b1057d1cd811fc9c3f88f81de9729fcd]

Daniel Vetter (4):
      Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"
         [48e858340dae43189a4e55647f6eac736766f828]
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
         [4283908ef7f11a72c3b80dd4cf026f1a86429f82]
      drm/i915: dump UTS_RELEASE into the error_state
         [4518f611ba21ba165ea3714055938a8984a44ff9]
      iommu/intel: disable DMAR for g4x integrated gfx
         [9452618e7462181ed9755236803b6719298a13ce]

David Henningsson (2):
      ALSA: usb - fix race in creation of M-Audio Fast track pro driver
         [b98ae2729dea161edc96c9d177459b6c28bcbba5]
      Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat codecs"
         [7ed4165e2d01bdbbb4c1086eb73eadf0f64cbbf0]

Denis N Ladin (1):
      USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"
         [036915a7a402753c05b8d0529f5fd08805ab46d0]

Dmitry Kasatkin (1):
      evm: checking if removexattr is not a NULL
         [a67adb997419fb53540d4a4f79c6471c60bc69b6]

Dzianis Kahanovich (1):
      USB: option: add Nexpring NP10T terminal id
         [ad86e58661b38b279b7519d4e49c7a19dc1654bb]

Eric Anholt (2):
      drm/i915: Correct the bit number for the MI_FLUSH_ENABLE.
         [fc74d8e01165b567922921d110b6d16320a61fa6]
      drm/i915: Remove the MI_FLUSH_ENABLE setting.
         [8d79c3490aecfe6e51f0ba6f9780746fb1434954]

Felix Fietkau (4):
      ath9k: do not link receive buffers during flush
         [a3dc48e82bb146ef11cf75676c8410c1df29b0c4]
      ath9k: fix double-free bug on beacon generate failure
         [1adb2e2b5f85023d17eb4f95386a57029df27c88]
      ath9k_hw: fix calibration issues on chainmask that don't include chain 0
         [4a8f199508d79ff8a7d1e22f47b912baaf225336]
      ath9k_hw: fix chain swap setting when setting rx chainmask to 5
         [24171dd92096fc370b195f3f6bdc0798855dc3f9]

H. Peter Anvin (2):
      x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI
         [e43b3cec711a61edf047adf6204d542f3a659ef8]
      x86/Sandy Bridge: mark arrays in __init functions as __initconst
         [ab3cd8670e0b3fcde7f029e1503ed3c5138e9571]

Hannes Reinecke (1):
      target: use correct sense code for LUN communication failure
         [18a9df42d53fabfa43b78be1104838cc8b9762e1]

Heiko Carstens (1):
      s390/time: fix sched_clock() overflow
         [ed4f20943cd4c7b55105c04daedf8d63ab6d499c]

Ian Abbott (3):
      staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should  select COMEDI_FC
         [34ffb33e09132401872fe79e95c30824ce194d23]
      staging: comedi: comedi_test: fix race when cancelling command
         [c0729eeefdcd76db338f635162bf0739fd2c5f6f]
      staging: comedi: don't hijack hardware device private data
         [c43435d7722134ed1fda58ce1025f41029bd58ad]

Ilija Hadzic (1):
      drm/radeon: fix a rare case of double kfree
         [1da80cfa8727abf404fcee44d04743febea54069]

Jan Kara (1):
      xfs: Fix possible use-after-free with AIO
         [4b05d09c18d9aa62d2e7fb4b057f54e5a38963f5]

Jason Liu (1):
      mm: compaction: fix echo 1 > compact_memory return error issue
         [7964c06d66c76507d8b6b662bffea770c29ef0ce]

Jerome Glisse (1):
      radeon/kms: force rn50 chip to always report connected on analog output
         [51861d4eebc2ddc25c77084343d060fa79f6e291]

Jesse Barnes (1):
      x86/Sandy Bridge: reserve pages when integrated graphics is present
         [a9acc5365dbda29f7be2884efb63771dc24bd815]

Joel D. Diaz (1):
      [SCSI] sd: Reshuffle init_sd to avoid crash
         [afd5e34b2bb34881d3a789e62486814a49b47faa]

Johannes Berg (1):
      mac80211: use del_timer_sync for final sta cleanup timer deletion
         [a56f992cdabc63f56b4b142885deebebf936ff76]

Kees Cook (1):
      x86: Use enum instead of literals for trap values
         [c94082656dac74257f63e91f78d5d458ac781fa5]

Kenji Kaneshige (2):
      PCI: pciehp: Fix wrong workqueue cleanup
         [027e8d52abdd44bc00e405af83cd2fbfb96c0824]
      PCI: pciehp: Handle push button event asynchronously
         [486b10b9f43500741cd63a878d0ef23cd87fc66d]

Konrad Rzeszutek Wilk (2):
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled
         [b88a634a903d9670aa5f2f785aa890628ce0dece]
      intel_idle: Don't register CPU notifier if we are not running.
         [6f8c2e7933679f54b6478945dc72e59ef9a3d5e0]

Larry Finger (1):
      staging: r8712u: Add new device ID
         [da849a92d3bafaf24d770e971c2c9e5c3f60b5d1]

Laura Abbott (1):
      mm: use aligned zone start for pfn_to_bitidx calculation
         [c060f943d0929f3e429c5d9522290584f6281d6e]

Mark Brown (2):
      ASoC: wm2000: Fix sense of speech clarity enable
         [267f8fa2e1eef0612b2007e1f1846bcbc35cc1fa]
      ASoC: wm5100: Remove DSP B and left justified formats
         [5f960294e2031d12f10c8488c3446fecbf59628d]

Mark Rustad (2):
      tcm_fc: Do not indicate retry capability to initiators
         [f2eeba214bcd0215b7f558cab6420e5fd153042b]
      tcm_fc: Do not report target role when target is not defined
         [edec8dfefa1f372b2dd8197da555352e76a10c03]

Matt Fleming (3):
      efi: Make 'efi_enabled' a function to query EFI facilities
         [83e68189745ad931c2afd45d8ee3303929233e7f]
      samsung-laptop: Disable on EFI hardware
         [e0094244e41c4d0c7ad69920681972fc45d8ce34]
      x86, efi: Set runtime_version to the EFI spec revision
         [712ba9e9afc4b3d3d6fa81565ca36fe518915c01]

Maxime Ripard (1):
      tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler
         [68e56cb3a068f9c30971c6117fbbd1e32918e49e]

Mike Dunn (2):
      ALSA: pxa27x: fix ac97 cold reset
         [41b645c8624df6ace020a8863ad1449d69140f7d]
      ALSA: pxa27x: fix ac97 warm reset
         [3b4bc7bccc7857274705b05cf81a0c72cfd0b0dd]

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog
         [b8f2c21db390273c3eaf0e5308faeaeb1e233840]

Nickolai Zeldovich (1):
      staging: speakup: avoid out-of-range access in synth_init()
         [ae428655b826f2755a8101b27beda42a275ef8ad]

Nicolas Pitre (1):
      ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area
         [6f16f4998f98e42e3f2dedf663cfb691ff0324af]

Oliver Neukum (1):
      USB: hub: handle claim of enabled remote wakeup after reset
         [07e72b95f5038cc82304b9a4a2eb7f9fc391ea68]

Olivier Sobrie (3):
      can: c_can: fix invalid error codes
         [6ea45886865c1abb01bb861f7f6bdd5d0f398cb3]
      can: pch_can: fix invalid error codes
         [ee50e135aeb048b90fab662e661c58b67341830b]
      can: ti_hecc: fix invalid error codes
         [71088c4bd9b8f8cbffb0e66f2abc14297e4b2ca8]

Philipp Reisner (1):
      drbd: add missing part_round_stats to _drbd_start_io_acct
         [72585d2428fa3a0daab02ebad1f41e5ef517dbaa]

Piotr Haber (1):
      brcmsmac: increase timer reference count for new timers only
         [a1fe52801a992e590cdaee2fb47a94bac9b5da90]

Pratyush Anand (1):
      usb: dwc3: gadget: fix ep->maxburst for ep0
         [6048e4c69d80600baba35856651056860d5d8f5a]

Quentin.Li (1):
      USB: option: Add new MEDIATEK PID support
         [94a85b633829b946eef53fc1825d526312fb856f]

Russell King (1):
      ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with sparsemem
         [15653371c67c3fbe359ae37b720639dd4c7b42c5]

Samuel Thibault (1):
      staging: speakup: avoid out-of-range access in synth_add()
         [6102c48bd421074a33e102f2ebda3724e8d275f9]

Sarah Sharp (8):
      USB: Allow USB 3.0 ports to be disabled.
         [41e7e056cdc662f704fa9262e5c6e213b4ab45dd]
      USB: Handle auto-transition from hot to warm reset.
         [1c7439c61fa6516419c32a9824976334ea969d47]
      USB: Handle warm reset failure on empty port.
         [65bdac5effd15d6af619b3b7218627ef4d84ed6a]
      USB: Ignore port state until reset completes.
         [4f43447e62b37ee19c82a13f72f35b1ca60a74d3]
      USB: Ignore xHCI Reset Device status.
         [8b8132bc3d1cc3d4c0687e4d638a482fa920d98a]
      USB: Increase reset timeout.
         [77c7f072c87fa951e9a74805febf26466f31170c]
      xhci: Avoid "dead ports", add roothub port polling.
         [c52804a472649b2e5005342308739434cbd51119]
      xhci: Handle HS bulk/ctrl endpoints that don't NAK.
         [55c1945edaac94c5338a3647bc2e85ff75d9cf36]

Sean Young (1):
      8250: blacklist Winbond CIR port
         [65ecc9c02dbad033a73a32916d17c107c5b25031]

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy: fix enumeration with g_multi
         [1d16638e3b9cc195bac18a8fcbca748f33c1bc24]

Sergei Shtylyov (1):
      usb: musb: core: print new line in the driver banner again
         [2ac788f705e5118dd45204e7a5bc8d5bb6873835]

Shuah Khan (1):
      ioat: Fix DMA memory sync direction correct flag
         [ac4989874af56435c308bdde9ad9c837a26f8b23]

Stefan Assmann (1):
      igb: release already assigned MSI-X interrupts if setup fails
         [52285b762b3681669215bf1d17ca6143448ab7d3]

Stephen Boyd (1):
      ARM: 7627/1: Predicate preempt logic on PREEMP_COUNT not PREEMPT alone
         [568dca15aa2a0f4ddee255894ec393a159f13147]

Stephen Hurd (1):
      8250/16?50: Add support for Broadcom TruManage redirected serial port
         [ebebd49a8eab5e9aa1b1f8f1614ccc3c2120f886]

Steven Rostedt (1):
      ftrace: Be first to run code modification on modules
         [c1bf08ac26e92122faab9f6c32ea8aba94612dae]

Sujith Manoharan (1):
      ath9k_htc: Fix memory leak
         [0981c3b24ef664f5611008a6e6d0622fac6d892b]

Suravee Suthikulpanit (1):
      IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround
         [318fe782539c4150d1b8e4e6c9dc3a896512cb8a]

Takashi Iwai (5):
      ALSA: hda - Add Conexant CX20751/2/3/4 codec support
         [61d648fb4726f8a89c07cd1904f9c2e11bf26df5]
      ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs
         [42c364ace52ae6b4699105b39f2559c256b6cd4c]
      ALSA: hda - Fix non-snoop page handling
         [9ddf1aeb2134e72275c97a2c6ff2e3eb04f2f27a]
      ALSA: hda/conexant - Correct vendor IDs for new codecs
         [2d825fd82eb765412a558a56e193b77117d56699]
      ALSA: usb-audio: Fix regression by disconnection-race-fix  patch
         [not upstream; regression only occurred when applied to 3.0 & 3.2]

Thomas Schlichter (1):
      ACPI / processor: Get power info before updating the C-states
         [f427e5f1cf75bba84cccdac1d8a90552d9ae1065]

Thomas Schwinge (1):
      sh: Fix FDPIC binary loader
         [4a71997a3279a339e7336ea5d0cd27282e2dea44]

Tom Mingarelli (1):
      intel-iommu: Prevent devices with RMRRs from being placed into SI Domain
         [ea2447f700cab264019b52e2b417d689e052dcfd]

Tomasz Mloduchowski (1):
      usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added
         [8cf65dc386f3634a43312f436cc7a935476a40c4]

Trond Myklebust (3):
      NFS: Don't silently fail setattr() requests on mountpoints
         [ab225417825963b6dc66be7ea80f94ac1378dfdf]
      NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session
         [c489ee290bdbbace6bb63ebe6ebd4dd605819495]
      SUNRPC: Ensure we release the socket write lock if the rpc_task exits early
         [87ed50036b866db2ec2ba16b2a7aec4a2b0b7c39]

Wang YanQing (1):
      smp: Fix SMP function call empty cpu mask race
         [f44310b98ddb7f0d06550d73ed67df5865e3eda5]

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()
         [1ee0a224bc9aad1de496c795f96bc6ba2c394811]

Yijing Wang (1):
      PCI: pciehp: Use per-slot workqueues to avoid deadlock
         [c2be6f93b383c873a4f9d521afa49b1b67d06085]

Zhenzhong Duan (2):
      drivers/firmware/dmi_scan.c: check dmi version when get system uuid
         [f1d8e614d74b09531b9a85e812485340f3df7b1c]
      drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists
         [9f9c9cbb60576a1518d0bf93fb8e499cffccf377]

Éric Piel (1):
      staging: comedi: fix minimum AO period for NI 625x and NI 628x
         [34b55d8c48f4f76044d8f4d6ec3dc786cf210312]

 Makefile                                           |    4 +-
 arch/arm/kernel/head.S                             |    3 +
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h        |    3 +
 arch/arm/mach-pxa/pxa27x.c                         |    4 +-
 arch/arm/mm/dma-mapping.c                          |   18 +--
 arch/arm/vfp/entry.S                               |    6 +-
 arch/arm/vfp/vfphw.S                               |    4 +-
 arch/powerpc/kvm/emulate.c                         |    2 +
 arch/s390/include/asm/timex.h                      |   28 +++++
 arch/s390/kernel/time.c                            |    2 +-
 arch/s390/kvm/interrupt.c                          |    2 +-
 arch/sh/include/asm/elf.h                          |    4 +-
 arch/x86/include/asm/efi.h                         |    1 +
 arch/x86/include/asm/traps.h                       |   25 ++++
 arch/x86/kernel/entry_32.S                         |    1 -
 arch/x86/kernel/irqinit.c                          |    2 +-
 arch/x86/kernel/msr.c                              |    3 +
 arch/x86/kernel/reboot.c                           |    2 +-
 arch/x86/kernel/setup.c                            |  103 +++++++++++++++--
 arch/x86/kernel/traps.c                            |  120 +++++++++++---------
 arch/x86/platform/efi/efi.c                        |   38 ++++++-
 arch/x86/platform/efi/efi_64.c                     |   22 +++-
 drivers/acpi/osl.c                                 |    2 +-
 drivers/acpi/processor_idle.c                      |    4 +
 drivers/ata/ahci.c                                 |    5 +-
 drivers/block/drbd/drbd_req.c                      |    1 +
 drivers/block/virtio_blk.c                         |    7 +-
 drivers/dma/ioat/dma_v3.c                          |    2 +-
 drivers/edac/edac_pci_sysfs.c                      |    2 +-
 drivers/firmware/dmi_scan.c                        |   80 ++++++++++---
 drivers/firmware/efivars.c                         |    4 +-
 drivers/firmware/iscsi_ibft_find.c                 |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    2 +
 drivers/gpu/drm/i915/i915_gem.c                    |    7 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   21 ++++
 drivers/gpu/drm/i915/i915_reg.h                    |    6 +-
 drivers/gpu/drm/i915/intel_display.c               |    4 +
 drivers/gpu/drm/i915/intel_lvds.c                  |    8 --
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   23 +++-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    2 +
 drivers/gpu/drm/radeon/radeon_device.c             |    3 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |    8 ++
 drivers/idle/intel_idle.c                          |    7 +-
 drivers/iommu/amd_iommu_init.c                     |   34 ++++++
 drivers/iommu/intel-iommu.c                        |   52 ++++++++-
 drivers/net/can/c_can/c_can.c                      |    4 +-
 drivers/net/can/pch_can.c                          |    2 +-
 drivers/net/can/ti_hecc.c                          |    4 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   22 +++-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   29 ++---
 drivers/net/wireless/ath/ath9k/beacon.c            |    1 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    2 +
 drivers/net/wireless/ath/ath9k/hw.h                |    1 +
 drivers/net/wireless/ath/ath9k/recv.c              |   10 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    7 +-
 drivers/net/wireless/mwifiex/init.c                |   40 +++++++
 drivers/net/wireless/mwifiex/main.c                |   11 +-
 drivers/net/wireless/mwifiex/main.h                |    9 ++
 drivers/net/wireless/mwifiex/pcie.c                |    2 +-
 drivers/net/wireless/mwifiex/sta_event.c           |    6 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   33 +++---
 drivers/net/wireless/mwifiex/txrx.c                |    5 +-
 drivers/pci/hotplug/pciehp.h                       |    3 +-
 drivers/pci/hotplug/pciehp_core.c                  |   20 +---
 drivers/pci/hotplug/pciehp_ctrl.c                  |    8 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   12 +-
 drivers/pci/hotplug/shpchp.h                       |    3 +-
 drivers/pci/hotplug/shpchp_core.c                  |   36 +++---
 drivers/pci/hotplug/shpchp_ctrl.c                  |    6 +-
 drivers/pci/pcie/aer/aerdrv_core.c                 |    1 +
 drivers/pci/pcie/aspm.c                            |    3 +
 drivers/platform/x86/ibm_rtl.c                     |    2 +-
 drivers/platform/x86/samsung-laptop.c              |    4 +
 drivers/regulator/max8997.c                        |   36 +++---
 drivers/regulator/max8998.c                        |    2 +-
 drivers/scsi/isci/init.c                           |    2 +-
 drivers/scsi/sd.c                                  |   13 ++-
 drivers/staging/comedi/Kconfig                     |    1 +
 drivers/staging/comedi/comedi_fops.c               |   18 +++
 drivers/staging/comedi/comedidev.h                 |    1 +
 drivers/staging/comedi/drivers.c                   |   34 ++----
 drivers/staging/comedi/drivers/comedi_test.c       |    2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   14 +--
 drivers/staging/comedi/internal.h                  |    1 +
 drivers/staging/rtl8712/usb_intf.c                 |    2 +
 drivers/staging/speakup/synth.c                    |    4 +-
 drivers/staging/usbip/usbip_common.c               |   11 +-
 drivers/staging/usbip/usbip_common.h               |    2 +-
 drivers/staging/usbip/vhci_rx.c                    |    3 +-
 drivers/staging/vt6656/bssdb.h                     |    1 -
 drivers/staging/vt6656/int.h                       |    1 -
 drivers/staging/vt6656/iocmd.h                     |   33 +++---
 drivers/staging/vt6656/iowpa.h                     |    8 +-
 drivers/target/target_core_transport.c             |    2 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   12 +-
 drivers/tty/serial/8250.c                          |   27 ++++-
 drivers/tty/serial/8250.h                          |    1 +
 drivers/tty/serial/8250_dw.c                       |    2 +-
 drivers/tty/serial/8250_pci.c                      |   38 +++++++
 drivers/tty/serial/8250_pnp.c                      |   20 +++-
 drivers/tty/serial/ifx6x60.c                       |    1 +
 drivers/usb/class/cdc-acm.c                        |    3 +
 drivers/usb/core/hub.c                             |  120 ++++++++++++++++----
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/dwc3/gadget.c                          |    1 +
 drivers/usb/gadget/dummy_hcd.c                     |    9 +-
 drivers/usb/host/uhci-hcd.c                        |   15 ++-
 drivers/usb/host/xhci-hub.c                        |   38 ++++++-
 drivers/usb/host/xhci-mem.c                        |    2 +
 drivers/usb/host/xhci-ring.c                       |    9 ++
 drivers/usb/host/xhci.c                            |   10 ++
 drivers/usb/musb/musb_core.c                       |    5 +-
 drivers/usb/serial/ftdi_sio.c                      |    2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 +
 drivers/usb/serial/io_ti.c                         |    3 +
 drivers/usb/serial/option.c                        |   27 ++++-
 fs/cifs/cifs_dfs_ref.c                             |    2 +
 fs/nfs/namespace.c                                 |   20 ++++
 fs/nfs/nfs4state.c                                 |   14 ++-
 fs/xfs/xfs_aops.c                                  |    2 +-
 include/linux/efi.h                                |   23 +++-
 include/linux/serial_core.h                        |    4 +-
 include/linux/syslog.h                             |    6 +
 init/main.c                                        |    2 +-
 kernel/printk.c                                    |   13 ++-
 kernel/smp.c                                       |   13 ++-
 kernel/trace/ftrace.c                              |    2 +-
 mm/compaction.c                                    |    6 +-
 mm/page_alloc.c                                    |    2 +-
 net/bluetooth/hidp/core.c                          |    2 +-
 net/mac80211/sta_info.c                            |    2 +-
 net/sunrpc/sched.c                                 |    3 +-
 net/sunrpc/xprt.c                                  |   12 +-
 security/integrity/evm/evm_crypto.c                |    4 +-
 sound/arm/pxa2xx-ac97-lib.c                        |   26 ++++-
 sound/pci/hda/hda_intel.c                          |   40 ++++---
 sound/pci/hda/patch_conexant.c                     |   34 +++---
 sound/soc/codecs/wm2000.c                          |    4 +-
 sound/soc/codecs/wm5100.c                          |    6 -
 sound/usb/endpoint.c                               |    6 +-
 sound/usb/mixer.c                                  |   17 ++-
 sound/usb/quirks.c                                 |    8 +-
 143 files changed, 1289 insertions(+), 500 deletions(-)

-- 
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstein

