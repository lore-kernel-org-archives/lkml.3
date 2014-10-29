Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaJ2Kce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:32:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54996 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbaJ2Kcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:32:32 -0400
Date: Wed, 29 Oct 2014 10:31:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-ID: <20141029103140.GY18557@sirena.org.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
 <20141028223121.GH18557@sirena.org.uk>
 <1414574413.18868.6.camel@AMDC1943>
 <20141029100142.GR18557@sirena.org.uk>
 <1414577934.18868.7.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xsYrt8mWir//dmFZ"
Content-Disposition: inline
In-Reply-To: <1414577934.18868.7.camel@AMDC1943>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xsYrt8mWir//dmFZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 11:18:54AM +0100, Krzysztof Kozlowski wrote:
> On =C5=9Bro, 2014-10-29 at 10:01 +0000, Mark Brown wrote:

> > No, this isn't suspend enable control - this is normal, standard enable
> > control and the device has no suspend enable control.

> You mean that for such regulator the driver shouldn't implement
> suspend_enable()?

Yes, if there is no separate control of suspend mode in hardware then of
course the driver shouldn't implement operations for things it doesn't
have.

--xsYrt8mWir//dmFZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUMILAAoJECTWi3JdVIfQl34IAIU09lINYcxSvqRF0ZWXjFp/
u7O7oIGMAPbZ5KKfuiDXQB2ia0NvKEQUrZMAfDOcs7tt2ZI6y3p3Q3VM6S0Eo6ac
zqEObwWNS5wo4GtIJslXDiuutFi8ww82HoWnbT6yjpUlun+fSs/Q/Vs4MQTTJVOJ
ALn1Z82x0DepYtI1l1BHLCIVrVsMvFcTwPWLwAOXt7+TYQj8BfLrU2YvdDf0XhBA
y8GFcu8EhW4y3ExPFJDiggNHd/i7R+NZc36pDXEbFt2J0uj9/yr0HQXBJY62+uum
yQkPfRBv6znlPj5hlheHkD90y8ulYZIoEnFeLF+rq3vuI7Z5XFHxM4PRWWySikE=
=B9Jq
-----END PGP SIGNATURE-----

--xsYrt8mWir//dmFZ--
