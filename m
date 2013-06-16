Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3FPWNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:13:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46291 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498Ab3FPWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.958132574@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [00/83] 3.2.47-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.47 release.
There are 83 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jun 18 22:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.46 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Adis Hamzić (1):
      radeon: Fix system hang issue when using KMS with older cards
         [e49f3959a96dc279860af7e86e6dbcfda50580a5]

Alan Stern (1):
      USB: revert periodic scheduling bugfix
         [fdc03438f53a00294ed9939eb3a1f6db6f3d8963]

Alex Deucher (1):
      drm/radeon: fix card_posted check for newer asics
         [09fb8bd1a63b0f9f15e655c4fe8d047e5d2bf67a]

Alex Hung (2):
      ACPI / video: ignore BIOS initial backlight value for HP m4
         [fedbe9bc6fd3e14b1ffbb3dac407777ac4a3650c]
      ACPI video: ignore BIOS initial backlight value for HP 1000
         [4ef366c583d6180b1c951147869ee5a3038834f2]

Alex Lyakas (1):
      md/raid1: consider WRITE as successful only if at least one non-Faulty and non-rebuilding drive completed it.
         [3056e3aec8d8ba61a0710fb78b2d562600aa2ea7]

Andrew Worsley (1):
      USB: serial: ftdi_sio: Handle the old_termios == 0 case e.g. uart_resume_port()
         [c515598e0f5769916c31c00392cc2bfe6af74e55]

Arnd Bergmann (2):
      ARM: 7742/1: topology: export cpu_topology
         [92bdd3f5eba299b33c2f4407977d6fa2e2a6a0da]
      ARM: 7743/1: compressed/head.S: work around new binutils warning
         [da94a829305f1c217cfdf6771cb1faca0917e3b9]

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6
         [780a6ec640a3fed671fc2c40e4dd30c03eca3ac3]

Ben Hutchings (1):
      rapidio/tsi721: Fix interrupt mask when handling MSI
         [not upstream; fixes wrongly backported commit]

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740
         [45a211d75137b1ac869a8a758a6667f15827a115]

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E1820
         [b8a24e6281d37243c06b9497dcbfaa98c1e2ad35]

Chiau Ee Chew (1):
      ata_piix: add PCI IDs for Intel BayTail
         [fca8c90d519dedd4f4b19901d005c243f7f0bf2e]

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID
         [c3456fb3e4712d0448592af3c5d644c9472cd3c1]

Dave Chinner (1):
      xfs: kill suid/sgid through the truncate path.
         [56c19e89b38618390addfc743d822f99519055c6]

Dave Kleikamp (1):
      jfs: fix a couple races
         [73aaa22d5ffb2630456bac2f9a4ed9b81d0d7271]

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.
         [53d3b4d7778daf15900867336c85d3f8dd70600c]

Emmanuel Grumbach (1):
      iwlwifi: dvm: fix zero LQ CMD sending avoidance
         [a87783699b23395c46bbeeb5d28f6db24897bf26]

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2
         [5bf8fae33d14cc5c3c53a926f9079f92c8b082b0]

Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617
         [591bfcfc334a003ba31c0deff03b22e73349939b]

Gustavo Maciel Dias Vieira (1):
      ACPI video: ignore BIOS backlight value for HP dm4
         [771d09b3c4c45d4d534a83a68e6331b97fd82e15]

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled
         [b7ea85a4fed37835eec78a7be3039c8dc22b8178]

Jeff Layton (1):
      cifs: fix potential buffer overrun when composing a new options string
         [166faf21bd14bc5c5295a44874bf7f3930c30b20]

Joe Perches (1):
      net: Add net_ratelimited_function and net_<level>_ratelimited macros
         [3a3bfb61e64476ff1e4ac3122cb6dec9c79b795c]

Johan Hedberg (1):
      Bluetooth: Fix missing length checks for L2CAP signalling PDUs
         [cb3b3152b2f5939d67005cff841a1ca748b19888]

Johan Hovold (11):
      USB: ark3116: fix control-message timeout
         [634371911730a462626071065b64cd6e1fe213e0]
      USB: iuu_phoenix: fix bulk-message timeout
         [6c13ff68a7ce01da7a51b44241a7aad8eaaedde7]
      USB: keyspan: fix bogus array index
         [a07088098a650267b2eda689538133a324b9523f]
      USB: mos7720: fix DMA to stack
         [72ea18a558ed7a63a50bb121ba60d73b5b38ae30]
      USB: mos7720: fix hardware flow control
         [a26f009a070e840fadacb91013b2391ba7ab6cc2]
      USB: mos7720: fix message timeouts
         [849513a7809175420d353625b6f651d961e99d49]
      USB: pl2303: fix device initialisation at open
         [2d8f4447b58bba5f8cb895c07690434c02307eaf]
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
         [5f8e2c07d75967ee49a5da1d21ddf5f50d48cda0]
      USB: spcp8x5: fix device initialisation at open
         [5e4211f1c47560c36a8b3d4544dfd866dcf7ccd0]
      USB: visor: fix initialisation of Treo/Kyocera devices
         [420021a395ce38b7ab2cceb52dee4038be7d8fa3]
      USB: whiteheat: fix broken port configuration
         [9eecf22d2b375b9064a20421c6c307b760b03d46]

Johannes Berg (2):
      cfg80211: check wdev->netdev in connection work
         [c815797663b72e3ac1736f1886538152bc48e4af]
      mac80211: close AP_VLAN interfaces before unregistering all
         [c8aa22db0112f640ac6631347f850879c621840b]

Kees Cook (3):
      b43: stop format string leaking into error msgs
         [e0e29b683d6784ef59bbc914eac85a04b650e63c]
      iscsi-target: fix heap buffer overflow on error
         [cea4dcfdad926a27a18e188720efe0f2c9403456]
      x86: Fix typo in kexec register clearing
         [c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1]

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.
         [bee980d9e9642e96351fa3ca9077b853ecf62f57]

Larry Finger (1):
      b43legacy: Fix crash on unload when firmware not available
         [2d838bb608e2d1f6cb4280e76748cb812dc822e7]

Manoj Iyer (1):
      thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR
         [a4f46bb9fa84642e356898ee44b670989622f8bb]

Michael Chan (1):
      tg3: Add New 5719 Read DMA workaround
         [091f0ea30074bc43f9250961b3247af713024bc6]

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()
         [30dad30922ccc733cfdbfe232090cf674dc374dc]

Nithin Sujir (2):
      tg3: Add read dma workaround for 5720
         [9bc297ea0622bb2a6b3abfa2fa84f0a3b86ef8c8]
      tg3: Wait for boot code to finish after power on
         [df465abfe06f7dc4f33f4a96d17f096e9e8ac917]

Oleg Nesterov (1):
      audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE
         [f000cfdde5de4fc15dead5ccf524359c07eadf2b]

Patrik Jakobsson (3):
      drm/gma500/cdv: Unpin framebuffer on crtc disable
         [22e7c385a80d771aaf3a15ae7ccea3b0686bbe10]
      drm/gma500/psb: Unpin framebuffer on crtc disable
         [820de86a90089ee607d7864538c98a23b503c846]
      drm/gma500: Increase max resolution for mode setting
         [cbbd379aa43890f36da934f5af619d2fb8ec3d87]

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform
         [bf593907f7236e95698a76b7c7a2bbf8b1165327]

Rafael Aquini (1):
      swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion
         [cbab0e4eec299e9059199ebe6daf48730be46d2b]

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.
         [8a2f132a01c2dd4c3905fa560f92019761ed72b1]

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device
         [6529591e3eef65f0f528a81ac169f6e294b947a7]

Robin Holt (1):
      reboot: rigrate shutdown/reboot to boot cpu
         [cf7df378aa4ff7da3a44769b7ff6e9eef1a9f3db]

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init
         [331de00a64e5027365145bdf51da27b9ce15dfd5]

Srivatsa S. Bhat (1):
      CPU hotplug: provide a generic helper to disable/enable CPU hotplug
         [16e53dbf10a2d7e228709a7286310e629ede5e45]

Stephen Hemminger (1):
      xen-netback: fix sparse warning
         [9eaee8beeeb3bca0d9b14324fd9d467d48db784c]

Stephen M. Cameron (1):
      cciss: fix broken mutex usage in ioctl
         [03f47e888daf56c8e9046c674719a0bcc644eed5]

Steven Rostedt (1):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section
         [7f49ef69db6bbf756c0abca7e9b65b32e999eec8]

Sujith Manoharan (2):
      ath9k: Disable PowerSave by default
         [73c79617596b89a3693ff0d89d42bcd5ddedcf15]
      ath9k: Use minstrel rate control by default
         [5efac94999ff218e0101f67a059e44abb4b0b523]

Takashi Iwai (2):
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface
         [8eafc0a161123d90617c9ca2eddfe87b382b1b89]
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270
         [11e7064f35bb87da8f427d1aa4bbd8b7473a3993]

Theodore Ts'o (1):
      ext4: lock i_mutex when truncating orphan inodes
         [721e3eba21e43532e438652dd8f1fcdfce3187e7]

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate
         [77df9e0b799b03e1d5d9c68062709af5f637e834]

Tony Lindgren (1):
      drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree
         [24b8256a1fb28d357bc6fa09184ba29b4255ba5c]

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR
         [e771451c0a831d96a7c14b0ca8a8ec671d98567b]

Vladimir Murzin (1):
      xhci: fix list access before init
         [88696ae432ce7321540ac53d9caab3de9118b094]

Wei Liu (8):
      netback: remove redundant assignment
         [16ecba2605a3bbd374cd993e532264e2d8de49e5]
      xen-netback: avoid allocating variable size array on stack
         [59ccb4ebbc35e36a3c143f2d1355deb75c2e628f]
      xen-netback: better names for thresholds
         [376414945d15aa636e65f7e773c1e398b7a21cb9]
      xen-netback: coalesce slots in TX path and fix regressions
         [2810e5b9a7731ca5fce22bfbe12c96e16ac44b6f]
      xen-netback: don't disconnect frontend when seeing oversize packet
         [03393fd5cc2b6cdeec32b704ecba64dbb0feae3c]
      xen-netback: remove redundent parameter in netbk_count_requests
         [ac69c26e7accb04ae2cb9ab0872068983a42b3c8]
      xen-netback: remove skb in xen_netbk_alloc_page
         [27f852282ab9a028f57da96d05c26f38c424a315]
      xen-netfront: reduce gso_max_size to account for max TCP header
         [9ecd1a75d977e2e8c48139c7d3efed183f898d94]

Xi Wang (2):
      ALSA: usb-audio: avoid integer overflow in create_fixed_stream_quirk()
         [8866f405efd4171f9d9c91901d2dd02f01bacb60]
      ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_rate_range()
         [4fa0e81b83503900be277e6273a79651b375e288]

Ying Xue (1):
      USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL pointer
         [a816e3113b63753c330ca4751ea1d208e93e3015]

 Makefile                                       |    4 +-
 arch/arm/boot/compressed/Makefile              |    1 -
 arch/arm/boot/compressed/head-sa1100.S         |    1 +
 arch/arm/boot/compressed/head-shark.S          |    1 +
 arch/arm/boot/compressed/head.S                |    1 +
 arch/arm/kernel/topology.c                     |    2 +
 arch/powerpc/kernel/exceptions-64s.S           |    2 +-
 arch/powerpc/kernel/traps.c                    |   10 +
 arch/x86/kernel/relocate_kernel_64.S           |    2 +-
 drivers/acpi/video.c                           |   32 +++
 drivers/ata/ata_piix.c                         |   14 ++
 drivers/ata/libata-core.c                      |    6 +
 drivers/block/cciss.c                          |   32 +--
 drivers/gpu/drm/drm_irq.c                      |    6 +-
 drivers/gpu/drm/i915/intel_lvds.c              |    4 +-
 drivers/gpu/drm/i915/intel_sdvo.c              |   12 +-
 drivers/gpu/drm/radeon/evergreen.c             |   10 +-
 drivers/gpu/drm/radeon/ni.c                    |   10 +-
 drivers/gpu/drm/radeon/r100.c                  |    9 +-
 drivers/gpu/drm/radeon/r300.c                  |    9 +-
 drivers/gpu/drm/radeon/r420.c                  |   10 +-
 drivers/gpu/drm/radeon/r520.c                  |    9 +-
 drivers/gpu/drm/radeon/r600.c                  |   10 +-
 drivers/gpu/drm/radeon/radeon_device.c         |   19 +-
 drivers/gpu/drm/radeon/rs400.c                 |    9 +-
 drivers/gpu/drm/radeon/rs600.c                 |    9 +-
 drivers/gpu/drm/radeon/rs690.c                 |    9 +-
 drivers/gpu/drm/radeon/rv515.c                 |    9 +-
 drivers/gpu/drm/radeon/rv770.c                 |   10 +-
 drivers/hwmon/adm1021.c                        |   58 ++++-
 drivers/md/raid1.c                             |   12 +-
 drivers/md/raid10.c                            |   12 +-
 drivers/net/ethernet/broadcom/tg3.c            |   42 ++++
 drivers/net/ethernet/broadcom/tg3.h            |    8 +-
 drivers/net/wireless/ath/ath9k/Kconfig         |   10 +-
 drivers/net/wireless/ath/ath9k/Makefile        |    2 +-
 drivers/net/wireless/ath/ath9k/init.c          |    7 +-
 drivers/net/wireless/ath/ath9k/rc.h            |    2 +-
 drivers/net/wireless/b43/main.c                |    2 +-
 drivers/net/wireless/b43legacy/main.c          |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c     |    2 +-
 drivers/net/xen-netback/netback.c              |  315 +++++++++++++++++++-----
 drivers/net/xen-netfront.c                     |   17 +-
 drivers/platform/x86/thinkpad_acpi.c           |    7 +
 drivers/rapidio/devices/tsi721.c               |    2 +-
 drivers/rtc/rtc-twl.c                          |    1 +
 drivers/staging/gma500/cdv_intel_display.c     |   14 ++
 drivers/staging/gma500/framebuffer.c           |    4 +-
 drivers/staging/gma500/psb_intel_display.c     |   14 ++
 drivers/target/iscsi/iscsi_target_parameters.c |    8 +-
 drivers/target/iscsi/iscsi_target_parameters.h |    4 +-
 drivers/usb/dwc3/gadget.c                      |   15 +-
 drivers/usb/host/ehci-sched.c                  |    2 +-
 drivers/usb/host/xhci-mem.c                    |   10 +-
 drivers/usb/host/xhci.c                        |   12 +-
 drivers/usb/serial/ark3116.c                   |    2 +-
 drivers/usb/serial/cypress_m8.c                |   18 +-
 drivers/usb/serial/cypress_m8.h                |    4 +
 drivers/usb/serial/ftdi_sio.c                  |    4 +
 drivers/usb/serial/iuu_phoenix.c               |    4 +-
 drivers/usb/serial/keyspan.c                   |    2 +-
 drivers/usb/serial/mos7720.c                   |   25 +-
 drivers/usb/serial/option.c                    |    2 +
 drivers/usb/serial/pl2303.c                    |   10 +-
 drivers/usb/serial/qcserial.c                  |    1 +
 drivers/usb/serial/spcp8x5.c                   |   10 +-
 drivers/usb/serial/visor.c                     |    2 +
 drivers/usb/serial/whiteheat.c                 |    2 +-
 drivers/xen/events.c                           |   19 +-
 fs/cifs/cifs_dfs_ref.c                         |    4 +-
 fs/ext4/super.c                                |    2 +
 fs/jfs/inode.c                                 |    2 +-
 fs/jfs/jfs_logmgr.c                            |    3 +-
 fs/xfs/xfs_iops.c                              |   47 ++--
 include/linux/cpu.h                            |    4 +
 include/linux/net.h                            |   23 ++
 include/linux/swapops.h                        |    3 +
 include/xen/interface/io/netif.h               |   19 ++
 kernel/audit.c                                 |    2 +-
 kernel/cpu.c                                   |   55 ++---
 kernel/sys.c                                   |   29 ++-
 kernel/trace/ftrace.c                          |   26 +-
 mm/hugetlb.c                                   |    2 +-
 mm/migrate.c                                   |   23 +-
 mm/swap_state.c                                |   18 +-
 net/bluetooth/l2cap_core.c                     |   85 +++++--
 net/mac80211/iface.c                           |    9 +
 net/wireless/sme.c                             |    3 +
 sound/usb/card.h                               |    1 +
 sound/usb/format.c                             |    6 +-
 sound/usb/mixer.c                              |    1 +
 sound/usb/quirks-table.h                       |    8 +-
 sound/usb/quirks.c                             |    6 +-
 93 files changed, 1025 insertions(+), 307 deletions(-)

-- 
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others.

