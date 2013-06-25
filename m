Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3FYK2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:28:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53457 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3FYK2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:28:47 -0400
Date: Tue, 25 Jun 2013 11:28:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
Message-ID: <20130625102818.GA27646@sirena.org.uk>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ucH0Tl3ykwO2QBzm"
Content-Disposition: inline
In-Reply-To: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2 00/12] ARM: s3c64xx: Let amba-pl08x driver handle
 DMA
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ucH0Tl3ykwO2QBzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 22, 2013 at 10:42:32PM +0200, Tomasz Figa wrote:
> This is another version of my patches extending support of amba-pl08x
> DMA engine driver to PL080S DMA engine (PL080 modified by Samsung) found
> in Samsung S3C64xx SoCs.

On my non-DT s3c64xx system I get this when trying to use SPI for the
first time:

[    1.739385] s3c64xx-spi s3c6410-spi.0: Failed to get RX DMA channel
[    1.743437] spi_master spi0: failed to prepare transfer hardware

though I haven't yet tried your clock patches (there were some conficts
that I didn't get round to picking up yet).

--ucH0Tl3ykwO2QBzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyXC/AAoJELSic+t+oim9GmUP/R8DpB8DADk0acHVgQrnkpIi
ZcQs+amajUAW0+rXzmXs941w7E8lPX5Vl7vZQ8C9Kcbl+HGFzaUttRBhPz+obciI
EoM7kJAf02rn2SCgcdlLcGtP2GIjdButZudsajqm/+eiOzF2BLGFepwGswmk/yN6
R7lwO9uw+DU/AvqRgl900IQmyUsFVjt9ozdVZqqqZNPK02BI5uDnXHkUVC4vJmSc
jGdxTeKbP3qVV7QyI44hxx/o12nBPYPIacu35Wlxcp5tsL3BOnS14wIP2VtXVVUH
4QXN9yMQ2A0iSNIO0xfiTQB0xl6IPSJKsprq6wpxfivTZnPXYuGQskB2OT1+FQdq
2gH2DXTfsBHG/oz/VQcYTZRdF2bcesV2ygPiLuxzAdBY/DyyqqErCoI5VrImc8Bd
mTM4+RNOEjhj2I5Ft0NrfDq9aOpk3tpfi2wSH8Wv99fhnVNzG97md0cgwwA/zHKF
KylX/NOt5fSbLTFMqXOUuaIPSsGEVpajPDZyjstYyWf21p8Ya8Y/9x+JZCZ1HF+3
X+S1eZo6R7RNCebzEv8WFjSf4z29xdlGC4DBK0N3dy73bhQ231wtdirG64KJQHDr
ZvkfSgZYW9xDCvo05TyjtnrzQPcuQn5AjdvhL8VG8vXEIqQ3bZRUsssrZVFwgt/A
3aWOcRCy+wNQ/q7Q+llY
=A9bA
-----END PGP SIGNATURE-----

--ucH0Tl3ykwO2QBzm--
