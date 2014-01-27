Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaA0UZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:25:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60306 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbaA0UZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:25:40 -0500
Date: Mon, 27 Jan 2014 20:25:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20140127202533.GR11841@sirena.org.uk>
References: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
 <1390570678-30686-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Aq6vH1t1JS3Uc7g3"
Content-Disposition: inline
In-Reply-To: <1390570678-30686-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/2] regulator: s5m8767: Document new binding for
 Buck9 GPIO control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Aq6vH1t1JS3Uc7g3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 24, 2014 at 02:37:58PM +0100, Krzysztof Kozlowski wrote:
> Add documentation for new binding for controlling (enable/disable) the
> Buck9 Converter by GPIO (BUCK9EN).

Applied, thanks.

--Aq6vH1t1JS3Uc7g3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5sC6AAoJELSic+t+oim9ENsP/REhERS50UsFd8b1I3tsFXEe
+NFVRLC/qdOHIfaDztcIbjRUM6bgg2qYHVZYfIT1amOLEu87/MBRMFcsZ7M62EV7
xceGpRQMGULFftYl6JNCU1A5GoNtGCgkhFibkwbnWuJCLXDLFxLvVzUgj/5Yp/9y
pPqWOx+/BF0cev4p+/BJMI69PKg40Whlj9q7klcty5PwlLawuB/zXeUQjSXl5No0
MTxXTXUvA8iEDLnmvipwB19sR7Z3/jkwaL8dhwqpEnWLc/DwLa8FpEYD02HJ/xyo
Y03FmFaPqCPlDr8eP6em40KbC0RFRgUiWXPoR0DU07DPsfAPpLA2QgVfStnlyItk
r3xFzG6yyQYb9XUWw5jSimhclmKJ7UhTXpoSW1GLNrlFV0ezhDzMCvk6FNNVLsbW
E1nmwe9CDJQAEi6Pw6qLI/2KudFv4BRny8gIrP3L+skGRvOTVVb48fijYl0A2db8
/ulH/Vtf/xV+KmlC8tikeNEr4MkXJDExaz8JISUy9fDQJRoJq2TcJzyuRjRFRH6y
PXNoH+gkJI7gGbUtATAfYg97eqcgJTLA13bXJhSVyQMmXsg0Sy9UnHFFFWRp5X3M
HzHd3hitFXzUz4cOdVBIPB24OF+qs9wAN+2PsXdqwhQSRL/KV1pjvewYoMegH+Np
6QIM34AGD1GYbByzIjV3
=5GSJ
-----END PGP SIGNATURE-----

--Aq6vH1t1JS3Uc7g3--
