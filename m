Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3KPQGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 11:06:19 -0500
Received: from sauhun.de ([89.238.76.85]:51549 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3KPQGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 11:06:06 -0500
Date: Sat, 16 Nov 2013 17:06:02 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-i2c@vger.kernel.org,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Fallback to of_node of parent
Message-ID: <20131116160601.GA8723@katana>
References: <528791EF.9060505@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <528791EF.9060505@koalo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +	if (!dev->of_node && dev->parent)
> +		dev->of_node = dev->parent->of_node;
> +

That is not enough. Current drivers could then have the assignment
removed and even more important, this behaviour should be documented.

Regards,

   Wolfram


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSh5fpAAoJEBQN5MwUoCm25B4P/RSu2lUvlTiCC0juQ14xPItg
9W+MTd/1HD6uCKly7aO8Gsk5JZHhm2sUCCACtrJ94pDgm/FTwUc6dVdsvF38Vgxd
fTcaRYdOtqwMBWW3Pa4+PJuMFnIuWwkeIrF8+XweqFQMcnfPhDgsabKxQue/1EMk
Kn8zGdlhmeixISQ7zVtnIxQjO4zDQkCd18j8btaw2xuvmzZHOzkWTitvKXP6DjMk
nPVP/M+3J9217XBd3t9cGY+lZ8R0ZlcSVP+TonUOGa93kjjQr3I2xixlqseu1xOD
fFTlXaTYgY+Wa2xGP/QZtx5ttYLQzqSfcNs98XpgAXJ/DUCfACHf1kOJLhvNtoPd
f2r5wckNoQNF9x6/Hgxh2LaleRQtovX4rO+g03Mr2/uPxrixrUhuDbycWKGwlh+7
15/RGJ4RQY/sxdwi0+DjNGy76UfFokUhW4nxxL+14hIJoevRV3SlGUfZbl3S2o6+
PmnGt15vQmoPmbysZy6sqDVEBwwfks9R4KW3l7V3NfV6JTVlEGuf5qN+HK3D4vfj
vMPoN54xddpXMT5F5Xnni3wKNzZdrEHAQcYa1hOYAdFcDFIAiEPE53yZvrqst7js
al0+nBVG8UPdGWQWRTKWaMk9dGp+TTWyglobS27mTdJpkKeZMf6XUH1myhf7l6ti
hNnTZOZbJoimWgda6lwX
=MHLQ
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
