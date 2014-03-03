Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaCCBCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:02:52 -0500
Received: from ozlabs.org ([203.10.76.45]:41783 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbaCCBCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:02:51 -0500
Date: Mon, 3 Mar 2014 12:02:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@wwwdotorg.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Markus Mayer <markus.mayer@linaro.org>, Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the bcm2835 tree with the arm-soc tree
Message-Id: <20140303120241.11066f951d53c50fb14faf47@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_12_02_41_+1100_BTnTkOK6hVEZ00=I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_12_02_41_+1100_BTnTkOK6hVEZ00=I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Today's linux-next merge of the bcm2835 tree got a conflict in
arch/arm/mach-bcm2835/Kconfig between commits ddb902cc3459 ("ARM:
centralize common multi-platform kconfig options") and 0676b21fffd1
("ARM: bcm2835: enable V6K instead of plain V6") from the arm-soc tree
and commit d30fe6272183 ("ARM: bcm2835: Move to mach-bcm directory") from
the bcm2835 tree.

I fixed it up (I applied the below merge fix patch) and can carry the fix
as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 3 Mar 2014 12:00:40 +1100
Subject: [PATCH] ARM: bcm2835: merge fix for movement to mach-bcm directory

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-bcm/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 396d05c8b570..7de3282a8613 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -33,10 +33,6 @@ config ARCH_BCM2835
 	select ARM_AMBA
 	select ARM_ERRATA_411920
 	select ARM_TIMER_SP804
-	select CLKDEV_LOOKUP
-	select CLKSRC_OF
-	select CPU_V6
-	select GENERIC_CLOCKEVENTS
 	select PINCTRL
 	select PINCTRL_BCM2835
 	help
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Mar_2014_12_02_41_+1100_BTnTkOK6hVEZ00=I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTE9S1AAoJEMDTa8Ir7ZwV5+EP/jiIx7GxfDikB0SjyLPnyIOI
asoLdYfb8zFKW22za0GAhaz6xEOulTsoRdapMjZJUUpiG1Bgxulas62+jV0S90oD
MjFktWyxVDMxk8P8YcvhaIRc4/g1rzfAHwRCjzZ/iL6AKAZztBWC7lSrUG+uE6ld
0RmENZNyICVFwxBxKFkKJes7z5V667ztmLC3Pxt/eQriWCGXqatkrAc8gvv5czxh
yMtlQhrwmyeSSjXap5wXOEBHfmf6XmVFizj2OmnjEDtqog9eqY08p1/1EeF6BYY2
WzD8iZ6Y82Z1ZqNX6EyrCD7jvoYMEDRhNhyyYDzLB37PQAabt48iHVQzcMjWjiuM
eBqCVFBAWIQA/GbVMLGJHPdrO2pR5KkCaDsuIPBiPvhMHRGdyDC739oKMZhQpIhZ
VpmW53UDEl/qtHMoll2XfCnBUMR+MiBaCBJs7VAv3aPUtD2glzapJYjNLlmhVtd9
s6oRVAWIp48D/uu60usxRFbV5iXCDnz6rJ48g27Maa6m8yKCVOG+TpqDw7RmuB+K
o7mVEO1QEyhQGRRUbotaDzVDiB8X2YQQx3hQmnw9hkmAMTwaqzXg4ijLRIYnqe9q
HSyFPjgyH0/1MyswoLZEcnGEH3u6bWY7vArHa4eRgkc3LAflPLarYbSnaT8dkdwG
TxQyEdv1Bfb4aAu8Mnya
=S7gk
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_12_02_41_+1100_BTnTkOK6hVEZ00=I--
