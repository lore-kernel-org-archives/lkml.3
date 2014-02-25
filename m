Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaBYABA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:01:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51174 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbaBYAA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:00:58 -0500
Date: Tue, 25 Feb 2014 09:00:27 +0900
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: "Austin, Brian" <Brian.Austin@cirrus.com>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Message-ID: <20140225000027.GI25940@sirena.org.uk>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
 <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
 <20140224160648.GC6132@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PcnNQAcZvbjJh8WA"
Content-Disposition: inline
In-Reply-To: <20140224160648.GC6132@MrMyself>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PcnNQAcZvbjJh8WA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 12:06:49AM +0800, Nicolin Chen wrote:
> On Mon, Feb 24, 2014 at 03:52:24PM +0000, Austin, Brian wrote:

> Wait...Regarding this clock part, I just forgot the reason I put the code:

> 385         cs42888->clk = devm_clk_get(&i2c->dev, "mclk");
> 386         if (IS_ERR(cs42888->clk))
> 387                 dev_warn(&i2c->dev, "failed to get the clock: %ld\n",
> 388                                 PTR_ERR(cs42888->clk));

> was because the MCLK might be provided from SoC (DAI master) so it could
> be totally controlled by CPU DAI driver, ESAI for example has its own
> dividers to derive the HCKT clock (MCLK for Tx) from ahb clock in SoC
> clock tree, in which case we might not easily pass a valid clock phandle
> via DT. (RFC to this thought.)

We should be getting those clocks visible in the clock API rather than
doing this.

--PcnNQAcZvbjJh8WA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTC90YAAoJELSic+t+oim9+tUQAJmsfJ5U9ZMR3D4G7qxQi6gy
Q295xlQdHlWD9HzZlPqccF7xf6P1aDeSv1xBZ/Oczq/5e35w+PqZP4rOqofXqXi/
EwfX2DLkkd6nOsCn9lOrGAwb3wRxp9rAb0FaGnbkg7bYeghN+9ssCsmICc+o3l8Y
2f5h+h07T0rB/GPI65QdfU7yC/ojKGsGvHePi7xWnpxxchnkK9IENeGKpmYZlpU0
lNcBrrI7ATyWOGcSvWJtmE4sRfGAkYCKXAQ9tJ+YeCbMIEZ+MovEosZ3pOMF92N2
T62LxqVRud5YbskDdkZw7dPNsQ2lifD+P9jDFViBxciUXW0B3bYFh+EOFMXfppMA
qanev9R7u39UkjUaIxBxPnoGC0bxui04a12GEZXc/9nIuKJ33PxTjtnIWzSDlZg6
h5+c1LDvRfcL42HFNB7jMXJcgcf3q7Aw71oVQ9pc60txxbBP6cKxvQGXkbQlI/eC
F8eDaBzfH0+wQU+fJZH9XZ70mB3zo6M3oTOW8c7wGwp5lILO5HwwBh+PO0DfSphP
22CEMVE8LRjcJ3SZqmuUt+zQPnwtTHoqX/v9sjzemS5ZmRBTz+HXCwlOsiW5sk3T
UbDCCsxLGEJ86F3sZ6HLdS/+BC5aGu9hKvZw1bboDZcqq9zGfY/5ovlaHc7pA+3a
ykEEdEKQPlyCNBBrrwjh
=VY5i
-----END PGP SIGNATURE-----

--PcnNQAcZvbjJh8WA--
