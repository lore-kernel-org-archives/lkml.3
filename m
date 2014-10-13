Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaJMWo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 18:44:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55730 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbaJMWo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 18:44:26 -0400
Date: Mon, 13 Oct 2014 17:44:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Anton Tikhomirov <av.tikhomirov@samsung.com>
CC: "'Vivek Gautam'" <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <kishon@ti.com>
Subject: Re: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on
 Exynos7
Message-ID: <20141013224409.GB1496@saruman>
Reply-To: <balbi@ti.com>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
 <1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
 <00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 13, 2014 at 01:54:59PM +0900, Anton Tikhomirov wrote:
> Hi Vivek,
>=20
> > Exynos7 also has a separate special gate clock going to the IP
> > apart from the usual AHB clock. So add support for the same.
>=20
> As we discussed before, Exynos7 SoCs have 7 clocks to be controlled
> by the driver. Adding only sclk is not enough.=20
>=20
> >=20
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > ---
> >  drivers/usb/dwc3/dwc3-exynos.c |   16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >=20
> > diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-
> > exynos.c
> > index 3951a65..7dc6a98 100644
> > --- a/drivers/usb/dwc3/dwc3-exynos.c
> > +++ b/drivers/usb/dwc3/dwc3-exynos.c
> > @@ -35,6 +35,7 @@ struct dwc3_exynos {
> >  	struct device		*dev;
> >=20
> >  	struct clk		*clk;
>=20
> The clock "clk" in Exynos5 just gated all that above 7 clocks, which
> we should control separately now in Exynos7.
>=20

should I drop this patch for now ?

--=20
balbi

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPFW5AAoJEIaOsuA1yqRE2JAP/jLhi8fw0frOAN+5nxZhVUTi
ByhmsFu6a7/oaLki/fg1WAz7AdgMH0CJuQZpY3UTlyc+4QUKHz7F/ZUWE49p2NFI
vwQzYMuWPCh5of6kFMN538d1DbLBSE4JqE0VmP4o8My0zxU96UPABocIA+YTlgmo
vCK8CPWe6rJ3/Hd78sD16wjANqK86UPGerLMQgIlpDcVTvu9Un8AFE4rumtYR+tF
PldWc8/tuMp2XO6eV4cTQT/oQD3adBDFDfvBdXZXygmvGOjUVlVdpJ8n+ebwkB1z
O0k6hfr5thmce3R5QKPLz8EGeg9ukSYgy6EOABoy5Hgo8XAJfMKT9r/7zLU1kdwk
Y/+dw6Thcnpg2+Y8mpo4XQaaIKNDrDL6wiYGqUm8y03NnKK93wau/tb61NAIZe2m
QiJvgf0FpvN7Fl2Mu2s2fgMHnYZZgIO/NXJ9V7eEGyyRt2/oucR9hduZ7kU1W2pZ
dcMHpGG5LgFB2DMiwKdycEbo3JPsIsEJN0iPZ6KRMVKiiCdC7UGk137ZBq3xk8As
8XEM4e1sdQv8ro/HammIM4mXBRrgLCIzfRk6ZYx3SRVKNPn9GdMEr5MJOmw8av1m
pecPWxA18bQvuWP3fzBs01sflMSVRgYGboRJNsR3yMIp+XFZysXwoCxZgd3Wsuys
IJI4eDVoTYvA1EYQOo4C
=XPMD
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
