Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3EIJwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:52:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52008 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3EIJwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:52:36 -0400
Date: Thu, 9 May 2013 10:51:43 +0100
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
Message-ID: <20130509095143.GB7478@sirena.org.uk>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081650.23264.arnd@arndb.de>
 <20130508150141.GA5057@opensource.wolfsonmicro.com>
 <518A8E6C.6070907@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="67nA0I2t09EExhkH"
Content-Disposition: inline
In-Reply-To: <518A8E6C.6070907@st.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--67nA0I2t09EExhkH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 06:42:04PM +0100, Srinivas KANDAGATLA wrote:

Fix your mailer to word wrap within paragraphs.

> Ultimately the syscon_write use the regmap_update_bits, however we
> really want is the flexibility in using/referring the syscon
> registers/bits in both device-trees and non-device tree cases.

So what you're looking for here is some way to offload discovery of
register fields from the driver?

> The reason for these APIs, is the extent of syscon usage is very high
> in ST set-top-box parts.

> Without these new APIs, its very difficult to pass this information to
> the drivers.

I'm not 100% convinced that putting all this information into DT is a
good idea, and to the extent that it is sensible it feels like something
which might be useful with any device using register maps, not just
syscon.  For example many MFDs have similar needs - essentially the
system controllers are just a particular kind of MFD.  To me that says
that this should be outside syscon so other things can use it.

--67nA0I2t09EExhkH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRi3GrAAoJELSic+t+oim9IWoQAJHvNeQZZXveXmlB1koA35Uf
gPsYkfgFvkD/EaS9Rr7OO3kd5RfavgeoOQu7CMrn5k4Cm4AXHDBW15YI6ZgBacvU
mP34x1IJh93o2AUtspBxWAGebGO+KahFKv+t5kag9mvfVjXE1QUnLQbOucWYBr/S
059Z5+WO8sPbcpuRAIfr3qYFwqrztYz6LcBmOK0XOpkgp/0to9W5wvUzG6xFgywz
YWCZfjh+vn7FUFR2U8mifUp48SHrKUqEu1EFDTG0u69yk5olnwSD1C71ga4LADau
O+N0/p6MtJe9V9r9/kxHTJYRfZqvB927ta8awZqCpCsuhepi1Tfihx0KcvefvJKU
2RL+LJhChs0jVwHCAmaFcE5D4xyT3EGrTiPWn+AaKrg17aHaz2qonQJTtpDuUBPC
K40ebQMzxlbXDh/1R71ZxPP3R+Kd5DdWKzG5SILYak0qTEVlcHiUpFhv/UIhsw4E
D8qQuxcELQkNMHAa6B3nuXCDUgYMNpot4cJiXLvKZbeRjZ4tLSnrzen4skkDZt7e
HMUf39XiYm2gfrPbcMb1GY1vrNUHrbMfpbkArvbRVa6l5tbh9Q972uk8Q0G2fQjb
r3dgXUGkooco4d5ruQVopj9m5bxTlQy3nG2U/SvEYC6NffkZHs42LLDrw+wzcCGZ
w6FS6DNQPrxLMbvrQT5I
=vpYd
-----END PGP SIGNATURE-----

--67nA0I2t09EExhkH--
