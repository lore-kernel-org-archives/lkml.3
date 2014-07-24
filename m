Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbaGXGWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:22:46 -0400
Received: from ozlabs.org ([103.22.144.67]:55509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176AbaGXGWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:22:44 -0400
Date: Thu, 24 Jul 2014 16:22:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <mat.krawczuk@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Subject: linux-next: manual merge of the usb tree with the samsung tree
Message-ID: <20140724162232.68747558@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Td0eVk86la6HqyHEhS8i56m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Td0eVk86la6HqyHEhS8i56m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
Documentation/devicetree/bindings/phy/samsung-phy.txt between commit
949ccc3a9363 ("phy: Add support for S5PV210 to the Exynos USB 2.0 PHY
driver") from the samsung tree and commit 016e0d3cb72c ("drivers: phy:
exynos-usb2: add support for Exynos 3250") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/phy/samsung-phy.txt
index 7dce043a6e29,6099a5c94283..000000000000
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@@ -26,7 -26,7 +26,8 @@@ Samsung S5P/EXYNOS SoC series USB PH
 =20
  Required properties:
  - compatible : should be one of the listed compatibles:
 +	- "samsung,s5pv210-usb2-phy"
+ 	- "samsung,exynos3250-usb2-phy"
  	- "samsung,exynos4210-usb2-phy"
  	- "samsung,exynos4x12-usb2-phy"
  	- "samsung,exynos5250-usb2-phy"

--Sig_/Td0eVk86la6HqyHEhS8i56m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0KYuAAoJEMDTa8Ir7ZwV9GYP/i0mYEJisdOlaXgSXNicBuXq
tlVi8NNXg5/1L86qz4TUdOSGmD+oph+LwsrWiobGt01zuxUtQxltr4i8pk4fhigf
b9AysNzET4uX6R7Zzq/3PdB+4oSdLwUjSIYjqneJHemnhjWqaKeiuAPxKXzDF0rX
bZEXUo+/AtyXIGDQ/GrrAwHNrPeLx0Fez517AbSJeE7Htne2hqodPDLS9ANcVbxV
DaUUxNGn9PIq3LZ3csgqMzMJVx34rfEp2haSuJqoyblgld0isQ/xWqCiNxrtlxJH
6/rwXR9vaIsFs/zJwULhS74pKBuJxDaCwphHFHfZ6Po/kyIxjVLtvxBSkmNe29UG
PLu3DYzultncK2jCTnqhItIiqqVZ1jr5vXrXN+/3OWLYDIbtnNWPSvmZz8aocbaU
r+59ATXXjB/Ec41hNvy+HL7xaDkIdRc4MWGdAvvYJ0HS762ez3cGqJyA4g+UaihH
E9GqhrgPm2wYIjNeSLUlIUKlu7Qc1AztK7uePy45yFPaLAYZDQ2YFuvsdOUGihGN
Bc/NSuibf6HmQYcvginQznTexh7pqtXYn2H3Y4yzZ+9mDJo91zUTlTw/SWiC0skW
ek40kx7It2kmOdGrfLTyZOFUz81wzrhXD1kn6dRdS4FjlHjkauvi+ATWFUX/YZTG
p2HqwYZAR4FS7OlOeF1x
=PlcX
-----END PGP SIGNATURE-----

--Sig_/Td0eVk86la6HqyHEhS8i56m--
