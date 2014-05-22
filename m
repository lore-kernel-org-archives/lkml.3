Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaEVKbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:31:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36220 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaEVKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:31:51 -0400
Date: Thu, 22 May 2014 11:31:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        dianders@chromium.org, jerry.wong@maximintegrated.com,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <20140522103137.GE12304@sirena.org.uk>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
 <1400750228-13750-3-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AV6bwGDIl1DgWyaJ"
Content-Disposition: inline
In-Reply-To: <1400750228-13750-3-git-send-email-tushar.behera@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: max98095: Add master clock handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AV6bwGDIl1DgWyaJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 02:47:08PM +0530, Tushar Behera wrote:
> If master clock is provided through device tree, then update
> the master clock frequency during set_sysclk.

Same issues here.

--AV6bwGDIl1DgWyaJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfdIGAAoJELSic+t+oim9O6wP/1P9klcj7qRF6QcyX1jclMzz
JRFmSf+Z9v9WuqNiD3TKJUMUjIVvy6YgY5xq8o4NX3IKYABNtoxgek/9pKxCQeWy
jheEjbCn3moVIpioYXLeK704xeUqLuKSnrvG12Qa2xwwZZQjqfBYKNJkEsmuJZp5
BMtfTogBVuNOYz6gSPVv7Rb3d23Zmckd2Otb7mKbv9N3THX/aRCJgQLJjpKQn5+4
JYj6s/nmrgEzCCQ4R77YE4kDinaY2a6nF54RsmMyw9WXcGOVpz5CHpv3WDMtg474
1H1n5HsCeFoNWV70xSvlXPhWql99If8ka5xI3Uhj2thCENn4Id3HiM+mkYaFP0f/
6GtyjD10mLARSmAbImjLfn/BQ7qJzZQZbMVEp+Tz3xYwhbc/wAdjRImkwdcRTnrv
LkDt/IQ1HUz3kciEhy8jVhBCfwvRIdurGeNmkN5hBkF5oSrsvJyBhm4PZ67yy3nZ
YcSb7VWIV+ltR7KtvLrr9cXs3nDfTMob92ETM09pBjqXn4/vIOVZiWtUed7it1zv
Abak2Brxy5f+df4dqqnHMHaUzIXwBCpvjpKTURFudyD36Mc4EfJy2cE2lTLo1qSk
FIUPXDH7OtXkpKTF8FhAisdpayumKn1rTDWxoyWHzE98XJEDo3uFN9jo8zOCyCN2
2m1C5+AeOmvKcuPEplBQ
=YGih
-----END PGP SIGNATURE-----

--AV6bwGDIl1DgWyaJ--
