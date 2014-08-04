Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaHDOrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:47:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45874 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaHDOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:47:43 -0400
Date: Mon, 4 Aug 2014 15:46:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linus.walleij@linaro.org, addy.ke@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140804144646.GR30458@sirena.org.uk>
References: <3923586.SsVg941346@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5N2+S1LJ+nNsdJJZ"
Content-Disposition: inline
In-Reply-To: <3923586.SsVg941346@diego>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.223
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: io-domain voltages as regulators?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5N2+S1LJ+nNsdJJZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2014 at 12:18:40AM +0200, Heiko St=FCbner wrote:

> As this sound like exactly the thing I'm trying to solve, is handling thi=
s via=20
> a regulator the correct general way?

My first thought is that it seems sensible if it's used as a regulated
supply in a context where just a plain regulator might be used like
MMC/SDIO type things.  If it's only setting logic levels for I/O pins
but isn't something that's being dynamically managed or really visible
to software (it's just a board design thing) then it might not be worth
it but if it might be controlled by changing an external regulator then
using the same API seems like it might be sensible.

--5N2+S1LJ+nNsdJJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT35zSAAoJELSic+t+oim9E18P/1W0TurxpNx2T3wDY+E9qhsN
kldaRs9pjcM4XxLE2FPlU9DTJXWTu3a5WV8b5ivCkHZZIIW10GFu6DBXkSluoFHm
/3F3nGPdMT+J6cv7cGoXdX5p6MrepwzzP/EdUBJNaOJIbv4cNkFbAtlyDmid4I0S
FzyyCE7/e0cFX1d8NAukk28ArmZ+/ZJQ0Xb9SodoAWwl2Bs7T2Q2GSS4lku1uyoG
KgzN1OutNr1JKn7SIGyLf//aVh2mwM8plZu3iqF5EPNTGk4GhhxRWqDXZuWF2+oc
uPKcVz8aDXfEzY4mp785jgG1eS5PzXym1n+rrsSr/+m8gRM/YQQux4KWL4OeZNiD
2ZuoUg/SU1wHm65LSRl1l1WOtfqF0gHQZu9gOp9cQ2butSQid2hJ1vWeOGjPdUQS
mp8lEbLUq7DV3Gq7cxLeuk0gQrfJdZRV9xbyHMtSLsKySTf5HT6Vkp1ak/aWH09D
L9SmUN0cPYFvdOfAd93tbbj75O7mCTIV5oV+1gmSwxKNVHPyDYSVITzrKjzs/655
savMoJKFmTSmwHAU4n/rhU24D28iyd+hxErSa8lFd7pqFX1kQFJONwzcRnAFQVDc
qg/w2hAGCfPxPryUhHwcnWkgEuoVXyGru1Xfr8dfT6Dgew3ChQVK3XDMEtEdJXn2
edI5w9djHvVYeS0crsXn
=1OB5
-----END PGP SIGNATURE-----

--5N2+S1LJ+nNsdJJZ--
