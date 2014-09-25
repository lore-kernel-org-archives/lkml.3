Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaIYEIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:08:41 -0400
Received: from ozlabs.org ([103.22.144.67]:56038 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaIYEIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:08:39 -0400
Date: Thu, 25 Sep 2014 14:08:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>, Guenter Roeck <linux@roeck-us.net>,
        Guodong Xu <guodong.xu@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Werner <andreas.werner@men.de>
Subject: linux-next: manual merge of the mfd tree with the hwmon-staging
 tree
Message-ID: <20140925140831.4c283b73@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/v9JWNJ=0OhxcoMFBEWW8wLn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/v9JWNJ=0OhxcoMFBEWW8wLn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Lee,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mfd/Makefile between commit dfbdcd7cefca ("mfd: menf21bmc:
Introduce MEN 14F021P00 BMC MFD Core driver") from the hwmon-staging
tree and commit bc69ade0238e ("mfd: Add HI6421 PMIC Core driver") from
the mfd tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/Makefile
index d58068aa8aa9,f1b2e2c9264e..000000000000
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@@ -169,7 -171,7 +171,8 @@@ obj-$(CONFIG_MFD_AS3711)	+=3D as3711.
  obj-$(CONFIG_MFD_AS3722)	+=3D as3722.o
  obj-$(CONFIG_MFD_STW481X)	+=3D stw481x.o
  obj-$(CONFIG_MFD_IPAQ_MICRO)	+=3D ipaq-micro.o
 +obj-$(CONFIG_MFD_MENF21BMC)	+=3D menf21bmc.o
+ obj-$(CONFIG_MFD_HI6421_PMIC)	+=3D hi6421-pmic-core.o
 =20
  intel-soc-pmic-objs		:=3D intel_soc_pmic_core.o intel_soc_pmic_crc.o
  obj-$(CONFIG_INTEL_SOC_PMIC)	+=3D intel-soc-pmic.o

--Sig_/v9JWNJ=0OhxcoMFBEWW8wLn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUI5VEAAoJEMDTa8Ir7ZwVpAoP/jGPO0Vso/QjdvAA2Mq22iAI
xnl5eHtyeUmgB/o1/9GRUYJH181oPImA/DQFGI+WWCJPZBQQntWr570f0YYs7tsr
Qmym61OfXbofSr2ZhAy7dTzy55/Kg9bz958hkLTzVfGpMWOekkSLvgqwduIflE4C
jRuHhKJyJYKdqLansxGGN3dQfGiClHdLLYsGh68pHCM7yM3ytbMBPYBJJLeJkMNz
d9zGw51LZcWq4a4ha8wCzJvxKLxSXtXOwHp7E++qZ7Wd7Xo8hhiQPHpXlCAEFtFq
A5jyLyv18VFUIpdpp2ltLnkm37acOhGa/FmrD4leOsm/lIo1OtxIOiVLX/lVbiBS
Neu7SgVsjfgPapDjFK3uGqSCawrbuSfnYmPVu16oYIfbVSCUgmMqltrsEKOI2k+x
dK7L7ftZ3I/IuAo4B3MEQ965zBNRnDnMAxRc99/QK6/k/YOgMgS4ES9293SlFbDq
9HKy/66httSdQB4BDZexa6KNvxpC/APe/MkdKYdOcwIQrc1ka3BMhcHqf7WPtP8U
q4STUoeh9afsKXaB4LA9NYrnsDQp1wlyaIGgKu/i3I0JY71Y0eJPTcdvw9Kthfj3
s5qi+R+l2WrtJ8N3+Ocv5j0OOWgnBT5DcP4NINtN+CnP+b4ofb3ffFA8JAmaCJa3
RERDQInpuJ5Ndzq01IUg
=+UJJ
-----END PGP SIGNATURE-----

--Sig_/v9JWNJ=0OhxcoMFBEWW8wLn--
