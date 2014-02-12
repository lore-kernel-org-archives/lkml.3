Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaBLSju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:39:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39870 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaBLSjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:39:48 -0500
Date: Wed, 12 Feb 2014 13:39:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.14-rc2-tag
Message-ID: <20140212183941.GC27449@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.14-rc2-tag

which has an healthy amount of code being removed - which we
do not use anymore (the only user of it was ia64 Xen
which had been removed already). The other bug-fixes are
to make Xen ARM be able to use the new event channel mechanism
and proper export of header files to user-space.

Please pull!


 drivers/xen/Makefile              |   1 -
 drivers/xen/events/events_base.c  |   2 +
 drivers/xen/xencomm.c             | 219 --------------------------------------
 include/uapi/xen/Kbuild           |   2 +
 include/{ => uapi}/xen/gntalloc.h |   0
 include/{ => uapi}/xen/gntdev.h   |   0
 include/xen/interface/xencomm.h   |  41 -------
 include/xen/xencomm.h             |  77 --------------
 8 files changed, 4 insertions(+), 338 deletions(-)

David Vrabel (2):
      xen/events: bind all new interdomain events to VCPU0
      xen: install xen/gntdev.h and xen/gntalloc.h

Paul Bolle (1):
      ia64/xen: Remove Xen support for ia64 even more


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJS+7/kAAoJEFjIrFwIi8fJsXwH/2pN7m5u0vMW/OzFIZo7Xi1F
X2NhJ3Dgo2f8SnZgRk8xqmKqw7+m+lHiKa++rp+V6WvLLz4GW33Pf6VLMzLb5KHK
JN3G/HSey4Z/8eXiNN9VaTAvXl6EdfwOiVcJLqp/iKwqystTfRsx+bzfTj2/stBN
XYtVLJiWvla88/CwNlCoha9n5QN0COD77VzJt/4nRFKefXhKYZi1abf58k7PNoS6
BgjxpRmfS3xq+m1tE7rvoIsALJ5LmzQKX7aJfTRcswlCzFBs8z8VUdsukW4jJRc+
KyCCZtXvZiA544CFtSPjPHEoCxWbBY2sx5inpXQAjmU+HroJ7rCpD2yuDLFk8EE=
=0KxK
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
