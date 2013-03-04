Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3CDCDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:03:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36574 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab3CDCDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:03:40 -0500
Date: Mon, 4 Mar 2013 13:03:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Subject: linux-next: manual merge of the signal tree with Linus' tree
Message-Id: <20130304130333.96ae5a2f223cca784bd1aa82@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_13_03_33_+1100_1fiub=/4t=IZu=9T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_13_03_33_+1100_1fiub=/4t=IZu=9T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
include/asm-generic/unistd.h between commit 4dd3c95940b8
("asm-generic/unistd.h: handle symbol prefixes in cond_syscall") from
Linus' tree and commit 24a2641326f1 ("consolidate cond_syscall and
SYSCALL_ALIAS declarations") from the signal tree.

I fixed it up (I used the signal tree version as I think it supersedes
the former) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Mar_2013_13_03_33_+1100_1fiub=/4t=IZu=9T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNAD1AAoJEECxmPOUX5FEQDgP/0aaioyu+F2FiFmb8ubWwoHw
9zF/Mi2ehRiZ4sBj2lPcv7F2d1oK4ekVU3XhnO9DBv0NQMmQxXJpOYxQZAnlFqIS
XmZlMAZdKnqgCePWBvSI1vtGP+UTT4u0oG4FkOL0jgto48ow6QiQz4rI/KXq0xmr
fGQtXKvpRco+SPvIS8AWafUn5H9n49msNInjU/vIohjyT6yQlN1Nck08uHQeqLbd
E9Tdpx+IsroppjGKVAD46krIye49wUyyBIoUKnw+Y+guPZ3Pg7UHPOqEW/8HZG/l
GicshegfHv1AGN7BCu1AtMsIdlw2vBLjq50ZqTexo3QJu5UuD00GJ2AXC2DTwicK
WOZTXIvCU3e5G184uyMSCM1fSUXzb9qj5ovnZSCIxCgriHbEV+Se/DlOeD72/MNg
F1ZPJvuDkCkK2xg2eFRmmjmvp/WDkZQdbbL6Rx9P5w55lSskoDktm2UZr/mwyF7c
LVRAjJELF5Hlr2QwfgphmUvXgViYIuttRLDDZNPGdthFF8oq/DwF93RoUcwOURmG
pwEP8LL4Ik0ikIgD2J+8EudPtT0szrHDpTByS6wPuQzHs1YpIfUf6vKAuGpJ4GYD
oGBofDvWAlSa6rDrOpkawzBpe0bVNedWDB25UAPa20R7xxU2h+yQyR9/9X3eCc3O
9zYDtjJGWxAlfU4iD3tq
=wlet
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_13_03_33_+1100_1fiub=/4t=IZu=9T--
