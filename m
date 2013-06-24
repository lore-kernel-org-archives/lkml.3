Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3FXTe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:34:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42946 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab3FXTez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:34:55 -0400
Date: Mon, 24 Jun 2013 22:34:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>
Subject: Re: [PATCH v7 0/9] Generic PHY Framework
Message-ID: <20130624193403.GB11815@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <51BEE203.6090103@samsung.com>
 <20130618094942.GY5461@arwen.pp.htv.fi>
 <51C89D98.1070806@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <51C89D98.1070806@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2013 at 09:27:20PM +0200, Sylwester Nawrocki wrote:
> Hi,
>=20
> On 06/18/2013 11:49 AM, Felipe Balbi wrote:
> > On Mon, Jun 17, 2013 at 12:16:35PM +0200, Sylwester Nawrocki wrote:
> >> I have already used this API for our MIPI CSI-2/DSIM DPHYs driver,
> >> the RFC patch series can be found at [1].
> >>
> >> Thanks,
> >> Sylwester
> >>
> >> [1] http://www.spinics.net/lists/arm-kernel/msg251666.html
> >=20
> > one comment to that series:
> >=20
> > let's make the phy names standardized, how about phy-exynos-video-mipi.c
> > or phy-mipi-csi-dsim.c ?
>=20
> Yes, I have been thinking about that, wasn't sure exactly what pattern to
> chose. I would make it phy-exynos-mipi-video.c, phy-exynos-dsim-csis.c fe=
els
> a bit odd. phy-mipi-csis-dsim.c might be to generic as MIPI CSIS stands f=
or
> MIPI CSI Slave and MIPI DSIM - MIPI DSI Master. And there might be (actua=
lly
> are) IP blocks in an SoC that use the other MIPI Aliance standards.
> For the HDMI PHY I guess just phy-exynos-hdmi.c could be used.

sounds good to me :-)

--=20
balbi

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyJ8rAAoJEIaOsuA1yqREkSYP/2qexP8Dx9H7/V27jpH0HX9E
8MvETKnha0gPPT7aIp4wRK5ym1or1ZfWODJipaRvhgeG31JSFD+i3FHib8M2M08j
ba01L45w6C9exijHIbFZ0kBpt/+bxnjeb1s5m/ieR8SxAiyocnlNEmRlSEXajzO8
yFk7IzQUxslewCmFhkuuo68bp5xkH7G0yE278RfZQnBqMefdEGdCJr9CPKoS3NUI
srYt3rWWeLcAzF6VNR9fY+5YhRSoP3goLPMrLHSgD3w1Pg80kSJtArnAeReHYcHN
jsWt+gS7LU6c/WzGfR9Nm3CqvPNNXs++nepvNCFwGQGJCFrS/vSxOQQg7NMELNfX
dN1NpgBn7JiYi3XVNJEWx/8+Mm6GcVKD6WCpP99Mh955urXAdrbNniVd3W7+SiVc
0jPMDK6uf5HPPevdC0g4Lnz1AgdE1qjzEP77xx+MnrWFb0lzQPBtHIpdiqBli2Dq
HwkWYDIMmQGtcSpxg44nPnv/IAecQ7V5QvHZSqL3TbAF48bgWKAJyOiaJE9XZyUa
u1yJwrqJ4VSB9mXw9BcIgsTm0O5HS0bf0U8tF0jKaQGlcXXgpN1BdWal9pY4ilGn
gKjDAQdHCULoh4A7PPyfGwNkT36kaFQULa7J8b8IMI06CIm/iUjbNUuK/IlgRQ3y
QfQA5Ycvr0WFgethw3YO
=Ny+s
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
