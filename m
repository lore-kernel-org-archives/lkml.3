Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3B1QVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:21:04 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50249 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3B1QU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:20:58 -0500
Date: Thu, 28 Feb 2013 08:21:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.34
Message-ID: <20130228162101.GA9138@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.34 kernel.

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

 Makefile                                         |    2=20
 arch/arm/kernel/sched_clock.c                    |    4=20
 arch/arm/mach-pxa/include/mach/smemc.h           |    1=20
 arch/arm/mach-pxa/smemc.c                        |   15 ++
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S |   12 -
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S |    4=20
 arch/arm/mach-s3c24xx/pm-h1940.S                 |    2=20
 arch/arm/mach-s3c24xx/sleep-s3c2410.S            |   12 -
 arch/arm/mach-s3c24xx/sleep-s3c2412.S            |   12 -
 arch/arm/plat-samsung/include/plat/debug-macro.S |   18 +-
 arch/parisc/include/asm/pgtable.h                |   13 +
 arch/parisc/kernel/cache.c                       |   18 ++
 arch/powerpc/kernel/machine_kexec_64.c           |    5=20
 arch/s390/kvm/kvm-s390.c                         |    8 +
 arch/x86/Kconfig                                 |    4=20
 arch/x86/include/asm/mmzone_32.h                 |    6=20
 arch/x86/kernel/cpu/mshyperv.c                   |    3=20
 arch/x86/mm/numa.c                               |   32 +---
 arch/x86/mm/numa_32.c                            |  161 ------------------=
-----
 arch/x86/mm/numa_internal.h                      |    6=20
 arch/x86/power/hibernate_32.c                    |    2=20
 arch/x86/xen/spinlock.c                          |    1=20
 drivers/base/bus.c                               |    4=20
 drivers/base/dd.c                                |    2=20
 drivers/block/sunvdc.c                           |    2=20
 drivers/dca/dca-core.c                           |    5=20
 drivers/gpu/drm/drm_crtc.c                       |    3=20
 drivers/gpu/drm/drm_edid.c                       |    3=20
 drivers/gpu/drm/drm_usb.c                        |    2=20
 drivers/gpu/drm/i915/intel_display.c             |   12 +
 drivers/gpu/drm/radeon/atombios_crtc.c           |    6=20
 drivers/gpu/drm/udl/udl_drv.h                    |    2=20
 drivers/gpu/drm/udl/udl_fb.c                     |   48 ++++++
 drivers/hid/hid-wiimote-ext.c                    |    8 -
 drivers/iommu/intel-iommu.c                      |    8 +
 drivers/mmc/host/sdhci-esdhc-imx.c               |   19 +-
 drivers/net/wireless/b43/dma.h                   |    2=20
 drivers/net/wireless/p54/p54usb.c                |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c      |    1=20
 drivers/net/wireless/rtlwifi/usb.c               |   44 ++++--
 drivers/net/xen-netback/interface.c              |    3=20
 drivers/net/xen-netback/netback.c                |    8 -
 drivers/pcmcia/vrc4171_card.c                    |    1=20
 drivers/s390/kvm/kvm_virtio.c                    |   38 ++++-
 drivers/staging/comedi/comedi_fops.c             |    5=20
 drivers/staging/vt6656/usbpipe.c                 |   28 ++--
 drivers/target/target_core_device.c              |    8 +
 drivers/tty/n_gsm.c                              |   42 +++++-
 drivers/tty/tty_ioctl.c                          |    4=20
 drivers/tty/vt/vt.c                              |  136 ++++++++++++++-----
 drivers/usb/host/ehci-omap.c                     |    2=20
 drivers/usb/serial/ftdi_sio.c                    |   20 +-
 drivers/usb/serial/mct_u232.c                    |   22 +--
 drivers/usb/serial/option.c                      |   16 ++
 drivers/usb/serial/sierra.c                      |    8 -
 drivers/usb/serial/ssu100.c                      |   19 +-
 drivers/usb/serial/usb-serial.c                  |   14 +-
 drivers/usb/serial/usb_wwan.c                    |    8 -
 drivers/usb/storage/initializers.c               |    4=20
 drivers/usb/storage/unusual_cypress.h            |    2=20
 drivers/video/backlight/adp8860_bl.c             |    2=20
 drivers/video/backlight/adp8870_bl.c             |    2=20
 drivers/video/console/fbcon.c                    |   47 +++++-
 drivers/video/console/vgacon.c                   |   22 ++-
 drivers/video/fbmem.c                            |    9 -
 drivers/video/fbsysfs.c                          |    3=20
 drivers/video/fsl-diu-fb.c                       |    6=20
 drivers/xen/evtchn.c                             |   10 +
 fs/block_dev.c                                   |    1=20
 fs/lockd/clntproc.c                              |    3=20
 fs/nfs/blocklayout/blocklayout.c                 |    1=20
 fs/nfs/objlayout/objio_osd.c                     |    1=20
 fs/notify/inotify/inotify_user.c                 |    4=20
 fs/ocfs2/dlmglue.c                               |    5=20
 include/linux/console.h                          |    2=20
 include/linux/if_vlan.h                          |    6=20
 include/linux/mmu_notifier.h                     |    1=20
 include/linux/usb/audio.h                        |    6=20
 include/linux/vt_kern.h                          |    3=20
 include/net/inet6_hashtables.h                   |    8 -
 include/net/inet_sock.h                          |    1=20
 include/net/ipv6.h                               |   12 +
 include/net/sock.h                               |    2=20
 kernel/futex.c                                   |    2=20
 kernel/futex_compat.c                            |    2=20
 kernel/hrtimer.c                                 |   36 ++---
 kernel/irq/spurious.c                            |    7 -
 kernel/posix-cpu-timers.c                        |   23 +++
 kernel/timeconst.pl                              |    6=20
 mm/fadvise.c                                     |   18 ++
 mm/mmu_notifier.c                                |  147 ++++++++++++------=
---
 mm/page_alloc.c                                  |   15 +-
 mm/shmem.c                                       |   10 +
 net/bridge/br_stp_bpdu.c                         |    2=20
 net/core/datagram.c                              |    2=20
 net/core/sock_diag.c                             |    3=20
 net/ipv4/af_inet.c                               |    9 +
 net/ipv4/ping.c                                  |    4=20
 sound/pci/ali5451/ali5451.c                      |    2=20
 sound/pci/hda/patch_hdmi.c                       |    7 -
 sound/pci/hda/patch_realtek.c                    |    1=20
 sound/pci/rme32.c                                |    2=20
 sound/soc/codecs/wm2200.c                        |    4=20
 sound/usb/quirks-table.h                         |    2=20
 104 files changed, 806 insertions(+), 557 deletions(-)

Alan Cox (1):
      fb: rework locking to fix lock ordering on takeover

Alex Deucher (1):
      drm/radeon/dce6: fix display powergating

Anatolij Gustschin (1):
      drivers/video: fsl-diu-fb: fix pixel formats for 24 and 16 bpp

Andrea Arcangeli (1):
      mm: mmu_notifier: make the mmu_notifier srcu static

Arnd Bergmann (1):
      ARM: samsung: fix assembly syntax for new gas

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Bj=F8rn Mork (3):
      USB: option: add and update Alcatel modems
      USB: option: add Yota / Megafon M100-1 4g modem
      USB: option: add Huawei "ACM" devices using protocol =3D vendor

Chris Rattray (1):
      ASoC: wm2200: correct IN2L and IN3L digital mute

Christian Borntraeger (1):
      s390/kvm: Fix store status for ACRS/FPRS

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland A-PRO support

Cong Wang (1):
      vlan: adjust vlan_set_encap_proto() for its callers

Cornelia Huck (1):
      KVM: s390: Handle hosts not supporting s390-virtio.

Daniel Vetter (1):
      intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets

Dave Airlie (5):
      drm/udl: make usage as a console safer
      drm/udl: disable fb_defio by default
      vgacon/vt: clear buffer attributes when we load a 512 character font =
(v2)
      drm/usb: bind driver to correct device
      fbcon: don't lose the console font across generic->chip driver switch

Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code

David Henningsson (1):
      ALSA: hda - hdmi: ELD shouldn't be valid after unplug

David Herrmann (1):
      HID: wiimote: fix nunchuck button parser

David S. Miller (1):
      sunvdc: Fix off-by-one in generic_request().

David Vrabel (2):
      xen-netback: correctly return errors from netbk_count_requests()
      xen-netback: cancel the credit timer when taking the vif down

Denis Efremov (2):
      ALSA: ali5451: remove irq enabling in pointer callback
      ALSA: rme32.c irq enabling after spin_lock_irq

Dirkjan Bussink (1):
      tty: Prevent deadlock in n_gsm driver

Eric Dumazet (2):
      net: fix infinite loop in __skb_recv_datagram()
      ipv6: use a stronger hash for tcp

Fernando Luis Vazquez Cao (1):
      ALSA: hda - Workaround for silent output on Sony Vaio VGC-LN51JGB wit=
h ALC889

Grant Likely (1):
      drivercore: Fix ordering between deferred_probe and exiting initcalls

Greg Kroah-Hartman (1):
      Linux 3.4.34

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object

H. Peter Anvin (3):
      x86-32, mm: Remove reference to resume_map_numa_kva()
      x86-32, mm: Remove reference to alloc_remap()
      timeconst.pl: Eliminate Perl warning

Ian Abbott (1):
      staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors

Igor Grinberg (1):
      ARM: PXA3xx: program the CSMSADRCFG register

Jean Delvare (1):
      pcmcia/vrc4171: Add missing spinlock init

Jim Somerville (1):
      inotify: remove broken mask checks causing unmount to be EINVAL

Johan Hovold (1):
      USB: serial: fix null-pointer dereferences on disconnect

John David Anglin (1):
      Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

Joonsoo Kim (1):
      ARM: 7643/1: sched: correct update_sched_clock()

Josh Boyer (1):
      USB: usb-storage: unusual_devs update for Super TOP SATA bridge

Junxiao Bi (1):
      ocfs2: unlock super lock if lockres refresh failed

Jussi Kivilinna (1):
      rtlwifi: usb: allocate URB control message setup_packet and data buff=
er separately

Larry Finger (2):
      b43: Increase number of RX DMA slots
      rtlwifi: rtl8192cu: Add new USB ID

Lars-Peter Clausen (1):
      drivers/video/backlight/adp88?0_bl.c: fix resume

Leonid Shatz (1):
      hrtimer: Prevent hrtimer_enqueue_reprogram race

Li Wei (1):
      ipv4: fix a bug in ping_err().

Linus Torvalds (1):
      mm: fix pageblock bitmap allocation

MITSUNARI Shigeo (1):
      fs/block_dev.c: page cache wrongly left invalidated after revalidate_=
disk()

Maciej Sosnowski (1):
      dca: check against empty dca_domains list before unregister provider

Malcolm Priestley (1):
      staging: vt6656: Fix URB submitted while active warning.

Mathias Krause (1):
      sock_diag: Fix out-of-bounds access to sock_diag_handlers[]

Mel Gorman (1):
      mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to disc=
ard all pages

Mika Kuoppala (1):
      drm/i915: disable shared panel fitter for pipe

Nicholas Bellinger (1):
      target: Fix divide by zero bug in fabric_max_sectors for unconfigured=
 devices

Olaf Hering (1):
      x86: Hyper-V: register clocksource only if its advertised

Oleg Nesterov (1):
      tty: set_termios/set_termiox should not return -EINTR

Patrik Jakobsson (1):
      drm/i915: Set i9xx sdvo clock limits according to specifications

Paulo Zanoni (1):
      drm: don't add inferred modes for monitors that don't support them

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

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: fix host version read

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak

Stefan Bader (1):
      xen: Send spinlock IPI to all waiters

Stephen Hemminger (1):
      bridge: set priority of STP packets

Takashi Iwai (2):
      ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()
      fb: Yet another band-aid for fixing lockdep mess

Thomas Gleixner (2):
      genirq: Avoid deadlock in spurious handling
      futex: Revert "futex: Mark get_robust_list as deprecated"

Tomasz Guszkowski (1):
      p54usb: corrected USB ID for T-Com Sinus 154 data II

Trond Myklebust (1):
      NLM: Ensure that we resend all pending blocking locks after a reclaim

Ville Syrj=E4l=E4 (2):
      drm: Fill depth/bits_per_pixel for C8 format
      drm: Use C8 instead of RGB332 when determining the format from depth/=
bpp

Wei Liu (1):
      xen: close evtchn port if binding to irq fails

Ying Xue (1):
      net: fix a compile error when SOCK_REFCNT_DEBUG is enabled

fanchaoting (1):
      umount oops when remove blocklayoutdriver first

fangxiaozhi (1):
      USB: storage: properly handle the endian issues of idProduct


--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRL4PsAAoJEDjbvchgkmk+Eu4P/1VxzK/c2BWWwVf7A0at5xoU
Z5o4apiBdsBCdfCwP/XOpOBBcCCN7tt+bsyosipZeSHKA6I/kHNUfoTVkdSvYTGe
lsdn8SnO0cqg9o9rxETCr2SZmsqvmoFdPdbevmEmqod9a4GiikxYM85J2splb5Xs
cXf1JQ37V6+UQ3PTQm0x2TKM6MEjyVSycjLSLHgkF/1mINij6MdCzTYm9UOHPcb4
yMLK0Mh+97ZJ5q1F4uLTs05haBXaRRsCWoJRmpvkXptJ+0p+sixAEeNL1f79BYfX
TJ2mBwMGj+2xvTewAY3R20NVBw4M/LiF5Vfp8RojhrWM/mshgXvPJi0Gl0NP7efw
bBARjvXL2BtyepukmsGxyY0pRsJ93hpli3jrIesUYte0dpWSniuGvCAVEz62rllO
s1wY7/LKcT4AuSXqE8HE+yRIYkqG+W5LKeGVt6QJG4Qg6bPi28fxO0Q9ixhYIcEt
niJWIQr8PRibGP4ZFknLMfIU2pvHimQXFmFpIMidjpdbYYdHbSsdBKv/DdAAYgvU
eXb4I/2aR37kFvi/eo/pPajdTMt7LX8+sGRQEitkgbyNxNEHw62lr6Y5kcGvtkba
F9XVBzZV5l/ckugBKDXzV4J0zafX79OVaV7UQNI2vUrmrfO1bWRBHzFpLxH1NyzH
BiJ0GeoH4Iik8bO0b5ls
=bxOq
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
