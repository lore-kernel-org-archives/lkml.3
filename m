Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaAIWCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:02:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaAIWCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:02:43 -0500
Date: Thu, 9 Jan 2014 14:03:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.26
Message-ID: <20140109220314.GA26365@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.26 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt                |    4=20
 Makefile                                           |    2=20
 arch/arm/include/asm/arch_timer.h                  |    9 -
 arch/arm/kernel/hyp-stub.S                         |    2=20
 arch/arm/kvm/interrupts_head.S                     |    4=20
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |    4=20
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |    6=20
 arch/arm64/boot/dts/foundation-v8.dts              |    2=20
 arch/arm64/include/asm/arch_timer.h                |   10 -
 arch/arm64/include/asm/pgtable.h                   |    2=20
 arch/arm64/include/asm/spinlock.h                  |    3=20
 arch/arm64/include/asm/syscall.h                   |    6=20
 arch/arm64/include/asm/thread_info.h               |    4=20
 arch/arm64/include/asm/virt.h                      |   13 +
 arch/arm64/kernel/entry.S                          |    2=20
 arch/arm64/kernel/fpsimd.c                         |    2=20
 arch/arm64/kernel/ptrace.c                         |   38 ++---
 arch/arm64/kernel/smp.c                            |   15 +
 arch/arm64/mm/flush.c                              |   30 ---
 arch/arm64/mm/mmu.c                                |    1=20
 arch/arm64/mm/proc.S                               |    4=20
 arch/powerpc/include/asm/exception-64s.h           |    2=20
 arch/powerpc/kernel/head_64.S                      |    1=20
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |    6=20
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |    4=20
 arch/sh/kernel/sh_ksyms_32.c                       |    5=20
 arch/sh/lib/Makefile                               |    2=20
 arch/sparc/include/asm/pgtable_64.h                |    4=20
 arch/x86/include/asm/pgtable.h                     |   11 +
 arch/x86/include/asm/spinlock.h                    |    4=20
 arch/x86/kernel/cpu/intel.c                        |    3=20
 arch/x86/kvm/lapic.c                               |    8 -
 drivers/ata/libata-core.c                          |    7=20
 drivers/ata/libata-scsi.c                          |   21 ++
 drivers/block/rbd.c                                |  158 +++++++++++++---=
-----
 drivers/clocksource/arm_arch_timer.c               |   23 ---
 drivers/clocksource/dw_apb_timer_of.c              |    2=20
 drivers/cpufreq/intel_pstate.c                     |    5=20
 drivers/dma/Kconfig                                |    1=20
 drivers/firewire/sbp2.c                            |    1=20
 drivers/gpio/gpio-msm-v2.c                         |    4=20
 drivers/gpio/gpio-twl4030.c                        |   15 +
 drivers/gpu/drm/drm_edid.c                         |    8 +
 drivers/gpu/drm/i915/i915_dma.c                    |   10 +
 drivers/gpu/drm/i915/i915_gem_context.c            |    2=20
 drivers/gpu/drm/i915/intel_display.c               |    7=20
 drivers/gpu/drm/radeon/atombios_crtc.c             |    4=20
 drivers/gpu/drm/radeon/ni.c                        |   20 ++
 drivers/gpu/drm/radeon/radeon_uvd.c                |    2=20
 drivers/gpu/drm/radeon/rs690.c                     |   10 +
 drivers/idle/intel_idle.c                          |    3=20
 drivers/iio/adc/ad7887.c                           |   16 +-
 drivers/iio/imu/adis16400_core.c                   |    7=20
 drivers/infiniband/ulp/isert/ib_isert.c            |   16 +-
 drivers/input/input.c                              |    4=20
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    3=20
 drivers/net/ethernet/broadcom/tg3.c                |    2=20
 drivers/net/usb/dm9601.c                           |   34 +++-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |   52 +++++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   25 ++-
 drivers/net/wireless/ath/ath9k/main.c              |    5=20
 drivers/net/wireless/rtlwifi/pci.c                 |    4=20
 drivers/of/address.c                               |    8 -
 drivers/s390/char/tty3270.c                        |    2=20
 drivers/staging/comedi/drivers/8255_pci.c          |   15 +
 drivers/target/iscsi/iscsi_target.c                |   26 +--
 drivers/target/target_core_device.c                |    5=20
 drivers/target/target_core_file.c                  |    8 -
 drivers/target/target_core_file.h                  |    5=20
 drivers/tty/serial/8250/8250_dw.c                  |    2=20
 drivers/tty/serial/pmac_zilog.c                    |    3=20
 drivers/usb/class/cdc-wdm.c                        |    8 -
 drivers/usb/serial/generic.c                       |    9 -
 drivers/usb/serial/option.c                        |    2=20
 drivers/usb/serial/zte_ev.c                        |    3=20
 fs/ceph/addr.c                                     |    8 -
 fs/ceph/file.c                                     |   47 ++----
 fs/ceph/ioctl.c                                    |    8 -
 fs/ceph/mds_client.c                               |   15 +
 fs/ceph/mdsmap.c                                   |    4=20
 fs/ceph/super.c                                    |    2=20
 fs/ext4/ext4.h                                     |   10 +
 fs/ext4/ext4_jbd2.c                                |    9 +
 fs/ext4/extents.c                                  |   43 +++--
 fs/ext4/inode.c                                    |   12 -
 fs/ext4/mballoc.c                                  |   21 +-
 fs/ext4/super.c                                    |   17 +-
 fs/gfs2/aops.c                                     |   30 +++
 fs/gfs2/ops_fstype.c                               |   12 +
 fs/jbd2/transaction.c                              |    6=20
 include/asm-generic/pgtable.h                      |    2=20
 include/clocksource/arm_arch_timer.h               |    2=20
 include/drm/drm_pciids.h                           |    2=20
 include/linux/auxvec.h                             |    2=20
 include/linux/ceph/osd_client.h                    |    3=20
 include/linux/libata.h                             |    1=20
 include/linux/mm_types.h                           |   49 ++++++
 include/linux/spinlock.h                           |   14 +
 include/target/target_core_base.h                  |    1=20
 kernel/fork.c                                      |    1=20
 kernel/freezer.c                                   |    6=20
 kernel/sched/core.c                                |   14 +
 kernel/sched/fair.c                                |    7=20
 kernel/sched/rt.c                                  |   14 +
 kernel/trace/ftrace.c                              |    2=20
 mm/compaction.c                                    |    4=20
 mm/fremap.c                                        |    8 -
 mm/huge_memory.c                                   |   14 +
 mm/memcontrol.c                                    |    2=20
 mm/memory-failure.c                                |   10 +
 mm/migrate.c                                       |    4=20
 mm/mprotect.c                                      |    2=20
 mm/pgtable-generic.c                               |    8 -
 mm/rmap.c                                          |    4=20
 net/ceph/osd_client.c                              |   82 ++++++----
 net/wireless/radiotap.c                            |    4=20
 security/selinux/hooks.c                           |   53 +++++--
 security/selinux/include/xfrm.h                    |    9 -
 security/selinux/xfrm.c                            |   53 +++++--
 sound/core/pcm_lib.c                               |    2=20
 sound/pci/hda/hda_intel.c                          |    4=20
 sound/soc/codecs/wm5110.c                          |    2=20
 sound/soc/codecs/wm8904.c                          |    2=20
 sound/soc/codecs/wm_adsp.c                         |   10 -
 sound/soc/tegra/tegra20_i2s.c                      |    6=20
 sound/soc/tegra/tegra20_spdif.c                    |   10 -
 sound/soc/tegra/tegra30_i2s.c                      |    6=20
 tools/power/cpupower/utils/cpupower-set.c          |    6=20
 128 files changed, 995 insertions(+), 454 deletions(-)

AKASHI Takahiro (1):
      arm64: check for number of arguments in syscall_get/set_arguments()

Alex Deucher (4):
      drm/radeon: Fix sideport problems on certain RS690 boards
      drm/radeon: add missing display tiling setup for oland
      drm/radeon: fix asic gfx values for scrapper asics
      drm/radeon: 0x9649 is SUMO2 not SUMO

Alex Elder (4):
      libceph: add lingering request reference when registered
      rbd: flush dcache after zeroing page data
      rbd: set removing flag while holding list lock
      rbd: protect against concurrent unmaps

Anton Blanchard (1):
      powerpc: Align p_end

Ard Biesheuvel (1):
      auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE

Bj=C3=B8rn Mork (1):
      usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Bo Shen (1):
      ASoC: wm8904: fix DSP mode B configuration

Catalin Marinas (7):
      arm64: spinlock: retry trylock operation if strex fails on free lock
      arm64: Only enable local interrupts after the CPU is marked online
      arm64: dts: Reserve the memory used for secondary CPU release address
      arm64: Remove unused cpu_name ascii in arch/arm64/mm/proc.S
      arm64: Avoid cache flushing in flush_dcache_page()
      arm64: Do not flush the D-cache for anonymous pages
      arm64: Use Normal NonCacheable memory for writecombine

Chad Hanson (1):
      selinux: fix broken peer recv check

Charles Keepax (2):
      ASoC: wm_adsp: Add small delay while polling DSP RAM start
      ASoC: wm5110: Correct HPOUT3 DAPM route typo

Chris Wilson (2):
      drm/i915: Hold mutex across i915_gem_release
      drm/i915: Use the correct GMCH_CTRL register for Sandybridge+

Christian K=C3=B6nig (1):
      drm/radeon: fix UVD 256MB check

Dan Carpenter (4):
      ceph: cleanup types in striped_read()
      libceph: fix error handling in handle_reply()
      libceph: potential NULL dereference in ceph_osdc_handle_map()
      libceph: create_singlethread_workqueue() doesn't return ERR_PTRs

Dan Williams (1):
      net_dma: mark broken

Daniel Vetter (1):
      drm/i915: don't update the dri1 breadcrumb with modesetting

David Henningsson (1):
      ALSA: hda - Add enable_msi=3D0 workaround for four HP machines

Dinh Nguyen (1):
      clocksource: dw_apb_timer_of: Fix read_sched_clock

Dmitry Kunilov (1):
      usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev back to =
option

Dmitry Torokhov (1):
      Input: allocate absinfo data when setting ABS capability

Emil Goode (1):
      ceph: improve error handling in ceph_mdsmap_decode

Eric Whitney (1):
      ext4: fix bigalloc regression

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Feng Kan (1):
      arm64: Change kernel stack size to 16K

Geert Uytterhoeven (2):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()
      sh: always link in helper functions extracted from libgcc

Greg Kroah-Hartman (1):
      Linux 3.10.26

Ian Abbott (1):
      staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Jan Kara (2):
      ext4: Do not reserve clusters when fs doesn't support extents
      ext4: fix deadlock when writing in ENOSPC conditions

Jan Kiszka (1):
      KVM: x86: Fix APIC map calculation after re-enabling

Jiang Liu (1):
      arm64: fix possible invalid FPSIMD initialization state

Jianguo Wu (1):
      mm/hugetlb: check for pte NULL pointer in __page_check_address()

Johan Hovold (1):
      USB: serial: fix race in generic write

Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun

Jonathan Cameron (2):
      iio:imu:adis16400 fix pressure channel scan type
      iio:adc:ad7887 Fix channel reported endianness from cpu to big endian

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Joonsoo Kim (1):
      mm/compaction: respect ignore_skip_hint in update_pageblock_skip

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments

Josh Durgin (8):
      rbd: fix buffer size for writes to images with snapshots
      rbd: fix null dereference in dout
      libceph: add function to ensure notifies are complete
      rbd: complete notifies before cleaning up osd_client and rbd_dev
      rbd: make rbd_obj_notify_ack() synchronous
      rbd: fix use-after free of rbd_dev->disk
      rbd: ignore unmapped snapshots that no longer exist
      rbd: fix error handling from rbd_snap_name()

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload

Len Brown (1):
      x86 idle: Repair large-server 50-watt idle-power regression

Li Wang (1):
      ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Lukas Czerner (1):
      ext4: fix FITRIM in no journal mode

Marc Kleine-Budde (1):
      can: peak_usb: fix mem leak in pcan_usb_pro_init()

Marc Zyngier (1):
      ARM: hyp: initialize CNTVOFF to zero

Mark Rutland (3):
      arm64: virt: ensure visibility of __boot_cpu_mode
      clocksource: arch_timer: use virtual counters
      ARM: KVM: arch_timers: zero CNTVOFF upon return to host

Martin Schwidefsky (1):
      s390/3270: fix allocation of tty3270_screen structure

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask

Mel Gorman (5):
      sched: numa: skip inaccessible VMAs
      mm: clear pmd_numa before invalidating
      mm: numa: ensure anon_vma is locked to prevent parallel THP splits
      mm: numa: avoid unnecessary work on the failure path
      mm: numa: guarantee that tlb_flush_pending updates are visible before=
 page table updates

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus Sp=
inPoint M8

Mika Westerberg (1):
      serial: 8250_dw: add new ACPI IDs

Naoya Horiguchi (1):
      mm/memory-failure.c: transfer page count from head page to tail page =
after split thp

Nathaniel Yazdani (1):
      ceph: fix null pointer dereference

Nicholas Bellinger (2):
      iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set
      target/file: Update hw_max_sectors based on current block_size

Nithin Sujir (1):
      tg3: Expand 4g_overflow_test workaround to skb fragments of any size.

Nobuhiro Iwamatsu (1):
      sh: add EXPORT_SYMBOL(min_low_pfn) and EXPORT_SYMBOL(max_low_pfn) to =
sh_ksyms_32.c

Oleg Nesterov (2):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()
      sched: fix the theoretical signal_wake_up() vs schedule() race

Paul Moore (2):
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinu=
x_ip_postroute()

Peter Korsgaard (2):
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
      dm9601: work around tx fifo sync issue on dm962x

Rafael J. Wysocki (1):
      intel_pstate: Fail initialization if P-state information is missing

Rafa=C5=82 Mi=C5=82ecki (1):
      drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Rik van Riel (2):
      mm: fix TLB flush race between migration, and change_protection_range
      mm: fix use-after-free in sys_remap_file_pages

Rob Herring (1):
      Revert "of/address: Handle #address-cells > 2 specially"

Robin H. Johnson (1):
      libata: disable a disk via libata.force params

Roger Quadros (1):
      gpio: twl4030: Fix regression for twl gpio LED output

Sage Weil (1):
      rbd: fix a couple warnings

Sasha Levin (1):
      ceph: avoid accessing invalid memory

Stefan Richter (1):
      firewire: sbp2: bring back WRITE SAME support

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Stephen Warren (1):
      ASoC: tegra: fix uninitialized variables in set_fmt

Steven Whitehouse (2):
      GFS2: don't hold s_umount over blkdev_put
      GFS2: Fix incorrect invalidation for DIO/buffered I/O

Sujith Manoharan (1):
      ath9k: Fix interrupt handling for the AR9002 family

Suman Anna (1):
      ARM: OMAP2+: hwmod_data: fix missing OMAP_INTC_START in irq data

Tejun Heo (1):
      libata, freezer: avoid block device removal while system is frozen

Theodore Ts'o (3):
      ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
      ext4: add explicit casts when masking cluster sizes
      jbd2: don't BUG but return ENOSPC if a handle runs out of space

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Take modeset locks around intel_modeset_setup_hw_state()

Vincent Pelletier (1):
      libata: Add atapi_dmadir force flag

Vladimir Davydov (1):
      memcg: fix memcg_size() calculation

Wei Yongjun (1):
      iser-target: fix error return code in isert_create_device_ib_res()

Will Deacon (1):
      arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events

Yan, Zheng (5):
      ceph: cleanup aborted requests when re-sending requests.
      ceph: wake up 'safe' waiters when unregistering request
      libceph: fix safe completion
      libceph: fix truncate size calculation
      libceph: call r_unsafe_callback when unsafe reply is received

majianpeng (4):
      ceph: Free mdsc if alloc mdsc->mdsmap failed.
      ceph: Add check returned value on func ceph_calc_ceph_pg.
      ceph: fix bugs about handling short-read for sync read mode.
      ceph: allow sync_read/write return partial successed size of read/wri=
te.

pingfan liu (1):
      powerpc: kvm: fix rare but potential deadlock scene


--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzxyiAAoJEDjbvchgkmk+Z7EP/i1YOmO8w2AhtCAbbdFTd3rM
THnbv8CyGjiu/R9yfkEnDH7KSgNRTDAWMDWJEibeuXdzrmeMpFvIQOMNKnjU0Dn8
eYs93LKkj1fvzFbLoW3EbE9bEVn62TF5qx/cUDlik9aNT9FrCwnsZpv+7gTysE8B
GV3m/IXCwp1T88DXvWy+h/ZKplwcbqiY+w0U6BKcecSbiz6L5O1Kvw3YqZ8bt0bU
18vSm4/O15w38UgncSD7aWAZ9ETAyFL64VFk1Ba2vIILwhfEdJnFPKqNmDQoEFPn
Xjx8rxOTMODVdR1qEwtyzg/dd/uzUWtXm/g+IBA/AXM2g627CtNv4DjAUQnshX0r
wmlXFRzXkWy8U5zI1GgMdHnN5jYXNEIn8bSHWcLqT4NCBWbf/494uHgdvnh5zm6k
kRmHGyCXcxI+Eqz3Q+pJ0K4CU0JpYq6at6ze8cupBJ6E5fGxRkxahN1K+Fhztw81
TLUhzBvg8Y5vzJmwqmZDrf0Kr2e9A8V5Hv3YY0clCM95kjs0VtcMIF96gIoc+yNs
IRxRO84yzitS0IpJlGkTeDud8OSJEJLxramZ5hYfL3i5wFqo0a6rlm6bnsx0yQLN
V4Iz4Ds9GBh36cjg4hO6YkjlFvDxwSH8praqMcJtrJgkIwtk4NOtZiZQ5tUC2bxO
cTlwKyUNMqtQFkQ+MhL1
=Tkor
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
