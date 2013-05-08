Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935Ab3EHEJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:09:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34957 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3EHEJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:09:41 -0400
Date: Tue, 7 May 2013 21:09:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.12
Message-ID: <20130508040938.GA17325@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.12 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/arm/boot/dts/at91sam9260.dtsi            |   16 ++---
 arch/arm/boot/dts/at91sam9g15.dtsi            |    2=20
 arch/arm/boot/dts/at91sam9g15ek.dts           |    2=20
 arch/arm/boot/dts/at91sam9g25.dtsi            |    2=20
 arch/arm/boot/dts/at91sam9g35.dtsi            |    2=20
 arch/arm/boot/dts/at91sam9x25.dtsi            |    2=20
 arch/arm/boot/dts/at91sam9x35.dtsi            |    2=20
 arch/arm/boot/dts/at91sam9x5ek.dtsi           |    2=20
 arch/arm/configs/at91sam9g45_defconfig        |    1=20
 arch/arm/include/asm/pgtable.h                |    9 +++
 arch/arm/mach-at91/setup.c                    |    2=20
 arch/arm/mach-omap2/cpuidle34xx.c             |    5 +
 arch/arm/mach-u300/include/mach/u300-regs.h   |    2=20
 arch/avr32/configs/favr-32_defconfig          |    1=20
 arch/avr32/configs/merisc_defconfig           |    1=20
 arch/ia64/include/asm/futex.h                 |    5 -
 arch/ia64/include/asm/mca.h                   |    1=20
 arch/ia64/kernel/irq.c                        |    8 ++
 arch/ia64/kernel/mca.c                        |   37 ++++++++----
 arch/ia64/kvm/vtlb.c                          |    2=20
 arch/powerpc/kernel/cpu_setup_power.S         |    1=20
 arch/powerpc/kernel/exceptions-64s.S          |    2=20
 arch/powerpc/kernel/head_64.S                 |    1=20
 arch/powerpc/platforms/cell/spufs/inode.c     |    1=20
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S     |    6 +-
 arch/x86/kernel/irq.c                         |    4 -
 arch/x86/kvm/emulate.c                        |    4 +
 arch/x86/xen/enlighten.c                      |    5 +
 arch/x86/xen/smp.c                            |    2=20
 arch/x86/xen/time.c                           |    6 +-
 drivers/acpi/osl.c                            |    2=20
 drivers/acpi/pci_root.c                       |    4 -
 drivers/acpi/thermal.c                        |   16 ++++-
 drivers/ata/libata-acpi.c                     |   45 +++++++++------
 drivers/ata/sata_highbank.c                   |    2=20
 drivers/char/tpm/tpm.c                        |   31 +++++++++-
 drivers/char/tpm/tpm.h                        |    3 +
 drivers/i2c/busses/i2c-xiic.c                 |    6 --
 drivers/md/md.c                               |    9 +--
 drivers/md/raid1.c                            |    7 ++
 drivers/md/raid10.c                           |    7 ++
 drivers/mfd/adp5520.c                         |    8 ++
 drivers/mmc/core/mmc.c                        |    2=20
 drivers/mmc/host/Kconfig                      |   10 ---
 drivers/mmc/host/atmel-mci.c                  |   16 +++--
 drivers/net/ethernet/freescale/gianfar_ptp.c  |    3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   10 +++
 drivers/net/wireless/iwlwifi/dvm/debugfs.c    |   16 ++---
 drivers/net/wireless/iwlwifi/dvm/sta.c        |    5 +
 drivers/net/wireless/mwifiex/pcie.c           |    4 -
 drivers/net/wireless/rt2x00/rt2800lib.c       |    8 ++
 drivers/pci/pci.c                             |   12 +---
 drivers/rtc/rtc-cmos.c                        |    4 -
 drivers/s390/char/sclp_cmd.c                  |    4 +
 drivers/staging/zsmalloc/Kconfig              |    2=20
 drivers/staging/zsmalloc/zsmalloc-main.c      |    5 -
 drivers/tty/pty.c                             |    3 +
 drivers/tty/serial/serial_core.c              |    4 +
 drivers/tty/tty_io.c                          |    4 -
 drivers/usb/chipidea/udc.c                    |    8 ++
 drivers/usb/chipidea/udc.h                    |    4 -
 drivers/usb/core/devio.c                      |    2=20
 drivers/usb/host/ehci-hcd.c                   |    3 -
 drivers/usb/misc/appledisplay.c               |    1=20
 drivers/usb/serial/ftdi_sio.c                 |   23 +++++--
 drivers/usb/serial/ftdi_sio_ids.h             |    4 +
 drivers/usb/serial/option.c                   |    8 ++
 drivers/usb/storage/cypress_atacb.c           |   16 ++++-
 drivers/video/console/fbcon.c                 |    2=20
 fs/dcache.c                                   |    4 +
 fs/exec.c                                     |    7 +-
 fs/ext4/Kconfig                               |    3 -
 fs/ext4/ext4_jbd2.h                           |    6 +-
 fs/ext4/fsync.c                               |    3 -
 fs/ext4/inode.c                               |   11 +--
 fs/ext4/mballoc.c                             |    8 +-
 fs/ext4/mmp.c                                 |    2=20
 fs/ext4/resize.c                              |    2=20
 fs/ext4/super.c                               |    7 +-
 fs/fscache/stats.c                            |    2=20
 fs/jbd2/commit.c                              |   50 +++++++++--------
 fs/jbd2/journal.c                             |   31 ++++++++++
 fs/lockd/clntlock.c                           |    3 +
 fs/lockd/clntproc.c                           |    3 -
 fs/nfs/nfs4proc.c                             |    6 ++
 fs/nfsd/nfs4proc.c                            |    8 +-
 fs/nfsd/nfs4state.c                           |    8 --
 fs/nfsd/nfs4xdr.c                             |   19 +-----
 fs/notify/inotify/inotify_user.c              |    6 +-
 fs/sysfs/dir.c                                |   15 +++--
 include/asm-generic/pgtable.h                 |   10 +++
 include/linux/cgroup.h                        |    3 -
 include/linux/ipc_namespace.h                 |    2=20
 include/linux/jbd2.h                          |    2=20
 include/linux/sched.h                         |   18 +-----
 include/sound/emu10k1.h                       |    1=20
 ipc/shm.c                                     |    2=20
 kernel/cgroup.c                               |   13 ++--
 kernel/hrtimer.c                              |    6 ++
 kernel/rcutree_trace.c                        |    8 +-
 kernel/time/tick-broadcast.c                  |    4 +
 kernel/time/tick-common.c                     |    1=20
 kernel/trace/ftrace.c                         |    5 +
 kernel/trace/trace.c                          |    2=20
 kernel/trace/trace_stack.c                    |   76 +++++++++++++++++++++=
++---
 kernel/trace/trace_stat.c                     |    2=20
 lib/oid_registry.c                            |    5 +
 mm/mmap.c                                     |    4 -
 mm/page_io.c                                  |   17 +++++
 net/mac80211/pm.c                             |    4 -
 net/wireless/reg.c                            |    2=20
 scripts/kconfig/streamline_config.pl          |   17 ++---
 sound/pci/emu10k1/emu10k1_main.c              |   39 +++++++++++--
 sound/pci/hda/patch_realtek.c                 |    6 ++
 sound/soc/codecs/max98088.c                   |    2=20
 sound/usb/6fire/pcm.c                         |    1=20
 sound/usb/caiaq/audio.c                       |    3 -
 sound/usb/card.c                              |    4 +
 sound/usb/card.h                              |    1=20
 sound/usb/endpoint.c                          |    5 -
 sound/usb/midi.c                              |   13 ----
 sound/usb/misc/ua101.c                        |    3 -
 sound/usb/pcm.c                               |    2=20
 sound/usb/quirks.c                            |    1=20
 sound/usb/stream.c                            |    9 +++
 sound/usb/usx2y/usb_stream.c                  |    1=20
 sound/usb/usx2y/usbusx2yaudio.c               |    1=20
 sound/usb/usx2y/usx2yhwdeppcm.c               |    1=20
 129 files changed, 641 insertions(+), 320 deletions(-)

Aaron Lu (1):
      libata: acpi: make ata_ap_acpi_handle not block

Adrian Thomasset (2):
      USB: ftdi_sio: correct ST Micro Connect Lite PIDs
      USB: ftdi_sio: enable two UART ports on ST Microconnect Lite

Al Viro (1):
      rcutrace: single_open() leaks

Alex A. Mihaylov (1):
      rt2x00: Fix transmit power troubles on some Ralink RT30xx cards

Anurup m (1):
      fs/fscache/stats.c: fix memory leak

Ben Jencks (1):
      usb/misc/appledisplay: Add 24" LED Cinema display

Bj=F8rn Mork (1):
      USB: option: add a D-Link DWM-156 variant

Bryan Schumaker (1):
      nfsd: Decode and send 64bit time values

Calvin Owens (1):
      ALSA: usb: Add quirk for 192KHz recording on E-Mu devices

Catalin Marinas (1):
      arm: set the page table freeing ceiling to TASK_SIZE

Clemens Ladisch (2):
      ALSA: usb-audio: disable autopm for MIDI devices
      ALSA: USB: adjust for changed 3.8 USB API

Daniel Lezcano (1):
      ARM: omap3: cpuidle: enable time keeping

Daniel Mack (1):
      ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

David Howells (1):
      Give the OID registry file module info to avoid kernel tainting

Derek Basehore (1):
      drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

Dmitry Monakhov (3):
      jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_=
callback
      ext4: fix journal callback list traversal
      ext4: fix big-endian bug in metadata checksum calculations

Douglas Gilbert (1):
      ARM: at91/at91sam9260.dtsi: fix u(s)art pinctrl encoding

Duncan Laurie (1):
      TPM: Retry SaveState command in suspend path

Dylan Reid (1):
      ASoC: max98088: Fix logging of hardware revision.

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send zeroed LQ cmd

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145

Gleb Natapov (1):
      KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x inst=
ructions

Greg Kroah-Hartman (1):
      Linux 3.8.12

Greg Thelen (1):
      fs/dcache.c: add cond_resched() to shrink_dcache_parent()

Hans de Goede (1):
      usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl=
 ep

Heiko Carstens (1):
      s390/memory hotplug: prevent offline of active memory increments

Hugh Dickins (1):
      mm: allow arch code to control the user page table ceiling

J. Bruce Fields (1):
      nfsd4: don't close read-write opens too soon

Jacob Keller (1):
      ixgbe: fix EICR write in ixgbe_msix_other

Jerome Marchand (1):
      swap: redirty page if page write fails on swap file

Joerg Roedel (1):
      staging: zsmalloc: Fix link error on ARM

Johan Hovold (1):
      mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload

Johannes Berg (2):
      mac80211: fix station entry leak/warning while suspending
      wireless: regulatory: fix channel disabling race condition

Kailang Yang (1):
      ALSA: hda - Add the support for ALC286 codec

Konrad Rzeszutek Wilk (3):
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.
      xen/smp: Fix leakage of timer interrupt line for every CPU online/off=
line.
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for ever=
y CPU online/offline

Lars-Peter Clausen (1):
      mfd: adp5520: Restore mode bits on resume

Li Fei (1):
      x86: Eliminate irq_mis_count counted in arch_irq_stat

Li Zefan (2):
      cgroup: fix an off-by-one bug which may trigger BUG_ON()
      cgroup: fix broken file xattrs

Linus Torvalds (1):
      tty: fix up atime/mtime mess, take three

Linus Walleij (1):
      ARM: u300: fix ages old copy/paste bug

Maxime Ripard (1):
      ARM: at91: Fix typo in restart code panic message

Mel Gorman (1):
      mm: swap: mark swap pages writeback before queueing for direct IO

Michael Ellerman (1):
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()

Michael Grzeschik (2):
      usb: chipidea: udc: fix memory access of shared memory on armv5 machi=
nes
      usb: chipidea: udc: fix memory leak in _ep_nuke

Michael Neuling (3):
      powerpc: Add isync to copy_and_flush
      powerpc: Fix hardware IRQs with MMU on exceptions when HV=3D0
      powerpc/power8: Fix secondary CPUs hanging on boot for HV=3D0

Mika Kuoppala (1):
      fbcon: when font is freed, clear also vc_font.data

Ming Lei (1):
      sysfs: fix use after free in case of concurrent read/write and readdir

Namhyung Kim (3):
      tracing: Fix off-by-one on allocating stat->pages
      tracing: Check return value of tracing_init_dentry()
      tracing: Reset ftrace_graph_filter_enabled if count is zero

NeilBrown (1):
      md: bad block list should default to disabled.

Nicolas Ferre (3):
      ARM: at91: remove partial parameter in bootargs for at91sam9x5ek.dtsi
      ARM: at91/trivial: fix model name for SAM9G15-EK
      ARM: at91/trivial: typos in compatible property

Oleg Nesterov (1):
      exec: do not abuse ->cred_guard_mutex in threadgroup_lock()

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards

Prarit Bhargava (1):
      hrtimer: Add expiry time overflow check in hrtimer_interrupt

Rafael J. Wysocki (1):
      PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()

Richard Cochran (1):
      gianfar: do not advertise any alarm capability.

Robert Richter (1):
      sata_highbank: Rename proc_name to the module name

Robin Holt (1):
      ipc: sysv shared memory limited to 8TiB

Sandy Wu (1):
      crypto: crc32-pclmul - Use gas macro for pclmulqdq

Shaohua Li (1):
      MD: ignore discard request for hard disks of hybid raid1/raid10 array

Shengzhou Liu (1):
      usb: remove redundant tdi_reset

Stanislaw Gruszka (1):
      iwlwifi: fix freeing uninitialized pointer

Stefani Seibold (1):
      USB: add ftdi_sio USB ID for GDM Boost V1.x

Stephan Schreiber (2):
      Wrong asm register contraints in the futex implementation
      Wrong asm register contraints in the kvm implementation

Steven A. Falco (1):
      i2c: xiic: must always write 16-bit words to TX_FIFO

Steven Rostedt (1):
      localmodconfig: Process source kconfig files as they are found

Steven Rostedt (Red Hat) (3):
      tracing: Use stack of calling function for stack tracer
      tracing: Fix stack tracer with fentry use
      tracing: Remove most or all of stack tracer stack size from stack_max=
_size

Takashi Iwai (2):
      ALSA: emu10k1: Fix dock firmware loading
      ALSA: usb-audio: Fix autopm error during probing

Terry Barnaby (1):
      mmc: atmel-mci: pio hang on block errors

Theodore Ts'o (3):
      ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
      ext4: fix online resizing for ext3-compat file systems
      ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG

Thomas Gleixner (1):
      clockevents: Set dummy handler on CPU_DEAD shutdown

Tony Luck (1):
      Fix initialization of CMCI/CMCP interrupts

Tormod Volden (1):
      usb-storage: CY7C68300A chips do not support Cypress ATACB

Trond Myklebust (2):
      LOCKD: Ensure that nlmclnt_block resets block->b_status after a serve=
r reboot
      NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_open_delegation=
_recall

Wang YanQing (1):
      ACPI: Fix wrong parameter passed to memblock_reserve

Yinghai Lu (1):
      PCI / ACPI: Don't query OSC support with all possible controls

Yogesh Ashok Powar (2):
      mwifiex: Use pci_release_region() instead of a pci_release_regions()
      mwifiex: Call pci_release_region after calling pci_disable_device

Zhang Rui (1):
      ACPI / thermal: do not always return THERMAL_TREND_RAISING for active=
 trip points

Zhao Hongjiang (1):
      inotify: invalid mask should return a error number but not set it

fanchaoting (1):
      nfsd: don't run get_file if nfs4_preprocess_stateid_op return error


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRidACAAoJEDjbvchgkmk+uHwP/2KpVCfRB131KKY6znlWiYHD
RZI/w1r41+WFFra2fraRlhrMKD2Xgk870Ta+ZNjFOk4akoQHWZy+EtYeA1l4VGCp
wYZzP7nbpSMz/KId9ERtwZI/51QVtEHXrrUajzkta477UzADiQXEvdgd81v0ukc5
11CMVxJ80/28yALQJIlCLpApcfhGRa/A2X67qRfsEIdvf9pHNclegjPsiT39VsQ1
+rReNbNv56keIShT/q9yvFPbZieLrsM8x2ywHHbeMphl4wmcrTb848z9L8gvk53e
1u0m5G/jaX2p+2x1ZUxo9BBvm4wqE3PgAuAc6Dgp2rwy4xLA2tpU4k9/NGFH8un1
pFV9NXGesppZEDuik3zrUDI11c1FveS59KP5gy+j6doq0gmQNAa0v3/as/Gk5egY
mBWUNP8aMu6d3cd/aax617p3gOhoH++6l7G/fMgmjUfwXSmHyQDhUFWrFJqyQ3bw
ez90TjV6gySY8ldL+2Kx50fHjrwuBiLLK2F1+Awc2fIaor+vYD8W4bDmgIkCYMmD
9l7I48RKKNjuY+HxoIku4KKSgba7jZeoq8T6epdOpxKgOs1XGu82i0O3F3lQNJ4W
qQ4xmKAh2NIEQCEGW8Q12TSsmh9MG0q+wsSksBuun184N603JMsp+hdynB+mHuz+
kPwKYKn6Y9ZzqYOq8Iis
=oQ2t
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
