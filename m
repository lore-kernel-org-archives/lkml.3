Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177Ab3FSTZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:25:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33924 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935094Ab3FSTZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:25:00 -0400
Date: Wed, 19 Jun 2013 20:24:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
Message-ID: <20130619192449.GI1403@sirena.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
 <20130619174047.GB1403@sirena.org.uk>
 <3697657.tZFV7pR81Q@flatron>
 <201306192101.34102.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sO6W+9M0FHXpQYui"
Content-Disposition: inline
In-Reply-To: <201306192101.34102.arnd@arndb.de>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 00/11] ARM: s3c64xx: Let amba-pl08x driver handle DMA
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sO6W+9M0FHXpQYui
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2013 at 09:01:33PM +0200, Arnd Bergmann wrote:
> On Wednesday 19 June 2013, Tomasz Figa wrote:

> > >       if (plchan->mux_use++ == 0 && pd->get_signal) {
> > > -             ret = pd->get_signal(plchan->cd);
> > > +             ret = (pd->get_signal)(plchan->cd);

> > Hmm, that's strange. The former is a completely valid piece of code...

> get_signal is a macro defined in include/linux/signal.h. If that header
> gets included, neither of the two is valid.

Ah, that'll be it.  I'll post a patch to rename...

--sO6W+9M0FHXpQYui
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwgV+AAoJELSic+t+oim9/Z8P/2HMm4h5Ocvivr9UhfGhbcX4
MgsgkhoggnSuwpZGdTpx+nZ5Qbvpp0PpjUBAbew6fM9LrYrDJa7hcKGPJ1xPndFh
eJZqs/wYcSqpi7VcnE4qRJh6RZxz88aZv0MzA8FaFzTpDd2YK0pLssfAXH8G+niC
cE90ECG5tPegY4y3cNVknyksDkzOLssa8h7V9aaDsyoFOlJaTv5Lu3qDfPz9xAol
ym3pUOQqUzMkSCdXX13ljiKMzMjr6SI3Hbuk29nCz3ce4c2A1Vji/XfjGdFoY+9L
NXJ9pgLPKtBmcJopApLdvWJ/+hiYMkdsaJuJaQPSbHGZi8ZnYHZ+yHv7vlYivusc
TD33rpskwfGWsjo81E6w+tjeLtk+d6P+5jB4XH40ALdFFCtINx3b28UhnjBZ8NeR
Kn4JhKMnUXQml/z0dF8/WtTqdbgbVIncZ0T1OVnevM7OfESkFi53/TAdqlOLXF+h
WIGGgQbrpCO8Xlix2ZE/PI3FHfD43FkXZH/lneq+811MA0vHcMK0RONAce9+7SD1
Swqx3Op2RI2OhOQwqJ+rUFDGuMoKpoJRd01Ioj9m0kT6uxhCLpnUPLo1pJMtShED
tE4hXCFEMRNKEbwfcApp1kSodOyz7z0qlXH9B1MAtnP3mFquHMb6v8c1R6G0AgrF
hR7WgMnqkmlRDv3jIovS
=o0Ko
-----END PGP SIGNATURE-----

--sO6W+9M0FHXpQYui--
