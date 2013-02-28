Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3B1QUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:20:17 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36398 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3B1QUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:20:15 -0500
Date: Thu, 28 Feb 2013 08:20:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.67
Message-ID: <20130228162018.GA9070@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.67 kernel.

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

 Makefile                               |    2=20
 arch/arm/mach-pxa/include/mach/smemc.h |    1=20
 arch/arm/mach-pxa/smemc.c              |   15 +++
 arch/parisc/include/asm/pgtable.h      |   13 ++
 arch/parisc/kernel/cache.c             |   18 ++++
 arch/powerpc/kernel/machine_kexec_64.c |    5 +
 arch/s390/kvm/kvm-s390.c               |    8 +
 arch/x86/include/asm/mmzone_32.h       |    6 -
 arch/x86/power/hibernate_32.c          |    2=20
 arch/x86/xen/spinlock.c                |    1=20
 drivers/base/bus.c                     |    4=20
 drivers/block/sunvdc.c                 |    2=20
 drivers/dca/dca-core.c                 |    5 +
 drivers/gpu/drm/drm_usb.c              |    2=20
 drivers/gpu/drm/i915/intel_display.c   |    8 +
 drivers/net/wireless/p54/p54usb.c      |    2=20
 drivers/net/xen-netback/interface.c    |    3=20
 drivers/net/xen-netback/netback.c      |   10 +-
 drivers/pcmcia/vrc4171_card.c          |    1=20
 drivers/s390/kvm/kvm_virtio.c          |   38 ++++++--
 drivers/staging/comedi/comedi_fops.c   |    5 +
 drivers/staging/hv/hv_kvp.c            |   10 +-
 drivers/staging/vt6656/usbpipe.c       |   28 ++++--
 drivers/tty/tty_ioctl.c                |    4=20
 drivers/tty/vt/vt.c                    |  134 +++++++++++++++++++++-------=
--
 drivers/usb/host/ehci-omap.c           |    2=20
 drivers/usb/serial/option.c            |   16 +++
 drivers/usb/storage/initializers.c     |    4=20
 drivers/usb/storage/unusual_cypress.h  |    2=20
 drivers/video/backlight/adp8860_bl.c   |    2=20
 drivers/video/backlight/adp8870_bl.c   |    2=20
 drivers/video/console/fbcon.c          |   47 ++++++++--
 drivers/video/fbmem.c                  |    9 +-
 drivers/video/fbsysfs.c                |    3=20
 fs/ext4/resize.c                       |    1=20
 fs/ext4/super.c                        |   19 ++--
 fs/fat/namei_vfat.c                    |    3=20
 fs/lockd/clntproc.c                    |    3=20
 fs/nls/nls_base.c                      |   43 +++++++--
 fs/notify/inotify/inotify_user.c       |    4=20
 fs/ocfs2/dlmglue.c                     |    5 -
 include/linux/console.h                |    2=20
 include/linux/mmu_notifier.h           |    1=20
 include/linux/nls.h                    |    5 -
 include/linux/usb/audio.h              |    6 -
 include/linux/vt_kern.h                |    2=20
 include/net/inet6_hashtables.h         |    8 -
 include/net/inet_sock.h                |    1=20
 include/net/ipv6.h                     |   12 ++
 kernel/hrtimer.c                       |   36 ++++----
 kernel/irq/spurious.c                  |    7 -
 kernel/posix-cpu-timers.c              |   23 ++++-
 kernel/timeconst.pl                    |    6 -
 mm/fadvise.c                           |   18 +++-
 mm/mmu_notifier.c                      |  147 +++++++++++++++++++---------=
-----
 mm/page_alloc.c                        |   15 ++-
 mm/shmem.c                             |   10 +-
 net/bridge/br_stp_bpdu.c               |    2=20
 net/ipv4/af_inet.c                     |    9 +-
 net/ipv4/ping.c                        |    4=20
 sound/pci/ali5451/ali5451.c            |    2=20
 sound/pci/rme32.c                      |    2=20
 sound/usb/quirks-table.h               |    2=20
 63 files changed, 572 insertions(+), 240 deletions(-)

Alan Cox (1):
      fb: rework locking to fix lock ordering on takeover

Alan Stern (1):
      NLS: improve UTF8 -> UTF16 string conversion routine

Andrea Arcangeli (1):
      mm: mmu_notifier: make the mmu_notifier srcu static

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Bj=F8rn Mork (3):
      USB: option: add and update Alcatel modems
      USB: option: add Yota / Megafon M100-1 4g modem
      USB: option: add Huawei "ACM" devices using protocol =3D vendor

Christian Borntraeger (1):
      s390/kvm: Fix store status for ACRS/FPRS

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland A-PRO support

Cornelia Huck (1):
      KVM: s390: Handle hosts not supporting s390-virtio.

Dan Carpenter (1):
      ext4: add missing kfree() on error return path in add_new_gdb()

Dave Airlie (2):
      drm/usb: bind driver to correct device
      fbcon: don't lose the console font across generic->chip driver switch

David S. Miller (1):
      sunvdc: Fix off-by-one in generic_request().

David Vrabel (2):
      xen-netback: correctly return errors from netbk_count_requests()
      xen-netback: cancel the credit timer when taking the vif down

Denis Efremov (2):
      ALSA: ali5451: remove irq enabling in pointer callback
      ALSA: rme32.c irq enabling after spin_lock_irq

Eric Dumazet (1):
      ipv6: use a stronger hash for tcp

Greg Kroah-Hartman (1):
      Linux 3.0.67

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object

H. Peter Anvin (2):
      x86-32, mm: Remove reference to resume_map_numa_kva()
      timeconst.pl: Eliminate Perl warning

Ian Abbott (1):
      staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors

Ian Campbell (1):
      xen/netback: check correct frag when looking for head frag

Igor Grinberg (1):
      ARM: PXA3xx: program the CSMSADRCFG register

Jean Delvare (1):
      pcmcia/vrc4171: Add missing spinlock init

Jim Somerville (1):
      inotify: remove broken mask checks causing unmount to be EINVAL

John David Anglin (1):
      Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

Josh Boyer (1):
      USB: usb-storage: unusual_devs update for Super TOP SATA bridge

Junxiao Bi (1):
      ocfs2: unlock super lock if lockres refresh failed

Lars-Peter Clausen (1):
      drivers/video/backlight/adp88?0_bl.c: fix resume

Leonid Shatz (1):
      hrtimer: Prevent hrtimer_enqueue_reprogram race

Li Wei (1):
      ipv4: fix a bug in ping_err().

Linus Torvalds (1):
      mm: fix pageblock bitmap allocation

Maciej Sosnowski (1):
      dca: check against empty dca_domains list before unregister provider

Malcolm Priestley (1):
      staging: vt6656: Fix URB submitted while active warning.

Mel Gorman (1):
      mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to disc=
ard all pages

Mika Kuoppala (1):
      drm/i915: disable shared panel fitter for pipe

Oleg Nesterov (1):
      tty: set_termios/set_termiox should not return -EINTR

Pawel Moll (1):
      ALSA: usb: Fix Processing Unit Descriptor parsers

Phileas Fogg (1):
      powerpc/kexec: Disable hard IRQ before kexec

Robin Holt (1):
      mmu_notifier_unregister NULL Pointer deref and multiple ->release() c=
allouts

Roger Quadros (1):
      USB: ehci-omap: Fix autoloading of module

Sagi Grimberg (1):
      mm: mmu_notifier: have mmu_notifiers use a global SRCU so they may sa=
fely schedule

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak

Stefan Bader (1):
      xen: Send spinlock IPI to all waiters

Stephen Hemminger (1):
      bridge: set priority of STP packets

Takashi Iwai (1):
      fb: Yet another band-aid for fixing lockdep mess

Tao Ma (1):
      ext4: Free resources in some error path in ext4_fill_super

Thomas Gleixner (1):
      genirq: Avoid deadlock in spurious handling

Tomasz Guszkowski (1):
      p54usb: corrected USB ID for T-Com Sinus 154 data II

Trond Myklebust (1):
      NLM: Ensure that we resend all pending blocking locks after a reclaim

fangxiaozhi (1):
      USB: storage: properly handle the endian issues of idProduct


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRL4PCAAoJEDjbvchgkmk+FwYQALZukLMGdgrc4T1iK2wpbnFp
GDKxbly4j3kAti//ctHQArrI1gohbEX5tF8W/8I4M9rELh3ip9JOCH0y45t0O5dx
2EtHsFAzElZgjC4wg4TDii0cLj6pdDNNRc9FpWq0i0Wt07KntNGJr3vHEd/emiE8
84n/ufL/wf9WVNVO8BYfgvdEb9kUrQ77N1/gsYK6CPgQIY8GPL4JxOMmHoqh2pDw
QLvD6ngDPfx0mwPtSnEx1wAfZtMlwY+wi8lVTy8PcU0P6pUsSWraIAoFyVEGIxea
3lbuteFU79EoXOSS6H0olZsqkPDTX8+sQvlN8B64bISXdlMHkROE8S+DqQdHwHFK
pIU8QDfCfbMzYpyPHjCgtuhBTBLs7ojK2y/1MAOciq8wXQZiolhO2fSmQABOpqpa
KSLxY9Xn2vEPw5JY+WormR3vX4j5Zbv3TdB7/Mp6dZ153T/4vJXJsx0CHQCwOPqF
Jq+DXpUzG2LtuInQdLyfZZIaVvX1EsGgsi4Sw+Aefr2ZLU+bNuurOjgW7fKKs8/u
vHfosIdEVFfOG4bPVEsGNeIZshh8e4LtJZyPAL4u5t8n3deJFefZZXutnSf9SsxD
yc9GyBqWOceAqFJ8s/q7cae7EbU/RVlCNgCf8jrYTV7ox4G0l/O29G8JOtIAA/P0
7Ca09sZmPyiVAqXoqPu8
=XMJz
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
