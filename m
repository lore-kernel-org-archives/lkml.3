Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaBSNGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:06:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43090 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaBSNF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:05:58 -0500
Date: Wed, 19 Feb 2014 21:16:41 +0900
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140219121641.GL2669@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eWcwVm1EAUAdFu48y_O5puu+eGvGW3k6923MdXfMa3UAw@mail.gmail.com>
 <1392383156.12506.20.camel@AMDC1943>
 <20140214210502.GX4451@sirena.org.uk>
 <1392624454.3755.12.camel@AMDC1943>
 <20140218003555.GJ2669@sirena.org.uk>
 <1392711129.14646.9.camel@AMDC1943>
 <20140219040818.GQ2669@sirena.org.uk>
 <1392804580.17652.8.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g4yiczO1Q18OVQVC"
Content-Disposition: inline
In-Reply-To: <1392804580.17652.8.camel@AMDC1943>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g4yiczO1Q18OVQVC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 11:09:40AM +0100, Krzysztof Kozlowski wrote:

> I can't only find a way to set this from DTS. There are no bindings for
> regulation_constraints->state_{disk,mem,standby}.

> Should the driver set manually after obtaining init_data from DTS?

Someone should work out a suitably abstract way of defining what these
things mean and create bindings - that's not happened yet.  It's not
clear that what's in the code at the minute (which is a very direct
mapping onto Linux stuff) are general things that would apply well to
other OSs and there's not been much demand for this in general,
especially given the tendency for system designs to become more dynamic
and use case driven (or for these things to not be configurable by
software at all making the whole thing moot).

Something that defined a single suspend mode configuration suitable for
all modes would be a bit easier I think, and/or a good work through of
how things are part of the hardware rather than software configuration.

--g4yiczO1Q18OVQVC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBKCmAAoJELSic+t+oim9zm8P/jC/2chZXD98tpC9O6K7qYt+
z3eS0T64yLYmZF0yKxihrdjhKdrbaJMEBnxhD3zJ3DY7BbfdhigR4mcW9gDRv5XE
i6zFcQbNUFgsNoeqb4Mr4THDin7hQzPY0htTtVrU2hET7hb+8SMQxu0uXvxiPAiD
ewWHaPlTIK9fbbFbE6LW7MSoxrEk0HfTDycPR/JOyCZ94x6Exl7Swj0e3yMhY+Ja
ucEFOgAsdmyTvAM50JPAoaU07nCBlpnkYmq8ei4Jfh2rnFAsp/KlCFa1uR2wvfvu
HdyL2ZPB/q2IyheiY1TMd6HJSGyGEjmxedyann4VoFi1XPzUA7HiOzYFUt4QmtdL
SJFXDWYiDJqt5yucA8cLxcnE5VOnFVv8BjEYStVVkI0BvCXBHkeSBwjQOHGnRddI
rpVysOn5zidzHnGa4oicBHtkpka2Q+c9FgKY9PQ06kJ3xh/UNQZeAg3slhB+6xp7
9TeCjupC0rbpXM+j7SnCGjQCmT2FyIzIatO7p9MIJj5u2Y4HshZ84rWSdLPdA3gS
aoJq1aPpCykq/26A0p3Cjknq8TrYIIKjntTX9VwXauC5UomlBlV0NcpCpkDJcFQu
aZkekJmhS4wSOgs8WOmbnZtJ1ESYTB8jjr7eJSTjGhVCh5mIVBQubh4AENJed4Pj
/OiE9PkSR0SY0JW4GqHQ
=5bLl
-----END PGP SIGNATURE-----

--g4yiczO1Q18OVQVC--
