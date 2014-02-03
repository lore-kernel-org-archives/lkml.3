Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaBCVmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:42:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31987 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCVme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:42:34 -0500
Date: Mon, 3 Feb 2014 16:41:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/for-3.14-rc1-tag
Message-ID: <20140203214123.GA13515@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.14-rc1-tag

which has a revert of a fix that caused build regression on ARM (with Xen enabled),
and a tiny litte fix for Xen PVH where we did not set the CR4 flags properly.

Please pull!


 arch/x86/include/asm/xen/page.h     |  5 +--
 arch/x86/xen/enlighten.c            | 12 +++++
 arch/x86/xen/p2m.c                  | 17 ++++++-
 drivers/block/xen-blkback/blkback.c | 15 ++++---
 drivers/xen/gntdev.c                | 13 +++---
 drivers/xen/grant-table.c           | 89 ++++++-------------------------------
 include/xen/grant_table.h           |  8 +---
 7 files changed, 58 insertions(+), 101 deletions(-)


Konrad Rzeszutek Wilk (1):
      Revert "xen/grant-table: Avoid m2p_override during mapping"

Mukesh Rathor (1):
      xen/pvh: set CR4 flags for APs


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJS8Az/AAoJEFjIrFwIi8fJgDwIAJvMEm+1YCWyh0EN4u0/5Pag
+EMilLuvZN76WHL0zFdPNW+sEP3fF+MB+cYz9s4E0FS63eJ5UUXGhUJ45DRgm7yc
zn2wDl8FVkrB3XZvYrL22OU2gDE+ikndcInzUmOgNcvC6jkvtMpXnTGhLRnl9SRC
XsCWP6IN234izbNMmJRytgZzAYlNyZKwrYAgWo96qYJ2ARwu2NnS+X+NuZ+3fJCX
pRuaQ9CQz39+TqI183q00KyNwjoey5xFIwVmf10IudlpwwkkQPPoFBx9LrlxeXcp
YMZgh/M6LLbDrHMc7Ucl+CoPDFEKVjXjak9IL6HAngixBtQTyxtiqQY+ilRv9GU=
=XUnV
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
