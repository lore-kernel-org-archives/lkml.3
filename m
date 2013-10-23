Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3JWTb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:31:28 -0400
Received: from ring0.de ([91.143.88.219]:43035 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab3JWTbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:31:25 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 23 Oct 2013 21:31:12 +0200
From: Sebastian Reichel <sre@debian.org>
To: Joe Perches <joe@perches.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv4 2/3] Input: twl4030-pwrbutton: use dev_err for errors
Message-ID: <20131023193112.GB30437@earth.universe>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1382550852-11508-1-git-send-email-sre@debian.org>
 <1382550852-11508-3-git-send-email-sre@debian.org>
 <1382552266.22433.36.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <1382552266.22433.36.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2013 at 11:17:46AM -0700, Joe Perches wrote:
> On Wed, 2013-10-23 at 19:54 +0200, Sebastian Reichel wrote:
> > Use dev_err() to output errors instead of dev_dbg().
> []
> > diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/mis=
c/twl4030-pwrbutton.c
> []
> > @@ -60,7 +60,7 @@ static int twl4030_pwrbutton_probe(struct platform_de=
vice *pdev)
> > =20
> >  	pwr =3D input_allocate_device();
> >  	if (!pwr) {
> > -		dev_dbg(&pdev->dev, "Can't allocate power button\n");
> > +		dev_err(&pdev->dev, "Can't allocate power button\n");
> >  		return -ENOMEM;
> >  	}
>=20
> input_allocate_device uses kzalloc and it will emit a
> standardized OOM message along with a dump_stack()
> so this dev_err/dev_dbg is redundant and not necessary.

I saw you sent a big patchset changing this for all drivers.
Should I drop this patch?

-- Sebastian

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSaCQAAAoJENju1/PIO/qa6m8P/3pSlYlEIrdc/ZCFHkRKfOIP
Z1TsVJLGNnXJ3uY/PEU2/fFzWBilSgrH8eK0Iuv0SFig69hJnGYw+/BWr102ACQ/
GIPJOrFM9zlCN2qgpN0rZ4i7/yaK+JKd4WlyiroRnrcC9sWPmL+b2uw0hRaDi5IV
n0Ib9C4Oi7V0J76HGz1Tzp0lT/+Z2DBfK6Y7bRqo7vLreLn1khTfjXHIGbR3e9th
wLdw3Pj2xHHfMj96xdkzNsZLvKUleKN3D7tZHh2PLaEKNZTn3eZZblScFsculkPz
Dopuc7Kjy1SQGMPy7ZY/JPCY9ZeA7HDH3zE/90kcBJF+xUROUCALq/jxovw9i3NM
Ppp0tm0+oGxOcjTSwKZTKx0CiRJ+e4TZZcMDwIJw3o3iOSLY7+JatD6hSAoDnPcw
nEMgYQJgP4+ZxlCG/2Da+ZV5u0GR7sTUaf998oBFJ8IwtLRdxkUsiaElfu4KLtk8
z6OWr1/aZ5w3rMTkVI7yriwyZjKJfi3jYFOzaQnZsJdPZ23N7U1nezXUgGWEfgZU
4MbNIreE8f8MnEUALe1DGnyE2cGSe1bdYd0D8mEVRry3VAAyJLmYWkQ9EWyNlsmN
LLDGymdDyBfJcMbytXWyXiA9ob7iMUgorGkgXzS8d6m8nYqNd+GdLliyx8Tl7Pft
v9y91ej4ZRreyun7EQwB
=+Y67
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
