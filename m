Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3LBNlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:41:51 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57366 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3LBNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:41:49 -0500
Date: Mon, 2 Dec 2013 13:41:10 +0000
From: Mark Brown <broonie@kernel.org>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
Message-ID: <20131202134110.GH27568@sirena.org.uk>
References: <201312012047.02299.heiko@sntech.de>
 <201312012047.42669.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cjNfFEtZoUGcCUIb"
Content-Disposition: inline
In-Reply-To: <201312012047.42669.heiko@sntech.de>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [rtc-linux] [PATCH v3 1/2] dt-bindings: add hym8563 binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cjNfFEtZoUGcCUIb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 01, 2013 at 08:47:42PM +0100, Heiko St=FCbner wrote:

> +Required properties:
> +- compatible: should be: "haoyu,hym8563"
> +- reg: i2c address
> +- gpios: alarm interrupt gpio

Why is this specified as a GPIO and not as an interrupt?

--cjNfFEtZoUGcCUIb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnI3zAAoJELSic+t+oim9mJMP/jV7/3NN0h1XZsWJouY0MDpn
yR0rv4J1AirhVArU4fDUJiDHVBIRyTIQCB5kWYq/0ztjrIFFj3IaCLXI52v8EYv1
BVuW+YPvmjFD+HRRslOkT4YfiBEFEd8qi6VFzjSKgNNHCXzzaaZTapx0YWXmNcBc
RN4kBWbBKo5/GHjH25YxnhphF38k6k0fPIFhnUGthpywgFCPPbjpBE7SVcxDlzqD
2buqRrSkh0q8jr1FrAGRda7MEpTn4rL5tAxQANP1GyCUpXOIyAVR5w+ExWNjK1/Q
wsasWShU3QfVp2w+FDw4ETO/6KPaM2qtknStvH4wTkH7zQHIyHzhc3+i2gqWKk6M
pcFyFIroLB6ZLy0yBK33B4F9Df7r20Aj0P6LEHYQn01RJ7BcgEAR3CEusezXwWL5
CpDT0KbSgfzuesYqfVKyEr7wABKWXR4ijc0fuvXC9VLEhpCEN9YcgMpxCrRq90yn
+RjIIwAdagmFwi3X3EVFIdZTD729l9dnFpo7epjyE4fuBnEFmeBGey3VVhDEmn6d
LzuzfRMq1jNJQBnJ8jVjSiseONgcBYNMX3tT6qi1Z5vmiawtoUu10UIru87Qtx0d
VBtb/u9+YVblsnCdbIB/oEGSE5snTHbgW5b6yNDOJljil9InetBov8XQ1LawwlqY
j7b3RCD9HTjFC4utsPW3
=6n80
-----END PGP SIGNATURE-----

--cjNfFEtZoUGcCUIb--
