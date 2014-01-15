Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaAOECy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:02:54 -0500
Received: from ozlabs.org ([203.10.76.45]:51165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaAOECw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:02:52 -0500
Date: Wed, 15 Jan 2014 15:02:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: manual merge of the md tree with the  tree
Message-Id: <20140115150240.a497f4e8245edbf8344b457e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Jan_2014_15_02_40_+1100_mg7JcEwZZ3sgDibP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jan_2014_15_02_40_+1100_mg7JcEwZZ3sgDibP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next merge of the md tree got a conflict in
drivers/md/raid1.c between commit 4f024f3797c4 ("block: Abstract out bvec
iterator") from the block tree and commit 41a336e01188 ("md/raid1: fix
request counting bug in new 'barrier' code") from the md tree.

I fixed it up (a line fixed in the latter was removed by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__15_Jan_2014_15_02_40_+1100_mg7JcEwZZ3sgDibP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1ghkAAoJEMDTa8Ir7ZwVi/0P/jvyCVEsFhs2hdCqpfoY2zZh
8h4OG9F2PLT5ukBd+F2rm1DVRhp/83ACzD2I/+n56EGEg++CmmsClEr+rtCdQo31
1MZsLk0rDaUFlVWOMN00sO8P0AcFdb+CZEy97feon7SXcCbL3JJxFS7nqQNRr/fi
c647hfyP/sp1Ct3z36wagnwiiu4jpji1qUG+BYjcHEQEr79PvJbjiyoB7+hQm2dc
65uHEwcrvR1kE7wFPzWPpOiPhKcvQXfTOB5/XRBT+27fAkbF7gBktw742MDEA91h
9yu701FYlqoJadE6XZJqRwDO3mW/OdOSysw9OYHaRuSlVTV83NwNo//Esm7RJv3V
IvYhNo3PXI1HI3ccbKrGcWkHG4RkTrJ4eemVwi3UuI88Bew6UYqHN0NB/4YTZU6g
RwvH+o1gfjQKkn37JLzf6lRoCDYfHjYnL52G+58s2TK0z3RvD5hsM2EviqdSaNRK
+BIgTtlY6jnCrHEkmcAipczs07i7Uiz9pE32E5CRu88/gkDDAh9teCJrxtTPEQIz
YKRZqZG6oe5xEFTj8M2b0Hm/WQUAVJt0A6jUpACKk3Roiq4jZCo2ESa5Tcx526Aa
TyCNOfEdFy/Me5KwVd4Gcl/ToVwMV3qZ0juqXuKPa9rJ3mpsnOHE2mYKf8STf+jI
HFKQpTcl1WEJMNOtAlXg
=XobU
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jan_2014_15_02_40_+1100_mg7JcEwZZ3sgDibP--
