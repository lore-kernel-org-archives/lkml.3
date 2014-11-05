Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaKEJvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:51:15 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40290 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754602AbaKEJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:51:04 -0500
Date: Wed, 5 Nov 2014 10:45:43 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Priit Laes <plaes@plaes.org>
Cc: linux-sunxi@googlegroups.com, Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH 3/6] phy: Add driver to support individual
 USB PHYs on sun9i
Message-ID: <20141105094543.GC27686@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-4-git-send-email-wens@csie.org>
 <1415081773.665.1.camel@plaes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <1415081773.665.1.camel@plaes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 08:16:13AM +0200, Priit Laes wrote:
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
> > @@ -153,6 +153,18 @@ config PHY_SUN4I_USB
> >                         This driver controls the entire USB PHY=20
> > block, both the USB OTG
> >                         parts, as well as the 2 regular USB 2 host=20
> > PHYs.
> >=20
> > +config PHY_SUN9I_USB
> > +       tristate "Allwinner sun9i SoC USB PHY driver"
>=20
> Adding 'A80' to the user visible data makes things a bit easier for=20
> end users:
> "AllWinner sun9i (A80) SoC USB PHY driver"

Until some new SoC part of the sun9i family comes up, and it will just
add to the confusion.

Plus, who the "end user" is for a Kconfig file? My guess is that it is
a kernel developper, or at least someone with a good kernel
experience.

Such a person would know that the A80 is part of the sun9i family if
it has some knowledge of the Allwinner SocS. And if they don't, A80 or
sun9i or both won't make any kind of difference.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWfHHAAoJEBx+YmzsjxAg3QsP/j6JKI7waKgyqTA4dSMUuPkD
uJ/g8lHFoXPV0aZJl47R5js9rqBODO7zvuo5i3NDR30oYGBbHd0ORwitOCDwy4LF
kE3WMFUuY5h3/6zq/g0kP1HYb9wtgcIHNZQvpAUN6he3Vbo4v7h/C+y60Dmh/ncY
bNQX9LO265mpu2oohd1Qf9LBfWxFaW5U0cFOjxaNNcoJtvdoIIMMX6DysUCghD79
UWD+pupozJ1Dob3Wt65LiBQ04djWe9DalJreuUVowvx0cmEwWZyMR5WoTpk+Azmd
PqLKSueVLo7b8DmJexiTNXgsdgbnZ9gGxudEnDLojheeuY2rRYoliSeOOB3PvJo3
CEKP3QkqoAudHEurcghPp+NcrsdDLWjmkQ3PSH/gNduoOjRa9nuOyLgzZxLqeyJ5
h3KO/UfgIg1RaG6/pm39A7+PbzqyEfD4QpwexRLW4SBz5zmNClCZTbKfDBaOoEuD
+04AbY9j9Sq5SSQbrkOL9P72MGDA+OgEgSpS76lXOfxwQceqGFg3wy99cc+TnXKr
tSOrjPlUuJbJt3V8mxq/TPmrBiPM8x7OaHtg2KfwO0Vw3W4bBHY5RBeRVI7MsjE+
l+YDPxUWZJqmgzCAss/87Ze0/mAwVHhEvT6ARgvExnlFfRf+dNBYatw8LwDvgkH6
hFUcKUzAM1KyhAJ7Kd6/
=OzeO
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
