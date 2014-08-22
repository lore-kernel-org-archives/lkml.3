Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaHVB0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:26:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54077 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaHVB0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:26:37 -0400
Date: Thu, 21 Aug 2014 20:26:22 -0500
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: atull@opensource.altera.com, jdelvare@suse.de, lm-sensors@lm-sensors.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Message-ID: <20140822012622.GS24407@sirena.org.uk>
References: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
 <1408659686-29106-3-git-send-email-atull@opensource.altera.com>
 <20140822003650.GQ24407@sirena.org.uk>
 <20140822011810.GA17461@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eV6hq+iIxLRNwbYS"
Content-Disposition: inline
In-Reply-To: <20140822011810.GA17461@roeck-us.net>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] pmbus: ltc2978: add regulator gating
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eV6hq+iIxLRNwbYS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 21, 2014 at 06:18:10PM -0700, Guenter Roeck wrote:
> On Thu, Aug 21, 2014 at 07:36:50PM -0500, Mark Brown wrote:
> > On Thu, Aug 21, 2014 at 05:21:26PM -0500, atull@opensource.altera.com wrote:

> > This all looks very much like pmbus could use regmap and then the regmap
> > helpers.  I'd not insist on it though.  What I would however suggest is

> Not unless regmap got extended recently to support quick, byte, and word
> smbus accesses at the same time.

Depending on how you decide which it quite possibly does - if it's based
on the register number that'd work.

--eV6hq+iIxLRNwbYS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9pw7AAoJELSic+t+oim9I8YP/3fxE8mTRYRNcShnaQi0RNox
SQV3BtIGhKtEfQo7bZTvynT27JeKeQoh0JCU9SqdDbpLKrqgbP/CAqd/E6z97xxT
tCF+wB+iHlHG1Xd4uMuoHzdbUEo94zlm3TA8hwkqK0lrz7fRl8Q6K08DBkzCuT9p
+Xyez0epnYMzTkYriE1gQqbm7My4uRZ3MgDRpBnjZ03ljnyVzdoZvijgLks3R2wD
nnxWG2Af2gIBcbtcpwjeCrVRq0qRktUj6bsORqH6eIhbUqGECtfhXC1CpzZaPruu
3g1nRy1bds5mgS7yHS0jzxyJR9FIlZlIAGarGNP8oJ1FRm/LERGpQ1UMp29WQXdg
+akTj3M3b4bm2LR1pzWocg3cEU5UMsynmKNUKkI4n6UequFiqgc3o59SYl+/Z2Wi
AZfHSoN+jHAedMA2B9J1qSHHT1ZX9U3jqXbi+Np+FTuk84aZjfOSdD9do3p5/Y/q
cMAZBHo6+Ky0sTr7E3+/QxStaZfYnhE3Ib5E7ScCfyQQ7Win1pIiIXzgoZh7/ieD
i3naTY535FqQ5fv1mY6nl218YfkSj+ZPNwDInxq3YaJk/DEt9DGcJ0Bj3zqDmD4N
t9rSgMRCPy8LeAdPHFj+ylWIIoDS+Zbx6PQVpLl8EuZJ9zaAWh7eh4GaY5Ppw70o
q1XoMED8yzEGf1RmP/g4
=a4Kt
-----END PGP SIGNATURE-----

--eV6hq+iIxLRNwbYS--
