Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3DDEkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:40:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42254 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3DDEkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:40:19 -0400
Date: Thu, 4 Apr 2013 15:40:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-Id: <20130404154017.baa42c6bcef82c4cbc750646@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_15_40_17_+1100_bT_/Y+cHcCg8.lmm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_15_40_17_+1100_bT_/Y+cHcCg8.lmm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/dgrp/dgrp_specproc.c between commit 464b4fd02caa ("dgrp
procfs fixes, part 2") and various other commits from the vfs tree and
commit 433121c6ef51 ("staging: dgrp: cleanup sparse warnings") from the
staging tree.

I just used the version from the vfs tree and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_15_40_17_+1100_bT_/Y+cHcCg8.lmm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXQQxAAoJEECxmPOUX5FECeAP/A9NxEKjQlNbe3YBMF2OpsmZ
XAUKIbtHGXxbnMig81agmXGCO5xpmNbqRnZ1SYU5Q6Dn2I2ZE+ueaZP/3OOwawX2
lJm1zcJGUTLesfUF7g7G+nmZJmGj2E8pLuf/K9WLIcwW0P+neqJwEjj/3ICnf2Pg
Ak63XB5gnB6IuMR5QmvC31FdavZfwebb6e+xF2L27F6nV/WtZdNG2JP/BLcIlT9j
ILzSrUbnQCPTpNOqvXcCRkehTXr6r75LbntV/LSpnAD5tieaKTy1H9CfaL5WlkrK
LPyMoEZiqpgZaejvrn73DJ3MRTwoNMD2GTIUp2ezEwJKPNQ++igO9xWo5Pr9ERgm
8uhPq0FU+9YgUH5Cszt67S/g2KyDcGZ0Ckw9VRh9336U3zoxWPEX/Afrh30Yj8aA
Ra628c58Jtabw5IlURUHgvfySaAOpuo/fUrdEPlWRAhV/vcurntq7bur+1zF9D2e
HZoO7kvRZUgh5EzVB4i8h+HJ6+qUMj45I0BKQ+Zy2EpuhwqqeJ5Gmjq1mJHgDILV
MCY0N007lb5C7fU6/QSeKL6t3wGIGHe7kDpBw0FgQLsqszU6xu/vYY+DGxwm5xun
mC9+pQEeDJq11pIOsbAdPehF1kSbrCnkXNZLwAFrJJRSDkdmeDpxPtGrZ1UcN3T4
xm0w5wVBuPyK32BjdwmE
=5tc+
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_15_40_17_+1100_bT_/Y+cHcCg8.lmm--
