Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3BDGEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:04:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56467 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3BDGEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:04:31 -0500
Date: Mon, 4 Feb 2013 17:04:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the arm-soc tree with the mfd tree
Message-Id: <20130204170421.1dd829d596474b12c12190df@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_17_04_21_+1100_1iX_kiPsqLu_9deu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_17_04_21_+1100_1iX_kiPsqLu_9deu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mfd/db8500-prcmu.c between commit 5073e7b57041 ("mfd:
db8500-prcmu: Add ux500_wdt mfd_cell") from the mfd tree and commit
520f7bd73354 ("irqchip: Move ARM gic.h to
include/linux/irqchip/arm-gic.h") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/db8500-prcmu.c
index e42a417,42f3afc..0000000
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@@ -32,8 -33,6 +33,7 @@@
  #include <linux/regulator/db8500-prcmu.h>
  #include <linux/regulator/machine.h>
  #include <linux/cpufreq.h>
 +#include <linux/platform_data/ux500_wdt.h>
- #include <asm/hardware/gic.h>
  #include <mach/hardware.h>
  #include <mach/irqs.h>
  #include <mach/db8500-regs.h>

--Signature=_Mon__4_Feb_2013_17_04_21_+1100_1iX_kiPsqLu_9deu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRD09lAAoJEECxmPOUX5FEgqAQAISAw7QFLsE0lpxuxWJeXXvz
RTPu0yZysg0thk/ExJSrhct9MvBU2L2MM3oB1g75lB6R5Q5x5dzEhyX2WClh36sx
pK0liSlTNnvEcKS44Q9eL1lZ2zHm9Hc3S/y7bZf49vTjacSBDc9+A0Ut8sYRv36O
wDkjtcftF7Djsqh5ApkMCxEv9UnRCPSwHFpXrYl2n8iVAUiq4AeDUn2VuthiL6T5
8PcJwRddcRk6e8PUDzrl+zSC4wZ8YeOv91SsyfjHTqHIlXNIh6DQahEyBwyym2mu
297EJ14rRPNdoGTB2fry2Gkset9RaTxwsXLvAZz2lcOU666FvjrVhnaTOee2QzD3
JPtaNzRxhV43I/Vyg5D/kksq0Aru1cTg+yYjNKf1sXpAm9oLptEBdi+yp4tg/tF3
dvzUSDWIGVT0C/mrxLpPz2GNvKb9/X1bgQrpIcHB2q7ODXStv/M49gnaR1HN8wDC
dV9UWotN+U3PicKQIMVa2fBlkNbLdcNkNSbaUJn4SHVPKCIvUXx3zfTDsAcLXFdz
d9jXFIm0QzUKPokb+rWz71hkQVEatPMwEhgacX+k0VzQ9JT8fUbYxcWK1JIpgiso
fUqEBfnwH0R7Fmg0YiTjqmDiqrkNcllbyZq4TDSgctMZs/8qEPbxuEMkrQFE4oPL
svXrL/LI6EIqs7ZIvOFV
=/SrF
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_17_04_21_+1100_1iX_kiPsqLu_9deu--
