Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaFWA5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:57:51 -0400
Received: from ozlabs.org ([103.22.144.67]:35402 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaFWA5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:57:49 -0400
Date: Mon, 23 Jun 2014 10:57:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the mvebu tree with Linus' tree
Message-ID: <20140623105741.70094961@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/00uqVYu.f2WHX56R/es3R/k"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/00uqVYu.f2WHX56R/es3R/k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/mach-mvebu/Kconfig between commit 21278aeafbfa ("ARM: use
menuconfig for sub-arch menus") from Linus' tree and commit
55fc83023212 ("ARM: Kirkwood: Add setup file for netxbig LEDs") from
the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mvebu/Kconfig
index 4a7c250c9a30,8e3b5f12cd7c..000000000000
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@@ -94,4 -99,13 +96,11 @@@ config MACH_KIRKWOO
  	  Say 'Y' here if you want your kernel to support boards based
  	  on the Marvell Kirkwood device tree.
 =20
+ config MACH_NETXBIG
+ 	bool "LaCie 2Big and 5Big Network v2"
+ 	depends on MACH_KIRKWOOD
+ 	help
+ 	  Say 'Y' here if you want your kernel to support the
+ 	  LaCie 2Big and 5Big Network v2
+=20
 -endmenu
 -
  endif

--Sig_/00uqVYu.f2WHX56R/es3R/k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTp3uLAAoJEMDTa8Ir7ZwVmDwP/2Vr3fmqtZYUI385YkGOPIo9
d2lI4xlrq1u7rLZuxIo9WehYQHy0j264msVp5eV2AHdmVbiXybeUtenQJiC3XtUH
ySY/JdgMv5b6PJ4UXQeq1jPlkrUb1MeIQhTZh9b0hY7/nlKWKNqZMVwwPkYJLRrb
RRX501AmibvQE1UyiQ+FuUugvTDtFDiMzxBhxvcJn0zyNTCAdklf4RjiWDE1BSoD
L8FQNwLkfSqJipwo4lKfI9bz7hmJhOormNRyg8b1YYY7xacib+axTFwUm8yseK5E
aV9MSdjjBWm5n5deABbBadk7YKMXQUxoGVCQarzqYJAG+w/tkpJVEa4K6Ja1cPqW
PkqWFIbUxEEju0G1lploTG1ttpopYIV2/G1JMqsDlqw3cvh/sf5W9k9lNhPtJCnL
X0biqEbFLHfAwMn2Gc8CKcGR//+GKOmKhDXojrlHWbBPNga4DRxyDuXGc/BKpjIa
m1zlxQPTxzXdM1okBp4Kyn5IHsXShTnHc1uucs21ZHzxZ0KI5E13C3YcYRQANz5D
oZmAq2TYZMFL8//1obkyxR9nUN1zKs7XZnMNkRvW5T0NV0SHTAvXaaYtL6aijsMp
n3DPpYKHtkWnmVnTJO/by2NZhUZfsxFEcJmo3U8hTTrOxk1gmGRIRnD811LZ1QEL
rG72fr3x+0dY6s0ac6PB
=h8E/
-----END PGP SIGNATURE-----

--Sig_/00uqVYu.f2WHX56R/es3R/k--
