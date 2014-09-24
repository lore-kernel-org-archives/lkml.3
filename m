Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaIXJ1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:27:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36816 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaIXJ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:26:59 -0400
Date: Wed, 24 Sep 2014 10:26:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Anders Berg <anders.berg@avagotech.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Message-ID: <20140924092621.GD16977@sirena.org.uk>
References: <20140916183431.GX7960@sirena.org.uk>
 <1410936418-26443-1-git-send-email-anders.berg@avagotech.com>
 <20140924083205.GZ4015@sirena.org.uk>
 <20140924083331.GA4015@sirena.org.uk>
 <20140924092312.GS5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
Content-Disposition: inline
In-Reply-To: <20140924092312.GS5182@n2100.arm.linux.org.uk>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi: pl022: Add support for chip select extension
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 10:23:12AM +0100, Russell King - ARM Linux wrote:

> It's fine.  I'd prefer to have seen the vendor list ordered in some way
> (since it's neither alphabetical nor numerical with its existing three
> entries) but that would be the subject of a separate patch.

> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks, applied now.

--d01dLTUuW90fS44H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUIo48AAoJECTWi3JdVIfQc6AH/jhYxD1YWc8TNFtlg3K+dqck
H8qZlGBz2Jg/44BzxNrFzdNEUndV6YfwLjm3sHqbzNIxpbXVYXiYAh8TR2kghb4I
RZ6eu0aXHav0guNpRdydtPX5bdfsEnvgAnImVoqu6ugVj8qPLnu7A1YmDO3c5EUl
ttd6VrSYSQeNnqB/WEKBPXWNYlZOTiLASHb5qo4zQ1pPbeSa5r6rbTxk2LW7asqR
0CFADe9TDfom39BENSXdLw+Y3rDPy3JyC25c3D6sAfh+H/8CppviKs40mx/jLmbI
YvIqOv8XxOpiXDm88GYqwXLqw/Rq5BoV8d9FrhpOpl0wiORsGqiSiNr/mTVlv20=
=81f9
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
