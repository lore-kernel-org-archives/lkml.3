Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161212AbaDPUv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:51:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35380 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbaDPUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:51:52 -0400
Date: Wed, 16 Apr 2014 21:51:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Michael Spang <spang@chromium.org>, Sean Paul <seanpaul@chromium.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140416205136.GZ12304@sirena.org.uk>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
 <1397672724-9063-1-git-send-email-dianders@chromium.org>
 <1397672724-9063-6-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AVsU0XxfC6ed1aQ6"
Content-Disposition: inline
In-Reply-To: <1397672724-9063-6-git-send-email-dianders@chromium.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/5] regulator: tps65090: Make FETs more reliable by
 adding retries
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AVsU0XxfC6ed1aQ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 11:25:24AM -0700, Doug Anderson wrote:
> An issue was discovered with tps65090 where sometimes the FETs
> wouldn't actually turn on when requested (they would report
> overcurrent).  The most problematic FET was the one used for the LCD

Please don't send new patches as replies in the middle of threads, it
makes it confusing trying to work out which versions of things should be
applied.

--AVsU0XxfC6ed1aQ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTu1UAAoJELSic+t+oim9gdQP/jgL1zeFa70WHw73//08m5pc
5iiD5gVA1IYjfbVNMlP1qclGO+PvK5bEQ/Su8pTnB1idN5OTiyksubFSmCHNAUyf
Jw/Gwd8ZHX7YlZcmZyFvoHM5+zGMMEGvNTXwe6es48kcUOLVXBzyJ5kLBWgQQ/1T
1hSWtV3imc6SmX8tW3t+uV4SFRHoqi2U3C0KDmpDy8iOOJc/lx8sNiq5T1Rfcuy7
DqTRISD1GDzfB77ao9a2RZosF4ktjOkg9sILzkQ4zXNP/cpmsKbL48J0RRCXrS7Z
zfbjte492EA76jBm70tTCMwZ7SOmKB09bVv2geM9qsd2B5gBuCyz/WRKyS+xvy71
1BqSoMSqCZ9dFrCk0j1xZJ3Uf6ksCYRRHV5dcqJAWKGmzIsH6nT9YZBNlNChzUoJ
0VVtYwU6G7Rf5YsdKHSzkUlJPSHlvxFBs+wuHPZ/V6OJ/wMJtzK6fmLcUfn4DqG4
8f5iv5pXcRshlGovFk5W0qP8A0ZaW+Me2ODj+8UKl48/9qOcaHt4Wp9UG2Ug9ql6
YNZYCmb1aYmFV4dv9m4gY9AuEjV8FFK06xRO7qSusKKCZyzMdvDs5MeGizYyxYMW
ppURY2sz/8r6DgEkxR2T18yZ0LxtKgkEHwxgRYc5EYqR4hIlPb6S4J9sjy5gjMsU
k2KzLgDFdF8Q4GOMSM1N
=UN3W
-----END PGP SIGNATURE-----

--AVsU0XxfC6ed1aQ6--
