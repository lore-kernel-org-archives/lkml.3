Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281AbaGXG5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:57:06 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:39091 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbaGXG5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:57:01 -0400
Message-ID: <53D0AE3A.8000004@suse.cz>
Date: Thu, 24 Jul 2014 08:56:58 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.25
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm announcing the release of the 3.12.25 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

- ----------------------------------------------------------------
Aaron Lu (1):
      thermal: hwmon: Make the check for critical temp valid consistent

Adam Thomson (1):
      iio: of_iio_channel_get_by_name() returns non-null pointers for
error legs

Alex Deucher (10):
      vgaswitcheroo: switch the mux to the igp on power down when
runpm is enabled
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
      drm/radeon/atom: fix dithering on certain panels
      drm/radeon/dpm: fix typo in vddci setup for eg/btc
      drm/radeon/dpm: fix vddci setup typo on cayman
      drm/radeon/cik: fix typo in EOP packet
      drm/radeon: fix typo in ci_stop_dpm()
      drm/radeon: fix typo in golden register setup on evergreen

Alex Elder (1):
      rbd: use reference counts for image requests

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table
entries in modules

Alexandre Demers (1):
      drm/radeon/dpm: Reenabling SS on Cayman

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Anton Blanchard (2):
      powerpc: 64bit sendfile is capped at 2GB
      powerpc/perf: Never program book3s PMCs with values >= 0x80000000

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Asai Thambi S P (3):
      mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on AMD systems
      mtip32xx: Increase timeout for STANDBY IMMEDIATE command
      mtip32xx: Remove dfs_parent after pci unregister

Axel Lin (3):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
      hwmon: (adm1021) Fix cache problem when writing temperature limits

Bart Van Assche (3):
      IB/srp: Fix a sporadic crash triggered by cable pulling
      IB/umad: Fix error handling
      IB/umad: Fix use-after-free on close

Benjamin Herrenschmidt (2):
      powerpc/serial: Use saner flags when creating legacy ports
      powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Bjorn Helgaas (1):
      PCI: Fix incorrect vgaarb conditional in WARN_ON()

Bj?rn Mork (1):
      usb: option: add/modify Olivetti Olicard modems

Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
      ibmvscsi: Add memory barriers for send / receive

ChiaHao (1):
      arm64: Bug fix in stack alignment exception

Christian König (1):
      drm/radeon: stop poisoning the GART TLB

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

Colin Cross (1):
      arm64: implement TASK_SIZE_OF

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

David Rientjes (1):
      mm, pcp: allow restoring percpu_pagelist_fraction default

Deng-Cheng Zhu (1):
      MIPS: KVM: Fix memory leak on VCPU

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Emmanuel Grumbach (1):
      iwlwifi: pcie: try to get ownership several times

Eric Sandeen (1):
      ext4: disable synchronous transaction batching if max_batch_time==0

Ezequiel Garcia (1):
      usb: musb: Fix panic upon musb_am335x module removal

Fabio Baltieri (1):
      hwmon: (ina2xx) Cast to s16 on shunt and current regs

Felix Fietkau (1):
      mac80211: fix a memory leak on sta rate selection table

Florian Westphal (1):
      netfilter: nf_nat: fix oops on netns removal

Gabor Juhos (1):
      watchdog: ath79_wdt: avoid spurious restarts on AR934x

Gavin Shan (1):
      powerpc/pseries: Fix overwritten PE state

Greg Kroah-Hartman (1):
      lz4: add overrun checks to lz4_uncompress_unknownoutputsize()

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Guenter Roeck (3):
      hwmon: (emc2103) Clamp limits instead of bailing out
      hwmon: (adm1031) Fix writes to limit registers
      powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

Hans de Goede (2):
      Input: elantech - deal with clickpads reporting right button events
      Input: elantech - don't set bit 1 of reg_10 when the no_hw_res
quirk is set

Hugh Dickins (1):
      mm: fix crashes from mbind() merging vmas

Ilya Dryomov (1):
      rbd: handle parent_overlap on writes correctly

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug

Jacob Keller (1):
      Documentation/SubmittingPatches: describe the Fixes: tag

James Hogan (1):
      MIPS: KVM: Remove redundant NULL checks before kfree()

Jan Kara (2):
      ext4: Fix buffer double free in ext4_alloc_branch()
      ext4: Fix hole punching for files with indirect blocks

Jan Kardell (1):
      iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends

Jeff Mahoney (1):
      reiserfs: call truncate_setsize under tailpack mutex

Jiri Slaby (2):
      Revert "aio: fix kernel memory disclosure in io_getevents()
introduced in v3.10"
      Linux 3.12.25

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io

Joel Stanley (2):
      powerpc/perf: Add PPMU_ARCH_207S define
      powerpc/perf: Clear MMCR2 when enabling PMU

Johan Hedberg (3):
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Fix locking of hdev when calling into SMP code

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe

Joonsoo Kim (1):
      DMA, CMA: fix possible memory leak

Julian Anastasov (1):
      ipvs: stop tot_stats estimator only under CONFIG_SYSCTL

Jussi Kivilinna (1):
      crypto: sha512_ssse3 - fix byte count to bit count conversion

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code

Krzysztof Ha³asa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Krzysztof Kozlowski (1):
      clk: s2mps11: Fix double free corruption during driver unbind

Lan Tianyu (1):
      ACPI / battery: Retry to get battery information if failed
during probing

Linus Walleij (1):
      usb: musb: ux500: don't propagate the OF node

Lukas Czerner (1):
      dm thin: update discard_granularity to reflect the thin-pool
blocksize

Lv Zheng (4):
      ACPI / EC: Avoid race condition related to advance_transaction()
      ACPI / EC: Add asynchronous command byte write support
      ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
      ACPI / EC: Fix race condition in ec_transaction_completed()

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

Marek Ol¹ák (1):
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

Markos Chandras (1):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Mateusz Guzik (1):
      NFS: populate ->net in mount data when remounting

Mathias Nyman (1):
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Maxime Bizon (1):
      workqueue: fix dev_set_uevent_suppress() imbalance

Maxime Ripard (1):
      net: allwinner: emac: Add missing free_irq

Michael Ellerman (2):
      powerpc/mm: Check paca psize is up to date for huge mappings
      powerpc/perf: Ensure all EBB register state is cleared on fork()

Michael Neuling (1):
      powerpc: Don't setup CPUs with bad status

Michal Nazarewicz (3):
      usb: gadget: f_fs: fix NULL pointer dereference when there are
no strings
      tools: ffs-test: fix header values endianess
      mm: page_alloc: fix CMA area initialisation when pageblock >
MAX_ORDER

Michal Sojka (1):
      USB: serial: ftdi_sio: Add Infineon Triboard

Micky Ching (1):
      mmc: rtsx: add R1-no-CRC mmc command type handle

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Mikulas Patocka (2):
      iscsi-target: fix iscsit_del_np deadlock on unload
      sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

NeilBrown (1):
      md: flush writes before starting a recovery.

Nicholas Bellinger (3):
      target: Fix left-over se_lun->lun_sep pointer OOPs
      iscsi-target: Avoid rejecting incorrect ITT for Data-Out
      iscsi-target: Explicily clear login response PDU in exception path

Oleg Nesterov (1):
      tracing: Fix syscall_*regfunc() vs copy_process() race

Oliver Neukum (1):
      USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Paolo Bonzini (3):
      virtio-scsi: avoid cancelling uninitialized work items
      virtio-scsi: fix various bad behavior on aborted requests
      KVM: x86: preserve the high 32-bits of the PAT register

Paul Bolle (2):
      powerpc: fix typo 'CONFIG_PMAC'
      powerpc: fix typo 'CONFIG_PPC_CPU'

Pekon Gupta (1):
      mtd: eLBC NAND: fix subpage write support

Peter Chen (1):
      usb: chipidea: udc: delete td from req's td list at ep_dequeue

Peter Christensen (1):
      ipvs: Fix panic due to non-linear skb

Peter Hurley (2):
      serial: Fix IGNBRK handling
      tty: Correct INPCK handling

Prabhakar Lad (1):
      cpufreq: Makefile: fix compilation for davinci platform

Rafa³ Mi³ecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Roland Dreier (1):
      x86, ioremap: Speed up check for RAM pages

Sander Eikelenboom (1):
      ALSA: usb-audio: Prevent printk ratelimiting from spamming
kernel log while DEBUG not defined

Scott Mayhew (1):
      nfs: Fix cache_validity check in nfs_write_pageuptodate()

Scott Wood (1):
      powerpc: Don't skip ePAPR spin-table CPUs

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Steve Capper (1):
      arm64: mm: Make icache synchronisation logic huge page aware

Steve French (1):
      CIFS: fix mount failure with broken pathnames when smb3 mount
with mapchars option

Steven Rostedt (Red Hat) (3):
      tracing: Try again for saved cmdline if failed due to locking
      tracing: Remove ftrace_stop/start() from reading the trace file
      ring-buffer: Check if buffer exists before polling

Takashi Iwai (1):
      ALSA: usb-audio: Fix races at disconnection and PCM closing

Tejun Heo (2):
      ptrace,x86: force IRET path after a ptrace_stop()
      blkcg: fix use-after-free in __blkg_release_rcu() by making
blkcg_gq refcnt an atomic_t

Theodore Ts'o (4):
      ext4: fix unjournalled bg descriptor while initializing inode bitmap
      ext4: clarify error count warning messages
      ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
      ext4: fix a potential deadlock in __ext4_es_shrink()

Thomas Gleixner (7):
      rtmutex: Fix deadlock detector for real
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Handle deadlock detection smarter
      rtmutex: Plug slow unlock race
      usb: musb: Ensure that cppi41 timer gets armed on premature DMA
TX irq
      irqchip: spear_shirq: Fix interrupt offset
      clk: spear3xx: Use proper control register offset

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Thomas Jarosch (1):
      PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Tim Gardner (1):
      ALSA: usb-audio: Suppress repetitive debug messages from
retire_playback_urb()

Trond Myklebust (3):
      SUNRPC: Fix a module reference leak in svc_handle_xprt
      pNFS: Handle allocation errors correctly in
filelayout_alloc_layout_hdr()
      NFS: Don't declare inode uptodate unless all attributes were checked

Ulrich Obergfell (1):
      scsi_error: fix invalid setting of host byte

Ville Syrjälä (1):
      drm/i915: Don't clobber the GTT when it's within stolen memory

Vincent Minet (1):
      intel_pstate: Set CPU number before accessing MSRs

Viresh Kumar (1):
      watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Yann Droneaud (2):
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_cq
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_srq

Yasuaki Ishimatsu (1):
      workqueue: zero cpumask of wq_numa_possible_cpumask on init

gundberg (1):
      watchdog: kempld-wdt: Use the correct value when configuring the
prescaler with the watchdog

hujianyang (2):
      UBIFS: fix an mmap and fsync race condition
      UBIFS: Remove incorrect assertion in shrink_tnc()

pekon gupta (1):
      mtd: nand: omap: fix BCHx ecc.correct to return detected
bit-flips in erased-page

 Documentation/SubmittingPatches              |  22 +-
 Documentation/sysctl/vm.txt                  |   3 +-
 Makefile                                     |   2 +-
 arch/arm/mach-omap2/mux.c                    |   6 +-
 arch/arm64/include/asm/memory.h              |   2 +
 arch/arm64/kernel/entry.S                    |   1 -
 arch/arm64/mm/flush.c                        |   3 +-
 arch/mips/kernel/irq-msc01.c                 |   2 +-
 arch/mips/kvm/kvm_mips.c                     |  13 +-
 arch/powerpc/Kconfig                         |   3 +-
 arch/powerpc/include/asm/perf_event_server.h |   3 +-
 arch/powerpc/include/asm/switch_to.h         |   2 +
 arch/powerpc/include/asm/systbl.h            |   2 +-
 arch/powerpc/include/uapi/asm/cputable.h     |   1 +
 arch/powerpc/kernel/cputable.c               |   3 +-
 arch/powerpc/kernel/legacy_serial.c          |  15 +-
 arch/powerpc/kernel/setup-common.c           |  10 +-
 arch/powerpc/kernel/time.c                   |   2 +-
 arch/powerpc/lib/sstep.c                     |   2 +-
 arch/powerpc/mm/hash_utils_64.c              |  31 +-
 arch/powerpc/perf/core-book3s.c              |  24 +-
 arch/powerpc/perf/power8-pmu.c               |   2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c |   1 +
 arch/x86/crypto/sha512_ssse3_glue.c          |   2 +-
 arch/x86/include/asm/kvm_host.h              |   4 +-
 arch/x86/include/asm/ptrace.h                |  16 +
 arch/x86/mm/ioremap.c                        |  26 +-
 block/blk-cgroup.c                           |   7 +-
 block/blk-cgroup.h                           |  17 +-
 drivers/acpi/battery.c                       |  27 +-
 drivers/acpi/ec.c                            | 128 ++++----
 drivers/base/dma-contiguous.c                |  12 +-
 drivers/block/mtip32xx/mtip32xx.c            | 123 ++++++--
 drivers/block/rbd.c                          |  19 +-
 drivers/clk/clk-s2mps11.c                    |   7 +-
 drivers/clk/spear/spear3xx_clock.c           |   2 +-
 drivers/cpufreq/Makefile                     |   2 +-
 drivers/cpufreq/intel_pstate.c               |   2 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c       |  44 +++
 drivers/gpu/drm/i915/i915_reg.h              |   3 +
 drivers/gpu/drm/radeon/atombios_crtc.c       |  48 +--
 drivers/gpu/drm/radeon/atombios_dp.c         |  17 +-
 drivers/gpu/drm/radeon/atombios_encoders.c   |   5 +-
 drivers/gpu/drm/radeon/ci_dpm.c              |   2 +-
 drivers/gpu/drm/radeon/cikd.h                |   2 +-
 drivers/gpu/drm/radeon/cypress_dpm.c         |   2 +-
 drivers/gpu/drm/radeon/evergreen.c           |   8 +-
 drivers/gpu/drm/radeon/ni_dpm.c              |   2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c   |   2 +-
 drivers/gpu/drm/radeon/radeon_cs.c           |   6 +
 drivers/gpu/drm/radeon/rs600.c               |   6 +-
 drivers/gpu/drm/radeon/rv770_dpm.c           |   6 -
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c           |   1 -
 drivers/gpu/vga/vga_switcheroo.c             |   3 +-
 drivers/hv/connection.c                      |   8 +-
 drivers/hwmon/adm1021.c                      |  14 +-
 drivers/hwmon/adm1029.c                      |   3 +
 drivers/hwmon/adm1031.c                      |   8 +-
 drivers/hwmon/amc6821.c                      |   2 +-
 drivers/hwmon/emc2103.c                      |  15 +-
 drivers/hwmon/ina2xx.c                       |   7 +-
 drivers/iio/adc/ti_am335x_adc.c              |   2 +-
 drivers/iio/inkern.c                         |   6 +-
 drivers/infiniband/core/user_mad.c           |  75 +++--
 drivers/infiniband/hw/ipath/ipath_diag.c     |   4 +
 drivers/infiniband/hw/mlx5/cq.c              |  13 +-
 drivers/infiniband/hw/mlx5/srq.c             |  14 +-
 drivers/infiniband/hw/mlx5/user.h            |   2 +
 drivers/infiniband/hw/qib/qib_mad.c          |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |   6 +
 drivers/input/mouse/elantech.c               |  27 +-
 drivers/irqchip/spear-shirq.c                |   2 +-
 drivers/md/dm-io.c                           |  22 +-
 drivers/md/dm-thin.c                         |   3 +-
 drivers/md/md.c                              |  13 +
 drivers/mmc/host/rtsx_pci_sdmmc.c            |   3 +
 drivers/mtd/nand/fsl_elbc_nand.c             |  14 +
 drivers/mtd/nand/omap2.c                     |   2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c  |   1 +
 drivers/net/wireless/b43/xmit.c              |  10 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c    |  26 +-
 drivers/net/wireless/rt2x00/rt2500pci.c      |   7 +-
 drivers/net/wireless/rt2x00/rt2x00.h         |   1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c      |  24 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c      |   2 +
 drivers/pci/pci.c                            |   2 +-
 drivers/pci/quirks.c                         |   1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c             |  13 +-
 drivers/scsi/scsi_error.c                    |   2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c          |   4 +
 drivers/scsi/virtio_scsi.c                   |  26 +-
 drivers/target/iscsi/iscsi_target.c          |   2 +-
 drivers/target/iscsi/iscsi_target_login.c    |  13 +-
 drivers/target/iscsi/iscsi_target_util.c     |   2 +
 drivers/target/target_core_device.c          |   1 +
 drivers/thermal/thermal_hwmon.c              |  33 +-
 drivers/tty/n_tty.c                          |  19 +-
 drivers/tty/serial/8250/8250_core.c          |   2 +-
 drivers/tty/serial/altera_uart.c             |   6 +
 drivers/tty/serial/amba-pl010.c              |   2 +-
 drivers/tty/serial/amba-pl011.c              |   2 +-
 drivers/tty/serial/atmel_serial.c            |   2 +-
 drivers/tty/serial/bcm63xx_uart.c            |   2 +-
 drivers/tty/serial/bfin_uart.c               |   2 +-
 drivers/tty/serial/dz.c                      |   2 +-
 drivers/tty/serial/efm32-uart.c              |   2 +-
 drivers/tty/serial/fsl_lpuart.c              |   2 +-
 drivers/tty/serial/ip22zilog.c               |   2 +-
 drivers/tty/serial/m32r_sio.c                |   2 +-
 drivers/tty/serial/max310x.c                 |   2 +-
 drivers/tty/serial/mcf.c                     |   6 +
 drivers/tty/serial/mfd.c                     |   2 +-
 drivers/tty/serial/mpsc.c                    |   2 +-
 drivers/tty/serial/msm_serial.c              |   2 +-
 drivers/tty/serial/mxs-auart.c               |   2 +-
 drivers/tty/serial/netx-serial.c             |   2 +-
 drivers/tty/serial/pmac_zilog.c              |   2 +-
 drivers/tty/serial/pnx8xxx_uart.c            |   2 +-
 drivers/tty/serial/pxa.c                     |   2 +-
 drivers/tty/serial/sb1250-duart.c            |   2 +-
 drivers/tty/serial/sccnxp.c                  |   2 +-
 drivers/tty/serial/serial_ks8695.c           |   2 +-
 drivers/tty/serial/serial_txx9.c             |   2 +-
 drivers/tty/serial/sirfsoc_uart.c            |   2 +-
 drivers/tty/serial/st-asc.c                  |   2 +-
 drivers/tty/serial/sunsab.c                  |   2 +-
 drivers/tty/serial/sunsu.c                   |   2 +-
 drivers/tty/serial/sunzilog.c                |   2 +-
 drivers/tty/serial/ucc_uart.c                |   2 +-
 drivers/tty/serial/vr41xx_siu.c              |   2 +-
 drivers/tty/serial/zs.c                      |   2 +-
 drivers/usb/chipidea/udc.c                   |   7 +
 drivers/usb/gadget/f_fs.c                    |  12 +-
 drivers/usb/host/xhci-ring.c                 |   2 +-
 drivers/usb/host/xhci.c                      |  10 +-
 drivers/usb/musb/musb_am335x.c               |  23 +-
 drivers/usb/musb/musb_cppi41.c               |   2 +-
 drivers/usb/musb/ux500.c                     |   1 -
 drivers/usb/serial/cp210x.c                  |   1 +
 drivers/usb/serial/ftdi_sio.c                |  12 +-
 drivers/usb/serial/ftdi_sio_ids.h            |   9 +-
 drivers/usb/serial/option.c                  |  28 +-
 drivers/watchdog/ath79_wdt.c                 |  10 +
 drivers/watchdog/kempld_wdt.c                |   2 +-
 drivers/watchdog/sp805_wdt.c                 |   4 +-
 fs/aio.c                                     |   3 -
 fs/cifs/cifs_unicode.c                       |   7 +-
 fs/ext4/extents_status.c                     |   4 +-
 fs/ext4/ialloc.c                             |  14 +-
 fs/ext4/indirect.c                           |  20 +-
 fs/ext4/mballoc.c                            |   4 +-
 fs/ext4/super.c                              |   9 +-
 fs/jbd2/transaction.c                        |   5 +-
 fs/nfs/inode.c                               |  26 +-
 fs/nfs/nfs4filelayout.c                      |   2 +-
 fs/nfs/super.c                               |   1 +
 fs/nfs/write.c                               |   4 +-
 fs/nfsd/nfs4proc.c                           |   9 -
 fs/nfsd/nfs4xdr.c                            |  17 +-
 fs/reiserfs/inode.c                          |   8 +-
 fs/ubifs/file.c                              |   3 +-
 fs/ubifs/shrinker.c                          |   1 -
 include/linux/ptrace.h                       |   3 +
 include/linux/ring_buffer.h                  |   2 +-
 include/trace/syscall.h                      |  15 +
 kernel/cpuset.c                              |   8 +-
 kernel/fork.c                                |   2 +
 kernel/rtmutex-debug.h                       |   5 +
 kernel/rtmutex.c                             | 273 ++++++++++++++---
 kernel/rtmutex.h                             |   5 +
 kernel/sysctl.c                              |   3 +-
 kernel/trace/ring_buffer.c                   |   5 +-
 kernel/trace/trace.c                         |  40 ++-
 kernel/trace/trace.h                         |   4 +-
 kernel/workqueue.c                           |   3 +-
 lib/lz4/lz4_decompress.c                     |   6 +-
 mm/mempolicy.c                               |  48 ++-
 mm/page_alloc.c                              |  56 +++-
 net/bluetooth/hci_event.c                    |  11 +-
 net/bluetooth/l2cap_sock.c                   |   5 -
 net/bluetooth/mgmt.c                         |   7 +-
 net/mac80211/debugfs_netdev.c                |   6 +-
 net/mac80211/ibss.c                          |   1 +
 net/mac80211/sta_info.c                      |   1 +
 net/netfilter/ipvs/ip_vs_core.c              |  15 +-
 net/netfilter/ipvs/ip_vs_ctl.c               |   2 +-
 net/netfilter/nf_nat_core.c                  |  35 ++-
 net/sunrpc/svc_xprt.c                        |   2 +
 scripts/recordmcount.h                       |   4 +-
 sound/usb/card.c                             |  13 +-
 sound/usb/endpoint.c                         |  17 +-
 sound/usb/endpoint.h                         |   1 +
 sound/usb/pcm.c                              |   3 +-
 tools/usb/ffs-test.c                         |   4 +-
 194 files changed, 1478 insertions(+), 625 deletions(-)



thanks,
- -- 
js
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0K45AAoJEL0lsQQGtHBJbTcP/1ZHLvOUqmUs5lNEdA3Kh3LG
kxP49w7IECgEIyz3uaZPLO39jOvSIXZqxXxz2wJRInqX05BNzr5AiqHFzNx+V16+
HCn66lgpkP2lulBVgXteFT3N53G3mzfbQHsjxLK8gDZu8KAnVXkDj8V0cUNJRc9U
2hgSEjOmYUpTTYMeD0PJ5PVXoBkibfLhiRj2+d9DDIJ4WC9SckVN/8+xJLzHclVH
HKzO9psYEhfEFTEVSKYFE3/vZdlW654XUEqhbelKspco8v6IMlNcghidNKR9cajz
jgZtPVhxJPiogkWFbSRb0HNbU1IZgLfk9NSn3Ijnrmv8kO7hWO8BsDyvaTKdqS8+
SlMioYjQ/6EXNPoXkc7YU5IpWBi0iHgk30jM42V/PEZ9nB9TbdFGj6dDOje1nknh
g/57DlZfJNCl9yq3BMvug6hnnhFyC1bIkqZANfEDuA8amaWeWMqmziO60kumHrQa
22PwxN5nTNHCSauOoIObVWMpR8IzvNJcI0bOsh181R2j2HG7ZLph8QRLs3ToSrf8
Spunh1sr8f+f7q0mBNm5WIAV/h39l0zqmAWC0fxlX7XA+meRMSM6A/OkADbj6Lqg
5M851I4JCCGdWnpJa5/5OMUOoFW7FwEtsyzGHlfG8U358KPxjmQosrme//M1F+Ud
SmT/1abYfeEUgngMjKd0
=6/pP
-----END PGP SIGNATURE-----
