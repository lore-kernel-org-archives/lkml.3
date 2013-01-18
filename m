Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3ARDVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:21:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48443 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab3ARDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:21:41 -0500
Date: Fri, 18 Jan 2013 14:21:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130118142131.831834d9f26d917e3409e69e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Jan_2013_14_21_31_+1100_eDCZNp/dUReVtFhN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jan_2013_14_21_31_+1100_eDCZNp/dUReVtFhN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/common/Makefile between commit 81243e444c6e ("irqchip: Move ARM
GIC to drivers/irqchip") from the arm-soc tree and commit cbafeaaa418e
("ARM: Add interface for registering and calling firmware-specific
operations") from the samsung tree.

I fixed it up (as supplied - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/common/Makefile
index dc8dd0d,55d4182..0000000
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@@ -2,6 -2,10 +2,8 @@@
  # Makefile for the linux kernel.
  #
 =20
+ obj-y +=3D firmware.o
+=20
 -obj-$(CONFIG_ARM_GIC)		+=3D gic.o
 -obj-$(CONFIG_ARM_VIC)		+=3D vic.o
  obj-$(CONFIG_ICST)		+=3D icst.o
  obj-$(CONFIG_SA1111)		+=3D sa1111.o
  obj-$(CONFIG_PCI_HOST_VIA82C505) +=3D via82c505.o

--Signature=_Fri__18_Jan_2013_14_21_31_+1100_eDCZNp/dUReVtFhN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ+L+7AAoJEECxmPOUX5FE5O0P/0+PixjF4mMzMAm+RWF0iUol
Urry0306n+cqQtIE+PTDN91LGSbQ/zw8Swyuv4YzepoFZANs54lASql9fs9MSYBF
Y2Q7r0vJbx2ohSIxT0JpXaZ2bYBfBGZ41DNzYaDH5Bc9GklhqFotHVQdmeIarJ3B
koI3c/n7RfozOP0fOX2fV3PrGqdITosS76bheoaHfyFWW9WAKBIfWY+jgfZF8Acl
gGV1eBTJZV6Qj1M/NRp9ELtO8z/HHPHQxJDMkJvtWLNs00G7mgxEtypMxLR2sqR5
3VDGbWXk48EWSy0SvKJsi0b/tzvxgDO5jiSSIwI4AxwqHInG8HhDSutGP6Hd1JYX
zgEM2SF2amaUJFMOzbW0o3WeZOl+h6Pc/63pWVuC+fCb99sa2+CeZRlxzrpAhK/p
/NOLsCT+xKlzX4cHng8l9bmunHLhhXqh2VIY0JougbwBKHHQRDz8KgfUit1/g6qM
3sCtU7NRzNIOmxUIWOanXgSPmhJM0Sq0fcHlDs2xnQobiuH+Tw2jWIRgzcs6XfeD
Uu+ERZrSoOISFJnrcbch2Yi14EoadY02WT5u+cPrxrNSjkhkmQd39RUqdlz5raNz
H+T/G25zItq5+Ezw1AYnFv9XNsFSi7NMeMp0W6SQ1fw9rF20FHeqcFGtwYJhAV8E
ikFKo5+jfs+PA6KCGL/w
=IYbf
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jan_2013_14_21_31_+1100_eDCZNp/dUReVtFhN--
