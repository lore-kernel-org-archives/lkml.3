Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3HTPzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:55:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3HTPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:55:45 -0400
Date: Tue, 20 Aug 2013 08:57:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.92
Message-ID: <20130820155735.GA2805@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.92 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 +-
 arch/arm/include/asm/hardware/cache-l2x0.h |    9 +++++++--
 arch/arm/mm/cache-l2x0.c                   |   21 +++++++++++++++++++++
 arch/cris/kernel/vmlinux.lds.S             |    1 +
 arch/m68k/emu/natfeat.c                    |   23 +++++++++++++++++++----
 arch/m68k/include/asm/div64.h              |    9 +++++----
 arch/powerpc/Makefile                      |    2 +-
 arch/sparc/lib/Makefile                    |    2 +-
 arch/sparc/lib/ucmpdi2.c                   |   19 +++++++++++++++++++
 drivers/usb/core/quirks.c                  |    6 ++++++
 drivers/usb/serial/mos7720.c               |   21 ++++++++++++++-------
 include/linux/hugetlb.h                    |   16 ++++++++++++++++
 kernel/futex.c                             |    3 ++-
 mm/hugetlb.c                               |   17 +++++++++++++++++
 mm/nommu.c                                 |   10 ++++++++++
 net/key/af_key.c                           |    1 +
 net/netlink/genetlink.c                    |    7 +++++++
 17 files changed, 148 insertions(+), 21 deletions(-)

Andreas Schwab (1):
      m68k: Truncate base in do_div()

Anton Blanchard (1):
      powerpc: Use -mtraceback=no

David S. Miller (1):
      sparc32: Add ucmpdi2.o to obj-y instead of lib-y.

Geert Uytterhoeven (1):
      m68k/atari: ARAnyM - Fix NatFeat module support

Greg Kroah-Hartman (1):
      Linux 3.0.92

Jesper Nilsson (1):
      CRIS: Add _sdata to vmlinux.lds.S

Johan Hovold (1):
      USB: mos7720: fix broken control requests

Johannes Berg (1):
      genetlink: fix family dump race

Linus Torvalds (1):
      vm: add no-mmu vm_iomap_memory() stub

Linus Walleij (1):
      ARM: 7080/1: l2x0: make sure I&D are not locked down on init

Nicolas Dichtel (1):
      af_key: initialize satype in key_notify_policy_flush()

Oliver Neukum (1):
      usb: add two quirky touchscreen

Sam Ravnborg (1):
      sparc32: add ucmpdi2

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSE5HvAAoJEDjbvchgkmk+SsUQAJhsqu37FMUExNcFx3J+1qqk
ACu5veHr9wft7Qhb0V615C1kUfeMwiV1vSMlgEIApJjVfB7KGFQFZwSu28P7UPkd
WAYqrquqI7LDoCwHyE14viNwfydCekZ7ToAgUBTIYyMZLRm2MaAe9JpEy6Zixrhz
YZf1kuraAXETBzIQIXyaz3Lh0rxNT6d3AFxd8KHcTsbyABcGCp2ZqvahLfgzohiR
0ry9KBtgONyu0N/n5UxkMYsJOQ1wduJUpXXoUf9bHFB0iJhqXKPuSiXmWagEp74/
K3/Vs1u9fibYgwkdNfMAoIGxBPgA3uNiY80J0olgoRFtYu8IpvptMpuuefkgONA3
BcYfVgStEqgK/qGvfSdCkJo9A/j4m91XB8+K240ZropWzByhNi5S8NE4ywUnzUFD
+dVhnB/uOcDelPvu0rl6P8zwtHzYI9oSj5gmw/5g03QHzAMXY06BHhd708n6jCZC
exWBMZk8yxTdqojcAxRLYCea44udG5DlSKMFEutNzvbillKyp9S0ooa0zJWWQezv
U9kX2OiZWqNO/wSXZLHYK2VWIFESWsgZ/ty31mKN0W5J3Xx/F2jDIu/Xavtvdmec
LGv+mWnaWOjmmV4+gkdf3qDMi9HFyZqkwhLjv4Ov7blwOc90qKeOWZQIXcbVgBoy
pMmPaOXwHDgEOmhZkI64
=BlOC
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
