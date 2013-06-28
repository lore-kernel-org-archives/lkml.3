Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3F1SAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:00:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37664 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3F1SAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:00:21 -0400
Date: Fri, 28 Jun 2013 21:00:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Michael Grzeschik <mgr@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        George Cherian <george.cherian@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is not
 available
Message-ID: <20130628180000.GF25498@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
 <20130626101647.GT12640@arwen.pp.htv.fi>
 <51CAD977.6040309@ti.com>
 <20130626121210.GA12640@arwen.pp.htv.fi>
 <874nclghu2.fsf@ashishki-desk.ger.corp.intel.com>
 <20130627061416.GI3523@pengutronix.de>
 <20130627063526.GG15455@arwen.pp.htv.fi>
 <20130627072408.GJ3523@pengutronix.de>
 <20130627073033.GN15455@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yQbNiKLmgenwUfTN"
Content-Disposition: inline
In-Reply-To: <20130627073033.GN15455@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yQbNiKLmgenwUfTN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 27, 2013 at 10:30:33AM +0300, Felipe Balbi wrote:
> Hi,
>=20
> On Thu, Jun 27, 2013 at 09:24:08AM +0200, Michael Grzeschik wrote:
> > > > > > right, but in DT you will define both instances and each instan=
ce will
> > > > > > have a seaparate snps,maximum_speed attribute :-)
> > > > > >
> > > > > > I'm now considering if we should make maximum_speed a generic a=
ttribute,
> > > > > > Kishon ? Alex ? Alan ?
> > > > > >
> > > > > > anyone else needs such thing ?
> > > > >=20
> > > > > We have a force-full-speed attibute for chipidea on the way. This
> > > > > maximum_speed looks like a more generic alternative. Michael, wha=
t say
> > > > > you?
> > > >=20
> > > > The maximum_speed attribute sounds more reasonable. I will change my
> > > > patch to it.
> > >=20
> > > thanks, perhaps we can add a generic helper in udc-core or usb-common=
 ?
> >=20
> > As this function is not only udc specific, this should go into usb-comm=
on.
> > But right, we should go with a helper here. I will write one in addition
> > to my full-speed patch as first user of it.
>=20
> alright, thanks :-)

Michael, if you need any help with patching in maximum_speed attribute,
let me know as I have some time to work on that part.

cheers

--=20
balbi

--yQbNiKLmgenwUfTN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzc8gAAoJEIaOsuA1yqREmHIQAIxdWheDf+szT0G39nO4b92U
h+ydOWA42VquQ8AmICYM+xOXq0l17immZb3y9ySNY7woji9fas78dCeps/DlPjcd
FyEbdmR0fYXL3wXkAEESsjx9hHV3KW8Zl/80GjetzebZzPMPrAXOeI7mpgYDgLUJ
TyhTK4brnC0UyHBwTiVt0F2jLuXB955taLXwzxPHv6ejL8ysNStkPPPVBoq6rclt
VsM6pY89mhbgOtpj/KBxCLKK5/2SsT0gJRuQVsFLEOvK7aXit9H200W7JZk+bh4C
NTn1gnN8UHz/Y5Gps43rZYdjHJaAVLdSugMu2d0A70NQDIFPAVFY+Ogj4h+6d3jU
QLaMXWhkQk0AT1Jb1AXEY5KBhSkgQnEBtO5jJw3DRTg9BitZTDBa8D2BYhFLBCad
lWxmRfRJSj7z8xbLyjdoOdXQ4zbgJvkz/D/rkLyS5igO1N4+XDi0JfNfKEj0tv6T
gbKCgF88sZJRRPyw4uyo23+icDV2V7CRfN7abshIRPHDDAe392+zNiS5cLahS2YS
Tr9nD0iBucS8h79ugK8zxfmhQKfBV2NpJh22IZWtZE4H65CRcGSdOhE91fiVHBzx
U63SevQK/aAG2UpaOcS6l09sZY/Q8yPHA+4fKiDxkHRTqHjZAiAwzY5pMoT4ZE1G
ynnJE/ByKUPhUSU2fRnH
=CHmE
-----END PGP SIGNATURE-----

--yQbNiKLmgenwUfTN--
