Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3HMHKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:10:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49906 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3HMHKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:10:36 -0400
Date: Tue, 13 Aug 2013 17:10:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the ptr-ret tree with the staging tree
Message-Id: <20130813171031.d365f152275f5736803f4413@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Aug_2013_17_10_31_+1000_ohovDC=6.Ja8axCY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Aug_2013_17_10_31_+1000_ohovDC=6.Ja8axCY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the ptr-ret tree got a conflict in
drivers/staging/zcache/zcache-main.c between commit 962564604873
("staging: zcache: delete it") from the staging tree and commit
8a1d41cfeaf5 ("staging/zcache: don't use PTR_RET()") from the ptr-ret
tree.

I fixed it up (the former removes the file, so I did that) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Aug_2013_17_10_31_+1000_ohovDC=6.Ja8axCY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCdvnAAoJEECxmPOUX5FEKp4P/03S2+4fowekGDGx/k6LaYz0
S1XaWYJu5VmpjAL9quo8PhV3Pv0iM/YXBayOZZVNcSshV0im5J6/yn6wVQDsmv0F
yqJJwixyPEfedO5PCkD1BkvlsXEGWtwjb2/6UFP2B1YywgI2Gs30aO2UBP+TViqg
tIjhbUIhzPctcYn/cDC/jrisAMk4yxyi+Wyh41wjXsNiMUQxx0hUcLT4IPHzuPCX
nnSGRjJ/Vff5JbxE2ENr6KzzSOj4Xpoa5O3uCp1K+EJ9KcoZhQDkJa4GyoUHYGCo
rN3GoeK5pkwMY8AxOGCze4598ng5+qGPew979CFFWf91dKGwatLaO26TQKkceknp
zJxBZsmg+maU7yMC7ztloc05pvwOUni3jTD5z1/aBlmNbPT+WM4Kp6+/+Jvug5xv
g7wAhJypaIjorJ/ISX+3ghsc7xWfxCfjIFGei68zAZ4qRECILh3bj/VWyinHcvvH
tU6hLRA2to2Tm8Cn3WGoqcXqoiEmZhFpQwQ3LfnoAFHnnsl8zwPHOQX8QzT4yHOT
RtMI9gAdbDer3HjDHUuMv44ufUOGJmP646zXgqr2HNffQ8VVHOWY5vlVD1eGnAR+
BUYN09DfbVH6O/PjDbbB2O6PHjktWgb5n8kLeuK0SPk2MMFkNhuY/OM/gSZLN5Ge
cUW8z9AS+QNLGAQYhyVl
=cD3a
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Aug_2013_17_10_31_+1000_ohovDC=6.Ja8axCY--
