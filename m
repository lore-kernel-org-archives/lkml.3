Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaBQXj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 18:39:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59639 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaBQXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:39:27 -0500
Date: Tue, 18 Feb 2014 08:39:11 +0900
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Message-ID: <20140217233911.GB2669@sirena.org.uk>
References: <201402131031.s1DAVWrJ023725@swsrvapps-01.diasemi.com>
 <20140214093435.GI3403@lee--X1>
 <6ED8E3B22081A4459DAC7699F3695FB78F97CB13@SW-EX-MBX02.diasemi.com>
 <20140214145643.GA4451@sirena.org.uk>
 <6ED8E3B22081A4459DAC7699F3695FB78F97D757@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB78F97D757@SW-EX-MBX02.diasemi.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC V1] mfd: da9063: Add support for production silicon variant
 code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 16, 2014 at 12:18:43PM +0000, Opensource [Steve Twiss] wrote:

> Some registers in the new variant make backwards compatibility easy,
> however attempting to combine the two register maps in other components
> makes the driver a mess.=20

OK, that makes sense - if the changes really are substantial then
dropping the old revisions can be reasonable.

> I realise that the Linux community will have different aims however and=
=20
> I would like to support those as much as I can.

It's not just the community here - it's just a general thing with users,
the same issues face people using out of tree drivers (though
communication with the developers is often weaker there).

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAp2cAAoJELSic+t+oim9LZIP/2U3mYYkC/7+BmKq6l2QfWfs
kDWJ3+abdyD44Dat/DWdL+cS0SFK1cmP/EDqL0GYKCwM9sPl6UzEWZpdvzVV7FQ/
Qtwnplkv3HOVga9L4M/h3rX73iLwF1wyvAKT+9HN8Q972k+na5kZjcMxE2VqCqiV
lOskmdpa/MuUMpHnLlfO8tutY9RXeCgh2UeCPgOLl4mW4nKh4b1+SLe2GK7ejMwK
Q8zxFMmfRA6YRalE6sEiAtg+4LCO/8bkQoy2dFAcK/wK+Ui/JMvCyVz9YhutwSKv
rTZWTx0ROYBG6+9MVgXI+ASXJYDiFI4tnVvHr6kC2bvUHZ0bq3kiUScseP6kkffs
uynib0+D9/axIwFQ7wg4eEO02vtJiEvD/Km1zHHFnVuBS9nYUjAjyjzAOTJgjOiC
anOFgGsCRhVvLPCBq8Okux+I0Ig7qvT3cLTJcxHUzG6fZYnUWYXjz8S/fqrwMYCb
dHXR2qmWU6Zvggj/DtN3V/3Km9SblZPs9JT1w0WOeS2eBtolyb9W2k/PDIx86b7k
0+5UCx1zPx4jTIZazZSIlyV7QlAuEFg+CUKbm4cixFUTQDula52MrdQJn8Moo40P
X/B28b0VpequyzmprGkfMyaJc4y+6BAJCbGQemOuSZnIXT1bRUzwfcSefziDW031
rSxDQPwd8DHqSRcGke2w
=VFdC
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
