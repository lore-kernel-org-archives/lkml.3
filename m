Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472Ab3B0Rbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:31:52 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51448 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605Ab3B0Rbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:31:50 -0500
Date: Wed, 27 Feb 2013 09:31:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.10
Message-ID: <20130227173147.GA29822@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.10 kernel.

All users of the 3.7 kernel series must upgrade.

Note, this is the LAST 3.7 kernel to be released, it is now end-of-life
and all users of the 3.7 kernel series should be moving to the 3.8
series at this point in time.

The updated 3.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.7.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/s390/kvm/kvm-s390.c                      |    8 +
 arch/sparc/Kconfig                            |    1=20
 arch/sparc/include/asm/hugetlb.h              |    1=20
 arch/sparc/include/asm/page_64.h              |    4=20
 arch/sparc/include/asm/pgtable_64.h           |   14 --
 arch/sparc/include/asm/tsb.h                  |   28 +++-
 arch/sparc/kernel/tsb.S                       |   39 +++++-
 arch/sparc/mm/fault_64.c                      |    9 +
 arch/sparc/mm/gup.c                           |   59 +++++++++
 arch/sparc/mm/init_64.c                       |   62 ++++++----
 arch/sparc/mm/tlb.c                           |   11 +
 arch/sparc/mm/tsb.c                           |    2=20
 arch/x86/Kconfig                              |    4=20
 arch/x86/include/asm/mmzone_32.h              |    6=20
 arch/x86/kernel/cpu/mshyperv.c                |    3=20
 arch/x86/mm/numa.c                            |   32 +----
 arch/x86/mm/numa_32.c                         |  161 ---------------------=
-----
 arch/x86/mm/numa_internal.h                   |    6=20
 arch/x86/power/hibernate_32.c                 |    2=20
 arch/x86/xen/spinlock.c                       |    1=20
 drivers/base/bus.c                            |    4=20
 drivers/base/dd.c                             |    2=20
 drivers/block/sunvdc.c                        |    2=20
 drivers/gpu/drm/i915/intel_pm.c               |    2=20
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c |    4=20
 drivers/net/wireless/b43/dma.h                |    2=20
 drivers/net/wireless/p54/p54usb.c             |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c   |    1=20
 drivers/net/wireless/rtlwifi/usb.c            |   44 ++++---
 drivers/s390/kvm/kvm_virtio.c                 |   38 ++++--
 drivers/staging/zram/zram_drv.c               |    9 -
 drivers/target/target_core_device.c           |    8 +
 drivers/tty/n_gsm.c                           |   42 ++++++
 drivers/tty/serial/imx.c                      |   11 +
 drivers/tty/tty_ioctl.c                       |    4=20
 drivers/tty/vt/vt.c                           |    2=20
 drivers/usb/serial/ftdi_sio.c                 |   20 +--
 drivers/usb/serial/mct_u232.c                 |   22 +--
 drivers/usb/serial/quatech2.c                 |   18 +-
 drivers/usb/serial/sierra.c                   |    8 -
 drivers/usb/serial/ssu100.c                   |   19 +--
 drivers/usb/serial/usb-serial.c               |   14 +-
 drivers/usb/serial/usb_wwan.c                 |    8 -
 drivers/video/backlight/adp8860_bl.c          |    2=20
 drivers/video/backlight/adp8870_bl.c          |    2=20
 drivers/xen/evtchn.c                          |   10 +
 drivers/xen/xen-pciback/pciback_ops.c         |   14 +-
 fs/block_dev.c                                |    1=20
 fs/gfs2/bmap.c                                |    4=20
 fs/lockd/clntproc.c                           |    3=20
 fs/nfs/blocklayout/blocklayout.c              |    1=20
 fs/nfs/nfs4proc.c                             |    3=20
 fs/nfs/objlayout/objio_osd.c                  |    1=20
 fs/notify/inotify/inotify_user.c              |    4=20
 fs/ocfs2/dlmglue.c                            |    5=20
 include/uapi/linux/serial_core.h              |    2=20
 include/uapi/linux/usb/audio.h                |    6=20
 kernel/futex.c                                |    2=20
 kernel/futex_compat.c                         |    2=20
 kernel/hrtimer.c                              |   36 ++---
 kernel/irq/spurious.c                         |    7 -
 kernel/posix-cpu-timers.c                     |   23 +++
 kernel/timeconst.pl                           |    6=20
 kernel/workqueue.c                            |    2=20
 mm/fadvise.c                                  |   18 ++
 mm/mmu_notifier.c                             |   82 ++++++-------
 mm/page_alloc.c                               |   15 +-
 mm/shmem.c                                    |   10 +
 net/core/sock_diag.c                          |    3=20
 sound/pci/ali5451/ali5451.c                   |    2=20
 sound/pci/hda/patch_hdmi.c                    |   18 ++
 sound/pci/hda/patch_realtek.c                 |    1=20
 sound/pci/rme32.c                             |    2=20
 sound/usb/quirks-table.h                      |    2=20
 tools/perf/Makefile                           |    4=20
 tools/perf/ui/hist.c                          |    6=20
 tools/perf/util/parse-events.y                |    1=20
 tools/perf/util/pmu.y                         |    1=20
 79 files changed, 572 insertions(+), 470 deletions(-)

Adam Jackson (1):
      drm/i915: Fix up mismerge of 3490ea5d in 3.7.y

Anssi Hannula (1):
      ALSA: hda - Fix default multichannel HDMI mapping regression

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Bob Peterson (1):
      GFS2: Get a block reservation before resizing a file

Christian Borntraeger (1):
      s390/kvm: Fix store status for ACRS/FPRS

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland A-PRO support

Cornelia Huck (1):
      KVM: s390: Handle hosts not supporting s390-virtio.

Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code

David Henningsson (1):
      ALSA: hda - hdmi: ELD shouldn't be valid after unplug

David S. Miller (7):
      sunvdc: Fix off-by-one in generic_request().
      sparc64: Add missing HAVE_ARCH_TRANSPARENT_HUGEPAGE.
      sparc64: Fix get_user_pages_fast() wrt. THP.
      sparc64: Fix gfp_flags setting in tsb_grow().
      sparc64: Handle hugepage TSB being NULL.
      sparc64: Fix tsb_grow() in atomic context.
      sparc64: Fix huge PMD to PTE translation for sun4u in TLB miss handle=
r.

Denis Efremov (2):
      ALSA: ali5451: remove irq enabling in pointer callback
      ALSA: rme32.c irq enabling after spin_lock_irq

Dirkjan Bussink (1):
      tty: Prevent deadlock in n_gsm driver

Fernando Luis Vazquez Cao (1):
      ALSA: hda - Workaround for silent output on Sony Vaio VGC-LN51JGB wit=
h ALC889

Grant Likely (1):
      drivercore: Fix ordering between deferred_probe and exiting initcalls

Greg Kroah-Hartman (1):
      Linux 3.7.10

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object

H. Peter Anvin (3):
      x86-32, mm: Remove reference to resume_map_numa_kva()
      x86-32, mm: Remove reference to alloc_remap()
      timeconst.pl: Eliminate Perl warning

Jan Beulich (1):
      xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()

Jim Somerville (1):
      inotify: remove broken mask checks causing unmount to be EINVAL

Jiri Olsa (1):
      perf hists: Fix period symbol_conf.field_sep display

Johan Hovold (1):
      USB: serial: fix null-pointer dereferences on disconnect

Junxiao Bi (1):
      ocfs2: unlock super lock if lockres refresh failed

Jussi Kivilinna (1):
      rtlwifi: usb: allocate URB control message setup_packet and data buff=
er separately

Konstantin Khlebnikov (1):
      workqueue: un-GPL function delayed_work_timer_fn()

Larry Finger (2):
      b43: Increase number of RX DMA slots
      rtlwifi: rtl8192cu: Add new USB ID

Lars-Peter Clausen (1):
      drivers/video/backlight/adp88?0_bl.c: fix resume

Leonid Shatz (1):
      hrtimer: Prevent hrtimer_enqueue_reprogram race

Linus Torvalds (1):
      mm: fix pageblock bitmap allocation

MITSUNARI Shigeo (1):
      fs/block_dev.c: page cache wrongly left invalidated after revalidate_=
disk()

Marcin Slusarz (1):
      drm/nouveau/vm: fix memory corruption when pgt allocation fails

Mathias Krause (1):
      sock_diag: Fix out-of-bounds access to sock_diag_handlers[]

Mel Gorman (1):
      mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to disc=
ard all pages

Michael Chan (1):
      serial_core: Fix type definition for PORT_BRCM_TRUMANAGE.

Minchan Kim (1):
      zram: Fix deadlock bug in partial read/write

Nicholas Bellinger (1):
      target: Fix divide by zero bug in fabric_max_sectors for unconfigured=
 devices

Nicolas Pitre (1):
      tty vt: fix character insertion overflow

Olaf Hering (1):
      x86: Hyper-V: register clocksource only if its advertised

Oleg Nesterov (1):
      tty: set_termios/set_termiox should not return -EINTR

Pawel Moll (1):
      ALSA: usb: Fix Processing Unit Descriptor parsers

Robin Holt (1):
      mmu_notifier_unregister NULL Pointer deref and multiple ->release() c=
allouts

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak

Stefan Bader (1):
      xen: Send spinlock IPI to all waiters

Takashi Iwai (1):
      ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()

Thomas Gleixner (3):
      genirq: Avoid deadlock in spurious handling
      serial: imx: Fix recursive locking bug
      futex: Revert "futex: Mark get_robust_list as deprecated"

Tomasz Guszkowski (1):
      p54usb: corrected USB ID for T-Com Sinus 154 data II

Trond Myklebust (1):
      NLM: Ensure that we resend all pending blocking locks after a reclaim

Vinson Lee (1):
      perf tools: Fix build with bison 2.3 and older.

Wei Liu (1):
      xen: close evtchn port if binding to irq fails

Weston Andros Adamson (1):
      NFSv4.1: Don't decode skipped layoutgets

fanchaoting (1):
      umount oops when remove blocklayoutdriver first


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRLkMCAAoJEDjbvchgkmk+dGsP/2DcPNHo2bPQc6c9OPDoqfls
udXJ9rTLEtke+o5IoyuldsjzVKPXHCN/H4f/CdoRjom2REfzUEVTH1ZNpT90bEmg
RnGmhUL+S8fIPT0gcp5B8RQQv7eU/GB8e8MuFsWYGQaXOLHUyz9+5efTaj/IPGur
aCAjDK33+wxBu7Epu5BKcQT2m9VFvmvrLGQjGWsfDbt0n/DWTH6W41V5lVvAU02H
74cjzpWXe7qEgHBwm4f+pf+UI2Vo0UWxG62JD2RQpn9c6aUVFGFpk4DTtq6fS5nE
i81TI6CdNrYsm8wW1E4f1qL1xuQWkpKxEuA4fKFyiVW1HnNlaD+7HZPt0Foez0+J
HfE5cwLnpy9/8PGcvZerK7MbCOQKEHe6U1lCe9tpfCT58hXFgkCnW4eW3mo6uQ2/
FMUpPvc+Wb41/jI/V12VcaD+tFGWEv88o6DOBVYLYibvwxztDiTZCnq9SYC8sSb7
RoxC9F1pZla0sy3Tc/kW6aU9O1Hyw6UMXtJjQyPzBJgZZvnJYHWcYPTnk2SwPXix
3ZQ3MWxxoEBtirBiEp0jUmaq7USeNDiR29fXLQ7ohWXudm2brPy6+WYX6rcY5v2O
twFo9raIIckAjVlOfvPWzrze/M+V7gefdDE552ZXezb6aTNHVF0+07VfXbvHbAif
O0nGTnn+/9GTizjd2Nz0
=epNA
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
