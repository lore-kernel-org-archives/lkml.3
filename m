Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190AbaGXGdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:33:45 -0400
Received: from ozlabs.org ([103.22.144.67]:37005 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934162AbaGXGdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:33:43 -0400
Date: Thu, 24 Jul 2014 16:33:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the arm-soc tree
Message-ID: <20140724163329.03002387@canb.auug.org.au>
In-Reply-To: <20140724162811.5e12107a@canb.auug.org.au>
References: <20140724162811.5e12107a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Jbk1mBHhd9PY_CSCDyAYD+g"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Jbk1mBHhd9PY_CSCDyAYD+g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 24 Jul 2014 16:28:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the usb tree got a conflict in
> drivers/phy/Kconfig between commit 64562e99477f ("phy: Add drivers for
> PCIe and SATA phy on SPEAr13xx") from the arm-soc tree and commit
> 1de990d8a169 ("phy: qcom: Add driver for QCOM APQ8064 SATA PHY") from
> the usb tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Also drivers/phy/Makefile

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/phy/Makefile
index 241c741e6e39,971ad0aac388..000000000000
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@@ -18,8 -21,7 +21,10 @@@ phy-exynos-usb2-y			+=3D phy-samsung-usb2
  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+=3D phy-exynos4210-usb2.o
  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+=3D phy-exynos4x12-usb2.o
  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+=3D phy-exynos5250-usb2.o
 +phy-exynos-usb2-$(CONFIG_PHY_S5PV210_USB2)	+=3D phy-s5pv210-usb2.o
  obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+=3D phy-exynos5-usbdrd.o
  obj-$(CONFIG_PHY_XGENE)			+=3D phy-xgene.o
 +obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+=3D phy-spear1310-miphy.o
 +obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+=3D phy-spear1340-miphy.o
+ obj-$(CONFIG_PHY_QCOM_APQ8064_SATA)	+=3D phy-qcom-apq8064-sata.o
+ obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+=3D phy-qcom-ipq806x-sata.o

--Sig_/Jbk1mBHhd9PY_CSCDyAYD+g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0KjCAAoJEMDTa8Ir7ZwVLwcP/2RWUxdG+kHXUttv+ihmcmgc
GKQZVnXCOJBDNmqdMB3S7QndA2unKQMZ+6jaz8p5KMzNJPoKX+KSXv/8e8L3+va5
ylS1vrUKdB7XCVslGYXRR5TfkMWiM+nXGM5HXnIszidSRZ6qpZv2wz9pY/MEzPqj
zIzR2MSfzJ1nh0S+EemrVtMPKi99bA6DBOaIWeL/GWpOxnT9oEJlr1V+K8JN+EiV
Rj3riyRq0k3EQ5HCZrJLsPPNQsXm0scWat512pFo5Re2m3UI6lGDyBLB9yslYJe/
e5diPhZe++6U+t8o9wkVuWkGYKq3gKfKdKpxY5t6ugr0SXEuDLDbHVm6LiztJrqw
8vFzCJmyidfdgoEeXnIUh8nEhkx2+r1m4HYucTPR3QoQHyrHoJQPThirSUPWZYf4
GhJVaXVdrT7LRtNByz4AFCnIdV3fZlmQREFAF/WddAl/ZYC5JqhNxHNMx+foNsQz
7lZakidSiEI3Qgasg7neaKdqALTjzUFWcRxa4Uef9VnjMbvHmHSdx8CiyRcny5IM
wr/BvxQhC3lRBB98ESfU7xLuaEINLRBGtEnSCJtFeUFKd2dH0lGl4MJdw9SwZzml
hJXRTEXv+Y8jgKDAflks3PLVPj1TxMwWNtmqNAu+eKW54lPJ1qOdzS269LzK99s0
m81iVkra7WQaoDJw1ELD
=rp/J
-----END PGP SIGNATURE-----

--Sig_/Jbk1mBHhd9PY_CSCDyAYD+g--
