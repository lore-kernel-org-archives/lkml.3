Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaEVHK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:10:27 -0400
Received: from ozlabs.org ([103.22.144.67]:47103 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaEVHKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:10:25 -0400
Date: Thu, 22 May 2014 17:10:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: linux-next: manual merge of the dt-rh tree with the arm-soc tree
Message-ID: <20140522171014.57e04e48@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/E7MJHh8j9U1KhZHg94oFNxD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E7MJHh8j9U1KhZHg94oFNxD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rob,

Today's linux-next merge of the dt-rh tree got a conflict in
arch/arm/mach-vexpress/platsmp.c between commit d2606f81d563 ("ARM:
vexpress: Simplify SMP operations for DT-powered system") from the
arm-soc tree and commit 9d0c4dfedd96 ("of/fdt: update
of_get_flat_dt_prop in prep for libfdt") from the dt-rh tree.

I fixed it up (the former removed the code modified by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/E7MJHh8j9U1KhZHg94oFNxD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfaLcAAoJEMDTa8Ir7ZwVJ+UP/0+hh2cmKKNOmVpaBSdKCgTg
XIJJ/taFO72YLeQ6CFd0KGKld1vbKEKo8+DHTL09UYc6D2hjuwWR5ekC4aYdK4JS
gYt53GAq81QDks2ilyaGv/NpDZulbVjQMk42nhQRBPsx0m/9zn5Lf8GPr4MMPhz4
nsJa+4BY71xqbupl5GyMG+eoSp1zGnmIz1zxvdNmFnfqWdBiOiN/JB8MiT6c4lci
MyC4sMhQNPZD/4rgegyfUchBHaq8qOzi84S5/fRBnEvLClhZVfxP6M3Iig029gzQ
lqjnJhxYJmO4tpPTm4AweLZ6jV5y1NBDbz9wloYJQHbQ5iQ9LyvZr5Uhu8BXFXEN
A3DrSJW/7ZkKw9TnUYiv47KNHLydNQOBzij0kdnmyjDzpSypkukcxw+yR/8zXLat
fz5VffYlqHSRSK7zH2PfoAcDkT0rWe+jTdxmGCixGZLgsjB1bc07nbNFqcgSA7pb
U55j2pxEWTwPm0XLpEPjm2sESI4pqBSwAfy3X8UhV/wZ9Ej+qkciqB0KQoY3hKjD
MyKLKBKLUeJjB0ustmFSCYfU+7XxjK7FrCMZKPQNlmrTdeNVp+QsxFxifenmFzNO
2BxE1P+tOUHzu6JQrPiiaVZYQL4OLpCWIEKvht8mD1U9j++qajRZIBtUDPnwru74
Z/bDLkgOMeM1glkKDwI/
=CfsB
-----END PGP SIGNATURE-----

--Sig_/E7MJHh8j9U1KhZHg94oFNxD--
