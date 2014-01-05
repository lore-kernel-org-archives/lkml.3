Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaAEXtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:49:46 -0500
Received: from ozlabs.org ([203.10.76.45]:47027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaAEXto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:49:44 -0500
Date: Mon, 6 Jan 2014 10:49:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
Subject: linux-next: manual merge of the imx-mxs tree with the  tree
Message-Id: <20140106104938.82a53f6d3b4d773607fe7556@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_10_49_38_+1100_Bh_Is9I1rSMDHHyd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_10_49_38_+1100_Bh_Is9I1rSMDHHyd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/boot/dts/imx6q-sabrelite.dts between commit 8f568b496dd9 ("ARM:
imx: Explicitly pass the active level of the PHY reset") from the arm-soc
tree and commit e5a5af250568 ("ARM: dts: imx: sabrelite: add Dual
Lite/Solo support") from the imx-mxs tree.

I fixed it up (just used the latter) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Mon__6_Jan_2014_10_49_38_+1100_Bh_Is9I1rSMDHHyd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSye+WAAoJEMDTa8Ir7ZwVPWQP/R/agg5MPS2aYWbJwPWUydFo
rkat2FYU7sgv7PzOFSc/OXA3oq134dxlxaV9p4CVfXgkcOMRyudOlBAihLST7c0B
mjP0DNHa3RnN5vBIsY/VWvdlhLB7hCSLNYY/fPPaqlk6/4QYANKSgcruaEAyLEt6
ywQm/iIka5B6O8M1d2+44JzLVWvdusQxQ6M5T7t/xcntpwrFavB4d4IQSndyjw/6
2imaIeQUcbZpIQZyw1N0FC9qjNcvwIuf+ZhjVVDlvfpR+als3cIbt2bMjQQRRW9F
hhH5B5s7iSwIudw4qeCsDQkNIGFCtXxa74AWAEzQYwHKpa4ePlf9MFZyqDE6UxJw
mgOSy3ZHWQfW8QOU87PMqKYH72XK/fr21Z5EcEResb6uPjgDhwKy4X7pFvlXBwhh
clh0VFD++48OfMpB1kmar+L2t8V6PoFmUO7tvt2NwaiTVShHG4mRWwZcyzKB1ig8
i5iCNyKh6Me9ydfL5GSoUpqnVGuUDTkWoB54dxltfh3pmd8cIKCohZnr4bHT1HTy
IApCCbxemz5PeR/U1yDBmiVdryz24q/nG9p8/EI3l7efRJAwhBR3e6Ht0yCs7U5P
CHsjtFHrppc/sH0PzQyOnpmPd6phjiMLmlyu852AOc2j6ZkSEVDmp9kmSmAD/7da
QMGtORsnlq1Z9NZPMcbu
=FH9m
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_10_49_38_+1100_Bh_Is9I1rSMDHHyd--
