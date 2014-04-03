Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaDCWoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:44:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaDCWol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:44:41 -0400
Date: Thu, 3 Apr 2014 15:47:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.36
Message-ID: <20140403224704.GA13908@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.36 kernel.

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

 Makefile                                |    2=20
 arch/x86/include/asm/topology.h         |    3 -
 drivers/block/aoe/aoecmd.c              |    2=20
 drivers/input/mouse/cypress_ps2.c       |    1=20
 drivers/input/mouse/synaptics.c         |   55 ++++++++++++++++++++++++
 drivers/input/mousedev.c                |   73 ++++++++++++++++++---------=
-----
 drivers/net/ethernet/marvell/mvneta.c   |    4 -
 drivers/vfio/vfio_iommu_type1.c         |    4 -
 fs/ext4/inode.c                         |   15 +++---
 fs/proc/page.c                          |    2=20
 include/linux/bitops.h                  |   15 ++++++
 include/linux/huge_mm.h                 |   18 -------
 include/linux/mm.h                      |   14 +++++-
 mm/ksm.c                                |    2=20
 mm/memory-failure.c                     |    2=20
 mm/page_alloc.c                         |    4 +
 mm/swap.c                               |    4 -
 net/netfilter/nf_conntrack_proto_dccp.c |    6 +-
 virt/kvm/kvm_main.c                     |    4 -
 19 files changed, 154 insertions(+), 76 deletions(-)

Artem Fetishev (1):
      x86: fix boot on uniprocessor systems

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk

Daniel Borkmann (1):
      netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

David Rientjes (1):
      mm: close PageTail race

Dmitry Torokhov (1):
      Input: mousedev - fix race when creating mixed device

Greg Kroah-Hartman (1):
      Linux 3.10.36

Hans de Goede (2):
      Input: synaptics - add manual min/max quirk for ThinkPad X240
      Input: cypress_ps2 - don't report as a button pads

Theodore Ts'o (1):
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Thomas Petazzoni (1):
      net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPeToAAoJEDjbvchgkmk+pBoQAJFDtubBjarSuvw99OyiJJ1j
of5FRrRaixmiWiuL1SPzt1n8l+A+pra3qcY9sNJVfj7Vm54musZGQyt2WsWcgaT2
YihUKf5ByLOAIA+3o4Tr6UdQFTdEjtJw+Ijm+u14grb4aSWihOl4cST7Gk4N099u
x4aJYiV9ycbC3Cdlqjb/+6ZGdLSdC3QFZYdMxF6GfjkLpUTfKCVRUaxWMFWtIGzb
JfDTwpGeiBhO+BiF2z7MRsXMcxKpR2l0fudU0ON75/5l9bWXTb5V+JGkqxAltM+h
qVtzWtsDbIYSL9MOrEgNCzFi5BxJWOsTHQfIoHY7spYGj1nnpEUJ6D2jzdWzlacb
hDBcl2nhKW0okCYfhfNB3BxO0925ZPd0vZ0aMXNGIgIglz5/fu7JYIb3ok/5+USE
1vgec/FUgWOUwpxqNfOtdBD1bmsu4dwjYHmkr3Fw02Gup/xtaTuxUW0G82wCTRYY
CsBoGcB8wfgt2XaB9CqFfMXtfgIY0YtjiZPMX2+Mg5GHD1t/vToQE9MPrtjPNnKO
g/xY1lPWfxVY8jRQJ2KYyU8O8QbetXE1ZlY8mCJCmZl2a2GlvbDH9Zz7gZ+P2cUe
VBiRbypMjKGDqvni//dI6gi+tjn3xW9NKfANBMw7sfdhfcdreiLaYVZa9NUWVDcq
u2MbEJI1gTktW5ei54rF
=o7uh
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
