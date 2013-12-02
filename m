Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3LBOnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:43:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30448 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3LBOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:43:31 -0500
Date: Mon, 2 Dec 2013 09:43:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.13-rc2-tag
Message-ID: <20131202144322.GA22648@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.13-rc2-tag

which has three fixes. The signed tag has the details - but it is just
fixes to patches that went in this merge window along with a latent
bug.


 arch/arm/xen/p2m.c        | 5 +++--
 drivers/xen/grant-table.c | 6 ++++--
 drivers/xen/swiotlb-xen.c | 5 +++++
 3 files changed, 12 insertions(+), 4 deletions(-)

Josh Boyer (1):
      arm/xen: Export phys_to_mach to fix Xen module link errors

Matt Wilson (1):
      xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

Stefano Stabellini (2):
      swiotlb-xen: add missing xen_dma_map_page call
      xen/arm: p2m_init and p2m_lock should be static


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAEBAgAGBQJSnJyGAAoJEFjIrFwIi8fJwV0H/jih22c/FZhAwjxr2VkghNlX
KsCVwST03OGtrdCbxtJyWCa1SD8CdGY8q+U5vprVAWym0YSE3q7ySCgKbhZUjqFW
eta+9bgD8EarJGF15E2YhLbXwsWTMu2NpyoGQOr45DnaCaZWJJ+z/3A8FYGj1jYS
NgRkeM6mB/Xd2CxoSiDZX4gGSq+RB9EmXPU17IU9Tzcos2YqL2ykZGWfUG1k8Beo
Zf45XtjAZUM4R6ymgdm632NSELHk2dTVPajSVWHPsCnyeo+VElSxcPyEnNyCkHyl
lxMgWezmH6HndJZ4W+bsJu4Vux5SEd+XrI0lQ+YHOIZoX3ULdNIaz6XPlD/+Tyw=
=yZO1
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
