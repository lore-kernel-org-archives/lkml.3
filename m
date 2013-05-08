Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3EHK6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:58:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51552 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab3EHK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:58:05 -0400
Date: Wed, 8 May 2013 11:57:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508105732.GD7478@sirena.org.uk>
References: <1368004193-21213-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fkwCrey//1f/3EP1"
Content-Disposition: inline
In-Reply-To: <1368004193-21213-1-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: ux500: update MSP1 pinctrl defintions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fkwCrey//1f/3EP1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 11:09:53AM +0200, Fabio Baltieri wrote:
> Update MSP1 pinctrl definitions in mop500_family_pinmap by removing
> sleep state and setting default ones as pin hogs, as those are used by
> both ux500-msp-i2s.1 and ux500-msp-i2s.3.

This presumably needs to go along with the ASoC side of this change but
as I said in reply to that this isn't an obvious improvement.

--fkwCrey//1f/3EP1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRii+ZAAoJELSic+t+oim95H8QAJe3zo8AhohXKAX+4QKsu3oE
MNUkDZf2hr0IB2OiE1GKwQ1p2UsAeUMusRvbdw+u1sF8NbsgToEnITr6DzJ4YOdc
JcdY8jKtGCVjK4uaSPzu4eD1ZgKEuohaY8AzrLXhAZ7B0wQmZUkudFSjXXITDypN
c8RnBYnHlZJG2cKFDqx7qmkL51ZMUa0z7wLGCf2cJbuwzp4bPR0E82+imDk9iZnK
RHLQLLz6oqv/YdNQJQbh7b5gX6stiiFKIgpnw7ZrAKUw/L++RGZXq7qx+kNe2Cjy
LI5UpxItDeMJB3EVzPv4WLAv8B/SSdgDSKlN0JqrUpDrXWBqwj7ngA+Vs+IJaPVF
Xj9OPpstKCYswMvbO+UHD5cINn711M7ouie7f+l/W3o9wMm4X96sM5pr45+Dnbg9
ujuUxGn3/QZJ/NAlf2aAtHjgin0RajYEQYCgaJdgmow2hWDYyojaeI92HyUmokbS
mXRgid5fQZQzgkgiYieHzqa3RPfuSoDZv3d0UWdyAurX6m/TxmlWZ1AkB0R2ajhs
pJIUhoDEjM8cCLjstGZNdsL79ngTqqK/oUx2C06lLtqna1m5rlhTXEV7t6m097Jo
s7tNhkB+ol/EorTK5uTKFI+N7U6fQObHY+GAm8MkOIi3isiYJRNPjDPVK/OH8k15
Gy9+BTbLrfGL4CUM0TDX
=mpQu
-----END PGP SIGNATURE-----

--fkwCrey//1f/3EP1--
