Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170Ab3DCI7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:59:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56228 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039Ab3DCI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:59:15 -0400
Date: Wed, 3 Apr 2013 11:58:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Subject: Re: [PATCH 04/12] usb: phy: ab8500-usb: fix eye diagram for ab8500
 v2.0
Message-ID: <20130403085858.GK25837@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
 <1364978713-19612-5-git-send-email-fabio.baltieri@linaro.org>
 <20130403085336.GJ25837@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9/GiYV45wF7IL3Iq"
Content-Disposition: inline
In-Reply-To: <20130403085336.GJ25837@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9/GiYV45wF7IL3Iq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 11:53:36AM +0300, Felipe Balbi wrote:
> On Wed, Apr 03, 2013 at 10:45:05AM +0200, Fabio Baltieri wrote:
> > From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
> >=20
> > AB8500 v2.0 has eye diagram issues when drawing more than 100mA from
> > VBUS.  Force charging current to 100mA in case of standard host.
> >=20
> > Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.co=
m>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > ---
> >  drivers/usb/phy/phy-ab8500-usb.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >=20
> > diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8=
500-usb.c
> > index 5b92a59..1fd0780 100644
> > --- a/drivers/usb/phy/phy-ab8500-usb.c
> > +++ b/drivers/usb/phy/phy-ab8500-usb.c
> > @@ -485,6 +485,18 @@ static void ab8500_usb_phy_disable_work(struct wor=
k_struct *work)
> >  		ab8500_usb_peri_phy_dis(ab);
> >  }
> > =20
> > +static unsigned ab8500_eyediagram_workaroud(struct ab8500_usb *ab, uns=
igned mA)
> > +{
> > +	/* AB8500 V2 has eye diagram issues when drawing more than 100mA from
>=20
> wrong comment style. Please run *all* patches through checkpatch.pl
> --strict and sparse. I can wait 2 more hours before closing my tree for
> v3.10.

you know what ? this is simple enough, I'll fix it myself.

--=20
balbi

--9/GiYV45wF7IL3Iq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRW+9SAAoJEIaOsuA1yqRExpEP/3SJe5HNSAua89pA1S1L0nWw
hgm8fZdfpWiGJ93Folwk4c4qln5p7xUaCuCbaaskbK8a5BigzZUQgsSMW8sut77y
nccI+b577ucwzbZA6lTiyXfPhjJV5SAD7+ls9tedzv4nc0EfYni4NWUo7tiFBhwv
EH4cHQmAvJtzGT3lMAQhq3JXi90B28DmxPCs5sdhOBwAE/pHRyc5eD5O6uA3BeH1
fB6pthr+y4ll6JI+pdPsDbnD8jDc3zpQ4amUzautSYH75JdXovXFS+5RLAaP9nAC
s4FPK9NKcjc5N5wjYQ4kolhh+p4o19XdZQf90fS3a0x3hnitydcY9SRjhcaqma94
A/7y1mxU1Nk66P15jExQq+wVmpzC0FWUkVorpgybhrvn/jJzqxEqpW3W4YL/j+vT
T+sNCs8Tyr4fnkzyHFwzTI++1JqcvNXehMtcWH/M7GZdj5q9Q+CzhVbaLAtBJ6qE
7Fkd8ZzSzmFHOk+Rp0jZRhsk8whSQKaeaSsTwg4a4MhnJzyT1BFXrHAJaVIU6T/F
r7H8z5eUutTYDzVXZqnnFoQAQEByue+N6JoAFrRa31zS00ddtcmvHFqVgprdjrN6
VRA/ZZEVN2yqGnn8l9kkE6gjtR+Bx5yG5OlsmZK/hTHwF+6bWP/rXJIxPXq+dRmI
nuue509QlGLYR1cvteys
=BE9z
-----END PGP SIGNATURE-----

--9/GiYV45wF7IL3Iq--
