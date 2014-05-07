Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaEGWAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:00:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34218 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751351AbaEGWAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:00:10 -0400
Date: Wed, 7 May 2014 16:57:39 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        hdegoede@redhat.com, Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/7] phy: usb: sunxi: Introduce Allwinner A31 USB PHY
 support
Message-ID: <20140507215739.GB7047@lukather>
References: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399434623-20383-4-git-send-email-maxime.ripard@free-electrons.com>
 <536A36A2.5030109@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <536A36A2.5030109@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 07:05:30PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Wednesday 07 May 2014 09:20 AM, Maxime Ripard wrote:
> > The USB phy controller in the A31 differs mostly from the older control=
lers
> > because it has a clock dedicated for each phy, while the older ones wer=
e having
> > a single clock for all the phys.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/phy/phy-sun4i-usb.c | 35 ++++++++++++++++++++++++++---------
> >  1 file changed, 26 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
> > index e6e6c4ba7145..1d83abe07a29 100644
> > --- a/drivers/phy/phy-sun4i-usb.c
> > +++ b/drivers/phy/phy-sun4i-usb.c
> > @@ -61,16 +61,17 @@
> >  #define MAX_PHYS			3
> > =20
> >  struct sun4i_usb_phy_data {
> > -	struct clk *clk;
> >  	void __iomem *base;
> >  	struct mutex mutex;
> >  	int num_phys;
> >  	u32 disc_thresh;
> > +	bool dedicated_clocks;
>=20
> Don't think we need this structure member as it's been used only in probe.

Ah, right.

I'll change this in the next version.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTaqxTAAoJEBx+YmzsjxAgNdkQAICNJU5W4AmWZdwMlRV7wPgo
mNpuBMo7MiJe5f6MYGChADx6wZUiKhC4rjtpl+tnPoD02PoRqx7ScMm6uEWt6jW4
y1AgLZhqjcQuLOjG/w34iz4jI3Nmndz5pIeAbwI1a4vh8C2Qd7wud5XATYwxPwa1
mnAcNdCiDLvtB55EpMpDuIAI/huHBj4GHL3EM0wfqbJV2x0VpVWKcbsl942WRrKl
HsOL4pIZ5tB/PVk8Ug77sHbT6YSGxu0DIJBLSGv+zN3wdeSD9JMwmlewDf2jOePL
jvJrs0sCVp2NckreIJUZsabUaRwAKkgxK40tHR+84F3YVX4CZgcY5M3kPcMXQB8s
jhXQe2J2P0VY0VV/HvcRpgxPBxQpUqmyvUNw0WXhk8E8M70RBlYStLZaM1w0JSJv
D4k6tEx9T/fE3DJTM0ir1apyOmuQHyvlponeEJVv/h22USGm2j+Ma8Wz35t2jRJ7
MVE91QzViNQiBGgsDvIKFAoTXTb7LWMWWh+cYb0xP0PkWQxas4cKGpkg9rWJiXF8
gXWnN5K06ZAp38FgGgRPp0ej4rqh3D9FKAoVHBI+77tFcymrzX1D+5nDbqHPXLYc
lQnRuca0Uio4N6B5CnsZuhJy1eRBncop6gP4zqbUn5hv1XCrlWsKSKIc3dE6N2lO
21w6+qNZHkCPtCSqjs96
=Fe6F
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
