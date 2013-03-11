Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3CKAYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 20:24:13 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33284 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3CKAYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 20:24:10 -0400
MIME-Version: 1.0
Date: Sun, 10 Mar 2013 17:24:09 -0700
X-Google-Sender-Auth: 7pNWtTfxBoFzsxHva9SZn7JMOsM
Message-ID: <CA+55aFw28bYTn2k+UXidOqghYxjow9srnEzW2Vv8ASWLk8UGug@mail.gmail.com>
Subject: Linux 3.9-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, things have been reasonable calm. Sure, Dave Jones has been
messing with trinity and we've had some excitement from that, but Al
is back, and is hopefully now busy virtually riding to the rescue on a
white horse. But otherwise it's been good for this phase in the rc
window.

The diffstat is reasonably flat (good sign), with wireless network
drivers standing out. And that's mainly due to a new driver for the
ASIX AX88179_178A USB gigabit controller.

Other than network drivers, we've got some drm updates, md and gpio,
btrfs, etworking, arm, sound.. Stuff all over the place, but nothing
horribly scary. Considering that some rc2's are too big to post a
shortlog for, I'm happy.

And let's just keep it that way, ok?

             Linus

---
Akinobu Mita (1):
      powerpc: Remove unused BITOP_LE_SWIZZLE macro

Alex Deucher (3):
      drm/radeon: don't set hpd, afmt interrupts when interrupts are disabled
      drm/radeon: add primary dac adj quirk for R200 board
      drm/radeon: skip MC reset as it's probably not hung

Alexandre Courbot (3):
      gpiolib: check descriptors validity before use
      gpiolib: use const parameters when possible
      gpiolib: move comment to right function

Andrzej Hajda (1):
      regulator: fixed regulator_bulk_enable unwinding code

Arnd Bergmann (1):
      Revert parts of "hlist: drop the node parameter from iterators"

Avinash Patil (1):
      mwifiex: correct sleep delay counter

Axel Lin (2):
      regulator: twl: Convert twl4030ldo_ops to get_voltage_sel
      ASoC: wm8350: Use jiffies rather than msecs in schedule_delayed_work()

Ben Dooks (1):
      ARM: 7652/1: mm: fix missing use of 'asid' to get asid value
from mm->context.id

Ben Hutchings (4):
      sfc: Properly sync RX DMA buffer when it is not the last in the page
      sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
      sfc: Detach net device when stopping queues for reconfiguration
      dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Ben Skeggs (4):
      drm/nve0/graph: some random reg moved on kepler
      drm/nv84: fix regression in page flipping
      drm/nouveau/i2c: drop parent refcount when creating ports
      drm/nv50-: prevent some races between modesetting and page flipping

Benjamin Tissoires (1):
      HID: logitech-dj: do not directly call hid_output_raw_report()
during probe

Benson Leung (1):
      Platform: x86: chromeos_laptop : Add basic platform data for atmel devices

Bing Zhao (1):
      libertas: fix crash for SD8688

Bjørn Mork (1):
      net: cdc_ncm: tag Huawei devices (e.g. E5331) with FLAG_WWAN

Borislav Petkov (1):
      x86, smpboot: Remove unused variable

Cesar Eduardo Barros (3):
      MAINTAINERS: remove 3c505
      MAINTAINERS: remove drivers/net/wan/cycx*
      MAINTAINERS: remove eexpress

Charles Keepax (2):
      ASoC: wm5102: Correct OUT2 volume and switch names
      ASoC: wm5110: Correct OUT2/3 volume and switch names

Chen Gang (4):
      ARM: 7664/1: perf: remove erroneous semicolon from event initialisation
      ACPI / porocessor: Beautify code, pr->id is u32 which is never < 0
      powerpc/pseries/hvcserver: Fix strncpy buffer limit in location code
      drivers/tty/hvc: Use strlcpy instead of strncpy

Chris Mason (2):
      Btrfs: enforce min_bytes parameter during extent allocation
      Btrfs: improve the delayed inode throttling

Chris Metcalf (2):
      tile: work around bug in the generic sys_llseek
      tile: properly use COMPAT_SYSCALL_DEFINEx

Christopher Harvey (3):
      drm/mgag200: 'fbdev_list' in 'struct mga_fbdev' is not used
      drm/mgag200: Reject modes that are too big for VRAM
      drm: Documentation typo fixes

Chun-Yeow Yeoh (1):
      mac80211: fix the problem of forwarding from DS to DS in Mesh

Cong Wang (3):
      rds: limit the size allocated by rds_message_alloc()
      sctp: use KMALLOC_MAX_SIZE instead of its own MAX_KMALLOC_SIZE
      rds: simplify a warning message

Cyrill Gorcunov (1):
      ARM: 7665/1: Wire up kcmp syscall

Dan Carpenter (4):
      eCryptfs: remove unneeded checks in virt_to_scatterlist()
      irda: small read beyond end of array in debug code
      sctp: use the passed in gfp flags instead GFP_KERNEL
      ALSA: seq: seq_oss_event: missing range checks

Daniel Kurtz (1):
      Input: atmel_mxt_ts - Support for touchpad variant

Daniel Mack (1):
      drivers: net: ethernet: cpsw: consider number of slaves in interation

Daniel Vetter (1):
      drm/i915: enable irqs earlier when resuming

Dave Hansen (1):
      x86: Do not try to sync identity map for non-mapped pages

Dietmar Eggemann (1):
      ARM: 7662/1: hw_breakpoint: reset debug logic on secondary CPUs
in s2ram resume

Dirk Brandewie (2):
      cpufreq / intel_pstate: Fix intel_pstate_init() error path
      cpufreq / intel_pstate: Do not load on VM that does not report
max P state.

Dmitry Kravkov (1):
      bnx2x: fix UDP checksum for 57710/57711.

Dmitry Torokhov (1):
      regulator: db8500-prcmu - remove incorrect __exit markup

Dor Shaish (1):
      iwlwifi: mvm: Remove testing of static PIC in PhyDB

Egbert Eich (1):
      DRM/i915: On G45 enable cursor plane briefly after enabling the
display plane.

Emilio López (1):
      cpufreq: highbank: do not initialize array with a loop

Eric Dumazet (1):
      tcp: avoid wakeups for pure ACK

Eric W. Biederman (4):
      userns: Stop oopsing in key_change_session_keyring
      fs: Limit sys_mount to only request filesystem modules.
      fs: Limit sys_mount to only request filesystem modules (Part 2).
      proc: Use nd_jump_link in proc_ns_follow_link

Felix Fietkau (6):
      mac80211: fix idle handling in monitor mode
      mac80211: fix monitor mode channel reporting
      ath9k: fix RSSI dummy marker value
      ath9k_htc: fix signal strength handling issues
      ath9k_hw: improve reset reliability after errors
      rt2x00: error in configurations with mesh support disabled

Francisco Jerez (2):
      drm/nouveau: Disable AGP on PowerPC again.
      drm/nouveau: Fix typo in init_idx_addr_latched().

Frank Li (2):
      net: fec: put tx to napi poll function to fix dead lock
      net: fec: fix build error in no MXC platform

Freddy Xin (1):
      ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet
adapter driver

Frederic Weisbecker (3):
      nohz: Make tick_nohz_irq_exit() irq safe
      irq: Remove IRQ_EXIT_OFFSET workaround
      irq: Don't re-enable interrupts at the end of irq_exit

Glen Turner (1):
      usb/net/asix_devices: Add USBNET HG20F9 ethernet dongle

Graeme Gregory (1):
      regulator: palmas: fix number of SMPS voltages

Guenter Roeck (5):
      net/sctp: Validate parameter size for SCTP_GET_ASSOC_STATS
      hwmon: Update my e-mail address in driver documentation
      hwmon: (pmbus/ltc2978) Update datasheet links
      hwmon: (pmbus/ltc2978) Fix peak attribute handling
      hwmon: (pmbus/ltc2978) Use detected chip ID to select supported
functionality

Guillaume Nault (1):
      l2tp: Restore socket refcount when sendmsg succeeds

Hauke Mehrtens (2):
      bcma: init spin lock
      bgmac: omit the fcs

Hillf Danton (1):
      mm/mempolicy.c: fix wrong sp_node insertion

Hugh Dickins (1):
      ksm: fix m68k build: only NUMA needs pfn_to_nid

Ilya Dryomov (1):
      Btrfs: fix a mismerge in btrfs_balance()

Ivan Djelic (1):
      ARM: 7668/1: fix memset-related crashes caused by recent GCC
(4.7.2) optimizations

James Hogan (1):
      metag: remove SET_PERSONALITY()

Jean Delvare (1):
      hwmon: (adt7410) Document ADT7420 support

Jeff Layton (2):
      cifs: remove the sockopt= mount option
      cifs: don't try to unlock pagecache page after releasing it

Jiri Pirko (1):
      bond: check if slave count is 0 in case when deciding to take slave's mac

Joe Lawrence (1):
      md: raid1,10: Handle REQ_WRITE_SAME flag in write bios

Joe Perches (1):
      ACPI / Sleep: Avoid interleaved message on errors

Johannes Berg (6):
      mac80211: fix tim_lock locking
      nl80211: remove radar information
      nl80211: remove TCP WoWLAN information
      iwlwifi: always copy first 16 bytes of commands
      iwlwifi: mvm: fix AP/GO mode station removal
      iwlwifi: fix wakeup status query and packet reporting

Jonathan Austin (1):
      ARM: 7666/1: decompressor: add -mno-single-pic-base for building
the decompressor

Jonathan Brassow (4):
      MD RAID10: Minor non-functional code changes
      MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part 1)
      MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part 2)
      DM RAID: Add support for MD's RAID10 "far" and "offset" algorithms

Josef Bacik (1):
      Btrfs: use set_nlink if our i_nlink is 0

Josh Boyer (1):
      x86: Don't clear efi_info even if the sentinel hits

Josh Hunt (1):
      netfilter: ipset: timeout values corrupted on set resize

Jozsef Kadlecsik (2):
      netfilter: ipset: Fix range bug in hash:ip,port,net
      netfilter: ipset: "Directory not empty" error message

Julia Lemire (1):
      drm/mgag200: Bug fix: Renesas board now selects native resolution.

KOSAKI Motohiro (1):
      mm/mempolicy.c: fix sp_node_init() argument ordering

Kailang Yang (1):
      ALSA: hda - Add support of new codec ALC233

Kees Cook (2):
      proc connector: reject unprivileged listener bumps
      eCryptfs: allow userspace messaging to be disabled

Kenneth Graunke (1):
      drm/i915: Fix Haswell/CRW PCI IDs.

Konstantin Khlebnikov (1):
      memcg: initialize kmem-cache destroying work earlier

Krzysztof Mazur (1):
      x86: Fix 32-bit *_cpu_data initializers

Lee A. Roberts (4):
      sctp: fix association hangs due to off-by-one errors in sctp_tsnmap_grow()
      sctp: fix association hangs due to reneging packets below the
cumulative TSN ACK point
      sctp: fix association hangs due to errors when reneging events
from the ordering queue
      sctp: fix association hangs due to partial delivery errors

Li Fei (1):
      regmap: irq: call pm_runtime_put in pm_runtime_get_sync failed case

Li, Zhen-Hua (1):
      iommu, x86: Add DMA remap fault reason

Linus Torvalds (3):
      vfs: don't BUG_ON() if following a /proc fd pseudo-symlink
results in a symlink
      Atmel MXT touchscreen: increase reset timeouts
      Linux 3.9-rc2

Linus Walleij (1):
      ARM: 7642/1: netx: bump IRQ offset to 64

Liu Bo (6):
      Btrfs: check for NULL pointer in updating reloc roots
      Btrfs: build up error handling for merge_reloc_roots
      Btrfs: free all recorded tree blocks on error
      Btrfs: do not BUG_ON in prepare_to_reloc
      Btrfs: do not BUG_ON on aborted situation
      Btrfs: avoid deadlock on transaction waiting list

Lorenzo Colitti (1):
      net: ipv6: Don't purge default router if accept_ra=2

Marek Olšák (1):
      drm/radeon: don't check mipmap alignment if MIP_ADDRESS is FMASK

Marina Makienko (1):
      isdn: hisax: add missing usb_free_urb

Mark Brown (4):
      ASoC: wm8960: Correct register 0 and 1 defaults
      ASoC: wm8960: Fix ADC power bits
      hwmon: (sht15) Check return value of regulator_enable()
      ASoC: wm5102: Apply a SYSCLK patch for later revs

Mark Langsdorf (1):
      mailbox, pl320-ipc: remove __init from probe function

Matt Fleming (2):
      efivars: efivarfs_valid_name() should handle pstore syntax
      efivarfs: return accurate error code in efivarfs_fill_super()

Matthew Garrett (1):
      efi: be more paranoid about available space when creating variables

Mengdong Lin (2):
      ALSA: hda - check NULL pointer when creating SPDIF controls
      ALSA: hda - check NULL pointer when creating SPDIF PCM switch

Miao Xie (2):
      Btrfs: fix wrong handle at error path of create_snapshot() when
the commit fails
      Btrfs: fix unclosed transaction handler when the async
transaction commitment fails

Michael Neuling (4):
      powerpc: Avoid link stack corruption in MMU on syscall entry path
      powerpc: Fix setting FSCR for HV=0 and on secondary CPUs
      powerpc: Add DSCR FSCR register bit definition
      powerpc: Set DSCR bit in FSCR setup

Mika Westerberg (1):
      gpio/gpio-ich: fix ichx_gpio_check_available() return what callers expect

Namhyung Kim (1):
      cpufreq: Fix a typo in comment

Neal Cardwell (1):
      tcp: fix double-counted receiver RTT when leaving receiver fast path

Neil Horman (1):
      ipv[4|6]: correct dropwatch false positive in local_deliver_finish

NeilBrown (6):
      md: fix two bugs when attempting to resize RAID0 array.
      md: raid0: fix error return from create_stripe_zones.
      md/raid0: improve error message when converting RAID4-with-spares to RAID0
      md/raid1,raid10: fix deadlock with freeze_array()
      md: remove CONFIG_MULTICORE_RAID456
      md: expedite metadata update when switching  read-auto -> active

Nishanth Menon (3):
      regulator: core: update kernel documentation for regulator_desc
      regulator: core: fix documentation error in regulator_allow_bypass
      PM / OPP: improve introductory documentation

Patrik Jakobsson (2):
      drm/i915: Fix incorrect definition of ADPA HSYNC and VSYNC bits
      drm/i915: Turn off hsync and vsync on ADPA when disabling crt

Paul Bolle (1):
      drm/tegra: drop "select DRM_HDMI"

Paul Mundt (1):
      metag: Inhibit NUMA balancing.

Paulo Zanoni (2):
      drm/i915: wait_event_timeout's timeout is in jiffies
      drm/i915: also disable south interrupts when handling them

Pavel Shilovsky (1):
      CIFS: Fix missing of oplock_read value in smb30_values structure

Peter Hurley (2):
      ipc: fix potential oops when src msg > 4k w/ MSG_COPY
      ipc: don't allocate a copy larger than max

Peter Jones (1):
      x86, doc: Be explicit about what the x86 struct boot_params requires

Petr Malat (1):
      phy: Fix phy_device_free memory leak

Rafael J. Wysocki (4):
      PM / QoS: Fix concurrency issues and memory leaks in device PM QoS
      PM / QoS: Remove device PM QoS sysfs attributes at the right place
      ACPI / glue: Add .match() callback to struct acpi_bus_type
      ACPI / glue: Drop .find_bridge() callback from struct acpi_bus_type

Randy Dunlap (1):
      Randy has moved

Rusty Russell (1):
      hw_random: make buffer usable in scatterlist.

Sachin Prabhu (2):
      cifs: Fix bug when checking error condition in
cifs_rename_pending_delete()
      cifs: Check server capability before attempting silly rename

Sean Connor (1):
      ALSA: ice1712: Initialize card->private_data properly

Sebastian Riemer (1):
      md: protect against crash upon fsync on ro array

Seth Forshee (1):
      mac80211: Ensure off-channel frames don't get queued

Shawn Guo (1):
      ARM: 7655/1: smp_twd: make twd_local_timer_of_register() no-op for nosmp

Silviu-Mihai Popescu (2):
      caif_dev: fix sparse warnings for caif_flow_cb
      CAIF: fix sparse warning for caif_usb

Simon Que (1):
      eCryptfs: initialize payload_len in keystore.c

Stefan Behrens (1):
      Btrfs: allow running defrag in parallel to administrative tasks

Stephen Boyd (1):
      ARM: 7667/1: perf: Fix section mismatch on armpmu_init()

Stephen Warren (1):
      ASoC: tegra: fix I2S bit count mask

Stéphane Marchesin (1):
      drm/i915: Increase the RC6p threshold.

Syam Sidhardhan (2):
      drm/i915: Fix missing variable initilization
      ACPI / processor: Remove redundant NULL check before kfree

Takashi Iwai (1):
      ALSA: vmaster: Fix slave change notification

Tejun Heo (1):
      idr: remove WARN_ON_ONCE() on negative IDs

Theodore Ts'o (1):
      random: fix locking dependency with the tasklist_lock

Thomas Gleixner (4):
      irq: Ensure irq_exit() code runs with interrupts disabled
      irq: Sanitize invoke_softirq
      Revert "nohz: Make tick_nohz_irq_exit() irq safe"
      stop_machine: Mark per cpu stopper enabled early

Tim Gardner (2):
      eCryptfs: decrypt_pki_encrypted_session_key(): remove kfree()
redundant null check
      ecryptfs: ecryptfs_msg_ctx_alloc_to_free(): remove kfree()
redundant null check

Tony Breeds (2):
      powerpc: Fix compile of sha1-powerpc-asm.S on 32-bit
      powerpc: Wireup the kcmp syscall to sys_ni

Tyler Hicks (3):
      eCryptfs: Fix -Wunused-but-set-variable warnings
      eCryptfs: Fix -Wmissing-prototypes warnings
      eCryptfs: Fix redundant error check on ecryptfs_find_daemon_by_euid()

Ville Syrjälä (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails

Vlastimil Kosar (1):
      net/phy: micrel: Disable asymmetric pause for KSZ9021

Will Deacon (7):
      ARM: 7657/1: head: fix swapper and idmap population with LPAE
and big-endian
      ARM: 7658/1: mm: fix race updating mm->context.id on ASID rollover
      ARM: 7659/1: mm: make mm->context.id an atomic64_t variable
      ARM: 7660/1: tlb: add branch predictor maintenance operations
      ARM: 7661/1: mm: perform explicit branch predictor maintenance
when required
      ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit
      alpha: boot: fix build breakage introduced by system.h disintegration

Xi Wang (1):
      ALSA: hda/ca0132 - Avoid division by zero in dspxfr_one_seg()

Yaniv Rosner (3):
      bnx2x: Fix port identification for the 84834
      bnx2x: Fix KR2 link
      bnx2x: Fix KR2 work-around condition

Yinghai Lu (1):
      x86, mm: Make sure to find a 2M free block for the first mapped area

françois romieu (1):
      r8169: honor jumbo settings when chipset is requested to start.
