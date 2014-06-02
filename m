Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaFBImr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:42:47 -0400
Received: from ozlabs.org ([103.22.144.67]:50853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaFBImp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:42:45 -0400
Date: Mon, 2 Jun 2014 18:42:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>
Subject: linux-next: manual merge of the akpm-current tree with the arm tree
Message-ID: <20140602184238.2672e610@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wwp2gfl9Z8u9IuF1u_uZmtv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wwp2gfl9Z8u9IuF1u_uZmtv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/arm/include/asm/Kbuild between commit 8a87411b649c ("ARM: 8047/1:
rwsem: use asm-generic rwsem implementation") from the arm tree and
commit bca74b3faf68 ("lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual
Kconfig") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/Kbuild
index f5a357601983,2d95820276fd..000000000000
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@@ -21,7 -21,7 +21,8 @@@ generic-y +=3D parport.
  generic-y +=3D poll.h
  generic-y +=3D preempt.h
  generic-y +=3D resource.h
 +generic-y +=3D rwsem.h
+ generic-y +=3D scatterlist.h
  generic-y +=3D sections.h
  generic-y +=3D segment.h
  generic-y +=3D sembuf.h

--Sig_/wwp2gfl9Z8u9IuF1u_uZmtv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjDkDAAoJEMDTa8Ir7ZwVGiAQAJKtnZ8zTLbAvptHE4/N+BB4
NuCgo5veqwfxPRC3ZwBIDFuuGAE+VWnlT/+Ds5sQSNTMYwUtPPSJmh6Skg8dYRzB
o4C9/i/cJsUAMwBj3igsVarH5MwV7TIcBPGbg4wo1ZD7SXGckC9jLPHxpqZckODo
+5lPAuVZSQdk508rB/+5TnRVEU4LyV2KNmkQIg9MWzgsnQ97x4AEJtGbeqgGMd+S
ocYxVNEGfq6KPe9rID3H6+FhqBeOPsyt2gJ4sWeLikqLTalpXj3z4XE/4sq5UKMZ
eUTliwEQTss8xVd1inQv96mF2oTHiJCvzQXL6TfsRKfMXUsJkA1rKJlTNeVUQruq
vaMEwBxMF/TTnstl7VgZGyiAxlVtVKAy33p5tAZgrVhsCuMZm6dWb3GEBSJyFmBJ
DvyELNrg+PlRWXTh2EDLBjv0NklvAPkPdzK0xSo6i5CbsLiUhRiItz8GegaKcDaW
92fXmp2zsv4GhpdHHQfhyhH38IcgaoPMeeiGcaseEYTBIEOBlPqHOQkrF2gC1Y9G
OU81izAGLJX/mzIMemyEUXql+PVx8kuzuGNEuBTDsP5U20nDKlbbg12nZIFm6EOf
lRlhRG7z6MAalOdw/6RCKqLeYyj+7PUtSaUf6y8cxuLcJaWQJLKOCUgSzFHoEYzN
Za/D8UngTsp9+YWTGPeC
=h4X2
-----END PGP SIGNATURE-----

--Sig_/wwp2gfl9Z8u9IuF1u_uZmtv--
