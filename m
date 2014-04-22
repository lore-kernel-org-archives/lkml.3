Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaDVBRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:17:23 -0400
Received: from pide.tip.net.au ([101.0.96.218]:35521 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaDVBRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:17:20 -0400
Date: Tue, 22 Apr 2014 11:17:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20140422111707.4e26e062d4e8f8fc1fea27b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_11_17_07_+1000_sTh+EewZvKBq81/1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_11_17_07_+1000_sTh+EewZvKBq81/1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in mm/filemap.c
between commit b59b8cbca629 ("mm: fix new kernel-doc warning in
filemap.c") from Linus' tree and commit cbabd10029a4 ("write_iter
variants of {__,}generic_file_aio_write()") from the vfs tree.

I fixed it up (I used the vfs tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_11_17_07_+1000_sTh+EewZvKBq81/1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVcMdAAoJEMDTa8Ir7ZwVGREP/1Sygv8fnizI1hJboWj0z8Qq
zwLzPLF9BNh/jY8MBdIj4y+RcZCNXDKxsbVBLOwcioIV12XbsdyFXV28C3Y5XI/3
tat1+99vHnUD0pVSCg6V37acncbgSyEjpmutMTHpeVJSyZemOQLdpJ1q1K8s8XOE
VNqvpmXk7p/8T6KR9nMMMCW+zYHzHYD7kP8vaFqDggkX7t3X45v9uCZL+oq+kiQC
pl1oq2Xcpq8e1JulroqYfdBceNVInnqbfyQFY5VKWn4Z8+7ekx9KUkC5yy1s4iIU
1GPrMycXJpYxiKCpvyVx4wgqGzi/tj4Mm+Y3w/cPe681jQTeUwvcl2GfPvveryza
0OUxPhFSxXJ33HQ1CPh8IyjnLr4Ai3Xo1KExUiqSgbQ2lk4h7asunneU9YUH9SNs
BMeNW36PAZ2FABkNLCuXJ8uiI34B8LiB0WsxE+GaXUPrT7ZLwDq2mk+6ptq4UiDd
7RCmB4aQlzb7BIntkFdNU1WOKTYhVc6s8/GF/zs+leRyyBia7gS8CS5AL6WHf8Bz
o3X/v9X6x2QcmauFSHs1mSYJnIyFMipePq1XpvWkBFLGYEOfrn0ytRBBqjIKn800
OkYjgtoEJek7Y+c3D0s06CX+Hg3Imu3x0Wt49Dh7ex1meTu/r5zoS6q+htF7tgf0
Gg8C8jXItMJ6H0J63Yfb
=Q5io
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_11_17_07_+1000_sTh+EewZvKBq81/1--
