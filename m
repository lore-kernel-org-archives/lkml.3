Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab3HUPPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:15:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17906 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3HUPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:15:05 -0400
Date: Wed, 21 Aug 2013 11:14:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.12 for Linux 3.12 merge window.
Message-ID: <20130821151453.GA22076@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
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


--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAEBAgAGBQJSFNlpAAoJEFjIrFwIi8fJei0H/29ncwbIoHrxaZYqt+80LoVc
AX0tWXzJUAJbe/4qV/G4hZWm8UVSFYdQRnmRPeMLIcNu4YrwoygOmycO65XHVu1d
48KEL1sFP8XKm/iVnm/39F1AZGbQ8s0d/p0HUxe9VyI1sc3rxXz42qTQfg8LZP2p
RtaWi6t79NgjxHgoKABbC7mRPmxO3SUwccISO0wCUr+7D/6G1cwPIh/IT9V/Vihq
TD3ici/11uvf5GtYXAnG+78eLexTNtfQeq07l3ppJTQQzVer1CNlNS2g1CdhBuxH
V2sc5vQH9IeRyg7DYksQQ9ZmJUJwsXtIPDd60RrZntvzDyxWTuliRzEpmWE6eOU=
=j6vb
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
