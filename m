Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3HMHe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:34:28 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:55705 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3HMHeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:34:23 -0400
Date: Tue, 13 Aug 2013 09:34:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm-backlight: add "max-brightness" property
Message-ID: <20130813073415.GA9316@ulmo>
References: <1376345057-29895-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <1376345057-29895-1-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 03:04:17PM -0700, Andrew Bresticker wrote:
> Specifying each individual brightness value via the "brightness-levels"
> property can be a pain if we want to use a large continuous range of
> brightness values.  Add the property "max-brightness", which can be
> given in place of "brightness-levels", that specifies that all values
> between 0 and the given value can be used.

This was actually part of my first attempt at a DT binding for this
driver as well. Some discussion ensued and we ended up changing the
binding to what it is now. And I think there was even an attempt already
at adding the same thing you propose (albeit under a different name). So
instead of repeating myself I'll just point you at the earlier thread:

	https://groups.google.com/forum/#!topic/linux.kernel/UkXktWt6zI0

Thierry

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCeF3AAoJEN0jrNd/PrOhms0P/RUg93nY7tRIkL9NrmlRXX/H
ZOCCwhwWQykCCzE8WPoFsoem43vL0uvZVHet/20U4bZLy9IM5uqOJiXcut4hJe+S
X8jg+xkNzAJa+A5fiZiEWqLSRdnROYsLpjka8EQ+31/NJ38r6oJz6E/0IxRYOJ2W
mY9DF9DauTIPSKuJ+7ODC+3/STa4VOwU1tjEDmSeG49I16Ol1iUhw0GQpPVl/uNn
uAKzPiTN15T/lsb4WoDsrDBTaDXNZMyMxXf5MT8PMEdgtUiQBm1l7SrB8DqnLLjc
vTZT/cIJISGwzimae1FiwqccVuD2j0CdCoF0YQm4q6BZmimPdvTlQ1bVPLLt3kTQ
yy2XyWE7G7iQnrp6OFeuDI8wL8b6IHIE6KUr7I8x6Ic7BMKNA54uu87JFQpT21ym
h3PykGuXnaZXwflGU541VMDJ9KXJ34KnX7aOjj+rWiZic3GZD9jnCF8BSj5bVtED
fB/jPLwpIMOv15QhNfePB7rW3oyAh6Tj+dURTERG5+f5255wjA1b2Dauadu5fFB7
a9gzp+9guvWh8vbTVRo9zSbOILaQIURPTeOvOlnWJn4Ae5CUruqd6Vw2GA3/yWCD
lY8tFlMJ7YabcHZXCP2yfqp06Vn+5so7XZqbuNzTI1smd+idVP5uKsDfSleKQoCu
jvzvVRetD/USCRigqzxu
=ywAf
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
