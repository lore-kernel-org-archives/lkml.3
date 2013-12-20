Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3LTP4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:56:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3LTP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:56:36 -0500
Date: Fri, 20 Dec 2013 07:56:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.75
Message-ID: <20131220155646.GA20118@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.75 kernel.

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

 Makefile                                   |    2=20
 arch/arm/kernel/process.c                  |    7 +
 arch/arm/kernel/stacktrace.c               |    2=20
 arch/arm/mach-omap2/omap_hwmod.c           |   43 +++++++++++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   13 ---
 arch/arm/mach-pxa/tosa.c                   |  102 ++++++++++++++----------=
-----
 arch/mips/mm/dma-default.c                 |   16 ++--
 arch/x86/platform/efi/efi.c                |    7 -
 crypto/algif_hash.c                        |    3=20
 crypto/algif_skcipher.c                    |    3=20
 drivers/gpu/drm/radeon/si.c                |   11 ++-
 drivers/hwmon/w83l786ng.c                  |    4 -
 drivers/input/touchscreen/usbtouchscreen.c |   22 +++++-
 drivers/md/dm-bufio.c                      |    5 +
 drivers/md/dm-delay.c                      |   23 +++---
 drivers/md/dm-table.c                      |    5 +
 drivers/rtc/rtc-at91rm9200.c               |    2=20
 drivers/staging/comedi/drivers/pcmuio.c    |   12 +--
 drivers/staging/comedi/drivers/ssv_dnp.c   |    6 -
 drivers/usb/core/hub.c                     |    5 -
 drivers/usb/dwc3/ep0.c                     |    2=20
 drivers/usb/dwc3/gadget.c                  |    5 -
 drivers/usb/gadget/composite.c             |    1=20
 drivers/usb/serial/option.c                |   27 +++++++
 drivers/watchdog/sc1200wdt.c               |    3=20
 fs/hpfs/file.c                             |    5 +
 fs/nfs/blocklayout/extents.c               |    2=20
 fs/xfs/xfs_ioctl.c                         |    3=20
 fs/xfs/xfs_ioctl32.c                       |    3=20
 include/sound/memalloc.h                   |    2=20
 kernel/futex.c                             |    2=20
 net/ipv4/udp.c                             |    3=20
 net/mac80211/rx.c                          |    3=20
 security/selinux/hooks.c                   |   93 +++++++++++++++++++++---=
--
 virt/kvm/kvm_main.c                        |    3=20
 35 files changed, 302 insertions(+), 148 deletions(-)

Alan (1):
      sc1200_wdt: Fix oops

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Alex Deucher (1):
      drm/radeon: fixup bad vram size on SI

Andy Honig (1):
      KVM: Improve create VCPU parameter (CVE-2013-4587)

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

Christian Engelmayer (1):
      Input: usbtouchscreen - separate report and transmit buffer size hand=
ling

Dan Carpenter (1):
      xfs: underflow bug in xfs_attrlist_by_handle()

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Greg Kroah-Hartman (2):
      Revert "net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_N=
OTLAST"
      Linux 3.4.75

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

H Hartley Sweeten (1):
      staging: comedi: ssv_dnp: use comedi_dio_update_state()

Helge Deller (1):
      nfs: fix do_div() warning by instead using sector_div()

Ian Abbott (1):
      staging: comedi: pcmuio: fix possible NULL deref on detach

Jim Quinlan (1):
      MIPS: DMA: For BMIPS5000 cores flush region just like non-coherent R1=
0000

Johannes Berg (1):
      mac80211: don't attempt to reorder multicast frames

Julius Werner (1):
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTAC=
HED

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
      ARM: 7913/1: fix framepointer check in unwind_frame

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Linus Torvalds (1):
      futex: fix handling of read-only-mapped hugepages

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Mikulas Patocka (4):
      dm bufio: initialize read-only module parameters
      dm delay: fix a possible deadlock due to shared workqueue
      dm table: fail dm_table_create on dm_round_up overflow
      hpfs: fix warnings when the filesystem fills up

Paul Moore (2):
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute=
()

Roger Quadros (2):
      ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module
      ARM: OMAP2+: hwmod: Fix SOFTRESET logic

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStGi+AAoJEDjbvchgkmk+OKoQAJpvDUJuZzZOalbRGOv52y9h
V98Bamqk/u8SuxDk0kG2L1iH+JWBZYD6zHGlwLg60S3iD64Ole/zQt+OXYPfIMfp
1QHRkZ4cE//rHqlm6CD8AWKDRPbysJfXejKupPPmcaGJUUk6fkggpM/Ibr4tBMUs
lAzQJExhrewkyM0RzSytrdoiDVslQC2MjMzNMAPklxx1PvJtWdfvUS74DaAbb62Y
i5Njomuqxzn3D01yayfRbYQURs6f01KoPky5+M3aIotXPlDff+ATG5pQAKHqvX0V
Z9giqcrBok5SYdT1IcOUiEyKbHPSwg5pKBfrA3AjEZal4ukCVKqGnv5PoRMB8bOC
9uGHzbwcWAYgWyZ0qO0jOsZyxHGMZLEXCETW/PYu6LTz8dM49/gWIbODEtZQHV1v
4k0R/Cw6pEDjg54Klkk11fEGBS1B3k9G273zK4lH7ypw72y+2ZvDmpl+tH2qBdAF
sAs51PhHHindC85XL8+jIiMQpzpR1MyJIIkqzUz4n/ARv0mpRRBspvlHEMfX4sK/
Z/izjzwhwWzi43bK6s27NNVJV10TZNOacFx26BkVrRxW631qwax7rUVVQ3dVohJe
PdGSK6g4hgxwfG0EOjWfaN7gWOPMhIZlb6FsU1jRLmKYhiKLbiqsx/p/687jxLNJ
MIj47c+/Yxwczzp7p/z9
=VAch
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
