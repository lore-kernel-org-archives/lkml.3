Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3EHEIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:08:40 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62401 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3EHEIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:08:37 -0400
Date: Tue, 7 May 2013 21:08:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.77
Message-ID: <20130508040834.GA17223@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.77 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/ia64/include/asm/futex.h                 |    5 -
 arch/ia64/include/asm/mca.h                   |    1=20
 arch/ia64/kernel/irq.c                        |    8 ++
 arch/ia64/kernel/mca.c                        |   37 ++++++++----
 arch/ia64/kvm/vtlb.c                          |    2=20
 arch/powerpc/kernel/head_64.S                 |    1=20
 arch/powerpc/platforms/cell/spufs/inode.c     |    1=20
 arch/s390/include/asm/pgtable.h               |    4 +
 arch/x86/kernel/irq.c                         |    4 -
 arch/x86/xen/enlighten.c                      |    5 +
 arch/x86/xen/time.c                           |    6 +-
 drivers/acpi/pci_root.c                       |    4 -
 drivers/i2c/busses/i2c-xiic.c                 |    6 --
 drivers/mfd/adp5520.c                         |    8 ++
 drivers/mmc/core/mmc.c                        |    2=20
 drivers/net/can/sja1000/sja1000_of_platform.c |   31 +++++-----
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
 fs/ext4/Kconfig                               |    3 -
 fs/fscache/stats.c                            |    2=20
 fs/lockd/clntlock.c                           |    3 +
 fs/lockd/clntproc.c                           |    3 -
 fs/nfs/nfs4proc.c                             |    6 ++
 fs/nfsd/nfs4state.c                           |    8 --
 fs/nfsd/nfs4xdr.c                             |   19 +-----
 include/linux/ipc_namespace.h                 |    2=20
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
 net/wireless/reg.c                            |    2=20
 sound/soc/codecs/max98088.c                   |    2=20
 sound/usb/card.c                              |    4 +
 sound/usb/midi.c                              |   13 ----
 50 files changed, 242 insertions(+), 109 deletions(-)

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

Clemens Ladisch (1):
      ALSA: usb-audio: disable autopm for MIDI devices

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

Derek Basehore (1):
      drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

Dylan Reid (1):
      ASoC: max98088: Fix logging of hardware revision.

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145

Greg Kroah-Hartman (2):
      Revert :can: sja1000: fix handling on dt properties on little endian =
systems"
      Linux 3.0.77

Hans de Goede (1):
      usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl=
 ep

Heiko Carstens (1):
      s390/memory hotplug: prevent offline of active memory increments

J. Bruce Fields (1):
      nfsd4: don't close read-write opens too soon

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

Linus Torvalds (2):
      tty: fix up atime/mtime mess, take three
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h

Michael Ellerman (1):
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()

Michael Neuling (1):
      powerpc: Add isync to copy_and_flush

Mika Kuoppala (1):
      fbcon: when font is freed, clear also vc_font.data

Namhyung Kim (3):
      tracing: Fix off-by-one on allocating stat->pages
      tracing: Check return value of tracing_init_dentry()
      tracing: Reset ftrace_graph_filter_enabled if count is zero

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards

Prarit Bhargava (1):
      hrtimer: Add expiry time overflow check in hrtimer_interrupt

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

Theodore Ts'o (1):
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


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRic/CAAoJEDjbvchgkmk+Gx0QAIllXVYvXMxsKHXWaWx66GLr
OxolGqH1cm4LW+IHQBtQRCCszdXiUw83D7KBQeOJYf7QfwUAJ7glQrU0VwOhMb0W
5/sbqpKrTAzw1Uj4datvCbh5WxzEWXP54LnYvaz/NQKvNF5WVDguee4Lv3PAkvTh
UHiM4kl1ZkwDpheJ3ztwE1Z2+hoZgSVmXVx8E4sXNIsZjZnX4/94n4t022wLnCxv
ZLuSnLmkPdhlQeMS0yUuS5ritvblpxc6p00RKZqu4QPXB69wPKX0Wr1SzNDlRquh
+XlOy2mE24UKHywGRkvCbvYEjwhVwaCRf5Fb+DHGabc72QUTsnMoyAI90J0dKYPU
gNTb9zr9hPwuykYii59XN5tbcOZhgIOPYInyLVuvPFveaADhuJa5lDbymMO6VxDl
ErqlYd8ndSpPAaHUpo46DFUCCXdeSwLID6WXMlCTNcGF07/ARyrmOtDBGotV6lj7
2DP3pOXF/n/E1638OSx2mSeU6KGL02aNJtOGDso1f4VP65Px9MBJovHJqzReuN36
RQyyIRX4kZYk8oPF8Z4XiDCrSY1wd1CeDwAS5cZmxhZiu3/dpd2eqfPi3utU5L8J
pl3p5Ow4CKrQrAdAA5Cj41e0flfQDpfX2hcXhxn85UpGxU8h+8r8X9clBxM5Uu0m
eGYyQ27qxeIZGjPKRH4y
=DLrp
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
