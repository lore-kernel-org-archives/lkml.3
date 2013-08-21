Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3HUPDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:03:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19630 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3HUPDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:03:18 -0400
Date: Wed, 21 Aug 2013 11:03:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dx, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.12 for Linux 3.12 merge window.
Message-ID: <20130821150311.GB21743@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hey Jens,

Please git pull the following branch for your 3.12 tree:

 git pull  git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable=
/for-jens-3.12

It has two fixes to the xen-blkfront driver - both deal with the indirect
requests and make better usage of the persistent grants.

Please pull

=20
drivers/block/xen-blkfront.c | 44 ++++++++++++++++++++++++++++++++++++-----=
---
 1 file changed, 36 insertions(+), 8 deletions(-)

Roger Pau Monne (2):
      xen-blkfront: revoke foreign access for grants not mapped by the back=
end
      xen-blkfront: improve aproximation of required grants per request


--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAEBAgAGBQJSFNarAAoJEFjIrFwIi8fJT3AIANG8QLMT1qnE86TuKHi4WbW/
ibMHfM6IYcGO/ydx0LJG+kWSc01yQ7kHhAYxxe5BsX/Fzf5rvOZO5JQrWU01GZ5Z
G4iswfp97/rgG1Ej+niOu1pfXJbW2LPeZ9YHRhlUbxKbcfgqQAk9kM0A6RschXY6
jOHjKftYqTL4YlGUKxKJsn89gZRi4JNa+F4gchWHnKC61mE308wZv3POXQZpLVjg
wmzbvvQQfJSENahKPul/f6HL6rDweFt0YtT51TjS/D0UK8xa7hpQPly9N4270KaS
o9DzpXx68+3t8AuUN0TcOpu7/C5JvhVvSd6XmPyyNjiERB9g1dLCf/JNARCMzSg=
=zBHF
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
