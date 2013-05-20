Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3ETU7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:59:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33945 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab3ETU7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:59:06 -0400
Date: Mon, 20 May 2013 16:59:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] (xen) stable/for-linus-3.10-rc1-tag
Message-ID: <20130520205900.GA31892@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.10-rc1-tag

which is nicely documented in the signed tag. Reproducing it here:
<tag>
Fixes:
 * Regression fix in xen privcmd fixing a memory leak.
 * Add Documentation for tmem driver.
 * Simplify and remove code in the tmem driver.
 * Cleanups.
</tag>
What is nice is that there are more deletions :-)


 Documentation/kernel-parameters.txt     | 21 ++++++++
 drivers/xen/Kconfig                     |  7 ++-
 drivers/xen/balloon.c                   |  3 +-
 drivers/xen/privcmd.c                   |  2 +-
 drivers/xen/tmem.c                      | 87 +++++++++++++++------------------
 drivers/xen/xen-selfballoon.c           | 47 +++---------------
 drivers/xen/xenbus/xenbus_dev_backend.c | 21 ++++----
 7 files changed, 82 insertions(+), 106 deletions(-)

Dan Carpenter (1):
      xen/privcmd: fix condition in privcmd_close()

Konrad Rzeszutek Wilk (9):
      xen/tmem: Cleanup. Remove the parts that say temporary.
      xen/tmem: Move all of the boot and module parameters to the top of the file.
      xen/tmem: Split out the different module/boot options.
      xen/tmem: Fix compile warning.
      xen/tmem: s/disable_// and change the logic.
      xen/tmem: Remove the boot options and fold them in the tmem.X parameters.
      xen/tmem: Remove the usage of 'noselfshrink' and use 'tmem.selfshrink' bool instead.
      xen/tmem: Remove the usage of '[no|]selfballoon' and use 'tmem.selfballooning' bool instead.
      xen/tmem: Don't use self[ballooning|shrinking] if frontswap is off.

Lisa Nguyen (3):
      xen/xenbus: Fixed indentation error in switch case
      xen/xenbus: Fixed over 80 character limit issue
      xen: Fixed assignment error in if statement


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJRmo6OAAoJEFjIrFwIi8fJTtYIAMfGea1CFrQ32dUwRt+rKFHQ
e+Z/bh5xvhA2y1KuO4Rc4JjjDSmMAR+TLb9yZkf0fzKCIIOh7VsGzm1AzBKCRtH3
sSVUviC6Q4/0UbcWsPtUbFfYb6IWuICE4wEKpA+YveSNmJDlQt+907cqcGm0JQMv
wlw+Mi0uMlQooYbiy1lwaLdyHnNCBsN52o87oWgANyndGibw8c8gwGZj0Pp3y7B9
iuLIwRemqUj1/B5mozxEl6Nka53tneFapPgNAr/xlPFLPdImCthO5K8OOnCCiqPu
xVO8s2l4rE0SUGHizYVclsItJPuVsDpTorupTYuqdOzmFScCN41GW8/pOgoD2oQ=
=dXsI
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
