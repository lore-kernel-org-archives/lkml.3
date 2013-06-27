Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3F0Har (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:30:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50367 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3F0Hap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:30:45 -0400
Date: Thu, 27 Jun 2013 10:30:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michael Grzeschik <mgr@pengutronix.de>
CC: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        George Cherian <george.cherian@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is not
 available
Message-ID: <20130627073033.GN15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
 <20130626101647.GT12640@arwen.pp.htv.fi>
 <51CAD977.6040309@ti.com>
 <20130626121210.GA12640@arwen.pp.htv.fi>
 <874nclghu2.fsf@ashishki-desk.ger.corp.intel.com>
 <20130627061416.GI3523@pengutronix.de>
 <20130627063526.GG15455@arwen.pp.htv.fi>
 <20130627072408.GJ3523@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ie5iOtK4e9kgqh2F"
Content-Disposition: inline
In-Reply-To: <20130627072408.GJ3523@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Ie5iOtK4e9kgqh2F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 27, 2013 at 09:24:08AM +0200, Michael Grzeschik wrote:
> > > > > right, but in DT you will define both instances and each instance=
 will
> > > > > have a seaparate snps,maximum_speed attribute :-)
> > > > >
> > > > > I'm now considering if we should make maximum_speed a generic att=
ribute,
> > > > > Kishon ? Alex ? Alan ?
> > > > >
> > > > > anyone else needs such thing ?
> > > >=20
> > > > We have a force-full-speed attibute for chipidea on the way. This
> > > > maximum_speed looks like a more generic alternative. Michael, what =
say
> > > > you?
> > >=20
> > > The maximum_speed attribute sounds more reasonable. I will change my
> > > patch to it.
> >=20
> > thanks, perhaps we can add a generic helper in udc-core or usb-common ?
>=20
> As this function is not only udc specific, this should go into usb-common.
> But right, we should go with a helper here. I will write one in addition
> to my full-speed patch as first user of it.

alright, thanks :-)

--=20
balbi

--Ie5iOtK4e9kgqh2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy+oZAAoJEIaOsuA1yqRE9J0QAIZfIbQkrL/qlgq4i5THhn20
xN3HqI0IfIheYxVthasJ/CGNPTNjgqQolSia4qUIei2QuwVh8mjAMlHaEYvUvkjC
KbG61xpOm6AuMwrRV1MY3eSdY3Oug1qmJxwBo6d1I3O/kNDxZY/UV4h71iRp0/1n
7wJ6VYiDbCfB3rRTWlj66uyawemzQHdv5ptSJ7MKCrw3S6iXON36cRwdfbI9ax3I
FUJNzZu8WgxWfg3YL0SDZwndRmOuSHa+xMF4d1Ucgk8Wv06+LGH7rGpf5mTZplBZ
qcbl+IqADgXI9TltGm621c2l5tI8IUR8w7+AOIkTgTsgKlr29/dxVT9bayPOgBil
LVofxlKzKP0nPRPRCAiGwV85DMmRAptZxOHop+kQenFqJ1xSG4u9GA/zkbVpBDKC
LSODPenqUTeEGalaK0DjPq1MdHfpK5h2o9IRL3ngmHenF7w20wW/n+cPM/2LIc+y
f5+k8wWxpqrXKTdzDXZjlsIEXPvgzhCDV3IDMQ+QTJcyg11rH8y0OeohMe3pvQoO
vaIoAGFlKZTC2XSwLlBXrvpEOPQBae8KmSV7V69nfc3aaXuQzBKtmtXW2K5N6nWx
1f+0gh+pFTLp/UO7V1Toj677sDzfGhEoWcsAAbXqbgJXbd9c6a4juqWql8IOzX+2
Js4z2xrUJxbuN7EK3i4d
=obh7
-----END PGP SIGNATURE-----

--Ie5iOtK4e9kgqh2F--
