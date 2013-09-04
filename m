Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935115Ab3IDPFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:05:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40183 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3IDPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:05:46 -0400
Date: Wed, 4 Sep 2013 16:05:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Rutland <mark.rutland@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130904150540.GA10849@sirena.org.uk>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-12-git-send-email-lee.jones@linaro.org>
 <20130904131111.GJ18206@e106331-lin.cambridge.arm.com>
 <5227331A.5050507@metafoo.de>
 <20130904132638.GG20150@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20130904132638.GG20150@lee--X1>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/11] iio: pressure-core: st: Provide correct regulator
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 02:26:38PM +0100, Lee Jones wrote:
> On Wed, 04 Sep 2013, Lars-Peter Clausen wrote:

> > > I think this would be better handled with something like Mark Brown's
> > > suggested regulator_get_optional [1,2].

> Thanks Mark, I didn't know that existed.

It's only just gone into Linus' tree this merge window so it's very new.

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJ0xBAAoJELSic+t+oim9N2oQAIdYIPL4q+/cXj8DpzNq+TLA
sAknQx2cik8r8MIcOZwxJq0F7RceXxHQ3w5xYNoR/fc+AFXYawzV8cq3cyp+SUYa
aDK9x+N5lmV8OorqviB+tuxIoN2bNFyCt+Akp0MhuStBvGbkzntH2cAm3Ykki323
Z/59/5DWAh9BG1T4Gd3c08Nx5xCJWpPsLVTE9NRRG32d8F+qG1q9oG0zHqrsURbm
03ZJkshDWIYJMFqH0wS+g+6FQqv00T8yi/F0dacAZ4QEHewdIeZ55bnG+49PQCCw
FY2wh8Ohrmf35SUyrFtoF7FDtkINNoeqCMTLiwz6kcc/isSJ+B3uIB2Dr5YN6YTL
rHHGUX7KKOAAUC9xeN1fXvAcdCmWhglbOKVei2zK3IjMc6jNlswadFF5/Ni9iGb4
a36+MR/zBP0mTLZ2sw+d7GUI5o2GcF9K+/mGQXVT+XNLOpV4tcufLA1IYdSQDzxl
Fseufda6EJP05KHpnTpCv4v2iWSWNZDmvnzaUqj8oaPkJHNGS0P+BLcCnP7mN0xD
pAQzkedY6C/It6u4qrK5UNTfgJqHxFdte2guk3Nmd60OTwvp5J1JfTEi5DEhFdZF
e024jD+K1gqYsOOYq8vMNmF1SL4vF8F7z1Ya6HKcWbvwBqLOhDsUURoi+jvA7zVD
6dqUe1bjrOi2nshPkhZZ
=22IL
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
