Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbaEFDwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:52:53 -0400
Received: from ozlabs.org ([103.22.144.67]:38013 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933767AbaEFDwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:52:51 -0400
Date: Tue, 6 May 2014 13:52:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlos Garcia <carlos@cgarcia.org>, Lokesh Vutla <lokeshvutla@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: linux-next: manual merge of the trivial tree with Linus'  tree
Message-Id: <20140506135245.1e11ac1f55aca61df58105d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_May_2014_13_52_45_+1000_Gty1//SSfIRkEWeP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2014_13_52_45_+1000_Gty1//SSfIRkEWeP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
Documentation/devicetree/bindings/arm/omap/omap.txt between commit
11e2191c2a6f ("ARM: dts: am437x-gp-evm: Add gp dts") from the  tree and
commit c98be0c96db0 ("doc: spelling error changes") from the trivial tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/arm/omap/omap.txt
index 36ede19a1630,aa71962352ff..000000000000
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@@ -117,8 -114,5 +117,8 @@@ Boards
  - AM43x EPOS EVM
    compatible =3D "ti,am43x-epos-evm", "ti,am4372", "ti,am43"
 =20
 +- AM437x GP EVM
 +  compatible =3D "ti,am437x-gp-evm", "ti,am4372", "ti,am43"
 +
- - DRA7 EVM:  Software Developement Board for DRA7XX
+ - DRA7 EVM:  Software Development Board for DRA7XX
    compatible =3D "ti,dra7-evm", "ti,dra7"

--Signature=_Tue__6_May_2014_13_52_45_+1000_Gty1//SSfIRkEWeP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTaFyRAAoJEMDTa8Ir7ZwV/iMP/1IgLGwliBGu1zTQAFAtxNt8
CRbrXXnMSyebne/S5kVz47OoQiwjBKunptxGJiAIRordQMl38tZ/LtCR33LAkIoD
kNR6qQNaoLUePsab7TFOgp7BzHrQdusxqYXxUI6SKKjYYKH6vrN6GnWIM0F0m6qh
BZwUsQdd8/r10Eq4AMJL4Pots+aMmDV0b7DVaEBcDvf1/6dsbWPWz2laazP45Pdu
qAKwlCpNDS+9OlkPMizdkweqXsSmj3XgfkxFHuwmNYbdcwPBPuiuTHQiXraa995y
5PMcyxv1mFyFhbd+ahpYKu9DCEb3wWYRi3kZIEqanFqFHDLG4XfqpPnYxk1CrDKu
MGCHOsm6mTZDFe1oaGSJHgYPIFsQYmDH0UkGsUERYlwDQ2PUWjKc467VhLs4tiWN
Fx0vNTqqvUoKmJ6/gxfIcCtsBFjxmamRiWbJOvVJsY9k3pmKWj59+c2el1SnH4Wz
fSP9S4BGD2OSNsmaKpOaRWgCNSqM+P93oZUe1PcNBF4B83ZmEcEJ1kFDdElwwx/R
fNPGsyKqJJ3S0ZNizU3i0U35N5dOxLLXyGP6DikkmKYnwqcZhGSum5osNr3CRX/V
N6pPewlT9OPhNXqs+hTesxU3AilNPz+3MLq+XS3O02myT6pdBBaK4j1Lf94mn6om
BAwFcp+kXicW/PqK3Q3+
=yN0A
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2014_13_52_45_+1000_Gty1//SSfIRkEWeP--
