Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaAIWDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:03:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbaAIWDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:03:10 -0500
Date: Thu, 9 Jan 2014 14:03:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.7
Message-ID: <20140109220341.GA26345@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.7 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt                |    2=20
 Makefile                                           |    2=20
 arch/arm/boot/dts/r8a7790.dtsi                     |    4=20
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   32 ++---
 arch/arm/mach-omap2/board-ldp.c                    |    7 +
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |    4=20
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |    6 -
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |    2=20
 arch/arm64/kernel/ptrace.c                         |   38 +++----
 arch/powerpc/include/asm/exception-64s.h           |    2=20
 arch/powerpc/kernel/head_64.S                      |    1=20
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |    6 -
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |    4=20
 arch/sh/kernel/sh_ksyms_32.c                       |    5=20
 arch/sh/lib/Makefile                               |    2=20
 arch/sparc/include/asm/pgtable_64.h                |    4=20
 arch/x86/include/asm/pgtable.h                     |   11 +-
 arch/x86/kernel/cpu/intel.c                        |    3=20
 arch/x86/kvm/lapic.c                               |    8 -
 arch/x86/kvm/vmx.c                                 |    3=20
 arch/x86/mm/gup.c                                  |   13 ++
 drivers/acpi/acpi_lpss.c                           |    1=20
 drivers/acpi/bus.c                                 |   10 +
 drivers/ata/ahci_imx.c                             |    3=20
 drivers/ata/libata-core.c                          |   19 +++
 drivers/ata/libata-scsi.c                          |   21 +++
 drivers/clocksource/dw_apb_timer_of.c              |    7 -
 drivers/cpufreq/intel_pstate.c                     |    5=20
 drivers/dma/Kconfig                                |    1=20
 drivers/firewire/sbp2.c                            |    1=20
 drivers/gpio/gpio-msm-v2.c                         |    4=20
 drivers/gpio/gpio-twl4030.c                        |   15 ++
 drivers/gpu/drm/drm_edid.c                         |    8 +
 drivers/gpu/drm/i915/i915_dma.c                    |   10 +
 drivers/gpu/drm/i915/i915_gem.c                    |   34 ++++--
 drivers/gpu/drm/i915/i915_gem_context.c            |   16 ++
 drivers/gpu/drm/i915/intel_display.c               |    9 +
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   19 ++-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    6 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |   23 +---
 drivers/gpu/drm/radeon/cik.c                       |   12 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |    2=20
 drivers/gpu/drm/radeon/dce6_afmt.c                 |    4=20
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |    4=20
 drivers/gpu/drm/radeon/ni.c                        |   20 ++-
 drivers/gpu/drm/radeon/radeon.h                    |    4=20
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |   16 ++
 drivers/gpu/drm/radeon/radeon_kms.c                |    9 +
 drivers/gpu/drm/radeon/radeon_uvd.c                |    2=20
 drivers/gpu/drm/radeon/rs690.c                     |   10 +
 drivers/gpu/drm/radeon/rv770_dpm.c                 |    6 +
 drivers/gpu/drm/radeon/si.c                        |   12 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |    6 -
 drivers/idle/intel_idle.c                          |    3=20
 drivers/iio/adc/ad7887.c                           |   16 ++
 drivers/iio/imu/adis16400_core.c                   |    7 +
 drivers/infiniband/ulp/isert/ib_isert.c            |   22 ++--
 drivers/input/input.c                              |    4=20
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    3=20
 drivers/net/ethernet/broadcom/tg3.c                |    2=20
 drivers/net/usb/dm9601.c                           |   34 ++++--
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |   52 +++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   25 +++-
 drivers/net/wireless/ath/ath9k/main.c              |    5=20
 drivers/net/wireless/rtlwifi/pci.c                 |    4=20
 drivers/of/address.c                               |    8 -
 drivers/pci/hotplug/acpiphp_glue.c                 |   30 ++++-
 drivers/pinctrl/pinctrl-baytrail.c                 |    1=20
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |    2=20
 drivers/power/power_supply_core.c                  |   12 +-
 drivers/s390/char/tty3270.c                        |    2=20
 drivers/scsi/qla2xxx/qla_target.c                  |    9 -
 drivers/staging/comedi/drivers.c                   |    2=20
 drivers/staging/comedi/drivers/8255_pci.c          |   15 ++
 drivers/target/iscsi/iscsi_target.c                |   27 ++---
 drivers/target/iscsi/iscsi_target_login.c          |    6 -
 drivers/target/target_core_device.c                |    5=20
 drivers/target/target_core_file.c                  |    8 -
 drivers/target/target_core_file.h                  |    5=20
 drivers/tty/n_tty.c                                |    7 +
 drivers/tty/serial/8250/8250_dw.c                  |    2=20
 drivers/tty/serial/pmac_zilog.c                    |    3=20
 drivers/tty/tty_ldsem.c                            |   16 ++
 drivers/usb/chipidea/core.c                        |    4=20
 drivers/usb/chipidea/host.c                        |    3=20
 drivers/usb/chipidea/udc.c                         |    3=20
 drivers/usb/class/cdc-wdm.c                        |    8 -
 drivers/usb/host/xhci-pci.c                        |    7 +
 drivers/usb/musb/musb_core.c                       |   14 +-
 drivers/usb/serial/generic.c                       |    9 -
 drivers/usb/serial/option.c                        |    2=20
 drivers/usb/serial/zte_ev.c                        |    3=20
 fs/aio.c                                           |  113 ++++++++++++----=
-----
 fs/ceph/addr.c                                     |   10 +
 fs/ceph/cache.c                                    |    3=20
 fs/ceph/mds_client.c                               |    8 +
 fs/cifs/cifsproto.h                                |    7 -
 fs/cifs/dir.c                                      |   11 +-
 fs/cifs/inode.c                                    |    6 -
 fs/cifs/link.c                                     |   26 ++--
 fs/ext2/super.c                                    |    1=20
 fs/ext4/ext4.h                                     |   10 +
 fs/ext4/ext4_jbd2.c                                |    9 +
 fs/ext4/extents.c                                  |   45 +++++---
 fs/ext4/inode.c                                    |   12 --
 fs/ext4/mballoc.c                                  |   21 ++-
 fs/ext4/super.c                                    |   21 ++-
 fs/gfs2/aops.c                                     |   30 +++++
 fs/gfs2/log.c                                      |    4=20
 fs/gfs2/meta_io.c                                  |    5=20
 fs/gfs2/ops_fstype.c                               |   12 ++
 fs/jbd2/transaction.c                              |    6 -
 fs/xfs/xfs_qm.c                                    |   71 +++++++++----
 include/acpi/acpi_bus.h                            |    4=20
 include/asm-generic/pgtable.h                      |    2=20
 include/drm/drm_pciids.h                           |    2=20
 include/linux/auxvec.h                             |    2=20
 include/linux/libata.h                             |    1=20
 include/linux/migrate.h                            |   13 ++
 include/linux/mm_types.h                           |   49 +++++++++
 include/linux/reboot.h                             |    1=20
 include/target/target_core_base.h                  |    1=20
 include/uapi/drm/radeon_drm.h                      |    2=20
 kernel/cgroup.c                                    |   31 +++--
 kernel/fork.c                                      |    1=20
 kernel/freezer.c                                   |    6 +
 kernel/kexec.c                                     |    1=20
 kernel/reboot.c                                    |    2=20
 kernel/sched/fair.c                                |    7 +
 kernel/sched/rt.c                                  |   14 ++
 kernel/trace/ftrace.c                              |    2=20
 mm/compaction.c                                    |    4=20
 mm/fremap.c                                        |    8 -
 mm/huge_memory.c                                   |   49 +++++++--
 mm/memcontrol.c                                    |    2=20
 mm/memory-failure.c                                |   24 +++-
 mm/mempolicy.c                                     |    2=20
 mm/migrate.c                                       |   82 ++++++++++++---
 mm/mlock.c                                         |   44 +++++---
 mm/mprotect.c                                      |   13 ++
 mm/page_alloc.c                                    |   19 +--
 mm/pgtable-generic.c                               |    8 +
 mm/rmap.c                                          |    4=20
 net/wireless/radiotap.c                            |    4=20
 scripts/link-vmlinux.sh                            |    4=20
 security/selinux/hooks.c                           |   53 +++++++--
 security/selinux/include/xfrm.h                    |    9 -
 security/selinux/xfrm.c                            |   53 +++++++--
 sound/core/pcm_lib.c                               |    2=20
 sound/pci/hda/hda_intel.c                          |    4=20
 sound/pci/hda/patch_realtek.c                      |    3=20
 sound/soc/codecs/wm5110.c                          |    2=20
 sound/soc/codecs/wm8904.c                          |    2=20
 sound/soc/codecs/wm_adsp.c                         |   10 +
 sound/soc/tegra/tegra20_i2s.c                      |    6 -
 sound/soc/tegra/tegra20_spdif.c                    |   10 -
 sound/soc/tegra/tegra30_i2s.c                      |    6 -
 tools/power/cpupower/utils/cpupower-set.c          |    6 -
 158 files changed, 1349 insertions(+), 524 deletions(-)

Al Viro (1):
      ext4: fix del_timer() misuse for ->s_err_report

Alex Deucher (6):
      drm/radeon: Fix sideport problems on certain RS690 boards
      drm/radeon: add missing display tiling setup for oland
      drm/radeon/dpm: disable ss on Cayman
      drm/radeon: check for 0 count in speaker allocation and SAD code
      drm/radeon: fix asic gfx values for scrapper asics
      drm/radeon: 0x9649 is SUMO2 not SUMO

Anton Blanchard (1):
      powerpc: Align p_end

Ard Biesheuvel (1):
      auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE

Ben Dooks (1):
      ARM: shmobile: r8a7790: fix shdi resource sizes

Benjamin LaHaise (2):
      aio: fix kioctx leak introduced by "aio: Fix a trinity splat"
      aio/migratepages: make aio migrate pages sane

Bj=C3=B8rn Mork (1):
      usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Bo Shen (1):
      ASoC: wm8904: fix DSP mode B configuration

Bob Peterson (2):
      GFS2: Fix use-after-free race when calling gfs2_remove_from_ail
      GFS2: Fix slab memory leak in gfs2_bufdata

Chad Hanson (1):
      selinux: fix broken peer recv check

Charles Keepax (2):
      ASoC: wm_adsp: Add small delay while polling DSP RAM start
      ASoC: wm5110: Correct HPOUT3 DAPM route typo

Chris Wilson (3):
      drm/i915: Hold mutex across i915_gem_release
      drm/i915: Fix erroneous dereference of batch_obj inside reset_status
      drm/i915: Use the correct GMCH_CTRL register for Sandybridge+

Christian K=C3=B6nig (2):
      drm/radeon: fix typo in cik_copy_dma
      drm/radeon: fix UVD 256MB check

Dan Williams (1):
      net_dma: mark broken

Daniel Vetter (2):
      drm/i915: Fix use-after-free in do_switch
      drm/i915: don't update the dri1 breadcrumb with modesetting

David Henningsson (1):
      ALSA: hda - Add enable_msi=3D0 workaround for four HP machines

Dinh Nguyen (2):
      clocksource: dw_apb_timer_of: Fix read_sched_clock
      clocksource: dw_apb_timer_of: Fix support for dts binding "snps,dw-ap=
b-timer"

Dmitry Kunilov (1):
      usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev back to =
option

Dmitry Torokhov (1):
      Input: allocate absinfo data when setting ABS capability

Eric Whitney (1):
      ext4: fix bigalloc regression

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Fabio Estevam (1):
      usb: chipidea: host: Only disable the vbus regulator if it is not NULL

Geert Uytterhoeven (2):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()
      sh: always link in helper functions extracted from libgcc

Greg Kroah-Hartman (1):
      Linux 3.12.7

H Hartley Sweeten (1):
      staging: comedi: drivers: fix return value of comedi_load_firmware()

Hui Wang (1):
      ALSA: hda - Add Dell headset detection quirk for three laptop models

Ian Abbott (1):
      staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Ilia Mirkin (1):
      drm/nouveau: only runtime suspend by default in optimus configuration

Jan Kara (3):
      ext4: Do not reserve clusters when fs doesn't support extents
      ext4: fix deadlock when writing in ENOSPC conditions
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()

Jan Kiszka (2):
      KVM: nVMX: Unconditionally uninit the MMU on nested vmexit
      KVM: x86: Fix APIC map calculation after re-enabling

Jianguo Wu (2):
      mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate su=
ccessfully
      mm/hugetlb: check for pte NULL pointer in __page_check_address()

Jie Liu (1):
      xfs: fix infinite loop by detaching the group/project hints from user=
 dquot

Johan Hovold (1):
      USB: serial: fix race in generic write

Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun

Johannes Weiner (1):
      mm: page_alloc: revert NUMA aspect of fair allocation policy

Jonathan Cameron (2):
      iio:imu:adis16400 fix pressure channel scan type
      iio:adc:ad7887 Fix channel reported endianness from cpu to big endian

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Joonsoo Kim (2):
      mm/mempolicy: correct putback method for isolate pages if failed
      mm/compaction: respect ignore_skip_hint in update_pageblock_skip

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload

Laurent Pinchart (1):
      sh-pfc: Fix PINMUX_GPIO macro

Len Brown (1):
      x86 idle: Repair large-server 50-watt idle-power regression

Li Wang (2):
      ceph: allocate non-zero page to fscache in readpage()
      ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Linus Torvalds (1):
      aio: clean up and fix aio_setup_ring page mapping

Lukas Czerner (1):
      ext4: fix FITRIM in no journal mode

Marc Carino (1):
      libata: implement ATA_HORKAGE_NO_NCQ_TRIM and apply it to Micro M500 =
SSDs

Marc Kleine-Budde (1):
      can: peak_usb: fix mem leak in pcan_usb_pro_init()

Marek Ol=C5=A1=C3=A1k (3):
      drm/radeon: fix render backend setup for SI and CIK
      drm/radeon: expose render backend mask to the userspace
      drm/radeon: set correct pipe config for Hawaii in DCE

Marek Vasut (1):
      ahci: imx: Explicitly clear IMX6Q_GPR13_SATA_MPLL_CLK_EN

Martin Schwidefsky (1):
      s390/3270: fix allocation of tty3270_screen structure

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask

Maxime Ripard (1):
      ARM: sun7i: dt: Fix interrupt trigger types

Mel Gorman (12):
      mm: numa: serialise parallel get_user_page against THP migration
      mm: numa: call MMU notifiers on THP migration
      mm: clear pmd_numa before invalidating
      mm: numa: do not clear PMD during PTE update scan
      mm: numa: do not clear PTE for pte_numa update
      mm: numa: ensure anon_vma is locked to prevent parallel THP splits
      mm: numa: avoid unnecessary work on the failure path
      sched: numa: skip inaccessible VMAs
      mm: numa: clear numa hinting information on mprotect
      mm: numa: avoid unnecessary disruption of NUMA hinting during migrati=
on
      mm: numa: guarantee that tlb_flush_pending updates are visible before=
 page table updates
      mm: numa: defer TLB flush for THP migration as long as possible

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus Sp=
inPoint M8

Mika Westerberg (1):
      serial: 8250_dw: add new ACPI IDs

Milosz Tanski (1):
      ceph: hung on ceph fscache invalidate in some cases

Ming Lei (1):
      scripts/link-vmlinux.sh: only filter kernel symbols for arm

Naoya Horiguchi (1):
      mm/memory-failure.c: transfer page count from head page to tail page =
after split thp

Nicholas Bellinger (4):
      iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set
      iscsi-target: Fix incorrect np->np_thread NULL assignment
      iser-target: Move INIT_WORK setup into isert_create_device_ib_res
      target/file: Update hw_max_sectors based on current block_size

Nithin Sujir (1):
      tg3: Expand 4g_overflow_test workaround to skb fragments of any size.

Nobuhiro Iwamatsu (1):
      sh: add EXPORT_SYMBOL(min_low_pfn) and EXPORT_SYMBOL(max_low_pfn) to =
sh_ksyms_32.c

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Paul Drews (1):
      ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs

Paul Moore (2):
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinu=
x_ip_postroute()

Paulo Zanoni (1):
      drm/i915: change CRTC assertion on LCPLL disable

Peter Chen (1):
      usb: chipidea: fix nobody cared IRQ when booting with host role

Peter Hurley (2):
      tty: Fix hang at ldsem_down_read()
      n_tty: Fix apparent order of echoed output

Peter Korsgaard (2):
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
      dm9601: work around tx fifo sync issue on dm962x

Rafael J. Wysocki (2):
      intel_pstate: Fail initialization if P-state information is missing
      ACPIPHP / radeon / nouveau: Fix VGA switcheroo problem related to hot=
plug

Rafa=C5=82 Mi=C5=82ecki (1):
      drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Rajendra Nayak (1):
      ARM: DRA7: hwmod: Fix boot crash with DEBUG_LL

Rik van Riel (2):
      mm: fix TLB flush race between migration, and change_protection_range
      mm: fix use-after-free in sys_remap_file_pages

Rob Herring (1):
      Revert "of/address: Handle #address-cells > 2 specially"

Robin H. Johnson (1):
      libata: disable a disk via libata.force params

Roger Quadros (1):
      gpio: twl4030: Fix regression for twl gpio LED output

Sachin Prabhu (1):
      cifs: We do not drop reference to tlink in CIFSCheckMFSymlink()

Sebastian Andrzej Siewior (2):
      usb: musb: core: Call dma_controller_destroy() in error path only onc=
e.
      usb: musb: only cancel work if it is initialized

Shirish Pargaonkar (1):
      cifs: set FILE_CREATED

Shivaram Upadhyayula (1):
      qla2xxx: Fix schedule_delayed_work() for target timeout calculations

Shuah Khan (1):
      power_supply: Fix Oops from NULL pointer dereference from wakeup_sour=
ce_activate

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

Takashi Iwai (1):
      xhci: Limit the spurious wakeup fix only to HP machines

Tejun Heo (2):
      cgroup: fix cgroup_create() error handling path
      libata, freezer: avoid block device removal while system is frozen

Theodore Ts'o (3):
      ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
      ext4: add explicit casts when masking cluster sizes
      jbd2: don't BUG but return ENOSPC if a handle runs out of space

Thomas Hellstrom (1):
      drm/ttm: Fix accesses through vmas with only partial coverage

Tony Lindgren (1):
      ARM: OMAP2+: Fix LCD panel backlight regression for LDP legacy booting

Toshi Kani (1):
      ACPI / PCI / hotplug: Avoid warning when _ADR not present

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Take modeset locks around intel_modeset_setup_hw_state()

Vivek Goyal (1):
      kexec: migrate to reboot cpu

Vladimir Davydov (1):
      memcg: fix memcg_size() calculation

Vlastimil Babka (2):
      mm: munlock: fix a bug where THP tail page is encountered
      mm: munlock: fix deadlock in __munlock_pagevec()

Wei Yongjun (1):
      iser-target: fix error return code in isert_create_device_ib_res()

Will Deacon (1):
      arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events

Yan, Zheng (2):
      ceph: cleanup aborted requests when re-sending requests.
      ceph: wake up 'safe' waiters when unregistering request

Zhang Rui (1):
      nouveau_acpi: convert acpi_get_handle() to acpi_has_method()

pingfan liu (1):
      powerpc: kvm: fix rare but potential deadlock scene


--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzxy9AAoJEDjbvchgkmk+vC0P/jkeVzP15xULeut6KKluYwWv
4ZQBUWI4hJ7dBcT3poQys04bJOk+mUXhmXUvqzBuvSJsGHIJ1N1rq9+uNKxnaB4f
8tyb8i58pwGE3JuSw07SFa0xYMx7EJK0nmeRExN5EJUPjnYTCns8CB1AjJV9/7CM
nyMrDMYzw87v62iYiVk6gwHYJAQtpmzk2i2neYfVuDKvSbE2CCR+5V6AbBp2wsAL
IPjznPl6W87UOTSBV1W8oHFs9Gh9x38bE9V4fvMUmfMKpvJh9tXqWWAjLu+NxWgv
xjh1XBf8y4MT03FCL2RAXkoEqbPYLki2DeLh4D2Ow9XUqkSTg2zNNn3uUmxyjgQg
qhNLjL6KMYW/w0VBUjENb7YbjUJft5PEx+t3KTBIFYPALTkLPBmPMktpdqJxDSmY
kw4DJglancWupcIno7TGMq3nGK6ov1IS/5o9e9VFofMube+opuQW/pliQDB3Agoi
2O55tLin8GZY+UgzK7nLNAusH/OXoOm9BmMPP9W4GbhntuHoXft0oANYjFckS6QK
bUCogm7iUYZsIeM8oWOWnGny0edGHbZQFdnSOCM6s8YNv2PSQI8hs8abZAPJBdHC
U3ubtZ+issq3WhR4lLzTLeapc6yFNDP2FzsE0Z4Bh3ykINtU01VVr1xyayrG6/zg
ONQv1F8KH5YfrF9ux/wo
=Hg2L
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
