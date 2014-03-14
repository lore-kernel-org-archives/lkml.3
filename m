Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030207AbaCNVjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:39:53 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:65048 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbaCNVjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:39:47 -0400
Message-ID: <5323771F.6030709@suse.cz>
Date: Fri, 14 Mar 2014 22:39:43 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.14
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm announcing the release of the 3.12.14 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

Adam Thomson (1):
      ASoC: da9055: Fix device registration of PMIC and CODEC devices

Alan Stern (1):
      USB: EHCI: add delay during suspend to prevent erroneous wakeups

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8
and PXS8

Alex Deucher (4):
      drm/radeon/ni: fix typo in dpm sq ramping setup
      drm/radeon: fix audio disable on dce6+
      drm/radeon: print the supported atpx function mask
      drm/radeon: disable pll sharing for DP on DCE4.1

Alexander Shiyan (1):
      ASoC: txx9aclc_ac97: Fix kernel crash on probe

Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Andrew Lunn (2):
      PCI: mvebu: Use Device ID and revision from underlying endpoint
      irqchip: orion: Fix getting generic chip pointer.

Andy Adamson (1):
      NFS fix error return in nfs4_select_rw_stateid

Arve Hjønnevåg (1):
      staging: binder: Fix death notifications

Bjorn Helgaas (1):
      PCI: Enable INTx if BIOS left them disabled

Bjørn Mork (1):
      net: qmi_wwan: add Netgear Aircard 340U

Chao Bi (1):
      mei: set client's read_cb to NULL when flow control fails

Charles Keepax (1):
      Input - arizona-haptics: Fix double lock of dapm_mutex

Chen Gang (1):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Christian König (1):
      drm/radeon: fix missing bo reservation

Christoph Hellwig (1):
      fs: fix iversion handling

Clemens Ladisch (1):
      ALSA: usb-audio: work around KEF X300A firmware bug

Cong Wang (1):
      bridge: fix netconsole setup over bridge

Dan Carpenter (1):
      jbd2: fix use after free in jbd2_journal_start_reserved()

Dan Williams (1):
      ioat: fix tasklet tear down

Daniel Borkmann (1):
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

David Henningsson (3):
      ALSA: HDA - Limit mic boost and add mute LED for an HP machine
      ALSA: hda - Another Dell headset quirk
      ALSA: hda - A casual Dell Headset quirk

Davidlohr Bueso (1):
      ipc,mqueue: remove limits for the amount of system-wide queues

Denis CIOCCA (1):
      iio:gyro: bug on L3GD20H gyroscope support

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394

Dr. Greg Wettstein (1):
      qla2xxx: Fix kernel panic on selective retransmission request

Duan Jiong (1):
      ipv4: fix counter in_slow_tot

Dylan Reid (1):
      ASoC: max98090: sync regcache on entering STANDBY

Emil Goode (2):
      net: asix: add missing flag to struct driver_info
      usbnet: remove generic hard_header_len check

Eric Dumazet (2):
      6lowpan: fix lockdep splats
      net: use __GFP_NORETRY for high order allocations

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Eric Whitney (1):
      ext4: fix xfstest generic/299 block validity failures

Filipe David Borba Manana (3):
      Btrfs: return immediately if tree log mod is not necessary
      Btrfs: fix tree mod logging
      Btrfs: fix data corruption when reading/updating compressed extents

Florian Fainelli (1):
      usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Florian Westphal (3):
      net: add and use skb_gso_transport_seglen()
      net: core: introduce netif_skb_dev_features
      net: ip, ipv6: handle gso skbs in forwarding path

Gavin Shan (1):
      powerpc/powernv: Rework EEH reset

Geert Uytterhoeven (1):
      ipv4: Fix runtime WARNING in rtmsg_ifa()

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Hans de Goede (1):
      ACPI / video: Filter the _BCL table for duplicate brightness values

Hsin-Yu Chao (2):
      ALSA: hda/ca0132 - setup/cleanup streams
      ALSA: hda/ca0132 - Fix recording from mode id 0x8

Hui Wang (4):
      ALSA: hda - A Dell headset detection quirk
      ALSA: hda - Another Dell headset detection quirk
      ALSA: hda - One more Dell headset detection quirk
      ALSA: hda - Enable front audio jacks on one HP desktop model

Ilia Mirkin (2):
      drm/nouveau: set irq_enabled manually
      drm/nv50/disp: use correct register to determine DP display bpp

James Hogan (1):
      irq-metag*: stop set_affinity vectoring to offline cpus

Jan Kara (1):
      quota: Fix race between dqput() and dquot_scan_active()

Jani Nikula (2):
      drm/i915/dp: increase native aux defer retry timeout
      drm/i915/dp: add native aux defer retry limit

Jean Delvare (2):
      i7core_edac: Fix PCI device reference count
      i7300_edac: Fix device reference count

Jeff Layton (1):
      cifs: ensure that uncached writes handle unmapped areas correctly

Jerome Glisse (1):
      drm/radeon: free uvd ring on unload

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Jiri Slaby (1):
      Linux 3.12.14

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

John Ogness (1):
      tcp: tsq: fix nonagle handling

Kailang Yang (1):
      ALSA: hda/realtek - Make fixup regs persist after resume

Kevin Hao (1):
      powerpc: Set the correct ksp_limit on ppc32 when switching to
irq stack

Kirill A. Shutemov (1):
      mm, thp: fix infinite loop on memcg OOM

Knut Petersen (1):
      perf: Enforce 1 as lower limit for perf_event_max_sample_rate

Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()

Lars-Peter Clausen (2):
      ASoC: sta32x: Fix cache sync
      ASoC: wm8958-dsp: Fix firmware block loading

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Levente Kurusa (1):
      ahci: disable NCQ on Samsung pci-e SSDs on macbooks

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor

Maciej Żenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Manu Gupta (1):
      staging: r8188eu: Add new device ID

Marek Szyprowski (2):
      ARM: dma-mapping: fix GFP_ATOMIC macro usage
      x86: dma-mapping: fix GFP_ATOMIC macro usage

Mark Brown (1):
      ASoC: da732x: Mark DC offset control registers volatile

Matthieu CASTET (1):
      usb: chipidea: need to mask when writting endptflush and endptprime

Max Filippov (2):
      xtensa: save current register frame in
fast_syscall_spill_registers_fixup
      xtensa: introduce spill_registers_kernel macro

Michael S. Tsirkin (1):
      vhost: fix ref cnt checking deadlock

Mike Snitzer (2):
      dm thin: avoid metadata commit if a pool's thin devices haven't
changed
      dm thin: fix the error path for the thin device constructor

Nicholas Bellinger (1):
      bio-integrity: Fix bio_integrity_verify segment start bug

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Oliver Hartkopp (1):
      can: add destructor for self generated skbs

Olivier Langlois (2):
      rtlwifi: Fix incorrect return from rtl_ps_enable_nic()
      rtlwifi: rtl8192ce: Fix too long disable of IRQs

Olivier Sobrie (1):
      can: kvaser_usb: check number of channels returned by HW

Olof Johansson (1):
      ARM64: unwind: Fix PC calculation

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c

Paul Mackerras (1):
      powerpc: Increase stack redzone for 64-bit userspace to 512 bytes

Pavel Shilovsky (1):
      CIFS: Fix too big maxBuf size for SMB3 mounts

Pekon Gupta (2):
      ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when
MTD_NAND is built as module
      ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when
MTD_ONENAND is built as module

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Richard Yao (1):
      9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Sabrina Dubroca (1):
      netpoll: fix netconsole IPv6 setup

Sebastian Capella (1):
      PM / hibernate: Fix restore hang in freeze_processes()

Sebastian Hesselbarth (3):
      irqchip: orion: clear bridge cause register on init
      irqchip: orion: use handle_edge_irq on bridge irqs
      irqchip: orion: clear stale interrupts in irq_startup

Srivatsa S. Bhat (1):
      cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Stanislaw Gruszka (2):
      rtl8187: fix regression on MIPS without coherent DMA
      usb: ehci: fix deadlock when threadirqs option is used

Steve Twiss (1):
      regulator: da9063: Bug fix when setting max voltage on LDOs 5-11

Takashi Iwai (6):
      ALSA: hda - Add extra chmap for 2.1 outputs on ASUS laptops
      ALSA: hda - Fix missing bass speaker on ASUS N550
      ASoC: wm8770: Fix wrong number of enum items
      ASoC: sta32x: Fix wrong enum for limiter2 release rate
      ASoC: sta32x: Fix array access overflow
      ALSA: hda - Add a fixup for HP Folio 13 mute LED

Tejun Heo (5):
      cgroup: fix error return value in cgroup_mount()
      cgroup: fix error return from cgroup_create()
      cgroup: fix locking in cgroup_cfts_commit()
      cgroup: update cgroup_enable_task_cg_lists() to grab siglock
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN

Theodore Ts'o (4):
      ext4: don't try to modify s_flags if the the file system is
read-only
      ext4: fix online resize with very large inode tables
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized

Tomasz Nowicki (1):
      ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()

Tony Breeds (1):
      powerpc/le: Ensure that the 'stop-self' RTAS token is handled
correctly

Trond Myklebust (3):
      NFS: Do not set NFS_INO_INVALID_LABEL unless server supports
labeled NFS
      SUNRPC: Fix races in xs_nospace()
      SUNRPC: Ensure that gss_auth isn't freed before its upcall messages

Ville Syrjälä (2):
      drm/i915: Add intel_ring_cachline_align()
      drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon (4):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before
enabling MMU
      ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev
      iommu/arm-smmu: really fix page table locking
      iommu/arm-smmu: set CBARn.BPSHCFG to NSH for s1-s2-bypass contexts

Yifan Zhang (1):
      iommu/arm-smmu: fix pud/pmd entry fill sequence

Zheng Liu (1):
      ext4: fix error paths in swap_inode_boot_loader()

thanks,
- --
js
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTI3cfAAoJEL0lsQQGtHBJPXYQAKyTaaIX1Q5/dWwN8reiKPkt
DErsUJ7d+yfyHlzr+VPC3SKXyX282U38j5sIaoj7ugwCzOEK/oPjlTiSCyIh1NdX
Q4RK1Um7dGexwyTc0x6/3Sdue27rMfWVt1UoRAQUJ8dgpoawn5CWNT8Tyxh1Z8+x
wHOb/ggtwrdXmxefMZXbZ0sZEbyTUn1Q3s9/crWXlGN/ov2ptTuaXFccjaby2Cjr
m1Z+cUoCkIcd4Ad/JAdJkLw1/EPAwQ3QBYmeX8p64ZSlYRTGI1Xc+uvJqoUOK2o2
qxOLFSkZHfc8WBWv/uGKDtoh3a0BrwHFoRxPQxykP1yYGk0z0s8d6Ajf4OyXvjXJ
TO0EWALUdzSQqGG1z3NA4lJ1lnBd3110Fg9xUMfedNqMoFbICAy8Y3hvNi5oyKN4
R0zu5X3GXnZEAwneUlmzf5qHcYxPyl+tSzkyQt6C7me79kGnG8e6Di5V5wfJao3m
P66BdOQJ1ORtXz8Xd/vCS7fxED74Pn5z4XgYesDD+OeOcuPFsQV4Wh/6oRZvHIjb
0aIxLHh7GP0HxbHrhrG0YnzORGEsku/I99TNGl4Po0dohu34tD58UFScVLioyyvG
RKZ+gGOpknWZHh1CzpWGA463hlBVehE/7NMi0gwrpOqsFSauv0kFYaJHHFF+hdoM
0Tp4pEi1CGHaA5KNVPPt
=lwtS
-----END PGP SIGNATURE-----
