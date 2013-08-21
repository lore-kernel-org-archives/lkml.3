Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab3HUS3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:29:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36451 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUS3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:29:17 -0400
Date: Wed, 21 Aug 2013 19:28:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Florian Lobmaier <florian.lobmaier@ams.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Message-ID: <20130821182851.GJ26118@sirena.org.uk>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
 <1376997210-32631-5-git-send-email-florian.lobmaier@ams.com>
 <20130820120800.GN23699@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdEQJo40s7ofW8iR"
Content-Disposition: inline
In-Reply-To: <20130820120800.GN23699@lee--X1>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] mfd: as3722: introduce regmap support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdEQJo40s7ofW8iR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2013 at 01:08:00PM +0100, Lee Jones wrote:
> On Tue, 20 Aug 2013, Florian Lobmaier wrote:

> > Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> > ---
> >  drivers/mfd/as3722-regmap.c |  417 +++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 417 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/mfd/as3722-regmap.c

> I'll leave the review of this file to Mark, but it should be added
> either when you start calling the functions, or at least before they
> are used, or else the preceding commits won't build. This would cause
> someone a major headache if their bisect landed in the middle of your
> patches.

Mark wasn't CCed and only happened to notice this on the list...  might
be worth checking!

--sdEQJo40s7ofW8iR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFQbfAAoJELSic+t+oim9escP/2LlwE3AhbkhjMYqQJ4UJ83P
6mqPm/v2WFlX8+BcT5DfUoe5lHlqchUXkAuEMKBFMM+WOlKc5sV5U1d+2nRK0ik3
xBitZ8qfa76OMZGaANrOcXSWRCEsqI5RujnLkJIvg6+2bOHY7s5SZjDHIOgZngZo
ep0h7U21hog3LCeksixdrKm2myrIQPHjUuqZHOWT3JchuXi/9pmCv/Rbg5wputcg
Ia37cf7Rh4sGZAqq87GZzrv1ky4DLKSfOZRnsTpmvpNdsiqIayT/MlPT4hc9Db+L
K9EoyS/28inkp3GcmUiuUi2Gl1Le5wogYGBHW7LQJxUAkb7JzfwpWabUnlL1qNv7
m4XZMKRpeptOiletFZYi09eY0dbqzK/faWVqSBgktaENV4h1xidLTHb8J9KADZ+j
c1fYUEd3qtwuetsyKjsPa83QsOUdXGe2Cym+1H6eWryHv/LXMA+98bVfAmvyzLBL
DrQ10r/ND68gumGsl+gTsVuUlvb9/ffC7HeJ/TM32lxZh8oboUHNzBY8cbPQutIq
xgkMUTOjqdpOWnisCfwGMNP28QsRYJdtJbKSrTLYJ+XSVCc+gbw8MloNViFeg6y1
iD0FV0JggmHFzLZUihpC3jfGgPWzq+/i72YI2z00DWamvfiA0A1/zmyDklb8jvJy
UjKDppuNY7yyDaQ3BjcU
=J40Y
-----END PGP SIGNATURE-----

--sdEQJo40s7ofW8iR--
