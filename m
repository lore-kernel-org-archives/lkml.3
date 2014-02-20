Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaBTTaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:30:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaBTTax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:30:53 -0500
Date: Thu, 20 Feb 2014 11:32:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.12
Message-ID: <20140220193220.GA9252@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.12 kernel.

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

 Makefile                                      |    2=20
 arch/arm64/include/asm/cacheflush.h           |    1=20
 arch/arm64/kernel/vdso.c                      |    4 -
 arch/arm64/kernel/vdso/Makefile               |    2=20
 arch/arm64/kernel/vdso/gettimeofday.S         |    7 +
 arch/arm64/mm/mmu.c                           |   12 ++-
 arch/s390/crypto/aes_s390.c                   |   65 ++++++++++++-----
 arch/s390/crypto/des_s390.c                   |   95 ++++++++++++++++-----=
-----
 arch/x86/kernel/cpu/intel.c                   |    2=20
 drivers/irqchip/irq-armada-370-xp.c           |    2=20
 drivers/media/usb/dvb-usb-v2/af9035.c         |    2=20
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |    2=20
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |    2=20
 drivers/media/v4l2-core/videobuf-dma-contig.c |   12 +--
 drivers/media/v4l2-core/videobuf-dma-sg.c     |   10 +-
 drivers/media/v4l2-core/videobuf-vmalloc.c    |   10 +-
 drivers/pinctrl/core.c                        |    2=20
 drivers/pinctrl/pinctrl-at91.c                |   10 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c          |   15 +++-
 fs/btrfs/inode.c                              |    2=20
 fs/buffer.c                                   |    6 +
 fs/nfs/nfs4client.c                           |    2=20
 fs/nfs/nfs4proc.c                             |    8 +-
 fs/nfs/nfs4session.c                          |   25 +++++-
 fs/nfs/nfs4session.h                          |    2=20
 include/linux/nfs_xdr.h                       |    2=20
 kernel/irq/Kconfig                            |    1=20
 lib/Makefile                                  |    1=20
 mm/page-writeback.c                           |    5 -
 mm/swapfile.c                                 |   11 ++-
 security/selinux/ss/services.c                |    4 +
 sound/pci/hda/patch_analog.c                  |   27 +++++++
 sound/pci/hda/patch_realtek.c                 |    9 ++
 sound/usb/Kconfig                             |    1=20
 34 files changed, 257 insertions(+), 106 deletions(-)

Antti Palosaari (1):
      af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Catalin Marinas (1):
      arm64: Invalidate the TLB when replacing pmd entries during boot

Dave Jones (2):
      mxl111sf: Fix unintentional garbage stack read
      mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

Greg Kroah-Hartman (1):
      Linux 3.12.12

Hans Verkuil (1):
      Revert "[media] videobuf_vm_{open,close} race fixes"

Harald Freudenberger (3):
      crypto: s390 - fix concurrency issue in aes-ctr mode
      crypto: s390 - fix des and des3_ede cbc concurrency issue
      crypto: s390 - fix des and des3_ede ctr concurrency issue

Josef Bacik (1):
      Btrfs: disable snapshot aware defrag for now

KOSAKI Motohiro (2):
      mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of =
spin_lock_irq()
      mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

Lior Amsalem (1):
      irqchip: armada-370-xp: fix IPI race condition

Mel Gorman (1):
      x86: mm: change tlb_flushall_shift for IvyBridge

Nathan Lynch (2):
      arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE
      arm64: vdso: fix coarse clock handling

Nicolas Ferre (1):
      pinctrl: at91: use locked variant of irq_set_handler

Nitin A Kamble (1):
      genirq: Generic irq chip requires IRQ_DOMAIN

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=3Dy

Stanislaw Gruszka (1):
      pinctrl: protect pinctrl_list add

Stephen Smalley (1):
      SELinux: Fix kernel BUG on empty security contexts.

Takashi Iwai (5):
      ALSA: usb-audio: Add missing kconfig dependecy
      ALSA: hda - Fix missing VREF setup for Mac Pro 1,1
      ALSA: hda - Fix silent output on Toshiba Satellite L40
      ALSA: hda - Add missing mixer widget for AD1983
      ALSA: hda - Improve loopback path lookups for AD1983

Tony Prisk (1):
      pinctrl: vt8500: Change devicetree data parsing

Trond Myklebust (2):
      NFSv4.1: nfs4_destroy_session must call rpc_destroy_waitqueue
      NFSv4: Fix memory corruption in nfs4_proc_open_confirm

Vinayak Kale (1):
      arm64: add DSB after icache flush in __flush_icache_all()

Weijie Yang (1):
      mm/swap: fix race on swap_info reuse between swapoff and swapon

Will Deacon (1):
      arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBlhEAAoJEDjbvchgkmk+UNoQAM4Z2jcA552EePH0dobSFTPo
oslsFIUCXDK+dek4KO3r1a3jlE4ox49G2BykNnCECN1lQq0uJgxOQ3h8DfPBAHgA
MOX+Q10mey9VzlzbpOwih1mvLbn+1HVuyEld7cmbg3tDtWhzDerf1LDoWTFSOPVu
0OOJP/mrmVMVY1GIsjfTPrp5iIJQRorJwhv2vz2NWIjmcLgJFNswxoK9FO1j1Jxa
wFPkntbdMm0Pn5sNNZQZCSPCXtyzI7uWZG2RuX+CYkwV41DyzgfcOEYIMxB9gZWX
COHNGYOw4DXDRrIt0xXTYzcUOlazFhsmbdRLe3pixWLSxXsZhzoN36pAuqhbGLyB
s0M4qPr3JC2mnupjyi0wj/l7RT+gF24oNd2cS4Qk9u4F4q/SpAYRBEaQw19uPHro
993yZ0j8gyQOGCzTpc4uPTNPlARqwstWs815A6rNONJebdrFL2HOdxtkY8LkcE/I
l33S1PT0UddEwGOOcGJB9tfO1Lt1OWYMgkdTIAtIVq7xMIiq1NQti40U92A61Upr
kBUSB77IOU6U0D0mBTL06/xCXQCIw8y8p1hH+EMfQ37IBvHrT0jqSz/mbv0fIkJG
JdysoWhZNptkT6E/ORF+i3KvSaf8nctn6wAmhc4c7Sl4hNvS4873kvJpYcf2oBX2
EDR7HVK4MmmOSnpQPgm+
=6mg4
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
