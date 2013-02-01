Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3BABn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 20:43:58 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:59129 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3BABny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 20:43:54 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Feb 2013 12:43:33 +1100
X-Google-Sender-Auth: 1sDexfw_UZJiYuHi71Isej6Nhfs
Message-ID: <CA+55aFyA2mdw2ycDsEvUwPggFQQ8Zq=3zyE6Gchr_DLrLyoBtw@mail.gmail.com>
Subject: Linux 3.8-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a week since -rc5 (perhaps not counting timezone changes),
so -rc6 is out now.

I have to say, -rc6 is bigger than I'd like it to be. I'd really like
things to calm down by rc6, because usually I aim for rc7 to be
roughly the last rc in the series, and that means that I don't want to
see hundreds of patches. But hundreds of patches it is. Not good.

That said, I'm hoping that the bulk of this was due to Davem catching
the flu and the networking pull being delayed by that. Because while
there's been a few other worrisome patterns (x86 changes, EFI stuff
etc), it is largely true that a lot of the rc6 patches were
network-related.

So I'm hoping that rc7 would be better quite quite on its own.

But since I don't trust you sneaky bastards, I have a CleverPlan(tm)
to make *sure* that rc7 will be better and much smaller. That plan
largely depends on me being unreachable for the next week due to the
fact that there is no internet under water.

Paraphrasing the Alien films: "Under water, nobody can read your email".

And once I dry off enough, I'm going to be really pissy ("And how is
that different from the normal Linus, pray tell?") if people send me
pull requests that I think you shouldn't have sent. There will be
cursing. More cursing than normal. Don't send me stuff that doesn't
fix major security issues, big user-reported regressions, or nasty
oopses. Seriously. Just don't.

So think twice - or thrice - before sending me patches or a pull
request for -rc7. You need to have some seriously good reasons for
doing so, and you need to state those reasons very clearly. And I
don't just mean for the pull request in general, I mean for every
single patch in it. So don't ask me to pull three patches, because
_one_ of the three patches fixes a bad regression. Because while I can
see myself doing an rc8 (and I may just have to), I'm not going to
enjoy it much. So please help make sure that rc7 really is tiny and
only contains fixed that absolutely *have* to go in.

In other words, "It fixes a bug" just isn't good enough. The bug needs
to be something that actually matters.

                    Linus

---

AceLan Kao (3):
      Bluetooth: Add support for IMC Networks [13d3:3393]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e04e]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e056]

Al Cooper (1):
      MIPS: Function tracer: Fix broken function tracing

Alan Cox (1):
      x86/msr: Add capabilities check

Alasdair G Kergon (1):
      dm: fix write same requests counting

Alex Shi (1):
      arch/x86/platform/uv: Fix incorrect tlb flush all issue

Amitkumar Karwar (2):
      mwifiex: update config_bands during infra association
      mwifiex: correct config_bands handling for ibss network

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Andrew Lunn (1):
      pinctrl: mvebu: Fix compiler warnings

AnilKumar Ch (1):
      mfd: tps65910: Select REGMAP_IRQ in Kconfig to fix build error

Arend van Spriel (1):
      MIPS: BCM47xx: Select GPIOLIB for BCMA on bcm47xx platform

Arnd Bergmann (5):
      drm/exynos: don't include plat/gpio-cfg.h
      drm/exynos: fimd and ipp are broken on multiplatform
      mfd: twl4030: Don't warn about uninitialized return code
      pinctrl: exynos: don't mark probing functions as __init
      pinctrl: nomadik: nmk_prcm_gpiocr_get_mode may be unused

Ashish Jangam (1):
      mfd: da9052/53 lockup fix

Avinash Patil (1):
      mwifiex: fix typo in PCIe adapter NULL check

Axel Lin (4):
      mfd: max77686: Init max77686->dev before using it
      mfd: max77693: Init max77693->dev before using it
      mfd: pcf50633: Init pcf->dev before using it
      regulator: tps80031: Use IS_ERR to check return value of
regulator_register()

Benjamin Tissoires (1):
      HID: i2c-hid: fix i2c_hid_output_raw_report

Bjørn Mork (7):
      net: qmi_wwan: add TP-LINK HSUPA Modem MA180
      net: qmi_wwan: add ONDA MT8205 4G LTE
      net: cdc_ncm: workaround for missing CDC Union
      net: cdc_mbim: send ZLP after max sized NTBs
      net: cdc_ncm: fix error path for single interface probing
      net: cdc_mbim: send ZLP only for the specific buggy device
      net: cdc_ncm: use IAD provided by the USB core

Bob Copeland (2):
      mac80211: set NEED_TXPROCESSING for PERR frames
      mac80211: add encrypt headroom to PERR frames

Brian Foster (1):
      xfs: pull up stack_switch check into xfs_bmapi_write

Carl E. Love (1):
      powerpc/oprofile: Fix error in oprofile
power7_marked_instr_event() function

Charles Keepax (2):
      ASoC: arizona: Disable free-running mode on FLL1
      ASoC: wm_adsp: Release firmware on error

Chris Rattray (1):
      ASoC: wm2200: correct mixer values and text

Chris Wilson (2):
      drm/i915: Disable AsyncFlip performance optimisations
      drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for
scanline waits

Clemens Ladisch (1):
      ALSA: usb-audio: fix invalid length check for RME and other UAC 2 devices

Cong Ding (3):
      MIPS: vpe.c: Fix null pointer dereference in print arguments.
      x86/boot: Fix minor fd leakage in tools/relocs.c
      powerpc: kernel/kgdb.c: Fix memory leakage

Dan Carpenter (2):
      ip6mr: limit IPv6 MRT_TABLE identifiers
      EDAC: Test correct variable in ->store function

Daniel Schaal (1):
      Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.

Daniel Vetter (2):
      iommu/intel: disable DMAR for g4x integrated gfx
      drm/i915: dump UTS_RELEASE into the error_state

Daniel Wagner (1):
      net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly

Dave Airlie (1):
      Revert "console: implement lockdep support for console_lock"

Dave Chinner (3):
      xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
      xfs: limit speculative prealloc near ENOSPC thresholds
      xfs: fix shutdown hang on invalid inode during create

David Daney (1):
      MIPS: Fix build failure by adding definition of pfn_pmd().

David Henningsson (1):
      ALSA: hda - fix inverted internal mic on Acer AOA150/ZG5

David Teigland (1):
      GFS2: fix skip unlock condition

David Woodhouse (4):
      x86, efi: Fix display detection in EFI boot stub
      x86, efi: Fix 32-bit EFI handover protocol entry point
      x86, efi: Fix PCI ROM handing in EFI boot stub, in 32-bit mode
      x86, build: Dynamically find entry points in compressed startup code

Emmanuel Grumbach (1):
      iwlwifi: audit single frames from AGG queue in RS

Eric Dumazet (7):
      tcp: fix a panic on UP machines in reqsk_fastopen_remove
      macvlan: fix macvlan_get_size()
      tcp: fix incorrect LOCKDROPPEDICMPS counter
      net: splice: avoid high order page splitting
      net: splice: fix __splice_segment()
      netxen: fix off by one bug in netxen_release_tx_buffer()
      net: loopback: fix a dst refcounting issue

Eric Sandeen (1):
      xfs: Do not return EFSCORRUPTED when filesystem probe finds no XFS magic

Fabio Estevam (1):
      pinctrl: pinctrl-mxs: Fix variables' definition type

Felix Fietkau (11):
      ath9k: do not link receive buffers during flush
      ath9k: fix double-free bug on beacon generate failure
      ath9k: remove the WARN_ON that triggers if generating a beacon fails
      ath9k: add a better fix for the rx tasklet vs rx flush race
      ath9k: fix rx flush handling
      ath9k: remove sc->rx.rxbuflock to fix a deadlock
      ath9k: disable the tasklet before taking the PCU lock
      mac80211: fix monitor mode injection
      ath9k_hw: fix calibration issues on chainmask that don't include chain 0
      ath9k_hw: fix chain swap setting when setting rx chainmask to 5
      ath9k: allow setting arbitrary antenna masks on AR9003+

Gabor Juhos (2):
      MIPS: AR724x: Fix AR724X_PCI_MEM_SIZE
      MIPS: AR71xx: Fix AR71XX_PCI_MEM_SIZE

Geert Uytterhoeven (1):
      MIPS: delay.c: Check BITS_PER_LONG instead of __SIZEOF_LONG__

Gerald Schaefer (1):
      s390/thp: implement pmdp_set_wrprotect()

Giuseppe CAVALLARO (1):
      net: phy: icplus: fix broken INTR pin settings

Guenter Roeck (1):
      mfd: vexpress: Export global functions to fix build error

Gustavo Padovan (1):
      Bluetooth: Check if the hci connection exists in SCO shutdown

H. Peter Anvin (2):
      x86-32: Start out cr0 clean, disable paging before modifying cr3/4
      x86, boot: Define the 2.12 bzImage boot protocol

Haojian Zhuang (1):
      Revert "pinctrl: single: support gpio request and free"

Ilija Hadzic (1):
      drm/radeon: fix a rare case of double kfree

Inki Dae (2):
      drm/exynos: free sg object if dma_map_sg is failed
      drm/exynos: consider DMA_NONE flag to dmabuf import

Jacob Keller (2):
      ixgbe: only compile ixgbe_debugfs.o when enabled
      ixgbe: Fix overwriting of rx_mtrl in ixgbe_ptp_hwtstamp_ioctl

Jaganath Kanakkassery (1):
      Bluetooth: Fix authentication if acl data comes before remote feature evt

Jan Beulich (2):
      x86-64: Fix unwind annotations in recent NMI changes
      x86, efi: fix 32-bit warnings in setup_efi_pci()

Jan Engelhardt (1):
      netfilter: x_tables: print correct hook names for ARP

Jan Kara (1):
      xfs: Fix possible use-after-free with AIO

Jason Wang (2):
      tuntap: reduce memory using of queues
      tuntap: limit the number of flow caches

Jayachandran C (1):
      MIPS: Netlogic: Fix UP compilation on XLR

Jerome Glisse (1):
      drm/radeon: fix cursor corruption on DCE6 and newer

Jianjun Kong (1):
      net/hyperv: fix wrong length of mac address

Jiri Kosina (1):
      HID: remove x bit from sensor doc

Joe Perches (1):
      EDAC: Fix kcalloc argument order

Johannes Berg (1):
      mac80211: fix FT roaming

John Crispin (1):
      MIPS: Lantiq: Fix cp0_perfcount_irq mapping

Jonathan Brassow (1):
      DM-RAID: Fix RAID10's check for sufficient redundancy

Kukjin Kim (1):
      pinctrl: samsung: removing duplicated condition for PINCTRL_SAMSUNG

Larry Finger (1):
      rtlwifi: Fix build warning introduced by commit a290593

Lee Jones (1):
      mfd: Fix compile errors and warnings when !CONFIG_AB8500_BM

Li RongQing (2):
      ah4/esp4: set transport header correctly for IPsec tunnel mode.
      ah6/esp6: set transport header correctly for IPsec tunnel mode.

Li Zhong (1):
      powerpc: Fix MAX_STACK_TRACE_ENTRIES too low warning for ppc32

Liam Girdwood (2):
      regulator: MAINTAINERS: update email address
      ASoC: MAINTAINERS: Update email address.

Lingzhu Xiang (1):
      efivarfs: Drop link count of the right inode

Linus Torvalds (1):
      Linux 3.8-rc6

Linus Walleij (2):
      mfd: db8500-prcmu: Fix irqdomain usage
      mfd: tc3589x: Use simple irqdomain

Maarten Lankhorst (2):
      x86/dma-debug: Bump PREALLOC_DMA_DEBUG_ENTRIES
      x86, efi: remove attribute check from setup_efi_pci

Mark Brown (8):
      ASoC: dapm: Fix sense of regulator bypass mode
      ASoC: wm5102: Correct AEC loopback mask
      ASoC: wm5110: Correct AEC loopback mask
      ASoC: arizona: Use actual rather than desired BCLK when calculating LRCLK
      ASoC: wm_adsp: Use GFP_DMA for things that may be DMAed
      mfd: arizona: Disable control interface reporting for WM5102 and WM5110
      mfd: arizona: Check errors from regcache_sync()
      mfd: wm5102: Fix definition of WM5102_MAX_REGISTER

Matt Fleming (5):
      efivarfs: Never return ENOENT from firmware
      efivarfs: Delete dentry from dcache in efivarfs_file_write()
      x86, efi: Set runtime_version to the EFI spec revision
      efi: Make 'efi_enabled' a function to query EFI facilities
      samsung-laptop: Disable on EFI hardware

Matthias Schiffer (3):
      batman-adv: fix skb leak in batadv_dat_snoop_incoming_arp_reply()
      batman-adv: check for more types of invalid IP addresses in DAT
      batman-adv: filter ARP packets with invalid MAC addresses in DAT

Michal Kubecek (1):
      xfrm: fix freed block size calculation in xfrm_policy_fini()

Michel Dänzer (1):
      drm/radeon: Enable DMA_IB_SWAP_ENABLE on big endian hosts.

Mike Snitzer (1):
      dm thin: fix queue limits stacking

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper re-initalization

Nicholas Santos (1):
      HID: usbhid: quirk for Formosa IR receiver

Nickolai Zeldovich (2):
      3c574_cs: fix operator precedence between << and &
      net/xfrm/xfrm_replay: avoid division by zero

Nithin Nayak Sujir (2):
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode
      tg3: Fix crc errors on jumbo frame receive

Olivier Sobrie (3):
      can: c_can: fix invalid error codes
      can: ti_hecc: fix invalid error codes
      can: pch_can: fix invalid error codes

Or Gerlitz (1):
      net/mlx4_core: Set number of msix vectors under SRIOV mode to
firmware defaults

Pablo Neira Ayuso (2):
      netfilter: xt_CT: fix unset return value if conntrack zone are disabled
      netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns

Paul Moore (2):
      selinux: add the "attach_queue" permission to the "tun_socket" class
      tun: fix LSM/SELinux labeling of tun/tap devices

Peter Korsgaard (1):
      dm9601: support dm9620 variant

Piotr Haber (1):
      brcmsmac: increase timer reference count for new timers only

Pravin B Shelar (1):
      IP_GRE: Fix kernel panic in IP_GRE with GRE csum.

Rahul Sharma (1):
      drm/exynos: let drm handle edid allocations

Ralf Baechle (5):
      MIPS: BCM47xx: Enable SSB prerequisite SSB_DRIVER_PCICORE.
      MIPS: Export <asm/break.h>.
      MIPS: Add struct p_format to union mips_instruction.
      MIPS: PNX833x: Fix comment.
      MIPS: Octeon: Fix warning.

Randy Dunlap (1):
      x86/olpc: Fix olpc-xo1-sci.c build errors

Rob Herring (1):
      net: calxedaxgmac: throw away overrun frames

Romain KUNTZ (1):
      ipv6: fix header length calculation in ip6_append_data()

Sachin Kamat (4):
      drm/exynos: Make g2d_userptr_get_dma_addr static
      drm/exynos: Make ipp_handle_cmd_work static
      drm/exynos: Add missing static specifiers in exynos_drm_rotator.c
      drm/exynos: Make 'drm_hdmi_get_edid' static

Sean Paul (2):
      drm/exynos: Replace mdelay with usleep_range
      drm/exynos: Remove "internal" interrupt handling

Sergio Cambra (1):
      Bluetooth device 04ca:3008 should use ath3k

Seung-Woo Kim (1):
      drm/exynos: added validation of edid for vidi connection

Shawn Guo (1):
      ASoC: fsl: fix multiple definition of init_module

Shirish S (1):
      drm/exynos: add check for the device power status

Simon Guinot (1):
      pinctrl: mvebu: fix MPP6 value for kirkwood driver

Stanislaw Gruszka (2):
      mac80211: synchronize scan off/on-channel and PS states
      iwlegacy: fix IBSS cleanup

Stef van Os (1):
      phy/marvell: remove fiber/copper autoselect on 88e1111

Steffen Klassert (7):
      ipv4: Remove output route check in ipv4_mtu
      ipv4: Don't update the pmtu on mtu locked routes
      ipv6: Add an error handler for icmp6
      xfrm4: Invalidate all ipv4 routes on IPsec pmtu events
      ipv4: Invalidate the socket cached route on pmtu events if possible
      ipv4: Add a socket release callback for datagram sockets
      ipv4: Fix route refcount on pmtu discovery

Stephen Hemminger (1):
      MAINTAINERS: Stephen Hemminger email change

Steven J. Hill (1):
      MIPS: DSP: Fix DSP mask for registers.

Steven Rostedt (3):
      regulators: db8500: Fix compile failure for
drivers/regulator/dbx500-prcmu.c
      powerpc/pasemi: Fix crash on reboot
      mips: Move __virt_addr_valid() to a place for MIPS 64

Stuart Menefy (1):
      net: phy: icplus: Use the RGMII interface mode to configure clock delays

Sujith Manoharan (1):
      ath9k_htc: Fix memory leak

Suravee Suthikulpanit (1):
      IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround

Szymon Janc (1):
      Bluetooth: Fix sending HCI commands after reset

Takashi Iwai (3):
      ALSA: hda - Add a fixup for Packard-Bell desktop with ALC880
      ALSA: hda - Enable LPIB delay count for Poulsbo / Oaktrail
      ALSA: hda - Fix non-snoop page handling

Thadeu Lima de Souza Cascardo (1):
      cxgb4: set coalesce parameters on all queues

Tiejun Chen (2):
      powerpc/book3e: Disable interrupt after preempt_schedule_irq
      powerpc: Max next_tb to prevent from replaying timer interrupt

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump

Timo Teräs (1):
      r8169: remove the obsolete and incorrect AMD workaround

Torsten Kaiser (1):
      xfs: Fix xfs_swap_extents() after removal of xfs_flushinval_pages()

Trond Myklebust (7):
      NFS: Fix error reporting in nfs_xdev_mount
      NFSv4: Fix NFSv4 reference counting for trunked sessions
      NFSv4: Fix NFSv4 trunking discovery
      NFSv4.1: Ensure that nfs41_walk_client_list() does start lease recovery
      NFS: Don't silently fail setattr() requests on mountpoints
      SUNRPC: When changing the queue priority, ensure that we change the owner
      NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session

Tushar Behera (1):
      usbnet: dm9601: Fix incorrect command

Vlad Yasevich (1):
      SCTP: Free the per-net sysctl table on net exit. v2

Wang YanQing (1):
      smp: Fix SMP function call empty cpu mask race

Wanlong Gao (3):
      virtio-net: fix the set affinity bug when CPU IDs are not consecutive
      virtio-net: split out clean affinity function
      virtio-net: reset virtqueue affinity when doing cpu hotplug

Wei Shuai (2):
      usbnet: add new flag FLAG_NOARP for usb net devices
      cdc_ncm: add support FLAG_NOARP for Infineon modem platform

Wei WANG (4):
      mfd: rtsx: Add output voltage switch hook
      mmc: rtsx: Call MFD hook to switch output voltage
      mfd: rtsx: Add clock divider hook
      mfd: rtsx: Fix oops when rtsx_pci_sdmmc is not probed

Xufeng Zhang (1):
      sctp: set association state to established in dupcook_a handler

Yan Burman (1):
      net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode

françois romieu (1):
      r8169: fix vlan tag read ordering.

xueminsu (1):
      radeon_display: Use pointer return error codes
