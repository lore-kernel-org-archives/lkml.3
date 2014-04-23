Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaDWMtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:49:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42905 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaDWMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:49:51 -0400
Date: Wed, 23 Apr 2014 13:49:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, tiwai@suse.de, perex@perex.cz
Message-ID: <20140423124933.GB12304@sirena.org.uk>
References: <1398078886-31505-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VVZ3M5YIAeXhLfsz"
Content-Disposition: inline
In-Reply-To: <1398078886-31505-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: core: Don't break component searching if both id
 and num_dai are 0
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VVZ3M5YIAeXhLfsz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 21, 2014 at 07:14:46PM +0800, Nicolin Chen wrote:
> The commit e41975ed (ASoC: core: Fix the DAI name getting) added a break
> within the "if (id < 0 || id >= pos->num_dai)" while the original design
> of the search didn't break the loop if that condition contented but only
> mark the ret error and let it go on to search the next component.

Applied, thanks.

--VVZ3M5YIAeXhLfsz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV7baAAoJELSic+t+oim90zkP/j9O52fsS9bzQTvWIUFMenuP
h5dmOl2ClJph0sNxbRBJORrr9YNpx4ar7m+X058Rh9OwO23j8CFejewrb9/J46LF
F4XuRhjk2ZnyPsTUwNvcb3HedOwfezH/IRBbMUhzRexXotfRpDZXtcv9yq5LQIQ+
7pzo66+2jmRUF3xUXo8mQmXoRvVB0CAYyUbiaANOrHHZEyZHwZ+ZL63UrboQq9YS
aBx+wG4eaGqnioWROaEASrz4+4TGi9exgGFgqKoWM7uepAG+UTw6EEGP1Jtzi/Au
qE1ahn44SYJw5Jjs21kzbjB88m1MhiFF38ylRZpWAu3dDv42RU7L2uQ2J9fZsEjC
4MTEFmgtmcLJ7xdXTPArvwIoDCzAtF2ZFov0aEGNb0cAbp6o6a7SIhmL+NFu6in4
2bXwO79gAqO+mV57fwCzExGNmdWR9HyLvVcee2NS4j+5yLl2suMOx8YCePNVYI5T
TYGKPI/iMwnKBLNlpDDsKtfj5hgwMurSZ7OZ/eZ4hSP3yH+bkfoabxHFAO/iVtE4
MCudMlyV9awZdUHmPeEQlKwlfqd17lZBkYvGUFYtR0X5oqUD9uDcYEejpHvPb4CI
OgEVNnoer9BDonjk1GUhH4JBKbDmsflSabpettMOL/VXFmyiiMzcNUwPzvYh/lPD
g5rX8su+FQxMZTQRlsDL
=NzA9
-----END PGP SIGNATURE-----

--VVZ3M5YIAeXhLfsz--
