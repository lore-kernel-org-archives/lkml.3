Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaBXDIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:08:48 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53937 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBXDIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:08:45 -0500
MIME-Version: 1.0
Date: Sun, 23 Feb 2014 19:08:44 -0800
X-Google-Sender-Auth: gzyL56k7JWj5R3zZhAHlFBgIQ1g
Message-ID: <CA+55aFz5ezrCyriKhfB2x7BPqnXH977Yt2-iLcbstCkTD7MoNg@mail.gmail.com>
Subject: Linux 3.14-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, things are looking pretty normal, and rc4 is smaller than rc3, so
I'm happy.

The biggest patch in here (accounting for about a sixth of the total)
is just DaveJ re-indenting a reiserfs file. Ignoring that whitespace
cleanup, the rest is mostly the usual mix of drivers, networking and
some architecture updates.

Nothing big, and nothing that looks particularly scary.

So get to it, and test it all out.

           Linus

---

Aaro Koskinen (3):
      ARM: OMAP1: nokia770: enable tahvo-usb
      ARM: dts: N9/N950: fix boot hang with 3.14-rc1
      ARM: dts: N900: add missing compatible property

Aaron Lu (1):
      ACPI / video: Add systems that should favour native backlight interface

Adam Thomson (1):
      ASoC: da9055: Fix device registration of PMIC and CODEC devices

Ajay Kumar Gupta (1):
      usb: musb: host: Fix SuperSpeed hub enumeration

Alan Stern (1):
      USB: EHCI: add delay during suspend to prevent erroneous wakeups

Aleksander Morgado (2):
      net: qmi_wwan: add support for Cinterion PXS8 and PHS8
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Alex Deucher (7):
      drm/radeon: unify bpc handling
      drm: add DRM_CAPs for cursor size
      drm/radeon: fill in DRM_CAPs for cursor size
      drm/radeon/dpm: reduce r7xx vblank mclk threshold to 200
      drm/radeon: fix display tiling setup on SI
      drm/radeon/si: fix typo in dpm sq ramping setup
      drm/radeon/ni: fix typo in dpm sq ramping setup

Alexander Gordeev (4):
      PCI/MSI: Add pci_enable_msi() documentation back
      PCI/MSI: Fix cut-and-paste errors in documentation
      PCI/MSI: Add pci_enable_msi_exact() and pci_enable_msix_exact()
      ahci: Fix broken fallback to single MSI mode

Alexander Shiyan (1):
      ASoC: txx9aclc_ac97: Fix kernel crash on probe

Alexandre Courbot (2):
      drm/nouveau: fix ENG_RUNLIST register address
      drm/ttm: declare 'struct device' in ttm_page_alloc.h

Andrew Lunn (3):
      ATA: SATA_MV: Add missing Kconfig select statememnt
      PCI: mvebu: Use Device ID and revision from underlying endpoint
      irqchip: orion: Fix getting generic chip pointer.

Andrzej Pietrasiewicz (1):
      usb: gadget: fix NULL pointer dereference

Andy Adamson (1):
      NFS fix error return in nfs4_select_rw_stateid

Aneesh Kumar K.V (3):
      powerpc/mm: Add new "set" flag argument to pte/pmd update function
      mm: Dirty accountable change only apply to non prot numa case
      mm: Use ptep/pmdp_set_numa() for updating _PAGE_NUMA bit

Anton Blanchard (2):
      powerpc: Link VDSOs at 0x0
      powerpc: Use unstripped VDSO image for more accurate profiling data

Antonio Quartulli (9):
      batman-adv: fix soft-interface MTU computation
      batman-adv: fix TT-TVLV parsing on OGM reception
      batman-adv: release vlan object after checking the CRC
      batman-adv: properly check pskb_may_pull return value
      batman-adv: avoid potential race condition when adding a new neighbour
      batman-adv: fix TT CRC computation by ensuring byte order
      batman-adv: free skb on TVLV parsing success
      batman-adv: avoid double free when orig_node initialization fails
      batman-adv: fix potential kernel paging error for unicast transmissions

Archana Patni (1):
      HID: hid-sensor-hub: quirk for STM Sensor hub

Arnaldo Carvalho de Melo (1):
      perf trace: Fix ioctl 'request' beautifier build problems on
!(i386 || x86_64) arches

Arve Hjønnevåg (1):
      staging: binder: Fix death notifications

Ben Dooks (1):
      of_mdio: fix phy interrupt passing

Ben Hutchings (1):
      perf trace: Add fallback definition of EFD_SEMAPHORE

Ben Myers (1):
      MAINTAINERS: SGI no longer maintaining XFS

Benjamin Tissoires (2):
      HID: multitouch: add FocalTech FTxxxx support
      HID: fix buffer allocations

Bjorn Helgaas (1):
      PCI: Enable INTx if BIOS left them disabled

Boris Ostrovsky (1):
      sched/deadline: Test for CPU's presence explicitly

Brian Campbell (1):
      user_namespace.c: Remove duplicated word in comment

Chao Bi (1):
      mei: set client's read_cb to NULL when flow control fails

Charmaine Lee (1):
      drm/vmwgfx: Get maximum mob size from register SVGA_REG_MOB_MAX_SIZE

Chen Gang (3):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use
      avr32: add generic ioremap_wc() definition in io.h
      avr32: add generic vga.h to Kbuild

Christian König (1):
      drm/radeon: fix CP semaphores on CIK

Christoffer Dall (1):
      ARM: 7950/1: mm: Fix stage-2 device memory attributes

Christoph Hellwig (1):
      xfs: ensure correct timestamp updates from truncate

Clemens Ladisch (1):
      ALSA: usb-audio: work around KEF X300A firmware bug

Cong Wang (2):
      macvlan: unregister net device when netdev_upper_dev_link() fails
      net: correct error path in rtnl_newlink()

Dan Carpenter (5):
      drm/vmwgfx: unlock on error path in vmw_execbuf_process()
      ath5k: shifting the wrong variable for AR5K_AR5210
      jbd2: fix use after free in jbd2_journal_start_reserved()
      drm/radeon: delete a stray tab
      af_packet: remove a stray tab in packet_set_ring()

Daniel Borkmann (4):
      netdevice: add queue selection fallback handler for ndo_select_queue
      netdevice: move netdev_cap_txqueue for shared usage to header
      packet: check for ndo_select_queue during queue selection
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

Daniel Mack (4):
      usb: musb: do not sleep in atomic context
      usb: musb: do not sleep in atomic context
      usb: musb: correct use of schedule_delayed_work()
      usb: musb: correct use of schedule_delayed_work()

Dave Chinner (1):
      xfs: ensure correct log item buffer alignment

Dave Jones (2):
      drm/i2c: tda998x: Fix memory leak in tda998x_encoder_init error path.
      reiserfs: fix utterly brain-damaged indentation.

Dave Kleikamp (1):
      jfs: set i_ctime when setting ACL

David Herrmann (2):
      HID: Bluetooth: hidp: make sure input buffers are big enough
      HID: hyperv: make sure input buffer is big enough

David Howells (2):
      FS-Cache: Handle removal of unadded object to the
fscache_object_list rb tree
      Sparc: sparc_cpu_model isn't in asm/system.h any more [ver #2]

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394

Dirk Brandewie (2):
      intel_pstate: Use LFM bus ratio as min ratio/P state
      intel_pstate: Add support for Baytrail turbo P states

Duan Jiong (2):
      ipv4: distinguish EHOSTUNREACH from the ENETUNREACH
      ipv4: fix counter in_slow_tot

Dylan Reid (1):
      ASoC: max98090: sync regcache on entering STANDBY

Emil Goode (2):
      net: asix: add missing flag to struct driver_info
      usbnet: remove generic hard_header_len check

Emil Velikov (1):
      drm/nouveau/fb: use correct ram oclass for nv1a hardware

Emmanuel Grumbach (1):
      iwlwifi: disable TX AMPDU by default for iwldvm

Eric Sandeen (3):
      xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
      xfs: skip verification on initial "guess" superblock read
      xfs: limit superblock corruption errors to actual corruption

Eric Whitney (1):
      ext4: fix xfstest generic/299 block validity failures

Erik Hugne (1):
      tipc: fix message corruption bug for deferred packets

Ezequiel Garcia (1):
      ata: sata_mv: Cleanup only the initialized ports

FX Le Bail (1):
      ipv4: ipconfig.c: add parentheses in an if statement

Fabio Estevam (1):
      ata: pata_imx: Check the return value from clk_prepare_enable()

Felipe Balbi (1):
      usb: musb: fix obex in g_nokia.ko causing kernel panic

Florian Fainelli (3):
      net: of_mdio: fix of_set_phy_supported after driver probing
      usb: gadget: bcm63xx_udc: fix build failure on DMA channel code
      MAINTAINERS: add entry for the PHY library

Florian Vaussard (4):
      ARM: dts: omap3-tobi: Fix boot with OMAP36xx-based Overo
      ARM: dts: omap3-tobi: Use the correct vendor prefix
      ARM: dts: Add support for both OMAP35xx and OMAP36xx Overo/Tobi
      Documentation: dt: OMAP: Update Overo/Tobi

Florian Westphal (2):
      net: core: introduce netif_skb_dev_features
      net: ip, ipv6: handle gso skbs in forwarding path

Gavin Shan (3):
      powerpc/powernv: Rework EEH reset
      powerpc/eeh: Cleanup on eeh_subsystem_enabled
      powerpc/eeh: Disable EEH on reboot

Geert Uytterhoeven (2):
      mfd: max14577: max14577_{suspend,resume}() should depend on
CONFIG_PM_SLEEP
      mfd: sec-core: sec_pmic_{suspend,resume}() should depend on
CONFIG_PM_SLEEP

Gerrit Renker (1):
      dccp: re-enable debug macro

Grant Likely (2):
      of: Move testcase FDT data into drivers/of
      of: Add self test for of_match_node()

Greg Kroah-Hartman (3):
      PCI/MSI: Check kmalloc() return value, fix leak of name
      PCI/MSI: Fix leak of msi_attrs
      Revert "tty: Set correct tty name in 'active' sysfs attribute"

Guangliang Zhao (1):
      ceph: make ceph_forget_all_cached_acls() static inline

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

Haiyang Zhang (1):
      hyperv: Fix the carrier status setting

Hans de Goede (4):
      phy-core: phy_get: Leave error logging to the caller
      phy-core: Don't propagate -ENOSUPP from phy_pm_runtime_get_sync to caller
      phy-core: Don't allow building phy-core as a module
      ACPI / video: Filter the _BCL table for duplicate brightness values

Heiko Schocher (1):
      drivers: net: cpsw: fix buggy loop condition

Hsin-Yu Chao (2):
      ALSA: hda/ca0132 - setup/cleanup streams
      ALSA: hda/ca0132 - Fix recording from mode id 0x8

Huei-Horng Yo (1):
      HID: apple: add Apple wireless keyboard 2011 JIS model support

Hugh Dickins (1):
      cgroup: use an ordered workqueue for cgroup destruction

Hui Wang (2):
      ALSA: hda - add headset mic detect quirks for two Dell laptops
      ALSA: hda - Enable front audio jacks on one HP desktop model

Ilia Mirkin (7):
      drm/nouveau: set irq_enabled manually
      drm/nv4c/mc: nv4x igp's have a different msi rearm register
      drm/nv4c/vga: decode register is in a different place on nv4x igp's
      drm/nv4c/bios: disallow retrieving from prom on nv4x igp's
      drm/nv50/gr: add missing nv_error parameter priv
      drm/nv50/disp: use correct register to determine DP display bpp
      drm/nouveau: fix TTM_PL_TT memtype on pre-nv50

Ingo Molnar (1):
      drivers/net: tulip_remove_one needs to call pci_disable_device()

Jan Luebbe (1):
      net: fix macvtap type name in Kconfig

Jani Nikula (2):
      drm/i915/dp: increase native aux defer retry timeout
      drm/i915/dp: add native aux defer retry limit

Jarkko Nikula (1):
      ASoC: rt5640: Add ACPI ID for Intel Baytrail

Jason Cooper (1):
      ARM: dove: dt: revert PMU interrupt controller node

Jeff Layton (1):
      cifs: ensure that uncached writes handle unmapped areas correctly

Jiang Liu (1):
      ACPI / nouveau: fix probing regression related to _DSM

Jingoo Han (1):
      USB2NET: SR9800: use %zu for size_t

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Jiri Olsa (1):
      perf tools: Handle PERF_RECORD_HEADER_EVENT_TYPE properly

Joerg Roedel (1):
      arm/smmu: Use irqsafe spinlock for domain lock

Josh Cartwright (1):
      usb: phy: msm: fix compilation errors when !CONFIG_PM_SLEEP

Juri Lelli (3):
      sched/deadline: Fix bad accounting of nr_running
      sched/core: Fix sched_rt_global_validate
      sched/core: Make dl_b->lock IRQ safe

Kevin Hao (3):
      powerpc: Set the correct ksp_limit on ppc32 when switching to irq stack
      Revert "of: search the best compatible match first in __of_match_node()"
      of: reimplement the matching method for __of_match_node()

Kirill Tkhai (1):
      sched/deadline: Remove useless dl_nr_total

Kishon Vijay Abraham I (1):
      phy: let phy_provider_register be the last step in registering PHY

Kleber Sacilotto de Souza (2):
      powerpc/pseries: Fix regression on PCI link speed
      powerpc/pseries: Add Gen3 definitions for PCIE link speed

Krzysztof Kozlowski (1):
      regulator: max14577: Fix invalid return value on DT parse success

Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()

Lars-Peter Clausen (1):
      ASoC: blackfin: Fix machine driver Kconfig dependencies

Lee Jones (4):
      mfd: max8997: Naturalise cross-architecture discrepancies
      mfd: max8998: Naturalise cross-architecture discrepancies
      mfd: wm8994-core: Naturalise cross-architecture discrepancies
      mfd: tps65217: Naturalise cross-architecture discrepancies

Levente Kurusa (1):
      ahci: disable NCQ on Samsung pci-e SSDs on macbooks

Li Zefan (2):
      cpuset: update MAINTAINERS entry
      cgroup: protect modifications to cgroup_idr with cgroup_mutex

Li Zhong (1):
      workqueue: add args to workqueue lockdep name

Linus Torvalds (2):
      printk: fix syslog() overflowing user buffer
      Linux 3.14-rc4

Liu Junliang (1):
      USB2NET: Fix Default to 'y' for SR9800 Device Driver, setting to 'n'

Luis G.F (1):
      ACPI / SBS: Fix incorrect sscanf() string

Marek Belisko (2):
      ARM: dts: omap3-gta04: Add EOC irq gpio line handling.
      ARM: dts: omap3-gta04: Fix mmc1 properties.

Marek Szyprowski (2):
      ARM: dma-mapping: fix GFP_ATOMIC macro usage
      x86: dma-mapping: fix GFP_ATOMIC macro usage

Markus Metzger (1):
      perf, nmi: Fix unknown NMI warning

Masami Hiramatsu (1):
      perf probe: Do not add offset twice to uprobe address

Masanari Iida (2):
      PCI/MSI: Fix pci_msix_vec_count() htmldocs failure
      drm/ttm: Fix memory leak in ttm_agp_backend.c

Matija Glavinic Pecotic (1):
      net: sctp: Fix a_rwnd/rwnd management to reflect real state of
the receiver's buffer

Matt Porter (1):
      MAINTAINERS: add additional ARM BCM281xx/BCM11xxx maintainer

Matthieu CASTET (1):
      usb: chipidea: need to mask when writting endptflush and endptprime

Michael S. Tsirkin (2):
      vhost: fix ref cnt checking deadlock
      vhost: fix a theoretical race in device cleanup

Michal Simek (2):
      net: axienet: Fix compilation error
      net: axienet: Fix compilation warnings

Mika Westerberg (1):
      x86: tsc: Add missing Baytrail frequency to the table

Mike Galbraith (1):
      net,bonding: fix bond_options.c direct rwlock.h include

NeilBrown (1):
      ARM: dts: omap3-gta04: Fix 'aux' gpio key flags.

Nicolas Dichtel (1):
      gre: add link local route when local addr is any

Nishanth Menon (1):
      ARM: OMAP2+: add missing ARCH_HAS_OPP

Olivier Langlois (2):
      rtlwifi: rtl8192ce: Fix too long disable of IRQs
      rtlwifi: Fix incorrect return from rtl_ps_enable_nic()

Olivier Sobrie (1):
      can: kvaser_usb: check number of channels returned by HW

Paul Bolle (2):
      ARM: OMAP2+: Remove MACH_NOKIA_N800
      ARM: OMAP2+: Remove legacy macros for zoom platforms

Paul Gortmaker (4):
      Documentation/networking: delete orphaned 3c505.txt file.
      avr32: fix missing module.h causing build failure in mimc200/fram.c
      sparc32: fix build failure for arch_jump_label_transform
      sparc32: make copy_to/from_user_page() usable from modular code

Pavel Shilovsky (1):
      CIFS: Fix too big maxBuf size for SMB3 mounts

Pekon Gupta (2):
      ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when
MTD_NAND is built as module
      ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when
MTD_ONENAND is built as module

Peter Chen (1):
      usb: gadget: printer: using gadget_is_otg to check otg support at runtime

Peter Ujfalusi (6):
      ASoC: davinci-mcasp: Harmonize the sub hw_params function names
      ASoC: davinci-mcasp: Configure xxTDM, xxFMT and xxFMCT registers
synchronously
      ASoC: davinci-mcasp: Consolidate pm_runtime_get/put() use in the driver
      ASoC: davinci-evm: Add pm callbacks to platform driver
      ARM: DTS: am335x-evmsk: Correct audio clock frequency
      ARM: dts: am335x-evmsk: Fix mmc1 support

Peter Zijlstra (4):
      perf/x86/intel/p6: Add userspace RDPMC quirk for PPro
      perf/x86: Fix Userspace RDPMC switch
      sched: Add 'flags' argument to sched_{set,get}attr() syscalls
      perf/x86: Correctly use FEATURE_PDCM

Rafael J. Wysocki (2):
      ACPI / dock: Make 'docked' sysfs attribute work as documented
      Revert "ACPI: Blacklist Win8 OSI for some HP laptop 2013 models"

Reyad Attiyat (1):
      HID: microsoft: Add ID's for Surface Type/Touch Cover 2

Richard Weinberger (1):
      phy,phy-bcm-kona-usb2.c: Add dependency on HAS_IOMEM

Rik van Riel (1):
      sched,numa: add cond_resched to task_numa_work

Roger Quadros (1):
      usb: musb: core: Fix remote-wakeup resume

Russell King (3):
      ARM: dts: fix spdif pinmux configuration
      Fix uses of dma_max_pfn() when converting to a limiting address
      NET: fec: only enable napi if we are successful

Russell King - ARM Linux (1):
      hostap: fix "hostap: proc: Use remove_proc_subtree()"

Sachin Kamat (5):
      ASoC: samsung: Remove invalid dependencies
      ASoC: samsung: Fix trivial typo
      regulator: s5m8767: Use of_get_child_by_name
      regulator: s5m8767: Add missing of_node_put
      usb: gadget: s3c2410_udc: Fix build error

Sage Weil (1):
      ceph: add acl, noacl options for cephfs mount

Santosh Shilimkar (1):
      ARM: 7952/1: mm: Fix the memblock allocation for LPAE machines

Sebastian Hesselbarth (3):
      irqchip: orion: clear bridge cause register on init
      irqchip: orion: use handle_edge_irq on bridge irqs
      irqchip: orion: clear stale interrupts in irq_startup

Shawn Guo (2):
      ASoC: fsl: fix pm support of machine drivers
      ARM: imx6: build pm-imx6q.c independently of CONFIG_PM

Shuah Khan (7):
      ACPI / AC: fix AC driver compile error when CONFIG_PM_SLEEP is undefined
      ACPI / battery: fix battery driver compile error when
CONFIG_PM_SLEEP is undefined
      ACPI / button: fix button driver compile error when
CONFIG_PM_SLEEP is undefined
      ACPI / fan: fix fan driver compile error when CONFIG_PM_SLEEP is undefined
      ACPI / SBS: fix SBS driver compile error when CONFIG_PM_SLEEP is undefined
      ACPI / thermal: fix thermal driver compile error when
CONFIG_PM_SLEEP is undefined
      regulator: core: Change dummy supplies error message to a warning

Simon Wunderlich (1):
      batman-adv: fix potential orig_node reference leak

Srinivas Kandagatla (1):
      net: stmmac:sti: Add STi SOC glue driver.

Srivatsa S. Bhat (1):
      cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Stanislav Kholmanskikh (1):
      watchdog: w83697hf_wdt: return ENODEV if no device was found

Stanislaw Gruszka (1):
      rtl8187: fix regression on MIPS without coherent DMA

Stefan Sørensen (1):
      net:phy:dp83640: Move all HW initialization to dp83640_config_init

Stephane Eranian (1):
      perf/x86/uncore: Fix IVT/SNB-EP uncore CBOX NID filter table

Stephen Boyd (1):
      sched_clock: Prevent callers from seeing half-updated data

Stephen Warren (3):
      ASoC: max98090: make REVISION_ID readable
      ARM: tegra: fix RTC0 alias for Cardhu
      ARM: tegra: only run PL310 init on systems with one

Steve French (1):
      [CIFS] Fix cifsacl mounts over smb2 to not call cifs

Steve Twiss (1):
      regulator: da9063: Bug fix when setting max voltage on LDOs 5-11

Steven Rostedt (1):
      sched/deadline: Fix overflow to handle period==0 and deadline!=0

Sumit Semwal (1):
      dma-buf: update debugfs output

Tejun Heo (8):
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
      arm, pm, vmpressure: add missing slab.h includes
      nfs: include xattr.h from fs/nfs/nfs3proc.c
      cgroup: fix error return value in cgroup_mount()
      cgroup: fix error return from cgroup_create()
      cgroup: fix locking in cgroup_cfts_commit()
      Revert "cgroup: use an ordered workqueue for cgroup destruction"
      cgroup: update cgroup_enable_task_cg_lists() to grab siglock

Theodore Ts'o (4):
      ext4: don't try to modify s_flags if the the file system is read-only
      ext4: fix online resize with very large inode tables
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized

Thierry Reding (2):
      ARM: pxa: Add dummy backlight power supply on Mitac Mio A701
      ARM: tegra: Add head numbers to display controllers

Thomas Gleixner (1):
      x86, tsc: Fallback to normal calibration if fast MSR calibration fails

Thomas Hellstrom (4):
      drm/vmwgfx: Fix a couple of sparse warnings and errors
      drm/vmwgfx: Remove stray const
      drm/vmwgfx: Fix possible integer overflow
      drm/vmwgfx: Fix command defines and checks

Thomas Petazzoni (1):
      net: ethernet: update dependency and help text of mvneta

Tomasz Nowicki (1):
      ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()

Tommie Gannert (1):
      irtty-sir.c: Do not set_termios() on irtty_close()

Trond Myklebust (7):
      NFS: Do not set NFS_INO_INVALID_LABEL unless server supports labeled NFS
      SUNRPC: Don't create a gss auth cache unless rpc.gssd is running
      SUNRPC: Fix races in xs_nospace()
      SUNRPC: Fix potential memory scribble in xprt_free_bc_request()
      SUNRPC: Ensure that gss_auth isn't freed before its upcall messages
      SUNRPC: Fix a pipe_version reference leak
      NFSv4: Use the correct net namespace in nfs4_update_server

Uwe Kleine-König (1):
      net: cpsw: catch of_get_phy_mode failing and propagate error

Vegard Nossum (1):
      sched: Fix information leak in sys_sched_getattr()

Vijay Subramanian (1):
      net: sched: Cleanup PIE comments

Ville Syrjälä (2):
      drm/i915: Add intel_ring_cachline_align()
      drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Vince Weaver (1):
      perf list: Fix checking for supported events on older kernels

Wei Yongjun (1):
      ASoC: wm8993: drop regulator_bulk_free of devm_ allocated data

Will Deacon (6):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU
      ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev
      iommu/arm-smmu: really fix page table locking
      iommu/arm-smmu: fix table flushing during initial allocations
      iommu/arm-smmu: set CBARn.BPSHCFG to NSH for s1-s2-bypass contexts
      iommu/arm-smmu: fix compilation issue when !CONFIG_ARM_AMBA

Willy Tarreau (1):
      ARM: mvebu: dt: add missing alias 'eth3' on Armada XP mv78260

Xiubo Li (1):
      ASoC: fsl-esai: fix ESAI TDM slot setting

Yan, Zheng (6):
      ceph: properly handle XATTR_CREATE and XATTR_REPLACE
      ceph: remove xattr when null value is given to setxattr()
      ceph: fix ceph_removexattr()
      ceph: fix ceph_set_acl()
      ceph: add missing init_acl() for mkdir() and atomic_open()
      ceph: fix __dcache_readdir()

Yifan Zhang (1):
      iommu/arm-smmu: fix pud/pmd entry fill sequence

Yufeng Shen (1):
      HID: usbhid: quirk for CY-TM75 75 inch Touch Overlay

Zheng Liu (1):
      ext4: fix error paths in swap_inode_boot_loader()

dingtianhong (1):
      bonding: Fix deadlock in bonding driver when using netpoll

viresh kumar (1):
      cpufreq: remove sysfs link when a cpu != policy->cpu, is removed

wangweidong (2):
      sctp: fix a missed .data initialization
      sctp: optimize the sctp_sysctl_net_register
