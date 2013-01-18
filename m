Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3ARNKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:10:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54790 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab3ARNKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:10:23 -0500
Date: Fri, 18 Jan 2013 15:10:13 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <balbi@ti.com>, <thomas.abraham@linaro.org>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <sylvester.nawrocki@gmail.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH 0/2] ARM: Exynos5250: Enabling samsung usb phy
Message-ID: <20130118131013.GG4672@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Content-Disposition: inline
In-Reply-To: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 18, 2012 at 09:09:40PM +0530, Vivek Gautam wrote:
> This patch-set enables the samsung-usbphy driver on exynos5250,
> which enables the support for USB2 type and USB3 type phys.
> The corresponding phy driver patches are available at:
>  1) https://lkml.org/lkml/2012/12/18/201
>  2) https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December/0=
24559.html
>=20
> Tested this patch-set on exynos5250 with following patch-sets for
> USB 2.0 and USB 3.0:
>  - https://patchwork.kernel.org/patch/1794651/
>  - https://lkml.org/lkml/2012/12/18/201
>  - https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December/02=
4559.html
>  - http://comments.gmane.org/gmane.linux.usb.general/76352
>  - https://lkml.org/lkml/2012/12/13/492
>=20
> Vivek Gautam (2):
>   ARM: Exynos5250: Enabling samsung-usbphy driver
>   ARM: Exynos5250: Enabling USB 3.0 phy for samsung-usbphy driver

What should I do with this series ? Is it ready to apply ? If it is,
then please resend with Kukjim's Acked-by.

cheers

--=20
balbi

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+Um1AAoJEIaOsuA1yqRE9D4P/jM87o9sF5BhHZ1wW05XWkPf
Ogounha5VfOsBV7nAkGrK9r8kXFzrg3onbJ6S2O9Oqa9F/PEJH60ixjghBXTja9n
cursCGf4KlhoxFJ1pWA2TGjyjjMa2XoUFtN8M5RQOX7Ryx9jN1d7ETivDuwdcvdD
OFewjYFSUajnNfNZJIzIGXUUJ2xGkirwXi3HGd3anITWxooT4IoSeU2i8bLMK0vG
ypBWouEi8MJZliEVnyoNOWYpnZODrPUWxWZEsRB/DEemFdj3g56EN8o2DkRdXl9f
gzx2/bWOH/tAz/mDVMoqf6u0IaLusMByONaeE7zOj34UykvdePRO1VDDzLnozp5F
+YC/ItRXHmEAWQBIiHQdjZyAqRLsRr5JS97aIzJpGg2rnaZ5jWeUp411QxMurEZe
h6ppnocvv0IHhHn2j6gG7YyOykQdRfHND4gpCMyJVjE+N/R7tWWSrVii6IDEwIox
EYtktmpV0yaFYORJQeQy4RcJ7SoUltdAqONmfcByX0Ausq35pWynnLYEubceX2rG
9pyVSaDZbyJYFv4igWs4LkLW+aNYIkX2Dj0YhpG7UAMBlRmXqAKpnaPuybRW+lcM
5UcYCRByDcT2oD5N0eYEmTEABwCD6S8yrgGLWoPsfzdO9TQw9LE5gON2sncCxk0t
q1CGkpg56EUi6+6pNtdq
=sxUC
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
