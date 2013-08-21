Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3HUHVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:21:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58539 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3HUHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:21:32 -0400
Date: Wed, 21 Aug 2013 17:21:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: linux-next: manual merge of the aio tree with the aio-direct tree
Message-Id: <20130821172116.f873e18722024300b39a5ae8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_17_21_16_+1000_ibeN=Xtivde4k7pt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_17_21_16_+1000_ibeN=Xtivde4k7pt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benjamin,

Today's linux-next merge of the aio tree got a conflict in
fs/nfs/direct.c between commit 072d62aa3a83 ("nfs: simplify swap") from
the aio-direct tree and commit 73a7075e3f6e ("aio: Kill aio_rw_vect_retry
()") from the aio tree.

I fixed it up (the former also removed the line removed by the latter)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Aug_2013_17_21_16_+1000_ibeN=Xtivde4k7pt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFGp0AAoJEECxmPOUX5FEtK0P/101mRsgfLG+6nFJpGmciIEK
dsWKkqB/rIY9n31g9EWxYACc0wVoipHh5U7K/Opfr0GI50HIUdQHREAB8mdPLuxp
DnaUxlTmRInhRiNDyusGlXoR5ye4OqcgBSFdSVqx1lQSA/sLsthVHHzklgVOc5WL
bkQ7xRyVQIghuPRmryYnlajLvKcP1J7JU1NLMcnb08+fCGTWycyF2fQrpht8wD9M
PVMDegROfm3MXBynPecwp0X18t0szm7U4P6pWMGmaWoi5/MsX7bLpOKAojOHIzdH
Ra+Ql7EIzufPjBcKlgkQYw2HwWjvmGV6ayKmyvhsSNxUQNzwhnWKZ9uk0dFmFWdu
U39HcaKTcDyytBWEwBThguA6pkZ40LOE3PYZIEODVl31d5hM7BATbZcjikf/oJIF
YOlV64xx7M3RfrcWnqBW+7GlbCNfpTqThL8nOQ2denZrL/vrc1uekJBp47kgU5RD
dR7gpssyXEIIib8Qfs+5+4LBJjWRGppQG8iFPyWaH3s0UmoVEbnyy8qetrTMUd5D
IUwCQWYbQvfWVe7ANnsqJrSd8BkT4+fDyIqQQdLeEg99ZpvZF3qmIAWjRAzb9vz2
foZt/1BiCIL0x58mtiDQhW/9txgePZtPP9j6I7jhzG0Nm/2xAJy6X7e5x2aS2PuA
wgOj+7P93E1hSj9RMWXt
=CnE8
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_17_21_16_+1000_ibeN=Xtivde4k7pt--
