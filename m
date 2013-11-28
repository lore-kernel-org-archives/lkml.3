Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab3K1NsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:48:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34418 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3K1NsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:48:04 -0500
Date: Thu, 28 Nov 2013 13:47:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131128134757.GJ27568@sirena.org.uk>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8tZVdKiiYitVG083"
Content-Disposition: inline
In-Reply-To: <1385626183-22990-4-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/5] rtc: s5m: Limit endless loop waiting for register
 update
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8tZVdKiiYitVG083
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2013 at 09:09:41AM +0100, Krzysztof Kozlowski wrote:
> After setting alarm or time the driver is waiting for UDR register to be
> cleared indicating that registers data have been transferred.
>=20
> Limit the endless loop to only 5 retries.

Reviwed-by: Mark Brown <broonie@linaro.org>

--8tZVdKiiYitVG083
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSl0mKAAoJELSic+t+oim9IpkQAJhrj+Zm3eHK9rZX0R9/MXYp
sK3GFnkU4NFKBx17ExZjN7xyGEsfCmB7PiOZMykRX4JoVoducQelPGFy8ml6qYKk
mz4F97gdJlzhR1lmUArg25C05bIxdiSD06h+NFdQmVeCGhlLYTgkXcKFx5hPg4w3
wAi/+RmkO8fmmlZKtrPyuNIHmY4urn3ZyAB908dr5pFEVCD3aMVh91iiIdtLXZy4
g0L4jhUK/tuGBCOg7yixNPVI8eco7tYbl5WMISokXy9x1W/OmQpc/Y8DJPtYTl45
x/ivQnXJulSG2hzPFLACaHmPB6K2NS8+YNS11fL6fTL5aPYWJnLwCY7E3HW8Bq0T
5FfbHPhZgL1Oc0eD4Fjyy8mn1vDVsdFR+lPtnrjPI8eeYMj70sTn1iwOAts9nqHP
2MczfDjqBKjU2hVkyKD/+yjKyDFihP3HbHMjH5B1sKXKe7sFIsVmgN3WGt4ygO6o
GyJh+8rvdq+RR3NGR7XBk3RvPiZnbjj1+kA+FYyDL1izSUVAM07fnwz1s6M8niRk
lDhLk3Bg/Jcs7S8FC8m9h7NnHFlfljYDo1axpQHvrd2+QwqEoTUPW60itGIbasL8
H+Wf406tyihudwCeX99ZiWv1cWiIS2LpJr2b1Sfxx52O/gKHGbA43ZTAGS9X7/Md
dvYuNxt8WFdDDdlV+LQ9
=trZe
-----END PGP SIGNATURE-----

--8tZVdKiiYitVG083--
