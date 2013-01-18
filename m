Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3ARNNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:13:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54886 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3ARNM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:12:59 -0500
Date: Fri, 18 Jan 2013 15:12:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <thomas.abraham@linaro.org>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <sylvester.nawrocki@gmail.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH 0/2] ARM: Exynos5250: Enabling samsung usb phy
Message-ID: <20130118131250.GH4672@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
 <20130118131013.GG4672@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQmOcGOVkeO43v2v"
Content-Disposition: inline
In-Reply-To: <20130118131013.GG4672@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xQmOcGOVkeO43v2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2013 at 03:10:13PM +0200, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Dec 18, 2012 at 09:09:40PM +0530, Vivek Gautam wrote:
> > This patch-set enables the samsung-usbphy driver on exynos5250,
> > which enables the support for USB2 type and USB3 type phys.
> > The corresponding phy driver patches are available at:
> >  1) https://lkml.org/lkml/2012/12/18/201
> >  2) https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December=
/024559.html
> >=20
> > Tested this patch-set on exynos5250 with following patch-sets for
> > USB 2.0 and USB 3.0:
> >  - https://patchwork.kernel.org/patch/1794651/
> >  - https://lkml.org/lkml/2012/12/18/201
> >  - https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December/=
024559.html
> >  - http://comments.gmane.org/gmane.linux.usb.general/76352
> >  - https://lkml.org/lkml/2012/12/13/492
> >=20
> > Vivek Gautam (2):
> >   ARM: Exynos5250: Enabling samsung-usbphy driver
> >   ARM: Exynos5250: Enabling USB 3.0 phy for samsung-usbphy driver
>=20
> What should I do with this series ? Is it ready to apply ? If it is,
> then please resend with Kukjim's Acked-by.

actually, now that I look again, it's all under arch/arm/, so Kukjim can
take all of those through his tree ;-)

--=20
balbi

--xQmOcGOVkeO43v2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+UpSAAoJEIaOsuA1yqREb50QAKGs0rCGyrgv5vqJjavCqYn/
ibzVxtbi4H7tgbtGWO26u4CQ8ALt1LpyicEgOML1C+KMKXlosPzXQuKkZTNaMB1u
4EC+CMPFGRCZA28M7ZTtuZLQEt8ZLvY3cdAJO7516NRwuJKSkI6y3BxD4bl1mlSM
Z/GOsLWPwiEew0KkGzuQgbFl+GIzutED4GYdpY8y89IcyGWTo0BnpxZs6K4f9LZh
qO83faCSdkvzPNZq8b6HTJSra/X/8os4qy30uyqb3hZDRbnUr1LLRFrMqViXVjuJ
UgJiaKVeWS3im9B4vzl8VF5R0tzQ4HpBFhdEEOoqFJGM1Yc95AaCDfLugFC/jP4Z
llbTVB26VpjHThm5VtnZb4s6ZERwPuvkFamChuTTPMBlM0H/23f01TgK4cbzwTJc
j+6ezzRXoy48LNgcmQ6Tf6W63k574VsayhpusyE66X+DiAIiq3heu6S595Nqt/pI
4eDK9CznQeB+FW+cg3UItKikbFjv9XaTfqjBq7T5e/5ka2JJhz6TzUHUA3YGQ4QY
Lzg738T2bExewy4ScxADVANYy46lyXEwh9Qd4gs5pSjNzt0LKzLljth/Dwb5yMX0
6gxDOJwDn5v7lwSjyBPeNLAUD5HnLXKPQB9MP/w2NCwTnNDTpgImi0fhh5/HqrrY
gLnEggJsPpd9D6RAJbcc
=zpkJ
-----END PGP SIGNATURE-----

--xQmOcGOVkeO43v2v--
