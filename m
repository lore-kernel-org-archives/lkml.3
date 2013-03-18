Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab3CREE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:04:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43297 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3CREEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:04:23 -0400
Date: Mon, 18 Mar 2013 15:04:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the bcm2835 tree with the arm-soc tree
Message-Id: <20130318150415.7a9db62e8cfe03623a411ae9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_15_04_15_+1100_he8JCDkuvR+tr5hW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_15_04_15_+1100_he8JCDkuvR+tr5hW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Today's linux-next merge of the bcm2835 tree got a conflict in
arch/arm/Kconfig between commit 15bc1fe67f66 ("ARM: cns3xxx: enable
multiplatform support") from the arm-soc tree and commit f1ac922dec7e
("ARM: bcm2835: convert to multi-platform") from the bcm2835 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index c63daef,0d3daa6..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -362,26 -362,17 +362,6 @@@ config ARCH_AT9
  	  This enables support for systems based on Atmel
  	  AT91RM9200 and AT91SAM9* processors.
 =20
- config ARCH_BCM2835
- 	bool "Broadcom BCM2835 family"
- 	select ARCH_REQUIRE_GPIOLIB
- 	select ARM_AMBA
- 	select ARM_ERRATA_411920
- 	select ARM_TIMER_SP804
- 	select CLKDEV_LOOKUP
- 	select CLKSRC_OF
- 	select COMMON_CLK
- 	select CPU_V6
- 	select GENERIC_CLOCKEVENTS
- 	select MULTI_IRQ_HANDLER
- 	select PINCTRL
- 	select PINCTRL_BCM2835
- 	select SPARSE_IRQ
- 	select USE_OF
- 	help
- 	  This enables support for the Broadcom BCM2835 SoC. This SoC is
- 	  use in the Raspberry Pi, and Roku 2 devices.
-=20
 -config ARCH_CNS3XXX
 -	bool "Cavium Networks CNS3XXX family"
 -	select ARM_GIC
 -	select CPU_V6K
 -	select GENERIC_CLOCKEVENTS
 -	select MIGHT_HAVE_CACHE_L2X0
 -	select MIGHT_HAVE_PCI
 -	select PCI_DOMAINS if PCI
 -	help
 -	  Support for Cavium Networks CNS3XXX platform.
 -
  config ARCH_CLPS711X
  	bool "Cirrus Logic CLPS711x/EP721x/EP731x-based"
  	select ARCH_REQUIRE_GPIOLIB

--Signature=_Mon__18_Mar_2013_15_04_15_+1100_he8JCDkuvR+tr5hW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRpI/AAoJEECxmPOUX5FEe3MP/3hkv5sCAbZS/SBmys078VPD
2Vz/I10qSRCzJnC4VHK6ksTXiN8azXHP6ZT9nKYwd8YBEGBJZhOltL7bu8cp5dRv
DpvLaaEy0qmSQM4kYGU+hHdjzI40pNLN4NT8udvfhHxYP7LthiMdkpduucdSaBe1
2VJqJxeLGKl1JrMpekSNNpcc69XGNiVBclfIkqjIo39kgmpQ35fgM2dfcca3h5vz
Y/ajnadBMTVTYc/Uiw6pVyjaRkstSF1Q/sC04A+lSflNCk7ZzBwrs3n2tqgVsc3i
/T6oHk83BlhPS01e8ZnHlGzt3ylcN33zPOaYkZ02Dcxv86F4yFwQiZpK6Nmcb7XU
/koLJVDNy+RH8PTZGdlEeJM7PzgiCABgxMvKDQUdKQMCygmZ+Ara0T6z+lb+5JZB
XdARnnetzXe+kjXV3N8yOp9rrSG2xftO6MsVE397C9v0+z+F0bKX0DHsDZCIxW3Z
CBVzZR9FcXYV2TrWl+SdpQCuBJ43rizsilmCcIXxqydNquq4PsxQQMk6M3HfA3Ds
L/xntIW3Y8EUFZm863N3rC9JfqV0jo7tSXpyFnsO9hQdkTWu1Q/g81M3V5SccVIt
YcpDQBsT9+aokg0pqurqOCycllGKGWroMQDwSRacfXSdHqEsks6qf9YcBQzXrCPs
V3V6fFNC05aCty8OSdw4
=qoyx
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_15_04_15_+1100_he8JCDkuvR+tr5hW--
