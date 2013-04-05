Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3DEEmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:42:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44872 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3DEEmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:42:06 -0400
Date: Fri, 5 Apr 2013 15:42:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the imx-mxs tree with the pinctrl tree
Message-Id: <20130405154203.4069187c95a65ab74a2590a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Apr_2013_15_42_03_+1100_R0GGTqAssWKrFqqB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Apr_2013_15_42_03_+1100_R0GGTqAssWKrFqqB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
drivers/pinctrl/Makefile between commit 62194200e5e3 ("pinctrl: remove
pxa pinctrl driver") from the pinctrl tree and commit b8979245b6ff
("pinctrl: add pinctrl driver for imx6dl") from the imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/Makefile
index 82db76c,8bdaf23..0000000
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@@ -21,7 -21,10 +21,8 @@@ obj-$(CONFIG_PINCTRL_IMX35)	+=3D pinctrl-
  obj-$(CONFIG_PINCTRL_IMX51)	+=3D pinctrl-imx51.o
  obj-$(CONFIG_PINCTRL_IMX53)	+=3D pinctrl-imx53.o
  obj-$(CONFIG_PINCTRL_IMX6Q)	+=3D pinctrl-imx6q.o
+ obj-$(CONFIG_PINCTRL_IMX6Q)	+=3D pinctrl-imx6dl.o
 -obj-$(CONFIG_PINCTRL_PXA3xx)	+=3D pinctrl-pxa3xx.o
  obj-$(CONFIG_PINCTRL_FALCON)	+=3D pinctrl-falcon.o
 -obj-$(CONFIG_PINCTRL_MMP2)	+=3D pinctrl-mmp2.o
  obj-$(CONFIG_PINCTRL_MXS)	+=3D pinctrl-mxs.o
  obj-$(CONFIG_PINCTRL_IMX23)	+=3D pinctrl-imx23.o
  obj-$(CONFIG_PINCTRL_IMX28)	+=3D pinctrl-imx28.o

--Signature=_Fri__5_Apr_2013_15_42_03_+1100_R0GGTqAssWKrFqqB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXlYbAAoJEECxmPOUX5FEFVEP/2i3bSXmOw4a1HD7YNLwj9Gw
aCtH6SBmAjXaWac9ngXA+7DF/r5gsqanybvo65ACRFkhw1acHB0owNLssjfA6apu
SNUNQ37itlXeLMel4QbtqHtQm3qevI+QvfMQitcziGJpzA/UD5zepqtLYlPtqEU0
gkRm5NS2IPQ5cPd9+AH/t6nvPlETOa4Hs9XStRhrGhq76TaT51qkZjbtzyX4pdTp
kctp3knhkRUEo0BdKs6txgSgX8swEZx1GrAyWMJcNWMOre/XUF7LosAuBLWjEYbY
bEVTqgeYw4aqlBye8O5y4P6AFGzgzaQWJgIClFxy4iVaRMqGQ6pHme9vode1KD8W
QpOw/P/nzZpacIqFTXgJ/OEGS1X22OqUlZ0/euo20enfVSA7fPi6NFHn9248jpX2
52QFirf4Tlvq4MAF1CepLqEgN9iO8BF9ydIcn2ecRofJV4cuiJcHsJIdHFzDMag4
Au0YiBARrqDDuBiJrbyQYQFNYuwK8q9ueEtN1S6pLcTO3XGJ+sMAo3wFSwKLrr3I
EM5AqwBWmTgQczR0sHhlpm1vTou5bay4hl7VOzfeaFLD125VDF9TKb5FbL5/kv4I
epOa8Cxvf/a6RKWYqm+d+e/r4/UBm54PcD2mxyJ5/tMgVUBYLrbLgNGgkXxa067v
q59WgevbHjQd8fEsrud7
=hnKq
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Apr_2013_15_42_03_+1100_R0GGTqAssWKrFqqB--
