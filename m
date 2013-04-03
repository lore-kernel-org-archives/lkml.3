Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254Ab3DCJf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:35:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56367 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760110Ab3DCJfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:35:55 -0400
Date: Wed, 3 Apr 2013 12:35:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Subject: Re: [PATCH 04/12] usb: phy: ab8500-usb: fix eye diagram for ab8500
 v2.0
Message-ID: <20130403093538.GL25837@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
 <1364978713-19612-5-git-send-email-fabio.baltieri@linaro.org>
 <20130403085336.GJ25837@arwen.pp.htv.fi>
 <20130403085858.GK25837@arwen.pp.htv.fi>
 <20130403091200.GA3909@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MsEL38XAg4rx1uDx"
Content-Disposition: inline
In-Reply-To: <20130403091200.GA3909@balto.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MsEL38XAg4rx1uDx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 11:12:00AM +0200, Fabio Baltieri wrote:
> Hi Felipe,
>=20
> On Wed, Apr 03, 2013 at 11:58:58AM +0300, Felipe Balbi wrote:
> > On Wed, Apr 03, 2013 at 11:53:36AM +0300, Felipe Balbi wrote:
> > > On Wed, Apr 03, 2013 at 10:45:05AM +0200, Fabio Baltieri wrote:
> > > > From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
> > > >=20
> > > > AB8500 v2.0 has eye diagram issues when drawing more than 100mA from
> > > > VBUS.  Force charging current to 100mA in case of standard host.
> > > >=20
> > > > Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsso=
n.com>
> > > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > > > ---
> > > >  drivers/usb/phy/phy-ab8500-usb.c | 14 ++++++++++++++
> > > >  1 file changed, 14 insertions(+)
> > > >=20
> > > > diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy=
-ab8500-usb.c
> > > > index 5b92a59..1fd0780 100644
> > > > --- a/drivers/usb/phy/phy-ab8500-usb.c
> > > > +++ b/drivers/usb/phy/phy-ab8500-usb.c
> > > > @@ -485,6 +485,18 @@ static void ab8500_usb_phy_disable_work(struct=
 work_struct *work)
> > > >  		ab8500_usb_peri_phy_dis(ab);
> > > >  }
> > > > =20
> > > > +static unsigned ab8500_eyediagram_workaroud(struct ab8500_usb *ab,=
 unsigned mA)
> > > > +{
> > > > +	/* AB8500 V2 has eye diagram issues when drawing more than 100mA =
=66rom
> > >=20
> > > wrong comment style. Please run *all* patches through checkpatch.pl
> > > --strict and sparse. I can wait 2 more hours before closing my tree f=
or
> > > v3.10.
> >=20
> > you know what ? this is simple enough, I'll fix it myself.
>=20
> Ok, I was rushing a rebase but you've been faster! :-)
>=20
> Anyway, paches were already sparse and checkpatch checked, but I ignored
> a warning for "mA" camelcase (as that's how it's commonly spelled for
> regulator) and new line indentation (where I used two-tabs instead of
> open parenthesis to be coherent with the rest of the source).
>=20
> For comment style, checkpatch does not give me any warning for some
> reson.  The in-line open style is already used in the net/ subsystem so
> I was assuming that it was accepted here too.  If this is not the case
> maybe checkpatch.pl has to be fixed somehow.

right, only the net subsystem has this inline open style :-)

Nevermind, it was so minor that it didn't even hurt me :-p

cheers

--=20
balbi

--MsEL38XAg4rx1uDx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRW/fpAAoJEIaOsuA1yqREB5IQAIfaJIhdNuEwUUYO7XoEHnlW
Yp9hRxwIsmHZwU643zwvWU4ooMfp5B7akmiV+lN6YBmWaNxa1dKPP+CjyQmUA3Ag
+R6jbVlvByVr9vk/9tIazxKt3bPCwg7tWscSraZKa0kmWbQ3hWE6+rU6uIbuIKO/
KazRm8OdKLAD0WY2zgGyeu59gPzzO0Q7KanzSAU/sv4kBPp6hKRj7a4V9tmB5Flg
BCEpo1XkJ7qFA/Zx6IP4hmTYkyhsKmhfQY9jWuHEWDwSJSBcVDjStYX5YYjHLICC
D/eUoLbbB22jDVyRH4pYWqtlrh2QVVuIWSsoHEPPwR8QaN7d8yNybmE2EnG9QeES
1vMtLRpt8MLXRD7tF7OQd/zFKdBY3zUNEYoqSYriw5tZ7nohQVk+Ec+xrGh3cNnN
pZBGDiUr0Tak8A6atEBGwAT1b+ZiQqjTVI9Ls2K+SbyQIeW7pvYGw73j/baN1h94
bMPyl0Ffe/Ycq4hmVSxXTE9aqU0x6FMpMpsISLi6HBkNgvZToYapYeXX+yf6tHsl
mna5Qf55bDoYfqW7EPDXrwsM2XR7pRwiWRIMdmti2zWGYcb2LSCvHkgFFbqiI1jm
ZpX6YWIpt+ZJDK2MNvCp7qUiM0jiyRfT0LiWUYdgHbeKmDYxteY/LIS7zg1Kzr7l
zLwsaCGl0Jw0CNFwBohG
=wFzW
-----END PGP SIGNATURE-----

--MsEL38XAg4rx1uDx--
