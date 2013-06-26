Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3FZGGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:06:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52516 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3FZGGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:06:15 -0400
Date: Wed, 26 Jun 2013 16:06:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Mark Brown <broonie@kernel.org>, Jingchang Lu <b35083@freescale.com>
Subject: linux-next: manual merge of the pinctrl tree with the regmap tree
Message-Id: <20130626160603.7747e9db0f30c06a243c5aa5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Jun_2013_16_06_03_+1000_ZjE/P8fCMuOl_=+G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Jun_2013_16_06_03_+1000_ZjE/P8fCMuOl_=+G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/pinctrl/Makefile between commit 701016c0cba5 ("pinctrl: st: Add
pinctrl and pinconf support") from the regmap tree and commit
78bafc66180d ("pinctrl: add VF610 pinctrl driver") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/Makefile
index 6fc7844,cf699a5..0000000
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@@ -45,7 -50,7 +50,8 @@@ obj-$(CONFIG_PINCTRL_EXYNOS5440)	+=3D pin
  obj-$(CONFIG_PINCTRL_S3C64XX)	+=3D pinctrl-s3c64xx.o
  obj-$(CONFIG_PINCTRL_XWAY)	+=3D pinctrl-xway.o
  obj-$(CONFIG_PINCTRL_LANTIQ)	+=3D pinctrl-lantiq.o
 +obj-$(CONFIG_PINCTRL_ST) 	+=3D pinctrl-st.o
+ obj-$(CONFIG_PINCTRL_VF610)	+=3D pinctrl-vf610.o
 =20
  obj-$(CONFIG_PLAT_ORION)        +=3D mvebu/
  obj-$(CONFIG_ARCH_SHMOBILE)	+=3D sh-pfc/

--Signature=_Wed__26_Jun_2013_16_06_03_+1000_ZjE/P8fCMuOl_=+G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyoTPAAoJEECxmPOUX5FERz0P/03dsHTqK3Poaiiye2FRSke+
nOGMHyoUbGLVMhQIN6ty4abKlDodAzpG2pQVaHV1rlRKdjQyw/cWW2PVgs2ubnhj
tSdz5l6ZmQlPUoUWkFgaWaQ6r/duYUA31lMheSZnFuplq3zp3MXCFxt+MLcv0CKR
FHw4xD2BXFkeqgSgn8X0GNwwq4z9CptxY9MOqFFw643ascOaBU/Zd8nIlvKpk0RN
c30svIHmyhXrqqEhdzTbNUiYY2WYEzPwMuyt9LM0GxQHm0xofKCQpMkIv3pyavaG
Qo9muz5Xa8cATVDc9PnUAc2QXiDKT0XJXP1Dc+Q7JsoCLwR8mIaRplh7pEwk+nTI
TrXCuH2UTX0QH3euafjp27KkDo2YQ/FGydWLdF7C+v5oegvjJlkaD4oflJnU8zL1
MS1NnzerLOP3ZBTU6AttpV3eWIgPtMXUKrDWL7wU05DeRp21Dvc2njFtZh2iY4Nj
G4t8Xkkmw+Cd0MSHDd1bhJ9z/IqLH45wT4EW402KGbm6EJSR5w0aQ/vnxI7TIMSq
b5OHn0LYWtHYx8yH22tnhUl7P9r71uXdpoSzlbM46r4Ot/Vyx+7MXKsd3FNZZKrj
+9bdTNmLPtV0MHOxhyp2lySWgi2F3dp5UlIQbWAzV0uJRKr0eefylK4jFtBniW9q
dQ42wMXeIMHHLnN0ubi/
=03y+
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Jun_2013_16_06_03_+1000_ZjE/P8fCMuOl_=+G--
