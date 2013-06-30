Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3F3IVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 04:21:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49967 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab3F3IVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 04:21:06 -0400
Date: Sun, 30 Jun 2013 11:20:54 +0300
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
Message-ID: <20130630082054.GA2634@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130626101647.GT12640@arwen.pp.htv.fi>
 <51CAD977.6040309@ti.com>
 <20130626121210.GA12640@arwen.pp.htv.fi>
 <874nclghu2.fsf@ashishki-desk.ger.corp.intel.com>
 <20130627061416.GI3523@pengutronix.de>
 <20130627063526.GG15455@arwen.pp.htv.fi>
 <20130627072408.GJ3523@pengutronix.de>
 <20130627073033.GN15455@arwen.pp.htv.fi>
 <20130628180000.GF25498@arwen.pp.htv.fi>
 <20130628200601.GK3523@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20130628200601.GK3523@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 28, 2013 at 10:06:01PM +0200, Michael Grzeschik wrote:
> > > > > > > > right, but in DT you will define both instances and each in=
stance will
> > > > > > > > have a seaparate snps,maximum_speed attribute :-)
> > > > > > > >
> > > > > > > > I'm now considering if we should make maximum_speed a gener=
ic attribute,
> > > > > > > > Kishon ? Alex ? Alan ?
> > > > > > > >
> > > > > > > > anyone else needs such thing ?
> > > > > > >=20
> > > > > > > We have a force-full-speed attibute for chipidea on the way. =
This
> > > > > > > maximum_speed looks like a more generic alternative. Michael,=
 what say
> > > > > > > you?
> > > > > >=20
> > > > > > The maximum_speed attribute sounds more reasonable. I will chan=
ge my
> > > > > > patch to it.
> > > > >=20
> > > > > thanks, perhaps we can add a generic helper in udc-core or usb-co=
mmon ?
> > > >=20
> > > > As this function is not only udc specific, this should go into usb-=
common.
> > > > But right, we should go with a helper here. I will write one in add=
ition
> > > > to my full-speed patch as first user of it.
> > >=20
> > > alright, thanks :-)
> >=20
> > Michael, if you need any help with patching in maximum_speed attribute,
> > let me know as I have some time to work on that part.
>=20
> Feel free to begin with anything. I am currently short on time.
> Do you need some pointers?

not, really v1 will come on monday.

--=20
balbi

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRz+plAAoJEIaOsuA1yqREzY8QAJBVfr+9xHIGhPF4GJOADpJk
bRkjLZu/HRbq9Z9UT5elWmufWMuf6DygVzaiEgTA/JJLExLEp80SZKVNS/PPDSYP
xn80hE0TiEGulLF8xZMvd0JWrZqrvnxVcr1TV3uposDDHqCW7EfKMgnUv/IA6JrH
2MeeTk+VaPA626kPIVfZXTK/XURhAJXBPoMH2/kybrKE9gaU3UkrG2RRNOWEQCGh
EO/S+y/4qWX1U0TBmAcZxFN+yN4PyX7J6DtlnB2Hcdcx/bO6HWALFbBJu51qJv3N
wzt5fs4Qak2ip4a8+FZmBMq6tkov13X0w7u32IXot+riJF3craVygxZKy+HfoOxr
TpxZz5IMHYm3ov2TmN5QdhOxJ6w6v+moApkodwrlLGglMqN43rZKdQI04MEvmghu
HQtJyABQ9kjCGFW+OZIQIuE3nLgj+xg+rycMX8xJSC5gSj6HUpsxvFtR/KUYQ2us
YpNfPJu2OLxROX0cz4hhtJL7Fj6pX/NYlH8wUXoiwgGl2aPD1fvfxDUe0+Mnralv
eqIUX+PINlsgmXzCi0WcVNEE+4J5SUNJwv7IRaiVxb+nB+W1PQWSOG+ZH3xZzM0y
ibtcCsfkVfDo4XXoshQEMScB9iKT8WBygCTOsdvX7hQoYtad/vTPZ4s+5nhTTpyD
TqriesaHiaJB5vlM1f0L
=Pjbb
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
