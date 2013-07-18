Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab3GRP2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:28:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52265 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab3GRP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:28:42 -0400
Date: Thu, 18 Jul 2013 16:28:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, spi-devel-general@lists.sourceforge.net,
        grant.likely@linaro.org, rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130718152837.GS22506@sirena.org.uk>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
 <20130718104233.GG22506@sirena.org.uk>
 <51E7D569.2010709@ti.com>
 <20130718131822.GN22506@sirena.org.uk>
 <20130718133158.GA1628@arwen.pp.htv.fi>
 <20130718144241.GO22506@sirena.org.uk>
 <51E801C9.60609@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUHu8oqV+HCwPlU/"
Content-Disposition: inline
In-Reply-To: <51E801C9.60609@ti.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUHu8oqV+HCwPlU/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 08:25:05PM +0530, Sourav Poddar wrote:

> there is a QSPI_INTR_STATUS_ENABLED_CLEAR register, which indicated
> the interrupt
> status.
> if nothing is set in the above register, I should return IRQ_NONE.

Yes, and/or complain in the log.

--CUHu8oqV+HCwPlU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6AmiAAoJELSic+t+oim9g44P/1rjoLOGRA2eKexrsxH8Vg2r
LrHGRH04kkrxYFrRLY8TUKxyxwrKmS/n4mVg3fSec+z+kIAsCmwdeolkmQLeBCJq
iwyCxneI0V5+Dvo5+8WCjESpB1My4hV+3yH1LDdFYdZKToPXVssAMSogz0LX6VsO
iXIoPwf5P0gfXI4WCWpdhKXsg3eoHy14KQKz8eRDr+4Ft+XpCoxuGJTUAqk6FKPE
1EkQtY3bPPjmj3gmlHknaiawQboAnMI7juNEzyHuWQ5sIjdwQGkg4R+Dve3IwCny
bfxv48QGVp0gQAI33OEnN7U+UlW2JqcEw0iEjKH1JGfg5a8p3NnMYsY0K0ahlmfC
bhw3nhujVoC4dujud8oI4GwWC6xNCLP4kGxTjFxjARLflXFW+LmVMwc7mOtGzcwc
KwSwR6zdWZTJhBbtacgL1rzYGBoZPYnBQg31zSd79fmb35Dx2mgmK/Ygpss8Jd16
dqHMPS829SsOyZYpTh7iHEw0D9qGfQwuBpTXJcvFi2vzrUVTqMBv7bdpmjDKIWc3
bPYOUHUYFfffKkq5ypCKUpleZ40mD6GNEbb5ZfZvfsA+UTKwXozMbGgPQUARspvS
GGTdS72HeAxdehPUbWwXijrMxwT5F8IsQVTg0dBDCd7qaagDo+cXA3Z2JHPOvJxk
hXNL7vGhRM913eK7YkdP
=6pML
-----END PGP SIGNATURE-----

--CUHu8oqV+HCwPlU/--
