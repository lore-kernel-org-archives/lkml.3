Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab3D3PZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:25:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37936 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932956Ab3D3PZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:25:32 -0400
Message-ID: <517FE254.2050504@console-pimps.org>
Date: Tue, 30 Apr 2013 16:25:08 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EFI merge botch fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This first pull request is a merge of v3.9 into f53f292, as requested by
Ingo because I botched the original merge of v3.9-rc8 (which is currently
in tip/x86/efi) by losing the "select UCS2_STRING" line from
drivers/firmware/Kconfig. An equivalent line has been added to arch/ia64
in this merge.

The following changes since commit f53f292eeaa234615c31a1306babe703fc4263f2:

  Merge remote-tracking branch 'efi/chainsaw' into x86/efi (2013-04-20 09:16:44 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git efi-for-tip2

for you to fetch changes up to a614e1923d5389d01f3545ee4a90e39a04d0c90d:

  Merge tag 'v3.9' into efi-for-tip2 (2013-04-30 11:42:13 +0100)

----------------------------------------------------------------

Aaro Koskinen (2):
      ARM: OMAP1: fix USB host on 1710
      ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE

Abhijeet Dharmapurikar (1):
      irqchip: gic: fix irq_trigger return

Adam Jackson (1):
      drm/i915: Be sure to turn hsync/vsync back on at crt enable (v2)

Akinobu Mita (3):
      sparc/srmmu: clear trailing edge of bitmap properly
      sparc/iommu: fix typo s/265KB/256KB/
      GFS2: use memchr_inv

Al Viro (3):
      ecryptfs: close rmmod race
      procfs: add proc_remove_subtree()
      palinfo fixes

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running

Alex Elder (1):
      rbd: do a safe list traversal in rbd_img_request_submit()

Alex Shi (1):
      cpuidle / ACPI: recover percpu ACPI processor cstate

Alex Williamson (1):
      vfio-pci: Fix possible integer overflow

Alexander Clouter (2):
      arm: orion5x: fix orion5x.dtsi gpio parameters
      arm: orion5x: correct IRQ used in dtsi for mv_cesa

Alexander Duyck (1):
      igb: Revert support for build_skb in igb

Alexandre Belloni (1):
      gpio: pca953x: fix irq_domain_add_simple usage

Alexey Khoroshilov (1):
      tty: mxser: fix cycle termination condition in mxser_probe() and mxser_module_init()

Alexey Klimov (2):
      HID: fix Masterkit MA901 hid quirks
      media: radio-ma901: return ENODEV in probe if usb_device doesn't match

Alexey Pelykh (1):
      OMAP/serial: Revert bad fix of Rx FIFO threshold granularity

Alistair Popple (1):
      powerpc: Fix audit crash due to save/restore PPR changes

Amit Shah (2):
      virtio: console: rename cvq_lock to c_ivq_lock
      virtio: console: add locking around c_ovq operations

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use

Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts

Andrea Arcangeli (2):
      x86/mm/cpa: Convert noop to functional fix
      x86/mm/cpa/selftest: Fix false positive in CPA self test

Andreas Schwab (1):
      kbuild: generate generic headers before recursing into scripts

Andrei Epure (1):
      drivers/video/mmp/core.c: fix use-after-free bug

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.

Andrey Vagin (1):
      mnt: release locks on error path in do_loopback

Andy Lutomirski (2):
      userns: Check uid_map's opener's fsuid, not the current fsuid
      userns: Changing any namespace id mappings should require privileges

Antonio Quartulli (1):
      batman-adv: make is_my_mac() check for the current mesh only

Arend van Spriel (2):
      brcmfmac: remove advertising P2P device support
      brcmsmac: request firmware in .start() callback

Ariel Elior (1):
      bnx2x: Fix status blocks configuration

Arnd Bergmann (14):
      Merge tag 'msm-fix-3.9' of git://git.kernel.org/.../davidb/linux-msm into fixes
      Merge tag 'renesas-fbdev-fixes-for-v3.9' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'omap-for-v3.9-rc3/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'ux500-fixes-for-v3.9' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge tag 'imx-fixes-3.9-4' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'ep93xx-fixes-for-3.9-rc5' of git://github.com/RyanMallon/linux-ep93xx into fixes
      Merge tag 'mvebu_fixes_for_v3.9_round2' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'v3.9-rc1_cns3xxx_fixes' of git://git.infradead.org/users/cbou/linux-cns3xxx into fixes
      block: avoid using uninitialized value in from queue_var_store
      Merge tag 'mxs-fixes-3.9-4' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'imx-fixes-3.9-5' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'samsung-fixes-for-v3.9' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'mvebu_fixes_for_v3.9_round3' of git://git.infradead.org/users/jcooper/linux into fixes
      net: ax88796: avoid 64 bit arithmetic

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

Artem Savkov (1):
      cfg80211: sched_scan_mtx lock in cfg80211_conn_work()

Arun Easi (1):
      [SCSI] qla2xxx: Fix crash during firmware dump procedure.

Asai Thambi S P (3):
      mtip32xx: recovery from command timeout
      mtip32xx: return 0 from pci probe in case of rebuild
      mtip32xx: Add debugfs entry device_status

Asias He (7):
      tcm_vhost: Use ACCESS_ONCE for vs->vs_tpg[target] access
      tcm_vhost: Use vq->private_data to indicate if the endpoint is setup
      tcm_vhost: Initialize vq->last_used_idx when set endpoint
      tcm_vhost: Remove double check of response
      tcm_vhost: Fix tv_cmd leak in vhost_scsi_handle_vq
      tcm_vhost: Add vhost_scsi_send_bad_target() helper
      tcm_vhost: Send bad target to guest when cmd fails

Avinash Patil (1):
      mwifiex: reset skb->data after processing PCIe sleep confirm cmd respose

Axel Lin (1):
      ASoC: si476x: Add missing break for SNDRV_PCM_FORMAT_S8 switch case

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after loopback down-up

Bastian Hecht (1):
      ARM: 7697/1: hw_breakpoint: do not use __cpuinitdata for dbg_cpu_pm_nb

Ben Greear (2):
      mac80211: Don't restart sta-timer if not associated.
      net: rate-limit warn-bad-offload splats.

Ben Hutchings (1):
      MIPS: Add dependencies for HAVE_ARCH_TRANSPARENT_HUGEPAGE

Benjamin Tissoires (1):
      HID: magicmouse: fix race between input_register() and probe()

Bing Zhao (1):
      mwifiex: complete last internal scan

Bjorn Helgaas (3):
      Merge branch 'pci/mjg-rom' into for-linus
      Merge branch 'pci/yinghai-eisa' into for-linus
      Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"

Bjørn Mork (4):
      net: cdc_mbim: remove bogus sizeof()
      net: qmi_wwan: fixup missing ethernet header (firmware bug workaround)
      net: qmi_wwan: fixup destination address (firmware bug workaround)
      net: qmi_wwan: prevent duplicate mac address on link (firmware bug workaround)

Bob Peterson (1):
      GFS2: Issue discards in 512b sectors

Boris Ostrovsky (2):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
      x86/mm: Flush lazy MMU when DEBUG_PAGEALLOC is set

Borislav Petkov (2):
      cpufreq: Correct header guards typo
      x86, efi: Fix a build warning

Brian King (1):
      [SCSI] ibmvscsi: Fix slave_configure deadlock

Bryan Freed (1):
      spi: Unlock a spinlock before calling into the controller driver.

Calvin Owens (1):
      drm/nouveau: fix unconditional return waiting on memory

Catalin Marinas (1):
      ARM: 7684/1: errata: Workaround for Cortex-A15 erratum 798181 (TLBI/DSB operations)

Charles Keepax (1):
      ASoC: compress: Cancel delayed power down if needed

Chen Gang (3):
      perf: Fix strncpy() use, always make sure it's NUL terminated
      perf: Fix strncpy() use, use strlcpy() instead of strncpy()
      ftrace: Fix strncpy() use, use strlcpy() instead of strncpy()

Chris Metcalf (2):
      tile: expect new initramfs name from hypervisor file system
      tile: comment assumption about __insn_mtspr for <asm/irqflags.h>

Christian Ruppert (2):
      ARC: Add implicit compiler barrier to raw_local_irq* functions
      stmmac: prevent interrupt loop with MMC RX IPC Counter

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems

Christoph Paasch (4):
      e1000: ethtool: Add missing dma_mapping_error-call in e1000_setup_desc_rings
      ixgb: Add missing dma_mapping_error-call in ixgb_alloc_rx_buffers
      e1000e: Add missing dma_mapping_error-call in e1000_alloc_jumbo_rx_buffers
      ipv6/tcp: Stop processing ICMPv6 redirect messages

Christopher Harvey (1):
      drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal.

Chuck Lever (1):
      SUNRPC: Remove extra xprt_put()

Colin Ian King (1):
      iwlegacy: 4965-rs: avoid null pointer dereference error

Cong Wang (1):
      ipv6: statically link register_inet6addr_notifier()

Dan Carpenter (1):
      irda: small read past the end of array in debug code

Dan Williams (1):
      libertas: drop maintainership

Daniel Vetter (3):
      drm/i915: duct-tape locking when eDP init fails
      drm: don't unlock in the addfb error paths
      drm/fb-helper: Fix locking in drm_fb_helper_hotplug_event

Darrick J. Wong (1):
      dm cache: fix writes to cache device in writethrough mode

Dave Airlie (4):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      udl: handle EDID failure properly.

Dave Hansen (1):
      x86-32: Fix possible incomplete TLB invalidate with PAE pagetables

David Daney (2):
      MIPS: Fix logic errors in bitops.c
      MIPS: Unbreak function tracer for 64-bit kernel.

David Henningsson (1):
      ALSA: hda - fix typo in proc output

David Howells (1):
      Fix breakage in MIPS siginfo handling

David S. Miller (20):
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net
      Merge branch 'fixes-for-3.9' of git://gitorious.org/linux-can/linux-can
      Merge branch 'wireless'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless into wireless
      Merge branch 'master' of git://1984.lsi.us.es/nf
      Merge branch 'infoleaks'
      Merge branch 'wireless'
      Merge branch 'fixes-for-3.9' of git://gitorious.org/linux-can/linux-can
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf into netfilter
      Merge branch 'fixes-for-3.9' of git://gitorious.org/linux-can/linux-can
      Merge branch 'fixes' of git://git.kernel.org/.../jesse/openvswitch
      Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'qlogic'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf
      sparc64: Fix race in TLB batch processing.
      Merge branch 'bonding'
      Merge branch 'qmi_wwan'
      sparc64: Fix missing put_cpu_var() in tlb_batch_add_one() when not batching.

David Teigland (1):
      GFS2: use kmalloc for lvb bitmap

David Ward (1):
      net/802/mrp: fix possible race condition when calling mrp_pdu_queue()

David Woodhouse (1):
      libata: fix DMA to stack in reading devslp_timing parameters

Deng-Cheng Zhu (1):
      MIPS: Fix ISA level which causes secondary cache init bypassing and more

Dimitris Papastamos (1):
      regmap: Initialize `map->debugfs' before regcache

Dirk Behme (1):
      ARM i.MX6: Fix ldb_di clock selection

Dirk Brandewie (1):
      cpufreq / intel_pstate: Set timer timeout correctly

Dmitry Kravkov (2):
      line up comment for ndo_bridge_getlink
      bnx2x: Prevent UNDI FW illegal host access

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under synflood

Dmitry Tarnyagin (1):
      remoteproc/ste: fix memory leak on shutdown

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Emmanuel Grumbach (3):
      iwlwifi: fix length check in multi-TB HCMD
      iwlwifi: set rfkill in internal state of the transport
      iwlwifi: dvm: don't send HCMD in restart flow

Eric Dumazet (6):
      aoe: reserve enough headroom on skbs
      net: add a synchronize_net() in netdev_rx_handler_unregister()
      selinux: add a skb_owned_by() hook
      net: drop dst before queueing fragments
      bonding: fix l23 and l34 load balancing in forwarding path
      tcp: call tcp_replace_ts_recent() from tcp_ack()

Eric Hutter (1):
      ARM: kirkwood: Fix chip-delay for GoFlex Net

Eric W. Biederman (3):
      Revert "af_unix: dont send SCM_CREDENTIAL when dest socket is NULL"
      af_unix: If we don't care about credentials coallesce all messages
      userns: Don't let unprivileged users trick privileged users into setting the id_map

EunBong Song (1):
      MIPS: Fix build error cavium-octeon without CONFIG_SMP

Felix Fietkau (2):
      ath9k_htc: accept 1.x firmware newer than 1.3
      ath9k_hw: change AR9580 initvals to fix a stability issue

Florian Fainelli (1):
      MIPS: Fix code generation for non-DSP capable CPUs

Florian Westphal (2):
      netfilter: nf_nat: fix race when unloading protocol modules
      netfilter: xt_rpfilter: skip locally generated broadcast/multicast, too

Frank Li (1):
      enet: fec: fix fail resume from suspend state

Franky Lin (1):
      brcmfmac: do not proceed if fail to download nvram to dongle

Gabor Juhos (2):
      MIPS: Use CONFIG_CPU_MIPSR2 in csum_partial.S
      rt2x00: rt2x00pci: fix build error on Ralink RT3x5x SoCs

Gabriel Fernandez (1):
      gpio: stmpe: pass DT node to irqdomain

Gao feng (1):
      netfilter: reset nf_trace in nf_reset

Girish K S (1):
      spi/s3c64xx: modified error interrupt handling and init

Grazvydas Ignotas (1):
      ARM: OMAP3: hwmod data: keep MIDLEMODE in force-standby for musb

Greg Rose (1):
      ixgbe: Fix a bug in setting VF VLAN via PF

Greg Ungerer (1):
      m68k: define a local gpio_request_one() function

Gregory CLEMENT (2):
      arm: mvebu: Use local interrupt only for the timer 0
      arm: mvebu: Fix the irq map function in SMP mode

Guennadi Liakhovetski (1):
      tty: Documentation: fix a path in a DocBook template

Guenter Roeck (1):
      misc/vmw_vmci: Add dependency on CONFIG_NET

H Hartley Sweeten (1):
      ARM: ep93xx: Fix wait for UART FIFO to be empty

H. Peter Anvin (3):
      x86, microcode: Verify the family before dispatching microcode patching
      Merge remote-tracking branch 'efi/urgent' into x86/urgent
      Merge tag 'efi-urgent' into x86/urgent

Haiyang Zhang (2):
      hyperv: Fix a kernel warning from netvsc_linkstatus_callback()
      hyperv: Fix RNDIS send_completion code path

Hannes Frederic Sowa (3):
      ipv6: don't accept node local multicast traffic from the wire
      atl1e: drop pci-msi support because of packet corruption
      atl1e: limit gso segment size to prevent generation of wrong ip length fields

Hans Verkuil (1):
      [media] cx25821: do not expose broken video output streams

Hante Meuleman (3):
      brcmfmac: fix tkip mic tx/rx ap swap bug.
      brcmfmac: fix stopping AP.
      brcmfmac: fix returning cipher_suite for get_key operation.

Heiko Carstens (4):
      drivers/Kconfig: add several missing GENERIC_HARDIRQS dependencies
      s390/uaccess: fix clear_user_pt()
      s390/uaccess: fix page table walk
      s390/mm: provide emtpy check_pgt_cache() function

Helge Deller (1):
      parisc: disable -mlong-calls compiler option for kernel modules

Himanshu Madhani (1):
      qlcnic: fix beaconing test for 82xx adapter

Hong Zhiguo (1):
      openvswitch: correct an invalid BUG_ON

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Iestyn C. Elfick (1):
      b43: A fix for DMA transmission sequence errors

Ilija Hadzic (1):
      drm: correctly restore mappings if drm_open fails

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon

Ivan Vecera (1):
      be2net: take care of __vlan_put_tag return value

J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths

Jakub Kicinski (1):
      ixgbe: fix registration order of driver and DCA nofitication

Jan Beulich (1):
      x86: Fix rebuild with EFI_STUB enabled

Jan Kara (1):
      reiserfs: Fix warning and inode leak when deleting inode with xattrs

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()

Jason Gerecke (2):
      Input: wacom - fix "can not retrieve extra class descriptor" for 24HDT
      Input: wacom - correct reported resolution for Intuos4 Wireless

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources

Jean Delvare (1):
      gpio-ich: Fix value returned by ichx_gpio_request

Jens Axboe (2):
      mtip32xx: fix two smatch warnings
      Revert "loop: cleanup partitions when detaching loop device"

Jesse Gross (1):
      openvswitch: Preallocate reply skb in ovs_vport_cmd_set().

Jingoo Han (1):
      fbmon: use VESA_DMT_VSYNC_HIGH to fix typo

Jiri Kosina (1):
      Merge tag v3.9-rc1 into for-3.9/upstream-fixes

Jiri Pirko (3):
      net: ipv4: notify when address lifetime changes
      net: ipv4: reset check_lifetime_work after changing lifetime
      net: ipv4: fix schedule while atomic bug in check_lifetime()

Jiri Slaby (2):
      ALSA: hda/generic - fix uninitialized variable
      TTY: fix atime/mtime regression

Jitendra Kalsaria (3):
      qlcnic: Stop traffic before performing loopback test
      qlge: Fix ethtool autoneg advertising.
      qlge: Update version to 1.00.00.32.

Joe Carnuccio (1):
      [SCSI] Revert "qla2xxx: Add setting of driver version string for vendor application."

Joe Lawrence (1):
      [SCSI] st: Take additional queue ref in st_probe

Joe Perches (2):
      ASoC:: max98090: Remove executable bit
      checkpatch: fix stringification macro defect

Johan Hovold (1):
      Revert "drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR"

Johannes Berg (11):
      mac80211: always synchronize_net() during station removal
      cfg80211: fix potential BSS memory leak and update
      mac80211: fix crash with P2P Device returning action frames
      cfg80211: fix wdev tracing crash
      mac80211: fix virtual monitor interface locking
      cfg80211: always check for scan end on P2P device
      mac80211: fix remain-on-channel cancel crash
      mac80211: fix idle handling sequence
      iwlwifi: dvm: fix the passive-no-RX workaround
      mac80211: fix LED in idle handling
      mac80211: fix cfg80211 interaction on auth/assoc request

John Crispin (1):
      MIPS: Fix inconsistent formatting inside /proc/cpuinfo

John David Anglin (3):
      parisc: Provide __ucmpdi2 to resolve undefined references in 32 bit builds.
      parisc: Change kunmap macro to static inline function
      parisc: use spin_lock_irqsave/spin_unlock_irqrestore for PTE updates

John Gong (1):
      [SCSI] libsas: use right function to alloc smp response

John W. Linville (13):
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Revert "brcmsmac: support 4313iPA"
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge tag 'nfc-fixes-3.9-2' of git://git.kernel.org/.../sameo/nfc-fixes
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'for-john' of git://x-git.kernel.org/.../jberg/mac80211
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Jon Hunter (1):
      ARM: OMAP4: clock data: lock USB DPLL on boot

Jonas Gorski (3):
      spi/bcm63xx: don't disable non enabled clocks in probe error path
      MIPS: BCM63XX: Make nvram checksum failure non fatal
      Revert "MIPS: BCM63XX: Call board_register_device from device_initcall()"

Joonsoo Kim (1):
      ARM: 7694/1: ARM, TCM: initialize TCM in paging_init(), instead of setup_arch()

Joonyoung Shim (1):
      ASoC: core: Fix to check return value of snd_soc_update_bits_locked()

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay

Joseph CHANG (1):
      DM9000B: driver initialization upgrade

Josh Boyer (1):
      efi: Check EFI revision in setup_efi_vars

Josh Wu (1):
      avr32: fix build error in atstk1006_defconfig

Jozsef Kadlecsik (3):
      netfilter: ipset: list:set: fix reference counter update
      netfilter: ipset: hash:*net*: nomatch flag not excluded on set resize
      netfilter: ipset: bitmap:ip,mac: fix listing with timeout

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment

K. Y. Srinivasan (1):
      x86, hyperv: Handle Xen emulation of Hyper-V more gracefully

Kees Cook (1):
      tg3: fix length overflow in VPD firmware parsing

Kefeng Wang (2):
      sparc:remove unused declaration smp_boot_cpus()
      sparc:cleanup unused code in smp_32.h

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Kevin Cernekee (1):
      spi/bcm63xx: Remove unused variable

Kevin Hao (1):
      powerpc: add a missing label in resume_kernel

Kishon Vijay Abraham I (1):
      ARM: OMAP4: hwmod data: make 'ocp2scp_usb_phy_phy_48m" as the main clock

Kleber Sacilotto de Souza (1):
      [SCSI] ipr: fix addition of abort command to HRRQ free queue

Konrad Rzeszutek Wilk (1):
      xen/mmu: On early bootup, flush the TLB when changing RO->RW bits Xen provided pagetables.

Konstantin Khlebnikov (1):
      PCI: Don't try to disable Bus Master on disconnected PCI devices

Krzysztof Mazur (1):
      [libata] Fix HDIO_DRIVE_* ioctl() Linux 3.9 regression

Kuninori Morimoto (1):
      fbdev: sh_mobile_lcdc: fixup B side hsync adjust settings

Lars-Peter Clausen (4):
      regmap: cache Fix regcache-rbtree sync
      ASoC: spear_pcm: Update to new pcm_new() API
      ASoC: dma-sh7760: Fix compile error
      ASoC: tegra: Don't claim to support PCM pause and resume

Lauri Kasanen (1):
      drm/i915: Fix build failure

Laxman Dewangan (1):
      spi: slink-tegra20: move runtime pm calls to transfer_one_message

Lee Jones (3):
      ARM: ux500: Apply the TCPM and TCDM locations and sizes to dbx5x0 DT
      ARM: ux500: Stop passing ios_handler() as an MMCI power controlling call-back
      ARM: ux500: Enable the clock controlling Ethernet on Snowball

Len Brown (2):
      intel_idle: additional Haswell CPU-id
      tools/power turbostat: additional Haswell CPU-id

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path

Li RongQing (1):
      net: fix the use of this_cpu_ptr

Linus Torvalds (111):
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'stable' of git://git.kernel.org/.../cmetcalf/linux-tile
      Merge tag 'for-3.9-rc' of git://git.kernel.org/.../rwlove/fcoe
      Merge tag 'clk-fixes-for-linus' of git://git.linaro.org/people/mturquette/linux
      Merge tag 'fixes-for-linus' of git://git.kernel.org/.../rusty/linux
      Merge branch 'for-3.9' of git://linux-nfs.org/~bfields/linux
      Merge tag 'fixes' of git://git.kernel.org/.../arm/arm-soc
      Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
      Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
      Merge tag 'regmap-v3.9-rc4' of git://git.kernel.org/.../broonie/regmap
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-linus' of git://git.kernel.org/.../s390/linux
      Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-fs
      Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/.../tytso/ext4
      Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
      Merge tag 'gpio-fixes-v3.9' of git://git.kernel.org/.../linusw/linux-gpio
      Merge branch 'for-linus' of git://git.kernel.org/.../jikos/hid
      Merge tag 'upstream-3.9-rc6' of git://git.infradead.org/linux-ubifs
      Merge tag 'pm+acpi-3.9-rc6' of git://git.kernel.org/.../rafael/linux-pm
      Merge tag 'sound-3.9' of git://git.kernel.org/.../tiwai/sound
      Merge tag 'fbdev-fixes-3.9-rc6' of git://gitorious.org/linux-omap-dss2/linux
      Merge tag 'spi-fix-v3.9-rc5' of git://git.kernel.org/.../broonie/misc
      Merge git://git.kernel.org/.../steve/gfs2-3.0-fixes
      Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'pci-v3.9-fixes-1' of git://git.kernel.org/.../helgaas/pci
      Merge tag 'dm-3.9-fixes-2' of git://git.kernel.org/.../agk/linux-dm
      Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/.../tip/tip
      Merge git://git.kernel.org/pub/scm/virt/kvm/kvm
      Linux 3.9-rc6
      Merge tag 'trace-fixes-3.9-rc6' of git://git.kernel.org/.../rostedt/linux-trace
      Merge tag 'upstream-linus' of git://git.kernel.org/.../jgarzik/libata-dev
      Merge tag 'for-linus' of git://git.kernel.org/.../sfr/next-fixes
      Merge tag 'remoteproc-3.9-fixes' of git://git.kernel.org/.../ohad/remoteproc
      Merge tag 'hwspinlock-3.9-fix' of git://git.kernel.org/.../ohad/hwspinlock
      spinlocks and preemption points need to be at least compiler barriers
      Merge tag 'for-linus-20130409' of git://git.kernel.dk/linux-block
      Merge tag 'vfio-v3.9-rc7' of git://github.com/awilliam/linux-vfio
      Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs
      Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
      Merge git://git.kernel.org/.../herbert/crypto-2.6
      Merge tag 'nfs-for-3.9-4' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
      Merge tag 'nfs-for-3.9-5' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
      Merge tag 'for-linus' of git://linux-c6x.org/git/projects/linux-c6x-upstreaming
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'trace-fixes-3.9-rc-v2' of git://git.kernel.org/.../rostedt/linux-trace
      Merge tag 'stable/for-linus-3.9-rc6-tag' of git://git.kernel.org/.../konrad/xen
      Merge tag 'tty-3.9-rc6' of git://git.kernel.org/.../gregkh/tty
      Merge tag 'char-misc-3.9-rc6' of git://git.kernel.org/.../gregkh/char-misc
      Merge tag 'arm-soc-fixes' of git://git.kernel.org/.../arm/arm-soc
      Merge tag 'gpio-fixes-v3.9-rc6' of git://git.kernel.org/.../linusw/linux-gpio
      Merge tag 'regmap-v3.9-rc6' of git://git.kernel.org/.../broonie/regmap
      Merge tag 'pm-3.9-rc7' of git://git.kernel.org/.../rafael/linux-pm
      Merge branch 'fixes' of git://git.infradead.org/users/vkoul/slave-dma
      Merge tag 'sound-3.9' of git://git.kernel.org/.../tiwai/sound
      Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
      Merge tag 'scsi-fixes' of git://git.kernel.org/.../jejb/scsi
      Merge git://git.kernel.org/.../nab/target-pending
      kobject: fix kset_find_obj() race with concurrent last kobject_put()
      Add file_ns_capable() helper function for open-time capability checking
      Merge tag 'trace-fixes-v3.9-rc-v3' of git://git.kernel.org/.../rostedt/linux-trace
      Merge branch 'for-linus' of git://git.kernel.org/.../mason/linux-btrfs
      Merge git://www.linux-watchdog.org/linux-watchdog
      Merge branch 'for-linus' of git://git.kernel.org/.../gerg/m68knommu
      Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
      Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/.../tip/tip
      Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/.../tip/tip
      Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/.../tip/tip
      Linux 3.9-rc7
      Merge branches 'timers-urgent-for-linus', 'irq-urgent-for-linus' and 'core-urgent-for-linus' of git://git.kernel.org/.../tip/tip
      vm: add vm_iomap_memory() helper function
      Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input
      Merge branch 'rc-fixes' of git://git.kernel.org/.../mmarek/kbuild
      Merge tag 'for-linus' of git://git.kernel.org/.../sfr/next-fixes
      Merge git://git.kernel.org/pub/scm/virt/kvm/kvm
      Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-linus' of git://git.kernel.org/.../sage/ceph-client
      Merge branch 'akpm' (fixes from Andrew)
      Merge branch 'release' of git://git.kernel.org/.../lenb/linux
      Revert "block: add missing block_bio_complete() tracepoint"
      Merge branch 'for_linus' of git://cavan.codon.org.uk/platform-drivers-x86
      Merge branch 'userns-fixes' of git://git.kernel.org/.../luto/linux
      Merge branch 'for-linus' of git://git.kernel.org/.../mszeredi/fuse
      Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input
      vm: convert HPET mmap to vm_iomap_memory() helper
      vm: convert mtdchar mmap to vm_iomap_memory() helper
      vm: convert fb_mmap to vm_iomap_memory() helper
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
      mtdchar: remove no-longer-used vma helpers
      Merge tag 'fixes-for-linus' of git://git.kernel.org/.../arm/arm-soc
      net: fix incorrect credentials passing
      Merge git://git.kernel.org/.../davem/net
      Merge git://git.kernel.org/.../davem/sparc
      Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
      Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/.../tip/tip
      Merge branch 'x86-kdump-for-linus' of git://git.kernel.org/.../tip/tip
      Merge branch 'vm_ioremap_memory-examples'
      Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/.../tip/tip
      Linux 3.9-rc8
      Merge git://git.kernel.org/.../herbert/crypto-2.6
      Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
      Merge tag 'gpio-v3.9-lastminute' of git://git.kernel.org/.../linusw/linux-gpio
      Merge git://git.kernel.org/.../davem/sparc
      Merge branch 'fixes-3.9-late' of git://git.kernel.org/.../deller/parisc-linux
      Merge branch 'v4l_for_linus' of git://git.kernel.org/.../mchehab/linux-media
      Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/.../tip/tip
      vm: add no-mmu vm_iomap_memory() stub
      Merge tag 'fixes-for-linus' of git://git.kernel.org/.../arm/arm-soc
      Linux 3.9

Linus Walleij (2):
      crypto: ux500 - add missing comma
      Revert "gpio: pxa: set initcall level to module init"

Lucas Stach (1):
      net: fec: fix regression in link change accounting

Ludovic Desroches (1):
      dmaengine: at_hdmac: fix race condition in atc_advance_work()

Luis R. Rodriguez (1):
      ath9k: avoid queueing hw check work when suspended

Lukasz Dorau (1):
      [SCSI] libsas: fix handling vacant phy in sas_set_ex_phy()

Maarten Lankhorst (2):
      drm/nouveau: fix handling empty channel list in ioctl's
      drm/nouveau: fix NULL ptr dereference from nv50_disp_intr()

Mac Lin (1):
      ARM: cns3xxx: fix mapping of private memory region

Manish Chopra (1):
      MAINTAINERS: Update netxen_nic maintainers list

Marc Kleine-Budde (3):
      can: sja1000: fix define conflict on SH
      can: sja1000: limit PEAK PCAN-PC Card to HAS_IOPORT
      can: mcp251x: add missing IRQF_ONESHOT to request_threaded_irq

Marc Zyngier (5):
      ARM: KVM: vgic: force EOIed LRs to the empty state
      ARM: KVM: vgic: take distributor lock on sync_hwstate path
      ARM: KVM: fix KVM_CAP_ARM_SET_DEVICE_ADDR reporting
      ARM: KVM: fix L_PTE_S2_RDWR to actually be Read/Write
      ARM: KVM: fix unbalanced get_cpu() in access_dcsw

Marcelo Tosatti (1):
      Merge branch 'kvm-arm-fixes-3.9' of git://github.com/columbia/linux-kvm-arm

Marek Vasut (1):
      ARM: mxs: Slow down the I2C clock speed

Mark Brown (21):
      ASoC: dapm: Fix handling of loops
      Merge remote-tracking branch 'asoc/fix/adsp' into asoc-next
      Merge remote-tracking branch 'asoc/fix/core' into asoc-next
      Merge remote-tracking branch 'asoc/fix/dapm' into asoc-next
      Merge remote-tracking branch 'asoc/fix/fsl' into asoc-next
      Merge remote-tracking branch 'asoc/fix/max98090' into asoc-next
      Merge remote-tracking branch 'asoc/fix/sh' into asoc-next
      Merge remote-tracking branch 'asoc/fix/si476x' into asoc-next
      Merge remote-tracking branch 'asoc/fix/spear' into asoc-next
      regmap: async: Add missing return
      Merge remote-tracking branch 'regmap/fix/cache' into tmp
      Merge remote-tracking branch 'regmap/fix/core' into tmp
      Merge remote-tracking branch 'regmap/fix/async' into tmp
      ASoC: wm5102: Correct lookup of arizona struct in SYSCLK event
      regmap: Back out work buffer fix
      Merge remote-tracking branch 'asoc/fix/compress' into tmp
      Merge remote-tracking branch 'asoc/fix/core' into tmp
      Merge remote-tracking branch 'asoc/fix/samsung' into tmp
      Merge remote-tracking branch 'asoc/fix/tegra' into tmp
      Merge remote-tracking branch 'asoc/fix/wm8903' into tmp
      MAINTAINERS: Update e-mail address

Mark Salter (1):
      add memory barrier to arch_local_irq_restore

Markus Pargmann (3):
      ASoC: pcm030 audio fabric: remove __init from probe
      ARM: clk-imx35: Bugfix iomux clock
      ARM: imx35 Bugfix admux clock

Martin Schwidefsky (1):
      s390/3270: fix minor_start issue

Masami Hiramatsu (1):
      kprobes: Fix a double lock bug of kprobe_mutex

Mathias Krause (18):
      xfrm: Fix esn sequence number diff calculation in xfrm_replay_notify_esn()
      atm: update msg_namelen in vcc_recvmsg()
      ax25: fix info leak via msg_name in ax25_recvmsg()
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
      Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_recvmsg()
      Bluetooth: SCO - Fix missing msg_namelen update in sco_sock_recvmsg()
      caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
      irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
      l2tp: fix info leak in l2tp_ip6_recvmsg()
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
      netrom: fix info leak via msg_name in nr_recvmsg()
      NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      tipc: fix info leaks via msg_name in recv_msg/recv_stream
      VSOCK: vmci - fix possible info leak in vmci_transport_dgram_dequeue()
      VSOCK: Fix missing msg_namelen update in vsock_stream_recvmsg()
      crypto: algif - suppress sending source address information in recvmsg

Matt Fleming (3):
      x86, efivars: firmware bug workarounds should be in platform code
      efivars: only check for duplicates on the registered list
      Merge tag 'v3.9' into efi-for-tip2

Matthew Garrett (7):
      PCI: Add PCI ROM helper for platform-provided ROM images
      nouveau: Attempt to use platform-provided ROM image
      radeon: Attempt to use platform-provided ROM image
      Move utf16 functions to kernel core and rename
      efi: Pass boot services variable info to runtime code
      efi: Distinguish between "remaining space" and actually used space
      Revert "hp-wmi: Add support for SMBus hotkeys"

Matthias Schiffer (1):
      netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix lengths

Mauro Carvalho Chehab (1):
      [media] mb86a20s: Fix estimate_rate setting

Max.Nekludov@us.elster.com (1):
      ks8851: Fix interpretation of rxlen field.

Mengdong Lin (2):
      ALSA: hda - bug fix on return value when getting HDMI ELD info
      ALSA: hda - bug fix on HDMI ELD debug message

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP

Michael Neuling (1):
      powerpc: fix compiling CONFIG_PPC_TRANSACTIONAL_MEM when CONFIG_ALTIVEC=n

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header length

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test

Mike Marciniszyn (1):
      firmware,IB/qib: revert firmware file move

Mike Snitzer (1):
      dm cache: reduce bio front_pad size in writeback mode

Miklos Szeredi (1):
      fuse: fix type definitions in uapi header

Mirko Lindner (2):
      sky2: Receive Overflows not counted
      sky2: Threshold for Pause Packet is set wrong

Mugunthan V N (3):
      drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting tx queue
      drivers: net: ethernet: davinci_emac: use netif_wake_queue() while restarting tx queue
      drivers: net: ethernet: cpsw: get slave VLAN id from slave node instead of cpsw node

Namhyung Kim (2):
      tracing: Fix double free when function profile init failed
      tracing: Fix possible NULL pointer dereferences

Naoya Horiguchi (3):
      hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)
      fs/binfmt_elf.c: fix hugetlb memory check in vma_dump_size()
      hugetlbfs: add swap entry check in follow_hugetlb_page()

Neil Horman (1):
      e100: Add dma mapping error check

Nicholas Bellinger (1):
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs

Nicolas Dichtel (1):
      af_key: initialize satype in key_notify_policy_flush()

Nicolas Ferre (1):
      watchdog: Revert the AT91RM9200_WATCHDOG dependency

Nigel Roberts (2):
      ARM: Kirkwood: Fix typo in the definition of ix2-200 rebuild LED
      Fix GE0/GE1 init on ix2-200 as GE0 has no PHY

Oleg Nesterov (1):
      thinkpad-acpi: kill hotkey_thread_mutex

Olof Johansson (1):
      Merge tag 'omap-for-v3.9-rc6/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_acct: return -EINVAL if object name is empty

Padmavathi Venna (1):
      DMA: PL330: Add check if device tree compatible

Paolo Pisati (1):
      cpufreq: check OF node /cpus presence before dereferencing it

Patrick McHardy (2):
      netfilter: don't reset nf_trace in nf_reset()
      netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet

Paul Bolle (4):
      MIPS: Get rid of CONFIG_CPU_HAS_LLSC again
      ARM: 7690/1: mm: fix CONFIG_LPAE typos
      MIPS: Alchemy: Fix typo "CONFIG_DEBUG_PCI"
      MIPS: Kconfig: Rename SNIPROM too

Paul E. McKenney (1):
      events: Protect access via task_subsys_state_check()

Paul Moore (2):
      x86: remove the x32 syscall bitmask from syscall_get_nr()
      lsm: add the missing documentation for the security_skb_owned_by() hook

Paul Walmsley (1):
      ARM: OMAP4: PM: fix PM regression introduced by recent clock cleanup

Peter Ujfalusi (2):
      ASoC: dapm: Fix pointer dereference in is_connected_output_ep()
      dmaengine: omap-dma: Start DMA without delay for cyclic channels

Ping Cheng (2):
      Input: wacom - DTH2242 Grip Pen id was off by one bit
      Input: wacom - fix "can not retrieve extra class descriptor" for DTH2242

Prathyush K (2):
      ASoC: Samsung: return error if drvdata is not set
      ASoC: Samsung: set drvdata before adding secondary device

Rabin Vincent (1):
      ARM: 7689/1: add unwind annotations to ftrace asm

Rafael J. Wysocki (8):
      USB / PM: Don't try to hide PM QoS flags from usb_port_device_release()
      PM / QoS: Avoid possible deadlock related to sysfs access
      ACPI / SPI: Use parent's ACPI_HANDLE() in acpi_register_spi_devices()
      ACPI / I2C: Use parent's ACPI_HANDLE() in acpi_i2c_register_devices()
      PCI/ACPI: Always resume devices on ACPI wakeup notifications
      PCI/PM: Disable runtime PM of PCIe ports
      Merge branch 'acpi-fixes' into fixes
      Merge branch 'pm-fixes' into fixes

Rafał Miłecki (3):
      b43: N-PHY: increase initial value of "mind" in RSSI calibration
      b43: N-PHY: use more bits for offset in RSSI calibration
      ssb: implement spurious tone avoidance

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec

Rajagopal Venkat (1):
      PM / devfreq: Fix compiler warnings for CONFIG_PM_DEVFREQ unset

Rajendra Nayak (1):
      ARM: OMAP: clocks: Delay clk inits atleast until slab is initialized

Ralf Baechle (4):
      MIPS: compat: Return same error ENOSYS as native for invalid operation.
      MIPS: SEAD3: Enable LL/SC.
      MIPS: Delete definition of SA_RESTORER.
      Revert "MIPS: page.h: Provide more readable definition for PAGE_MASK."

Reilly Grant (1):
      VSOCK: Handle changes to the VMCI context ID.

Richard Weinberger (2):
      x86,efi: Check max_size only if it is non-zero.
      x86,efi: Implement efi_no_storage_paranoia parameter

Rob Herring (4):
      net: calxedaxgmac: fix rx ring handling when OOM
      net: calxedaxgmac: Wake-on-LAN fixes
      ARM: 7682/1: cache-l2x0: fix masking of RTL revision numbering and set_debug init
      ARM: highbank: fix cache flush ordering for cpu hotplug

Robert Love (5):
      bnx2fc: Make the fcoe_cltr the SCSI host parent
      fcoe: Fix deadlock between create and destroy paths
      libfc, fcoe, bnx2fc: Always use fcoe_disc_init for discovery layer initialization
      libfc, fcoe, bnx2fc: Split fc_disc_init into fc_disc_{init, config}
      libfcoe: Fix fcoe_sysfs VN2VN mode

Robert Shade (1):
      ath9k: Re-enable interrupts after a channel change failure

Robert Tivy (1):
      remoteproc: fix FW_CONFIG typo

Roland Stigge (1):
      MAINTAINERS: Add maintainer for LPC32xx

Russell King (4):
      Merge branch 'kvm-arm/vgic-fixes' of git://git.kernel.org/.../maz/arm-platforms into fixes
      ARM: iWMMXt: always enable iWMMXt support with PJ4 CPUs
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support) properly
      Merge branch 'for-rmk/740t' of git://git.kernel.org/.../will/linux into fixes

Rusty Russell (1):
      kernel/hz.bc: ignore.

Ryan Press (1):
      arm: mvebu: Fix pinctrl for Armada 370 Mirabox SDIO port.

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor

Sam Ravnborg (3):
      sparc: use generic headers
      bbc_i2c: fix section mismatch warning
      sparc: use asm-generic version of types.h

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Samuel Ortiz (3):
      NFC: llcp: Detach socket from process context only when releasing the socket
      NFC: llcp: Keep the connected socket parent pointer alive
      NFC: microread: Fix build failure due to a new MEI bus API

Santosh Shilimkar (1):
      ARM: 7681/1: hw_breakpoint: use warn_once to avoid spam from reset_ctrl_regs()

Sascha Hauer (1):
      ASoC: imx-ssi: Fix occasional AC97 reset failure

Satoru Takeuchi (1):
      hw_random: free rng_buffer at module exit

Saurav Kashyap (3):
      [SCSI] qla2xxx: Update copyright dates information in LICENSE.qla2xxx file.
      [SCSI] qla2xxx: Remove debug code that msleeps for random duration.
      [SCSI] qla2xxx: Update the driver version to 8.04.00.13-k.

Scott Wood (4):
      kvm/powerpc/e500mc: fix tlb invalidation on cpu migration
      kvm/ppc/e500: h2g_tlb1_rmap: esel 0 is valid
      kvm/ppc/e500: g2h_tlb1_map: clear old bit before setting new bit
      kvm/ppc/e500: eliminate tlb_refs

Sean Young (1):
      Revert "tty/8250_pnp: serial port detection regression since v3.7"

Sebastian Hesselbarth (1):
      ARM: Kirkwood: fix unused mvsdio gpio pins

Sebastian Ott (1):
      s390/scm_block: fix printk format string

Sergei Shtylyov (3):
      sh_eth: fix handling of no LINK signal
      sh_eth: workaround for spurious ECI interrupt
      sh_eth: make 'link' field of 'struct sh_eth_private' *int*

Sergey Popovich (1):
      sch: add missing u64 in psched_ratecfg_precompute()

Sergey Vlasov (2):
      x86/Kconfig: Make EFI select UCS2_STRING
      efi: Export efi_query_variable_store() for efivars.ko

Shahed Shaikh (1):
      qlcnic: Fix typo in logs

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Shawn Guo (2):
      ARM: imx: fix sync issue between imx_cpu_die and imx_cpu_kill
      ARM: imx: provide twd clock lookup from device tree

Shmulik Ladkani (1):
      net: core: Remove redundant call to 'nf_reset' in 'dev_forward_skb'

Silviu-Mihai Popescu (1):
      ASoC: core: fix invalid free of devm_ allocated data

Sjur BrÃ¦ndeland (1):
      Revert "virtio_console: Initialize guest_connected=true for rproc_serial"

Sjur Brændeland (1):
      remoteproc: fix error path of handle_vdev

Sricharan R (1):
      ARM: 7677/1: LPAE: Fix mapping in alloc_init_section for unaligned addresses

Sridhar Samudrala (1):
      sctp: remove 'sridhar' from maintainers list

Sritej Velaga (2):
      qlcnic: fix TSO race condition
      qlge: Fix receive path to drop error frames

Stanislav Kinsbursky (1):
      ipc: set msg back to -EAGAIN if copy wasn't performed

Stanislaw Gruszka (1):
      sched/cputime: Fix accounting on multi-threaded processes

Stefan Raspl (1):
      qeth: fix qeth_wait_for_threads() deadlock for OSN devices

Steffen Klassert (1):
      xfrm: Fix replay notification for esn.

Stepan Moskovchenko (1):
      ARM: 7678/1: Work around faulty ISAR0 register in some Krait CPUs

Stephane Eranian (3):
      perf/x86: Fix uninitialized pt_regs in intel_pmu_drain_bts_buffer()
      perf: Fix ring_buffer perf_output_space() boundary calculation
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Stephen Boyd (4):
      ARM: 7679/1: Clear IDIVT hwcap if CONFIG_ARM_THUMB=n
      ARM: 7680/1: Detect support for SDIV/UDIV from ISAR0 register
      ARM: msm: Stop counting before reprogramming clockevent
      ARM: 7699/1: sched_clock: Add more notrace to prevent recursion

Stephen Warren (1):
      regmap: don't corrupt work buffer in _regmap_raw_write()

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support

Steven Rostedt (Red Hat) (3):
      tracing: Fix race with update_max_tr_single and changing tracers
      ftrace: Do not call stub functions in control loop
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Steven Whitehouse (1):
      GFS2: Fix unlock of fcntl locks during withdrawn state

Stone Piao (1):
      mwifiex: limit channel number not to overflow memory

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Suman Anna (1):
      remoteproc: fix the error check for idr_alloc

Sylwester Nawrocki (2):
      ARM: S3C24XX: Correct NR_IRQS definition for s3c2440
      ARM: S3C24XX: Fix interrupt pending register offset of the EINT controller

Takashi Iwai (4):
      Merge tag 'asoc-fix-v3.9-rc4' of git://git.kernel.org/.../broonie/sound into for-linus
      Revert "ALSA: hda - Allow power_save_controller option override DCAPS"
      Merge tag 'asoc-v3.9-rc6' of git://git.kernel.org/.../broonie/sound into for-linus
      Merge tag 'asoc-maintainers-v3.9-rc6' of git://git.kernel.org/.../broonie/sound into for-linus

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Thierry Escande (1):
      NFC: llcp: Remove possible double call to kfree_skb

Thierry Reding (1):
      clk: tegra: Allow PLLE training to succeed

Thomas Gleixner (2):
      sched_clock: Prevent 64bit inatomicity on 32bit systems
      kthread: Prevent unpark race which puts threads on the wrong cpu

Thomas Graf (1):
      tcp: Reallocate headroom if it would overflow csum_start

Thomas Petazzoni (1):
      net: mvmdio: add select PHYLIB

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()

Tony Lindgren (1):
      Merge tag 'omap-fixes-a-for-3.9-rc' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9-rc3/fixes

Tony Luck (1):
      ACPI / BGRT: Don't let users configure BGRT on non X86 systems

Torstein Hegge (1):
      ALSA: usb: Work around CM6631 sample rate change bug

Trond Myklebust (5):
      NFSv4: Fix a memory leak in nfs4_discover_server_trunking
      NFSv4/4.1: Fix bugs in nfs4[01]_walk_client_list
      SUNRPC: Fix a potential memory leak in rpc_new_client
      NFSv4: Fix another potential state manager deadlock
      NFSv4: Doh! Typo in the fix to nfs41_walk_client_list

Ursula Braun (1):
      af_iucv: fix recvmsg by replacing skb_pull() function

Vasily Averin (1):
      cbq: incorrect processing of high limits

Veaceslav Falico (2):
      bonding: get netdev_rx_handler_unregister out of locks
      bonding: remove sysfs before removing devices

Vijay Subramanian (1):
      net: fq_codel: Fix off-by-one error

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works properly.

Vladimir Kondratiev (1):
      cfg80211: fix inconsistency in trace for rdev_set_mac_acl

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Wang YanQing (1):
      video:uvesafb: Fix dereference NULL pointer code path

Wei Yongjun (14):
      ASoC: wm_adsp: fix possible memory leak in wm_adsp_load_coeff()
      ASoC: core: fix possible memory leak in snd_soc_bytes_put()
      s390/scm_blk: fix error return code in scm_blk_init()
      netfilter: nfnetlink_queue: fix error return code in nfnetlink_queue_init()
      netfilter: nf_conntrack: fix error return code
      rtnetlink: fix error return code in rtnl_link_fill()
      GFS2: return error if malloc failed in gfs2_rs_alloc()
      netrom: fix invalid use of sizeof in nr_recvmsg()
      can: gw: use kmem_cache_free() instead of kfree()
      [SCSI] lpfc: fix potential NULL pointer dereference in lpfc_sli4_rq_put()
      perf: Fix error return code
      tuntap: fix error return code in tun_set_iff()
      esp4: fix error return code in esp_output()
      pkt_sched: fix error return code in fw_change_attrs()

Will Deacon (11):
      ARM: tlbflush: remove ARMv3 support
      ARM: cache: remove ARMv3 support code
      ARM: mm: fix numerous hideous errors in proc-arm740.S
      ARM: mm: remove broken condition check for v4 flushing
      ARM: modules: don't export cpu_set_pte_ext when !MMU
      ARM: 7685/1: delay: use private ticks_per_jiffy field for timer-based delay ops
      alpha: makefile: don't enforce small data model for kernel builds
      alpha: irq: run all handlers with interrupts disabled
      alpha: irq: remove deprecated use of IRQF_DISABLED
      ARM: 7698/1: perf: fix group validation when using enable_on_exec
      parisc: uaccess: fix compiler warnings caused by __put_user casting

Willy Tarreau (1):
      net: mvneta: fix improper tx queue usage in mvneta_tx()

Xishi Qiu (1):
      mm/vmscan: fix error return in kswapd_run()

Yan Burman (1):
      net/mlx4_en: Fix setting initial MAC address

Yaniv Rosner (1):
      bnx2x: Fix KR2 rapid link flap

Yinghai Lu (6):
      EISA/PCI: Fix bus res reference
      EISA/PCI: Init EISA early, before PNP
      x86, kdump: Set crashkernel_low automatically
      x86, kdump: Retore crashkernel= to allocate under 896M
      x86, kdump: Change crashkernel_high/low= to crashkernel=,high/low
      kexec: use Crash kernel for Crash kernel low

Yoichi Yuasa (1):
      MIPS: VR4133: Fix probe for LL/SC.

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms

Yuval Mintz (1):
      bnx2x: Prevent null pointer dereference in AFEX mode

Zefir Kurtisi (1):
      ath9k: fix DFS detector called in softirq context

Zhao Hongjiang (1):
      aio: fix possible invalid memory access when DEBUG is enabled

Zheng Liu (1):
      ext4: fix big-endian bugs which could cause fs corruptions

hayeswang (1):
      r8169: fix auto speed down issue

libin (1):
      sched/debug: Fix sd->*_idx limit range avoiding overflow

nikolay@redhat.com (10):
      bonding: fix disabling of arp_interval and miimon
      Revert "bonding: remove sysfs before removing devices"
      bonding: fix bonding_masters race condition in bond unloading
      bonding: fix netdev event NULL pointer dereference
      bonding: IFF_BONDING is not stripped on enslave failure
      bonding: mc addresses don't get deleted on enslave failure
      bonding: vlans don't get deleted on enslave failure
      bonding: primary_slave & curr_active_slave are not cleaned on enslave failure
      bonding: disable netpoll on enslave failure
      bonding: in bond_mc_swap() bond's mc addr list is walked without lock

stephen hemminger (1):
      bridge: make user modified path cost sticky

wenxiong@linux.vnet.ibm.com (2):
      [SCSI] ipr: ipr_test_msi() fails when running with msi-x enabled adapter
      [SCSI] ipr: dlpar failed when adding an adapter back

willy tarreau (1):
      net: mvneta: enable features before registering the driver

 Documentation/DocBook/device-drivers.tmpl          |    2 +-
 Documentation/kernel-parameters.txt                |   29 +-
 Documentation/scsi/LICENSE.qla2xxx                 |    2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt    |    5 +-
 MAINTAINERS                                        |   19 +-
 Makefile                                           |    5 +-
 arch/alpha/Makefile                                |    2 +-
 arch/alpha/include/asm/floppy.h                    |    2 +-
 arch/alpha/kernel/irq.c                            |    7 -
 arch/alpha/kernel/irq_alpha.c                      |   10 +-
 arch/alpha/kernel/sys_nautilus.c                   |    5 +
 arch/alpha/kernel/sys_titan.c                      |   14 +-
 arch/arc/include/asm/irqflags.h                    |   12 +-
 arch/arm/Kconfig                                   |   14 +-
 arch/arm/boot/dts/armada-370-mirabox.dts           |    2 +-
 arch/arm/boot/dts/armada-370.dtsi                  |    6 +
 arch/arm/boot/dts/dbx5x0.dtsi                      |    4 +-
 arch/arm/boot/dts/imx28-m28evk.dts                 |    1 -
 arch/arm/boot/dts/imx28-sps1.dts                   |    1 -
 arch/arm/boot/dts/imx6qdl.dtsi                     |    1 +
 arch/arm/boot/dts/kirkwood-goflexnet.dts           |    1 +
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts      |   14 +-
 arch/arm/boot/dts/orion5x.dtsi                     |    9 +-
 arch/arm/include/asm/delay.h                       |    2 +-
 arch/arm/include/asm/glue-cache.h                  |    8 -
 arch/arm/include/asm/hardware/iop3xx.h             |    2 +-
 arch/arm/include/asm/highmem.h                     |    7 +
 arch/arm/include/asm/mmu_context.h                 |    2 +
 arch/arm/include/asm/pgtable-3level.h              |    2 +-
 arch/arm/include/asm/tlbflush.h                    |   26 +-
 arch/arm/kernel/entry-common.S                     |   12 +
 arch/arm/kernel/head.S                             |    2 +-
 arch/arm/kernel/hw_breakpoint.c                    |    8 +-
 arch/arm/kernel/perf_event.c                       |    5 +-
 arch/arm/kernel/sched_clock.c                      |    4 +-
 arch/arm/kernel/setup.c                            |   27 +-
 arch/arm/kernel/smp.c                              |    3 -
 arch/arm/kernel/smp_tlb.c                          |   66 +++
 arch/arm/kernel/tcm.c                              |    1 -
 arch/arm/kvm/arm.c                                 |    1 +
 arch/arm/kvm/coproc.c                              |    4 +-
 arch/arm/kvm/vgic.c                                |   35 +-
 arch/arm/lib/delay.c                               |    8 +-
 arch/arm/mach-cns3xxx/core.c                       |   16 +-
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h       |   16 +-
 arch/arm/mach-ep93xx/include/mach/uncompress.h     |   10 +-
 arch/arm/mach-highbank/hotplug.c                   |   10 +-
 arch/arm/mach-imx/clk-imx35.c                      |    2 +
 arch/arm/mach-imx/clk-imx6q.c                      |    3 +-
 arch/arm/mach-imx/common.h                         |    2 +
 arch/arm/mach-imx/hotplug.c                        |   12 +
 arch/arm/mach-imx/src.c                            |   12 +
 arch/arm/mach-kirkwood/board-iomega_ix2_200.c      |    7 +-
 arch/arm/mach-kirkwood/guruplug-setup.c            |    2 +
 arch/arm/mach-kirkwood/openrd-setup.c              |    1 +
 arch/arm/mach-kirkwood/rd88f6281-setup.c           |    1 +
 arch/arm/mach-msm/timer.c                          |    5 +-
 arch/arm/mach-mvebu/irq-armada-370-xp.c            |   24 +-
 arch/arm/mach-omap1/clock_data.c                   |   12 +-
 arch/arm/mach-omap2/cclock44xx_data.c              |   20 +
 arch/arm/mach-omap2/common.h                       |    3 +
 arch/arm/mach-omap2/io.c                           |   18 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |    7 +-
 arch/arm/mach-omap2/omap_hwmod.h                   |    9 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |    7 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   12 +-
 arch/arm/mach-omap2/timer.c                        |    4 +
 arch/arm/mach-s3c24xx/include/mach/irqs.h          |    4 +-
 arch/arm/mach-s3c24xx/irq.c                        |    2 +-
 arch/arm/mach-ux500/board-mop500-sdi.c             |    1 -
 arch/arm/mach-ux500/board-mop500.c                 |   12 +
 arch/arm/mach-ux500/board-mop500.h                 |    1 +
 arch/arm/mach-ux500/cpu-db8500.c                   |    5 +-
 arch/arm/mm/Kconfig                                |    5 +-
 arch/arm/mm/Makefile                               |    1 -
 arch/arm/mm/cache-feroceon-l2.c                    |    1 +
 arch/arm/mm/cache-l2x0.c                           |   11 +-
 arch/arm/mm/cache-v3.S                             |  137 ------
 arch/arm/mm/cache-v4.S                             |    2 +-
 arch/arm/mm/context.c                              |    3 +-
 arch/arm/mm/mmu.c                                  |   75 ++--
 arch/arm/mm/proc-arm740.S                          |   30 +-
 arch/arm/mm/proc-arm920.S                          |    2 +-
 arch/arm/mm/proc-arm926.S                          |    2 +-
 arch/arm/mm/proc-mohawk.S                          |    2 +-
 arch/arm/mm/proc-sa1100.S                          |    2 +-
 arch/arm/mm/proc-syms.c                            |    2 +
 arch/arm/mm/proc-v6.S                              |    2 +-
 arch/arm/mm/proc-v7.S                              |   19 +-
 arch/arm/mm/proc-xsc3.S                            |    2 +-
 arch/arm/mm/proc-xscale.S                          |    2 +-
 arch/arm/{kernel => mm}/tcm.h                      |    0
 arch/avr32/include/asm/io.h                        |    4 +
 arch/c6x/include/asm/irqflags.h                    |    2 +-
 arch/ia64/Kconfig                                  |    1 +
 arch/ia64/kernel/palinfo.c                         |   77 +---
 arch/m68k/include/asm/gpio.h                       |   20 +
 arch/mips/Kconfig                                  |    7 +-
 arch/mips/bcm63xx/boards/board_bcm963xx.c          |    5 +-
 arch/mips/bcm63xx/nvram.c                          |    7 +-
 arch/mips/bcm63xx/setup.c                          |    2 +-
 arch/mips/cavium-octeon/setup.c                    |    5 +-
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_nvram.h |    4 +-
 .../include/asm/mach-sead3/cpu-feature-overrides.h |    4 -
 arch/mips/include/asm/mipsregs.h                   |  209 +++++++++-
 arch/mips/include/asm/page.h                       |    2 +-
 arch/mips/include/asm/signal.h                     |    2 +-
 arch/mips/include/uapi/asm/signal.h                |    8 +-
 arch/mips/kernel/Makefile                          |   25 +-
 arch/mips/kernel/cpu-probe.c                       |   13 +-
 arch/mips/kernel/linux32.c                         |    2 +-
 arch/mips/kernel/mcount.S                          |   11 +-
 arch/mips/kernel/proc.c                            |    2 +-
 arch/mips/kernel/traps.c                           |    2 +-
 arch/mips/lib/bitops.c                             |   16 +-
 arch/mips/lib/csum_partial.S                       |    4 +-
 arch/mips/mm/c-r4k.c                               |    6 +-
 arch/mips/mm/sc-mips.c                             |    6 +-
 arch/mips/pci/pci-alchemy.c                        |    4 +-
 arch/parisc/Makefile                               |    6 +-
 arch/parisc/include/asm/cacheflush.h               |    5 +-
 arch/parisc/include/asm/pgtable.h                  |   47 ++-
 arch/parisc/include/asm/uaccess.h                  |   14 +-
 arch/parisc/kernel/cache.c                         |    5 +-
 arch/parisc/kernel/parisc_ksyms.c                  |    2 +
 arch/parisc/lib/Makefile                           |    3 +-
 arch/parisc/lib/ucmpdi2.c                          |   25 ++
 arch/powerpc/kernel/entry_64.S                     |    4 +-
 arch/powerpc/kernel/process.c                      |    2 +
 arch/powerpc/kernel/signal_32.c                    |    2 +
 arch/powerpc/kernel/signal_64.c                    |    2 +
 arch/powerpc/kernel/tm.S                           |    2 +
 arch/powerpc/kvm/e500.h                            |   24 +-
 arch/powerpc/kvm/e500_mmu_host.c                   |   84 ++--
 arch/powerpc/kvm/e500mc.c                          |    7 +-
 arch/powerpc/platforms/pseries/lpar.c              |    8 +-
 arch/s390/include/asm/io.h                         |    4 -
 arch/s390/include/asm/pgtable.h                    |    8 +-
 arch/s390/lib/uaccess_pt.c                         |   83 ++--
 arch/sparc/include/asm/Kbuild                      |    5 +
 arch/sparc/include/asm/cputime.h                   |    6 -
 arch/sparc/include/asm/emergency-restart.h         |    6 -
 arch/sparc/include/asm/mutex.h                     |    9 -
 arch/sparc/include/asm/pgtable_64.h                |    1 +
 arch/sparc/include/asm/serial.h                    |    6 -
 arch/sparc/include/asm/smp_32.h                    |    5 -
 arch/sparc/include/asm/switch_to_64.h              |    3 +-
 arch/sparc/include/asm/tlbflush_64.h               |   37 +-
 arch/sparc/include/uapi/asm/Kbuild                 |    1 -
 arch/sparc/include/uapi/asm/types.h                |   17 -
 arch/sparc/kernel/smp_64.c                         |   41 +-
 arch/sparc/lib/bitext.c                            |    6 +-
 arch/sparc/mm/iommu.c                              |    2 +-
 arch/sparc/mm/srmmu.c                              |    4 +-
 arch/sparc/mm/tlb.c                                |   39 +-
 arch/sparc/mm/tsb.c                                |   57 ++-
 arch/sparc/mm/ultra.S                              |  119 ++++--
 arch/tile/include/asm/irqflags.h                   |   10 +-
 arch/tile/kernel/setup.c                           |   25 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/boot/compressed/Makefile                  |    5 +-
 arch/x86/boot/compressed/eboot.c                   |   47 +++
 arch/x86/include/asm/efi.h                         |    7 +
 arch/x86/include/asm/paravirt.h                    |    5 +-
 arch/x86/include/asm/paravirt_types.h              |    2 +
 arch/x86/include/asm/syscall.h                     |    4 +-
 arch/x86/include/asm/tlb.h                         |    2 +-
 arch/x86/include/uapi/asm/bootparam.h              |    1 +
 arch/x86/kernel/cpu/mshyperv.c                     |   18 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   20 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |    3 +-
 arch/x86/kernel/microcode_core_early.c             |   38 +-
 arch/x86/kernel/paravirt.c                         |   25 +-
 arch/x86/kernel/setup.c                            |   45 +-
 arch/x86/kvm/lapic.c                               |    2 +-
 arch/x86/kvm/x86.c                                 |   13 +-
 arch/x86/lguest/boot.c                             |    1 +
 arch/x86/mm/fault.c                                |    6 +-
 arch/x86/mm/pageattr-test.c                        |    2 +-
 arch/x86/mm/pageattr.c                             |   12 +-
 arch/x86/mm/pgtable.c                              |    7 +
 arch/x86/platform/efi/efi.c                        |  168 +++++++-
 arch/x86/xen/mmu.c                                 |   13 +-
 block/blk-core.c                                   |    1 +
 block/blk-sysfs.c                                  |    2 +
 block/partition-generic.c                          |    1 -
 crypto/algif_hash.c                                |    2 +
 crypto/algif_skcipher.c                            |    1 +
 crypto/gcm.c                                       |   17 +-
 drivers/acpi/Kconfig                               |    2 +-
 drivers/acpi/acpi_i2c.c                            |    2 +-
 drivers/acpi/pci_root.c                            |   76 ++--
 drivers/acpi/processor_idle.c                      |   13 +-
 drivers/ata/ata_piix.c                             |   14 +-
 drivers/ata/libata-core.c                          |    6 +-
 drivers/ata/libata-scsi.c                          |    8 +-
 drivers/base/power/qos.c                           |   60 ++-
 drivers/base/regmap/regcache-rbtree.c              |    2 +-
 drivers/base/regmap/regmap.c                       |    6 +-
 drivers/block/aoe/aoecmd.c                         |    3 +-
 drivers/block/loop.c                               |   30 +-
 drivers/block/mtip32xx/mtip32xx.c                  |  327 ++++++++++-----
 drivers/block/mtip32xx/mtip32xx.h                  |   18 +-
 drivers/block/rbd.c                                |    3 +-
 drivers/char/hpet.c                                |   14 +-
 drivers/char/hw_random/core.c                      |    9 +
 drivers/char/virtio_console.c                      |   44 +-
 drivers/clk/tegra/clk-tegra20.c                    |    2 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |   10 +-
 drivers/cpufreq/cpufreq_governor.h                 |    6 +-
 drivers/cpufreq/intel_pstate.c                     |    1 -
 drivers/crypto/ux500/cryp/cryp_core.c              |    2 +-
 drivers/dma/Kconfig                                |    1 +
 drivers/dma/at_hdmac.c                             |    9 +-
 drivers/dma/omap-dma.c                             |   20 +-
 drivers/dma/pl330.c                                |   38 +-
 drivers/eisa/pci_eisa.c                            |   67 ++-
 drivers/firmware/efi/efi-pstore.c                  |   11 +-
 drivers/firmware/efi/efi.c                         |    2 +-
 drivers/firmware/efi/efivars.c                     |    3 +-
 drivers/firmware/efi/vars.c                        |   37 +-
 drivers/firmware/google/gsmi.c                     |    9 +-
 drivers/gpio/gpio-ich.c                            |    2 +-
 drivers/gpio/gpio-pca953x.c                        |    2 +-
 drivers/gpio/gpio-pxa.c                            |    7 +-
 drivers/gpio/gpio-stmpe.c                          |   15 +-
 drivers/gpu/drm/drm_crtc.c                         |    2 -
 drivers/gpu/drm/drm_fb_helper.c                    |    8 +-
 drivers/gpu/drm/drm_fops.c                         |    6 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |    2 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   40 +-
 drivers/gpu/drm/i915/intel_dp.c                    |    3 +
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   13 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |   17 +
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |   18 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   32 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |    2 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |    2 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |   26 ++
 drivers/gpu/drm/udl/udl_connector.c                |    4 +
 drivers/hid/hid-core.c                             |   13 +-
 drivers/hid/hid-ids.h                              |    5 +-
 drivers/hid/hid-magicmouse.c                       |   29 +-
 drivers/hwspinlock/hwspinlock_core.c               |    2 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |    1 -
 drivers/idle/intel_idle.c                          |    1 +
 drivers/infiniband/hw/qib/qib_sd7220.c             |    2 +-
 drivers/input/tablet/wacom_wac.c                   |    8 +-
 drivers/irqchip/irq-gic.c                          |    3 +-
 drivers/md/dm-cache-target.c                       |   51 ++-
 drivers/md/dm.c                                    |    1 +
 drivers/md/raid5.c                                 |   11 +-
 drivers/media/dvb-frontends/mb86a20s.c             |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/radio/radio-ma901.c                  |   11 +
 drivers/misc/vmw_vmci/Kconfig                      |    2 +-
 drivers/mtd/mtdchar.c                              |   59 +--
 drivers/net/bonding/bond_main.c                    |  102 +++--
 drivers/net/bonding/bond_sysfs.c                   |   92 +++--
 drivers/net/can/mcp251x.c                          |   10 +-
 drivers/net/can/sja1000/Kconfig                    |    1 +
 drivers/net/can/sja1000/plx_pci.c                  |    4 +-
 drivers/net/can/sja1000/sja1000.c                  |    6 +-
 drivers/net/can/sja1000/sja1000.h                  |    2 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      |   31 +-
 drivers/net/ethernet/8390/ax88796.c                |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |    3 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   20 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |    7 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   |   18 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    7 +-
 drivers/net/ethernet/broadcom/tg3.c                |    7 +-
 drivers/net/ethernet/calxeda/xgmac.c               |    9 +-
 drivers/net/ethernet/davicom/dm9000.c              |  214 +++++-----
 drivers/net/ethernet/davicom/dm9000.h              |   11 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    5 +-
 drivers/net/ethernet/freescale/fec.c               |   83 ++--
 drivers/net/ethernet/intel/e100.c                  |   36 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |   14 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    7 +-
 drivers/net/ethernet/intel/igb/igb.h               |    8 -
 drivers/net/ethernet/intel/igb/igb_main.c          |  110 +----
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |    7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    6 +
 drivers/net/ethernet/marvell/Kconfig               |    2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   18 +-
 drivers/net/ethernet/marvell/sky2.c                |    2 +-
 drivers/net/ethernet/marvell/sky2.h                |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    4 +-
 drivers/net/ethernet/micrel/ks8851.c               |    2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   15 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |    3 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c  |    4 +-
 drivers/net/ethernet/qlogic/qlge/qlge.h            |    2 +-
 drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c    |    2 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |   36 +-
 drivers/net/ethernet/realtek/r8169.c               |   28 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   28 +-
 drivers/net/ethernet/renesas/sh_eth.h              |    2 +-
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |    1 +
 drivers/net/ethernet/ti/cpsw.c                     |    4 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    2 +-
 drivers/net/hyperv/netvsc.c                        |   17 +-
 drivers/net/hyperv/netvsc_drv.c                    |    2 -
 drivers/net/hyperv/rndis_filter.c                  |   14 +-
 drivers/net/tun.c                                  |    2 +-
 drivers/net/usb/cdc_mbim.c                         |    2 +-
 drivers/net/usb/qmi_wwan.c                         |  104 +++++
 drivers/net/usb/smsc75xx.c                         |   12 +-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |    2 +-
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    4 +-
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c  |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/ath/ath9k/link.c              |    3 +-
 drivers/net/wireless/ath/ath9k/main.c              |    4 +
 drivers/net/wireless/b43/dma.c                     |   65 ++-
 drivers/net/wireless/b43/phy_n.c                   |   11 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   53 ++-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  264 ++++++------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  369 ++++++-----------
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |   64 +--
 drivers/net/wireless/iwlegacy/4965-rs.c            |    3 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |    9 +
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |   18 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |    2 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c           |    4 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   13 +
 drivers/net/wireless/iwlwifi/pcie/tx.c             |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |    3 +-
 drivers/net/wireless/mwifiex/pcie.c                |    1 +
 drivers/net/wireless/mwifiex/scan.c                |   11 +-
 drivers/net/wireless/rt2x00/Kconfig                |    7 +
 drivers/net/wireless/rt2x00/Makefile               |    1 +
 drivers/net/wireless/rt2x00/rt2400pci.c            |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c            |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c            |    1 +
 drivers/net/wireless/rt2x00/rt2x00mmio.c           |  216 ++++++++++
 drivers/net/wireless/rt2x00/rt2x00mmio.h           |  119 ++++++
 drivers/net/wireless/rt2x00/rt2x00pci.c            |  176 --------
 drivers/net/wireless/rt2x00/rt2x00pci.h            |   88 ----
 drivers/net/wireless/rt2x00/rt61pci.c              |    1 +
 drivers/nfc/microread/mei.c                        |   38 +-
 drivers/pci/pci-acpi.c                             |   15 +-
 drivers/pci/pci-driver.c                           |    5 +-
 drivers/pci/pcie/portdrv_pci.c                     |   13 -
 drivers/pci/rom.c                                  |   67 ++-
 drivers/platform/x86/hp-wmi.c                      |    4 -
 drivers/platform/x86/thinkpad_acpi.c               |   10 -
 drivers/remoteproc/Kconfig                         |    2 +-
 drivers/remoteproc/remoteproc_core.c               |    6 +-
 drivers/remoteproc/ste_modem_rproc.c               |    7 +-
 drivers/rtc/rtc-at91rm9200.c                       |   50 +--
 drivers/rtc/rtc-at91rm9200.h                       |    1 +
 drivers/s390/block/scm_blk.c                       |   11 +-
 drivers/s390/block/scm_drv.c                       |    2 +-
 drivers/s390/char/tty3270.c                        |   16 +-
 drivers/s390/net/qeth_core.h                       |    3 +
 drivers/s390/net/qeth_core_main.c                  |   19 +
 drivers/s390/net/qeth_l2_main.c                    |    2 +
 drivers/s390/net/qeth_l3_main.c                    |    2 +
 drivers/sbus/char/bbc_i2c.c                        |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    6 +-
 drivers/scsi/fcoe/fcoe.c                           |   15 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   60 ++-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |    2 +-
 drivers/scsi/ipr.c                                 |   13 +-
 drivers/scsi/libfc/fc_disc.c                       |   26 +-
 drivers/scsi/libsas/sas_expander.c                 |   14 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |    5 -
 drivers/scsi/qla2xxx/qla_dbg.c                     |    3 +-
 drivers/scsi/qla2xxx/qla_def.h                     |    1 -
 drivers/scsi/qla2xxx/qla_gbl.h                     |    3 -
 drivers/scsi/qla2xxx/qla_init.c                    |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   58 ---
 drivers/scsi/qla2xxx/qla_version.h                 |    2 +-
 drivers/scsi/st.c                                  |    8 +-
 drivers/spi/Kconfig                                |    3 +-
 drivers/spi/spi-bcm63xx.c                          |    3 +-
 drivers/spi/spi-mpc512x-psc.c                      |    2 +-
 drivers/spi/spi-pxa2xx.c                           |    1 -
 drivers/spi/spi-s3c64xx.c                          |   41 +-
 drivers/spi/spi-tegra20-slink.c                    |   25 +-
 drivers/spi/spi.c                                  |   17 +-
 drivers/ssb/driver_chipcommon_pmu.c                |   29 ++
 drivers/target/target_core_alua.c                  |    3 +
 drivers/tty/mxser.c                                |    8 +-
 drivers/tty/serial/8250/8250_pnp.c                 |   12 +-
 drivers/tty/serial/omap-serial.c                   |   11 +
 drivers/tty/tty_io.c                               |   18 +-
 drivers/usb/core/port.c                            |    1 -
 drivers/vfio/pci/vfio_pci.c                        |    3 +-
 drivers/vhost/tcm_vhost.c                          |  198 ++++++---
 drivers/video/fbmem.c                              |   39 +-
 drivers/video/fbmon.c                              |    2 +-
 drivers/video/mmp/core.c                           |    2 -
 drivers/video/sh_mobile_lcdcfb.c                   |    1 +
 drivers/video/uvesafb.c                            |    3 +-
 drivers/watchdog/Kconfig                           |    2 +-
 drivers/xen/events.c                               |   19 +-
 firmware/Makefile                                  |    2 +-
 firmware/{intel => qlogic}/sd7220.fw.ihex          |    0
 fs/aio.c                                           |    2 +-
 fs/binfmt_elf.c                                    |    1 +
 fs/bio.c                                           |    2 -
 fs/block_dev.c                                     |    1 +
 fs/btrfs/tree-log.c                                |   48 ++-
 fs/cifs/connect.c                                  |   16 +-
 fs/ecryptfs/miscdev.c                              |   14 +-
 fs/efivarfs/super.c                                |    3 +-
 fs/ext4/extents.c                                  |   11 +-
 fs/ext4/indirect.c                                 |    4 +-
 fs/gfs2/file.c                                     |    5 +-
 fs/gfs2/incore.h                                   |    1 +
 fs/gfs2/lock_dlm.c                                 |   39 +-
 fs/gfs2/rgrp.c                                     |   32 +-
 fs/hfsplus/extents.c                               |    2 +-
 fs/hugetlbfs/inode.c                               |    2 +-
 fs/inode.c                                         |    2 +-
 fs/namespace.c                                     |    2 +-
 fs/nfs/nfs4client.c                                |   45 +-
 fs/nfs/nfs4proc.c                                  |    1 +
 fs/nfs/nfs4state.c                                 |    8 +-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/proc/array.c                                    |    1 +
 fs/proc/generic.c                                  |  119 ++++--
 fs/reiserfs/xattr.c                                |    4 +-
 fs/ubifs/super.c                                   |   12 +-
 include/asm-generic/tlb.h                          |    7 +-
 include/linux/ata.h                                |    2 +-
 include/linux/blktrace_api.h                       |    1 -
 include/linux/capability.h                         |    2 +
 include/linux/compat.h                             |    4 +-
 include/linux/devfreq.h                            |   16 +-
 include/linux/efi.h                                |   54 +--
 include/linux/ftrace.h                             |    5 +-
 include/linux/kexec.h                              |    2 +
 include/linux/kvm_host.h                           |    2 +-
 include/linux/kvm_types.h                          |    1 +
 include/linux/libata.h                             |    1 +
 include/linux/mm.h                                 |    2 +
 include/linux/netdevice.h                          |    4 +-
 include/linux/netfilter/ipset/ip_set_ahash.h       |   30 +-
 include/linux/pci.h                                |    1 +
 include/linux/preempt.h                            |   22 +-
 include/linux/proc_fs.h                            |    2 +
 include/linux/sched.h                              |    5 +-
 include/linux/security.h                           |   12 +
 include/linux/signal.h                             |    4 +-
 include/linux/skbuff.h                             |    7 +
 include/linux/spinlock_up.h                        |   29 +-
 include/linux/ssb/ssb_driver_chipcommon.h          |    2 +
 include/linux/swiotlb.h                            |    1 +
 include/linux/ucs2_string.h                        |   14 +
 include/net/addrconf.h                             |    1 +
 include/net/irda/irlmp.h                           |    3 +-
 include/net/iucv/af_iucv.h                         |    8 +
 include/net/scm.h                                  |    4 +-
 include/scsi/libfc.h                               |    3 +-
 include/sound/soc-dapm.h                           |    1 +
 include/trace/events/block.h                       |    8 +-
 include/trace/events/sched.h                       |    2 +-
 include/uapi/linux/fuse.h                          |  436 ++++++++++----------
 ipc/msg.c                                          |    1 +
 kernel/.gitignore                                  |    1 +
 kernel/capability.c                                |   24 ++
 kernel/events/core.c                               |    8 +-
 kernel/events/internal.h                           |    2 +-
 kernel/events/ring_buffer.c                        |   22 +-
 kernel/hrtimer.c                                   |    3 +-
 kernel/kexec.c                                     |  118 +++++-
 kernel/kprobes.c                                   |   19 +-
 kernel/kthread.c                                   |   52 +--
 kernel/sched/clock.c                               |   26 ++
 kernel/sched/core.c                                |    8 +-
 kernel/sched/cputime.c                             |    2 +-
 kernel/signal.c                                    |    2 +-
 kernel/smpboot.c                                   |   14 +-
 kernel/sys.c                                       |    3 +-
 kernel/trace/blktrace.c                            |   26 +-
 kernel/trace/ftrace.c                              |   54 ++-
 kernel/trace/trace.c                               |    9 +-
 kernel/trace/trace_stack.c                         |    2 +-
 kernel/user_namespace.c                            |   22 +-
 lib/Kconfig                                        |    3 +
 lib/Makefile                                       |    2 +
 lib/kobject.c                                      |    9 +-
 lib/swiotlb.c                                      |   19 +-
 lib/ucs2_string.c                                  |   51 +++
 mm/hugetlb.c                                       |   12 +-
 mm/memory.c                                        |   48 +++
 mm/mmap.c                                          |    2 +-
 mm/nommu.c                                         |   12 +-
 mm/vmscan.c                                        |    2 +-
 net/802/mrp.c                                      |    4 +
 net/atm/common.c                                   |    2 +
 net/ax25/af_ax25.c                                 |    1 +
 net/batman-adv/main.c                              |    5 +-
 net/batman-adv/main.h                              |    2 +-
 net/batman-adv/routing.c                           |   38 +-
 net/batman-adv/translation-table.c                 |    2 +-
 net/batman-adv/vis.c                               |    4 +-
 net/bluetooth/af_bluetooth.c                       |    4 +-
 net/bluetooth/rfcomm/sock.c                        |    1 +
 net/bluetooth/sco.c                                |    1 +
 net/bridge/br_if.c                                 |    3 +-
 net/bridge/br_private.h                            |    1 +
 net/bridge/br_stp_if.c                             |    1 +
 net/caif/caif_socket.c                             |    2 +
 net/can/gw.c                                       |    6 +-
 net/core/dev.c                                     |   11 +-
 net/core/dev_addr_lists.c                          |    6 +-
 net/core/flow.c                                    |    2 +-
 net/core/rtnetlink.c                               |    8 +-
 net/ipv4/devinet.c                                 |   66 ++-
 net/ipv4/esp4.c                                    |    6 +-
 net/ipv4/ip_fragment.c                             |   14 +-
 net/ipv4/netfilter/ipt_rpfilter.c                  |    8 +-
 net/ipv4/syncookies.c                              |    4 +-
 net/ipv4/tcp_input.c                               |   64 ++-
 net/ipv4/tcp_output.c                              |    9 +-
 net/ipv6/addrconf.c                                |   51 ++-
 net/ipv6/addrconf_core.c                           |   19 +
 net/ipv6/ip6_input.c                               |   12 +
 net/ipv6/netfilter/ip6t_NPT.c                      |    2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c                 |    8 +-
 net/ipv6/reassembly.c                              |   12 +-
 net/ipv6/tcp_ipv6.c                                |    1 +
 net/irda/af_irda.c                                 |    2 +
 net/irda/iriap.c                                   |    3 +-
 net/irda/irlmp.c                                   |   10 +-
 net/iucv/af_iucv.c                                 |   36 +-
 net/key/af_key.c                                   |    1 +
 net/l2tp/l2tp_ip6.c                                |    1 +
 net/llc/af_llc.c                                   |    2 +
 net/mac80211/cfg.c                                 |    6 +-
 net/mac80211/chan.c                                |   17 +-
 net/mac80211/ieee80211_i.h                         |    4 +-
 net/mac80211/iface.c                               |   62 +--
 net/mac80211/mesh.c                                |    3 +-
 net/mac80211/mlme.c                                |   30 +-
 net/mac80211/offchannel.c                          |   23 +-
 net/mac80211/rx.c                                  |   14 +-
 net/mac80211/sta_info.c                            |   12 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |    6 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |   18 +
 net/netfilter/ipset/ip_set_hash_net.c              |   22 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |   22 +-
 net/netfilter/ipset/ip_set_hash_netport.c          |   18 +
 net/netfilter/ipset/ip_set_list_set.c              |   10 +-
 net/netfilter/nf_conntrack_sip.c                   |    6 +-
 net/netfilter/nf_conntrack_standalone.c            |    1 +
 net/netfilter/nf_nat_core.c                        |   40 +-
 net/netfilter/nfnetlink_acct.c                     |    2 +
 net/netfilter/nfnetlink_queue_core.c               |    4 +-
 net/netrom/af_netrom.c                             |    1 +
 net/nfc/llcp/llcp.c                                |    8 -
 net/nfc/llcp/sock.c                                |    9 +-
 net/openvswitch/datapath.c                         |   30 +-
 net/openvswitch/flow.c                             |    2 +-
 net/rose/af_rose.c                                 |    1 +
 net/sched/cls_fw.c                                 |    2 +-
 net/sched/sch_cbq.c                                |    5 +-
 net/sched/sch_fq_codel.c                           |    2 +-
 net/sched/sch_generic.c                            |    2 +-
 net/sunrpc/clnt.c                                  |   11 +-
 net/tipc/socket.c                                  |    7 +
 net/unix/af_unix.c                                 |    6 +-
 net/vmw_vsock/af_vsock.c                           |    8 +-
 net/vmw_vsock/vmci_transport.c                     |   34 +-
 net/vmw_vsock/vsock_addr.c                         |   10 -
 net/vmw_vsock/vsock_addr.h                         |    2 -
 net/wireless/core.c                                |   64 ++-
 net/wireless/core.h                                |    3 +
 net/wireless/nl80211.c                             |   52 +--
 net/wireless/scan.c                                |   24 +-
 net/wireless/sme.c                                 |    8 +-
 net/wireless/trace.h                               |    5 +-
 net/wireless/wext-sme.c                            |    6 +
 net/xfrm/xfrm_replay.c                             |   66 ++-
 scripts/checkpatch.pl                              |    1 +
 security/capability.c                              |    6 +
 security/security.c                                |    5 +
 security/selinux/hooks.c                           |    7 +
 sound/core/pcm_native.c                            |   12 +-
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/hda_eld.c                            |    2 +-
 sound/pci/hda/hda_generic.c                        |    2 +-
 sound/pci/hda/hda_intel.c                          |    6 +-
 sound/pci/hda/patch_hdmi.c                         |    2 +-
 sound/pci/hda/patch_realtek.c                      |    4 +-
 sound/soc/codecs/si476x.c                          |    1 +
 sound/soc/codecs/wm5102.c                          |    2 +-
 sound/soc/codecs/wm8903.c                          |    2 +
 sound/soc/codecs/wm_adsp.c                         |    5 +-
 sound/soc/fsl/imx-ssi.c                            |    5 +
 sound/soc/fsl/pcm030-audio-fabric.c                |    2 +-
 sound/soc/samsung/i2s.c                            |   17 +-
 sound/soc/sh/dma-sh7760.c                          |    4 +-
 sound/soc/soc-compress.c                           |   14 +-
 sound/soc/soc-core.c                               |   10 +-
 sound/soc/soc-dapm.c                               |   14 +
 sound/soc/spear/spear_pcm.c                        |   12 +-
 sound/soc/tegra/tegra_pcm.c                        |   24 +-
 sound/usb/clock.c                                  |   45 +-
 sound/usb/mixer_quirks.c                           |    4 +-
 sound/usb/quirks.c                                 |    2 +-
 tools/power/x86/turbostat/turbostat.c              |    5 +-
 virt/kvm/kvm_main.c                                |   47 ++-
 612 files changed, 6458 insertions(+), 4050 deletions(-)
 delete mode 100644 arch/arm/mm/cache-v3.S
 rename arch/arm/{kernel => mm}/tcm.h (100%)
 create mode 100644 arch/parisc/lib/ucmpdi2.c
 delete mode 100644 arch/sparc/include/asm/cputime.h
 delete mode 100644 arch/sparc/include/asm/emergency-restart.h
 delete mode 100644 arch/sparc/include/asm/mutex.h
 delete mode 100644 arch/sparc/include/asm/serial.h
 delete mode 100644 arch/sparc/include/uapi/asm/types.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00mmio.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00mmio.h
 rename firmware/{intel => qlogic}/sd7220.fw.ihex (100%)
 create mode 100644 include/linux/ucs2_string.h
 mode change 100755 => 100644 include/sound/max98090.h
 create mode 100644 lib/ucs2_string.c
 mode change 100755 => 100644 sound/soc/codecs/max98090.c
 mode change 100755 => 100644 sound/soc/codecs/max98090.h
-- 
Matt Fleming, Intel Open Source Technology Center
