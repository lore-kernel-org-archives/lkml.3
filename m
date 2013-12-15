Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3LOXrs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:47:48 -0500
Received: from ozlabs.org ([203.10.76.45]:33129 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab3LOXrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:47:46 -0500
Date: Mon, 16 Dec 2013 10:47:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: linux-next: manual merge of the renesas tree with the arm-soc tree
Message-Id: <20131216104738.6f845aabd0e3b609ed9ca170@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Dec_2013_10_47_38_+1100_=7iMq0Gbca0J+HhM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Dec_2013_10_47_38_+1100_=7iMq0Gbca0J+HhM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
drivers/clk/Makefile between commit 0ad6125b1579 ("clk: at91: add PMC
base support") from the arm-soc tree and commit 10cdfe9f327a ("clk:
shmobile: Add R-Car Gen2 clocks support") from the renesas tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/Makefile
index ace7309c4369,8dd1339be98b..000000000000
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@@ -35,7 -35,7 +35,8 @@@ obj-$(CONFIG_ARCH_TEGRA)	+=3D tegra
  obj-$(CONFIG_PLAT_SAMSUNG)	+=3D samsung/
  obj-$(CONFIG_COMMON_CLK_XGENE)  +=3D clk-xgene.o
  obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+=3D keystone/
 +obj-$(CONFIG_COMMON_CLK_AT91)	+=3D at91/
+ obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+=3D shmobile/
 =20
  obj-$(CONFIG_X86)		+=3D x86/
 =20

--Signature=_Mon__16_Dec_2013_10_47_38_+1100_=7iMq0Gbca0J+HhM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSrj+fAAoJEMDTa8Ir7ZwVho0QAIAclvtVRJsvewie/f5TZIoH
LbhOhVdnt3A9syxERhimIXnN9BOz2ZmqvQfpKD46Cdc/8b0TATwef6KojM7zhu6k
xEAo9SXQpJSMRkj5Bt8JucZhy2tQXE4aR5QmafsrrAP1YHxpEpbB5E5Wr+wpUGEn
8WDlZoyZcXdCiAS4cP1pJC/LJUaMRHsfn3qPJvLWZKtv7FW/uC4CEwvv0kzgSkTd
Tf/+gw/8zxrvr4ex5a2YfNHq1owcmUHxj5t2NZwjoj1olFQF5aTaq4jH4ZG/BYgW
6trfPp6VokzsPa9suVAOrJsN1+dJL2gIxmz+7dt+y3x8jC5vsVTG/2b9h7foi+X9
TWiHkfYIyl+mRf9oW3/YgNhMe3U49JoRR3g5LO6WcGWjoOwiIbDWd1Kn7hvwYl0S
IFeiMkhkvNMANEL8Zk0KzYGe3tH1aFIKw3kTnZeE8oYucj4BZo3uxGvS7qZhZhup
t2yygLH4U9TfGBUdsne9Cnu1lz7bFXXs6EClcmRMkECYxCyfvjyjg4sdm939LIOt
42YXb0W5xN0M+FokCYitLzahjtga44oD6jkTkNR8jcJOLPGm+MsT96lmJltCQA5g
sv1lQGEYeIbu2tkLUoqzQxcGDpaKlZVaRRxpbTrI9HrAqcZNCVR3f401CNc2TrPv
/DdNIiy30ly4wt7Ie3vZ
=/02w
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Dec_2013_10_47_38_+1100_=7iMq0Gbca0J+HhM--
