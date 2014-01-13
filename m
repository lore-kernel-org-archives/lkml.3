Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaAMCRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 21:17:12 -0500
Received: from ozlabs.org ([203.10.76.45]:60496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaAMCRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 21:17:10 -0500
Date: Mon, 13 Jan 2014 13:17:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: linux-next: manual merge of the mmc tree with Linus' tree
Message-Id: <20140113131700.840c214536826d7e9a92ef8b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_13_17_00_+1100_NAUCTjMUOU5GXuxH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_13_17_00_+1100_NAUCTjMUOU5GXuxH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in MAINTAINERS
between commit c2fd4e380322 ("MAINTAINERS: set up proper record for
Xilinx Zynq") from Linus' tree and commit 45f210424b4b ("mmc: arasan: Add
driver for Arasan SDHCI") from the mmc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index 64b39e610589,518bf717b02b..000000000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -1387,9 -1371,7 +1387,10 @@@ T:	git git://git.xilinx.com/linux-xlnx.
  S:	Supported
  F:	arch/arm/mach-zynq/
  F:	drivers/cpuidle/cpuidle-zynq.c
 +N:	zynq
 +N:	xilinx
 +F:	drivers/clocksource/cadence_ttc_timer.c
+ F:	drivers/mmc/host/sdhci-of-arasan.c
 =20
  ARM SMMU DRIVER
  M:	Will Deacon <will.deacon@arm.com>


--Signature=_Mon__13_Jan_2014_13_17_00_+1100_NAUCTjMUOU5GXuxH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS00ykAAoJEMDTa8Ir7ZwVpMkP/Aykpev6fHXvuQNM84kH352I
iq5xuzuqAXwke28QGN/e0FpT6ztd4uuwdz+jdBc1ZNnWd5QPXSoslcQUa5546x5O
WkISCMDDX6Pgx0ZRWaZNFU1IzdjTSR82/Tc2ao8CNYsVVJctagE6st+G2taFiAIQ
9sBXaORg2krXokAuRSdNaLal1x7HbORqYKag5A9DHeMxu9hLFGi92pLfPWnwvqWz
0/LHZ7qLpTYgp8HDywhghU2xTErcN7nyjpO7w3YdGuMBpZ+Qa0tx4uoWriLG/Kx1
L6f9+rWr3lWE9SVXItRBFFUCniHie4smwBE+RTQdKtZRxPacVuLAoYZuBMbakz5N
H85hvTLMZT+e2mdK8G6SN2O5tCP8qVDJctzPlZfpbWMMACnibmFhth54s9Gk2/OB
N8SBwepKHqEb7/9PFLijjSAhSJFBJwmfdg9FdFXKb3XP0mNycfMNg3e6UNKh3rmb
ndRxbYB8t3hTTabikHN5bim95deXvj50M45Rgyj6GBARX0VPfY2xoK4NQWRMKWnj
OjZ67tofRk8H2nNwN5q0xY67P9Pd97lcTY9e1UGPndZserKCjb1aR+TvU7OQkeal
M0xUXHmaH6pifqmKMnbPb8luUpf4+RJEM/UosBOsf+J/v9Z74hVyDjNrldml9ILH
c0Rlh+ZuMfSro1BTJAsj
=4lCb
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_13_17_00_+1100_NAUCTjMUOU5GXuxH--
