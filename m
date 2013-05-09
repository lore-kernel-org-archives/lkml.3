Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3EIN0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:26:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56522 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3EIN0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:26:37 -0400
Date: Thu, 9 May 2013 14:26:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Arnd Bergmann <arnd@arndb.de>, dong.aisheng@linaro.org,
        sameo@linux.intel.com, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Message-ID: <20130509132600.GA3200@sirena.org.uk>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081650.23264.arnd@arndb.de>
 <20130508150141.GA5057@opensource.wolfsonmicro.com>
 <518A8E6C.6070907@st.com>
 <20130509095143.GB7478@sirena.org.uk>
 <518B8F49.5020902@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <518B8F49.5020902@st.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 09, 2013 at 12:58:01PM +0100, Srinivas KANDAGATLA wrote:

> Currently, we have two bits of information which come from device trees.
> 1> The syscon bank/group definition itself.
> 2> syscon register offsets and bits information to the drivers.

> These are the 2 things which keep changing per each SOC.

> There is no other way to pass this information to the drivers other than
> passing them as part of their own device node and syscon node.

Sure there is, for example the drivers could have this information
internally as part of knowing which device they're working with or they
could take advantage of some patterns in the register map to store some
higher level information that they use to configure.

> >  and to the extent that it is sensible it feels like something
> > which might be useful with any device using register maps, not just
> > syscon.

> If you think this is going to be useful for other drivers, Am happy to
> move this out of syscon to regmap something like adding
> of_regmap_field_claim/regmap_field_claim/regmap_field_read/regmap_field_write/regmap_field_release
> functions.

> so any exiting drivers can still use the old syscon API to get the
> regmap instance.
> Alternatively they can use the new regmap APIs directly.

Well, I'd need to see the code to decide if it was sane but I do think
that if this is a good approach it's not syscon specific.  Anything like
this needs to be independent of DT too since not all architectures use
DT.

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRi6PhAAoJELSic+t+oim9KC8P/RhLDLjfaPiuWOd+fCm5qqXJ
xKoiS9+Z/JJf3K5eUwFnJAl+3Txm8gjyQxv5xJKT1OGyn83PQ0JbdAW46yelczNW
vQJaKPUHNPuspRBdQu/g7FNH5U9J40nYtFv3WrmcXisg4jshEP8fuVIi2oZmdyPM
hXQxWD4xKPG3tR+SBHuKjSp7rOeWVcnQpPph+6wbxTJpZIBYTxj6IvITJr4Zd0mj
yxeclFHsaxgt+HASw3I7evr/tB8tYfljHRF1dFSthEXwqBddlfAfXvaEMc7YP6Tj
w4QyBDbGv/2SChRWufr9qzUz4WoLcsQMAO6iFE6JW2m5/PLIfhZ4GHDz23YV1xRB
7+UXiNJL0iMIztTnkiWiV+3uKcA9R9EnIUbs5JgM5zuAYjSjbj9t3cgRkWQ9uEK9
2gpUgyvx1Ua55LXgqxX5vYkIrJsxZ72MiLEHr3o/Lm5Ct1K5Zgn6REgvkSxy8KL4
9J/9+88NGUz47tJfLHL+o7nHKD6OHScDQB77UZRpw4ufgIxaH2HSIY1KHPyqRy/I
XTMd/UKhmZoLZ5OAEY3Y1WY5dPDihTwpkVQSz7oHbIWZqpHNxKWTW65x06eE69l/
9B+FAAJb61xoRrTwAfCtHXC9jGCu0Ekg9UNNLd2GDVgQFBsQPry6bfCd6mnvirWS
C5Oxvj1/9p+THRFSzTHq
=Pi9l
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
