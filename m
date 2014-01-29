Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbaA2AfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:35:24 -0500
Received: from ozlabs.org ([203.10.76.45]:45068 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbaA2AfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 19:35:22 -0500
Date: Wed, 29 Jan 2014 11:35:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the imx-mxs tree with the arm tree
Message-Id: <20140129113514.86275e22015dea313d78d5e1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Jan_2014_11_35_14_+1100_UrkZyoCHIbAMnvG5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jan_2014_11_35_14_+1100_UrkZyoCHIbAMnvG5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/boot/dts/Makefile between commits 208d7baf8085 ("ARM: imx:
initial SolidRun HummingBoard support") and 971488f1149f ("ARM: imx:
initial SolidRun Cubox-i support") from the arm tree and various commits
from the imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/Makefile
index b9d6a8b485e0,2841184f354c..000000000000
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@@ -150,15 -137,32 +153,35 @@@ dtb-$(CONFIG_ARCH_MXC) +=3D=20
  	imx53-m53evk.dtb \
  	imx53-mba53.dtb \
  	imx53-qsb.dtb \
+ 	imx53-qsrb.dtb \
  	imx53-smd.dtb \
+ 	imx53-tx53-x03x.dtb \
+ 	imx53-tx53-x13x.dtb \
+ 	imx53-voipac-bsb.dtb \
 +	imx6dl-cubox-i.dtb \
+ 	imx6dl-dfi-fs700-m60.dtb \
+ 	imx6dl-gw51xx.dtb \
+ 	imx6dl-gw52xx.dtb \
+ 	imx6dl-gw53xx.dtb \
+ 	imx6dl-gw54xx.dtb \
 +	imx6dl-hummingboard.dtb \
+ 	imx6dl-nitrogen6x.dtb \
  	imx6dl-sabreauto.dtb \
+ 	imx6dl-sabrelite.dtb \
  	imx6dl-sabresd.dtb \
  	imx6dl-wandboard.dtb \
  	imx6q-arm2.dtb \
+ 	imx6q-cm-fx6.dtb \
 +	imx6q-cubox-i.dtb \
+ 	imx6q-dfi-fs700-m60.dtb \
+ 	imx6q-dmo-edmqmx6.dtb \
+ 	imx6q-gk802.dtb \
+ 	imx6q-gw51xx.dtb \
+ 	imx6q-gw52xx.dtb \
+ 	imx6q-gw53xx.dtb \
+ 	imx6q-gw5400-a.dtb \
+ 	imx6q-gw54xx.dtb \
+ 	imx6q-nitrogen6x.dtb \
  	imx6q-phytec-pbab01.dtb \
  	imx6q-sabreauto.dtb \
  	imx6q-sabrelite.dtb \

--Signature=_Wed__29_Jan_2014_11_35_14_+1100_UrkZyoCHIbAMnvG5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6EzGAAoJEMDTa8Ir7ZwVeGQP/j2Mk98eUGlxCukxNQTS2a1f
+ibIC0M6i0R05d9EzJlyQ6AlQr3bYonlinX8pOJahEdFgqY9iO86cTJ4kC9Cq8uI
1ckm55O7KzeAqA/m1AxNTJ5+qn2BksGaW2uIuVryQ4SThWZlaJ7fk+5uyDZQdvv8
B5eFOmwQajbKTOutrnVTfNdZz3NO9CbswU/PkcQp1mmm0ueXThi/WzHTM0dqr/D7
r1ZZ/8mvLCrKhQy7FAJkh5IYYFEMJmGoiSBwNOm4fxl9HdPqePwHqIiu78r6t0lL
ANHlHFLj78tJyBObBVSwQJWK5xycVyJMJrrF8Ht0/47vOGpfUpHEudWG4WDPnrZy
D7YkNggKmHFZEfYIZAxUr88PzsMbh8iFemsD1GzCOG5Ih7kuC+hGs8ueVPPCzumb
uBdzKtQgAMyiFw2ptZv2pUUWE4lEJMAduSzRBSwQ2LuOOjTVIlD4b9QVaHu1f92S
5Qo5WviXh+ufs4NaRmIEkvPKdeApkhWn2S79Vhxarzv4YrX4vTNb5mh9ZQBvftPu
nIGCOvs/rU0oXRIwXS77MUmQ8RBu68dpvnJ43Ye0+s9GlSABHAJs960IBpLV9Tbb
yXAUB5qpgb/GXhaJJqF9QnBudSvdnPSVQecx7lW0ywxxPKlFLcbEoVsd8nhtRouz
kD9OOpxQIopZqBYBDYE7
=a7hg
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jan_2014_11_35_14_+1100_UrkZyoCHIbAMnvG5--
