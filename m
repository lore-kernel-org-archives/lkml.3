Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbaEMMR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:17:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395AbaEMMRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:17:24 -0400
Date: Tue, 13 May 2014 14:17:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.90
Message-ID: <20140513121723.GA26657@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.90 kernel.

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

 Makefile                                    |    2=20
 arch/mips/power/hibernate.S                 |    1=20
 arch/x86/crypto/ghash-clmulni-intel_asm.S   |   28 --
 arch/x86/crypto/ghash-clmulni-intel_glue.c  |   14 +
 drivers/ata/libata-core.c                   |   21 +-
 drivers/block/floppy.c                      |   11 -
 drivers/gpio/gpio-mxs.c                     |    3=20
 drivers/gpu/drm/i915/intel_crt.c            |    8=20
 drivers/md/dm-thin.c                        |    2=20
 drivers/mtd/nand/nuc900_nand.c              |    2=20
 drivers/mtd/sm_ftl.c                        |   11 -
 drivers/net/wireless/b43/phy_n.c            |   14 -
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |   15 +
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c |   27 ++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |    1=20
 drivers/tty/hvc/hvc_console.c               |    2=20
 drivers/video/aty/mach64_accel.c            |    3=20
 drivers/video/aty/mach64_cursor.c           |   22 +-
 drivers/video/cfbcopyarea.c                 |  153 ++++++++--------
 drivers/video/matrox/matroxfb_accel.c       |   38 ++--
 drivers/video/matrox/matroxfb_base.h        |    2=20
 drivers/video/tgafb.c                       |  264 +++++------------------=
-----
 drivers/virtio/virtio_balloon.c             |    6=20
 fs/locks.c                                  |    7=20
 include/linux/libata.h                      |    1=20
 25 files changed, 279 insertions(+), 379 deletions(-)

Ard Biesheuvel (1):
      crypto: ghash-clmulni-intel - use C implementation for setkey()

Dan Carpenter (2):
      mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()
      mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

Giacomo Comes (1):
      Skip intel_crt_init for Dell XPS 8700

Greg Kroah-Hartman (1):
      Linux 3.4.90

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Jeff Layton (1):
      locks: allow __break_lease to sleep even when break_time is 0

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix too long disable of IRQs

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

Matthew Daley (2):
      floppy: ignore kernel-only members in FDRAWCMD ioctl input
      floppy: don't write kernel-only members to FDRAWCMD ioctl output

Mike Snitzer (1):
      dm thin: fix dangling bio in process_deferred_bios error path

Mikulas Patocka (5):
      framebuffer: fix cfb_copyarea
      matroxfb: restore the registers M_ACCESS and M_PITCH
      mach64: use unaligned access
      mach64: fix cursor when character width is not a multiple of 8 pixels
      tgafb: fix data copying

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: Fix machine check error due to improper access of B43_MMIO_PSM_P=
HY_HDR

Rusty Russell (1):
      virtio_balloon: don't softlockup on huge balloon changes.

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Tyler Stachecki (1):
      mpt2sas: Don't disable device twice at suspend.


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcg1TAAoJEDjbvchgkmk+IggP/37NVR5uDs/Uy3K6OTju0zkS
BPTMHlhw5Jw5gZZyAsxv0cKDr4J1fH62Nvd7eiqp8M1koqR0s9/Ax8LbRRWdg5yD
1CmNIxhc3LIk8ghF62Us1gPMO7hNzpI/q8HXYYRFVsoi1n3ezBje205xVky65Z/8
mHYGOar1z3581I825SM7qSjIsBT9DZdq++atylcb1i5Pw41xPSnEQ+0aqjmq8fDk
BJJ6zV/07X3dQCQjhF0cq9BYpn8/92s1w8GM6Z1RdjNQ/VXaTkbxuK9E9OKC0ShV
lrb2EbARyoLUPQiqj0UjXjuZy2DlgCWaOXNxYJlN8bSt+iXxdXZ4ajVVCnS2eOPf
KIR1AFVjg+tLwu1IAq4peGLecqQll9pfdfcGn9Z2luOqChGSg9S4yavqVpGvuNLq
haVQABrayItyPVi4XdjNZVvrapI4thJWZ/CqgXKfUf+jtSYGo9xo0C4dF9JqEQsc
vdqk6oE9OUabiuj42GE7IY65EbPnqTjdarR2J44kKP856JA6yWNgt+XaYW4Wpro7
L6He2Vv328PG7sZ0cp+zytCZddZACI0m6o6v1nuhfkocD7o99BeSEtTngu0Xf4n4
OCdjX828RNPypdw8Zr6e0e0fmSW2rJdUZdyinHzJ+nO7R6NiPyVLxAhhcGnj5drF
nVqZZj7hQv4i5jwNJhN0
=yNqa
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
