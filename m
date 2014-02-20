Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaBTTa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:30:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaBTTaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:30:22 -0500
Date: Thu, 20 Feb 2014 11:31:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.31
Message-ID: <20140220193149.GA9190@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.31 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
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
 drivers/infiniband/hw/qib/qib_user_sdma.c     |    6 -
 drivers/irqchip/irq-armada-370-xp.c           |    2=20
 drivers/media/usb/dvb-usb-v2/af9035.c         |    2=20
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |    2=20
 drivers/pinctrl/core.c                        |    2=20
 drivers/pinctrl/vt8500/pinctrl-wmt.c          |   15 +++-
 fs/btrfs/inode.c                              |    2=20
 fs/buffer.c                                   |    6 +
 lib/Makefile                                  |    1=20
 mm/hugetlb.c                                  |   11 ++-
 mm/memory-failure.c                           |   22 ++++--
 mm/page-writeback.c                           |    5 -
 security/selinux/ss/services.c                |    4 +
 sound/pci/hda/patch_analog.c                  |    1=20
 sound/pci/hda/patch_realtek.c                 |    9 ++
 sound/usb/Kconfig                             |    1=20
 25 files changed, 201 insertions(+), 80 deletions(-)

Antti Palosaari (1):
      af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Catalin Marinas (1):
      arm64: Invalidate the TLB when replacing pmd entries during boot

Dave Jones (1):
      mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

Greg Kroah-Hartman (1):
      Linux 3.10.31

Harald Freudenberger (3):
      crypto: s390 - fix concurrency issue in aes-ctr mode
      crypto: s390 - fix des and des3_ede cbc concurrency issue
      crypto: s390 - fix des and des3_ede ctr concurrency issue

Jan Kara (1):
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()

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

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak in successful soft offlining

Nathan Lynch (2):
      arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE
      arm64: vdso: fix coarse clock handling

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=3Dy

Stanislaw Gruszka (1):
      pinctrl: protect pinctrl_list add

Stephen Smalley (1):
      SELinux: Fix kernel BUG on empty security contexts.

Takashi Iwai (3):
      ALSA: usb-audio: Add missing kconfig dependecy
      ALSA: hda - Fix missing VREF setup for Mac Pro 1,1
      ALSA: hda - Add missing mixer widget for AD1983

Tony Prisk (1):
      pinctrl: vt8500: Change devicetree data parsing

Vinayak Kale (1):
      arm64: add DSB after icache flush in __flush_icache_all()

Will Deacon (1):
      arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k

Xishi Qiu (1):
      mm: fix process accidentally killed by mce because of huge page migra=
tion


--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBlglAAoJEDjbvchgkmk+EQEP/1mc9X1KNhzGTRmf9KXVh2oV
gJuMo+2ot0PgXUh871MTcO6/Ynak/tCqQAplfOc1l9G1lx7i7rmYUC9ueP1zE/Q0
fsYesG2cx8bqZh6CSe8zTYOI0HOzZeKMfUmEy8iGp5QQANj5bRB1RJXLThUhp3fY
rPkwK2m+jqpLnDQVKDvUhsFZ2uKsPGmVecUA35Vx42moYsgC/joWOUIs7xPL1Vwk
isldAQVv8GUb7Vlsg9UDh1RzDqs1/mbkyZlOOm3gMgjo0eU6wqhVRal1V84LSgOj
E8YdQ/71GZCteXwyJUwdC0X7ozuBh6GdqYklaShHRUT+bvg9gYaDHbJdSktd6p2r
kIMu6YishtnbnS6uR/uVteBGRdKsjFf6jiLq2uAZmTCN4s9QwQKGnvu5lY1lz7xs
da+Vc8F3EfNPr2Cn6mGrL7KtTWZMwFZRAos2Xzf0IvpocybTdnpPdHsNB9ftqlt3
8CrZBO9L3Ie7feM+fajsUh45B0LEKJt7AIyZcN+iIs7mCCMcKeVwvOKz4EzP8oap
su6rrU074z2waWxjA9wcSerJaRO1xcOXoN6Hyj4UxhydOHhlwJ5xT4Sw4tvB0BWS
VtAmekktPHI+EA2pOSmmR6k5qz7GbVysHV7WIwsl/IhA056vbuEbLhBSe+0cE+Bu
H/gRxM+zmYUYFGksgG2w
=grFL
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
