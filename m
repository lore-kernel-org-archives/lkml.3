Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3EHEJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:09:17 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:64985 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3EHEJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:09:12 -0400
Date: Tue, 7 May 2013 21:09:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.44
Message-ID: <20130508040908.GA17271@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.44 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/arm/configs/at91sam9g45_defconfig        |    1=20
 arch/arm/include/asm/pgtable.h                |    9 +++
 arch/arm/mach-at91/setup.c                    |    2=20
 arch/avr32/configs/favr-32_defconfig          |    1=20
 arch/avr32/configs/merisc_defconfig           |    1=20
 arch/ia64/include/asm/futex.h                 |    5 -
 arch/ia64/include/asm/mca.h                   |    1=20
 arch/ia64/kernel/irq.c                        |    8 ++
 arch/ia64/kernel/mca.c                        |   37 ++++++++----
 arch/ia64/kvm/vtlb.c                          |    2=20
 arch/powerpc/kernel/head_64.S                 |    1=20
 arch/powerpc/platforms/cell/spufs/inode.c     |    1=20
 arch/x86/kernel/irq.c                         |    4 -
 arch/x86/kvm/emulate.c                        |    4 +
 arch/x86/xen/enlighten.c                      |    5 +
 arch/x86/xen/time.c                           |    6 +-
 drivers/acpi/pci_root.c                       |    4 -
 drivers/i2c/busses/i2c-xiic.c                 |    6 --
 drivers/md/md.c                               |    9 +--
 drivers/mfd/adp5520.c                         |    8 ++
 drivers/mmc/core/mmc.c                        |    2=20
 drivers/mmc/host/Kconfig                      |   10 ---
 drivers/mmc/host/atmel-mci.c                  |   16 +++--
 drivers/net/ethernet/freescale/gianfar_ptp.c  |    3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   10 +++
 drivers/net/wireless/mwifiex/pcie.c           |    4 -
 drivers/pci/pci.c                             |   12 +---
 drivers/rtc/rtc-cmos.c                        |    4 -
 drivers/s390/char/sclp_cmd.c                  |    4 +
 drivers/tty/pty.c                             |    3 +
 drivers/tty/serial/serial_core.c              |    4 +
 drivers/tty/tty_io.c                          |    4 -
 drivers/usb/core/devio.c                      |    2=20
 drivers/usb/misc/appledisplay.c               |    1=20
 drivers/usb/serial/ftdi_sio.c                 |    5 +
 drivers/usb/serial/ftdi_sio_ids.h             |    4 +
 drivers/usb/serial/option.c                   |    8 ++
 drivers/usb/storage/cypress_atacb.c           |   16 ++++-
 drivers/video/console/fbcon.c                 |    2=20
 fs/dcache.c                                   |    4 +
 fs/exec.c                                     |    4 -
 fs/ext4/Kconfig                               |    3 -
 fs/ext4/ext4_jbd2.h                           |    6 +-
 fs/ext4/mballoc.c                             |    8 +-
 fs/ext4/resize.c                              |    2=20
 fs/ext4/super.c                               |    7 +-
 fs/fscache/stats.c                            |    2=20
 fs/jbd2/commit.c                              |   50 +++++++++--------
 fs/lockd/clntlock.c                           |    3 +
 fs/lockd/clntproc.c                           |    3 -
 fs/nfs/nfs4proc.c                             |    6 ++
 fs/nfsd/nfs4state.c                           |    8 --
 fs/nfsd/nfs4xdr.c                             |   19 +-----
 fs/sysfs/dir.c                                |   15 +++--
 include/asm-generic/pgtable.h                 |   10 +++
 include/linux/ipc_namespace.h                 |    2=20
 include/linux/jbd2.h                          |    1=20
 ipc/shm.c                                     |    2=20
 kernel/cgroup.c                               |    2=20
 kernel/hrtimer.c                              |    6 ++
 kernel/time/tick-broadcast.c                  |    4 +
 kernel/time/tick-common.c                     |    1=20
 kernel/trace/ftrace.c                         |    5 +
 kernel/trace/trace.c                          |    2=20
 kernel/trace/trace_stack.c                    |   76 +++++++++++++++++++++=
++---
 kernel/trace/trace_stat.c                     |    2=20
 mm/mmap.c                                     |    4 -
 net/wireless/reg.c                            |    2=20
 sound/soc/codecs/max98088.c                   |    2=20
 sound/usb/card.c                              |    4 +
 sound/usb/midi.c                              |   13 ----
 sound/usb/stream.c                            |    8 ++
 73 files changed, 347 insertions(+), 170 deletions(-)

Adrian Thomasset (1):
      USB: ftdi_sio: correct ST Micro Connect Lite PIDs

Anurup m (1):
      fs/fscache/stats.c: fix memory leak

Ben Jencks (1):
      usb/misc/appledisplay: Add 24" LED Cinema display

Bj=F8rn Mork (1):
      USB: option: add a D-Link DWM-156 variant

Bryan Schumaker (1):
      nfsd: Decode and send 64bit time values

Catalin Marinas (1):
      arm: set the page table freeing ceiling to TASK_SIZE

Clemens Ladisch (1):
      ALSA: usb-audio: disable autopm for MIDI devices

Daniel Mack (1):
      ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

Derek Basehore (1):
      drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

Dmitry Monakhov (2):
      jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_=
callback
      ext4: fix journal callback list traversal

Dylan Reid (1):
      ASoC: max98088: Fix logging of hardware revision.

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145

Gleb Natapov (1):
      KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x inst=
ructions

Greg Kroah-Hartman (1):
      Linux 3.4.44

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

Johan Hovold (1):
      mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload

Johannes Berg (1):
      wireless: regulatory: fix channel disabling race condition

Konrad Rzeszutek Wilk (1):
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.

Lars-Peter Clausen (1):
      mfd: adp5520: Restore mode bits on resume

Li Fei (1):
      x86: Eliminate irq_mis_count counted in arch_irq_stat

Li Zefan (1):
      cgroup: fix an off-by-one bug which may trigger BUG_ON()

Linus Torvalds (1):
      tty: fix up atime/mtime mess, take three

Maxime Ripard (1):
      ARM: at91: Fix typo in restart code panic message

Michael Ellerman (1):
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()

Michael Neuling (1):
      powerpc: Add isync to copy_and_flush

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

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards

Prarit Bhargava (1):
      hrtimer: Add expiry time overflow check in hrtimer_interrupt

Rafael J. Wysocki (1):
      PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()

Richard Cochran (1):
      gianfar: do not advertise any alarm capability.

Robin Holt (1):
      ipc: sysv shared memory limited to 8TiB

Stefani Seibold (1):
      USB: add ftdi_sio USB ID for GDM Boost V1.x

Stephan Schreiber (2):
      Wrong asm register contraints in the futex implementation
      Wrong asm register contraints in the kvm implementation

Steven A. Falco (1):
      i2c: xiic: must always write 16-bit words to TX_FIFO

Steven Rostedt (Red Hat) (3):
      tracing: Use stack of calling function for stack tracer
      tracing: Fix stack tracer with fentry use
      tracing: Remove most or all of stack tracer stack size from stack_max=
_size

Takashi Iwai (1):
      ALSA: usb-audio: Fix autopm error during probing

Terry Barnaby (1):
      mmc: atmel-mci: pio hang on block errors

Theodore Ts'o (2):
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

Yinghai Lu (1):
      PCI / ACPI: Don't query OSC support with all possible controls

Yogesh Ashok Powar (2):
      mwifiex: Use pci_release_region() instead of a pci_release_regions()
      mwifiex: Call pci_release_region after calling pci_disable_device


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRic/kAAoJEDjbvchgkmk+AsIQAMuJ+h8K9DWYLWVoG0aEf+6K
sIA8noXMz4acFtlaP++NnfR34cdy3hTau/U0CGvZn2dRvncrtuuqmkrBzPsr6ldR
FXb8fvUm1vbkFoRUyOhRFpZML0LRgykK+anLii/Xj4Q/F8d+rxzqVOXHS6PcyMDb
yjpduWGbbzlu8AfTVxa9Is1q/zSCTGgvgBHgAUHjGKdn6JsZLsGKn74pMXRK+ZQ7
FsjvEeDJEEsSebaVcjLA1LAY6ZtMgYhvJYqf3un+T0wZYtQcCVOMESjBRJ6zVwNS
CogWURpQApwG3FO3q717ww71G9fHgiFH+VBseJpIaGdoqNtKW981JzazKnlfaheE
KPDtfBBYBz+ecB7YRO/AkUODdTk0m9w9awPLHepIvqOWpAfcFcLmx/gc8+94f3xL
SlFQY4ixjOkLLS+wi/cKrLMuyEusavsbBU99NkN9ECD1nOqC8aGo1TI0gwITbuPp
Utn1W3chdP5cGhLju6JnJW4MQ4m7S2NxmrExO0id0kuC5MfbrUQw42ErtKOi6Lsg
IUGf/ebE7sqTMH67g2CeTRRsEgx/OADzENRkQ6zN+Zjy/8r1VCAk+nzEau0so27O
IblnngFfLVAHyFAuNCWDToUmp/t9bw0Psfc5L7D5CdhLYCzxZCw9PsBl70xhICf1
nAeyJfTYouF129uYShv9
=41nM
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
