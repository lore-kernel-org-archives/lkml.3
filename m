Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3FYPix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:38:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51260 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3FYPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:38:51 -0400
Date: Tue, 25 Jun 2013 16:38:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
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
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
Message-ID: <20130625153843.GF27646@sirena.org.uk>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
 <20130625102818.GA27646@sirena.org.uk>
 <6520269.XdaOpEg0Ud@amdc1227>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qPhbOctOI3h5o759"
Content-Disposition: inline
In-Reply-To: <6520269.XdaOpEg0Ud@amdc1227>
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


--qPhbOctOI3h5o759
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 01:22:20PM +0200, Tomasz Figa wrote:
> On Tuesday 25 of June 2013 11:28:18 Mark Brown wrote:

> > On my non-DT s3c64xx system I get this when trying to use SPI for the
> > first time:

> Could you clarify first time? Does it work on further retries?

No, the system appears to lock up fairly solidly - I suspect poor error
handling in the SPI driver.

> > [    1.739385] s3c64xx-spi s3c6410-spi.0: Failed to get RX DMA channel
> > [    1.743437] spi_master spi0: failed to prepare transfer hardware

> > though I haven't yet tried your clock patches (there were some conficts
> > that I didn't get round to picking up yet).

> This shouldn't really matter, as long as the pl080 drivers probes=20
> correctly.

Indeed, I was wondering if it was failing to probe due to not getting
its clocks though since that's another area you've been actively working
on.

--qPhbOctOI3h5o759
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRybmAAAoJELSic+t+oim913QP/juMt3TkCGQjjxdjvuMq43df
qSp98jXUvmvlCtiGXei/uV3RcIj98fYj5y7KP8CqSqMVoqbdURSTZojkFEOilp1c
Rd6fhfUJLQ5h5xFBfdSYqBnphXp/DqX7z754SeAgH21xjD8w4fDTqxObAqLQ+6B7
G27WceaFLTkQfpiGekL1KZWIT6N/f20bcfkiVGU8ek20xytwF+5GMrB/FF1apCvA
bK6a69QUAkHnPNBIr3XA53G+Yz9xmvNkC8fH0Ygii9qEyQ8io2oWCfrZ3MErUq5n
Bi5jxNX1+ILF4sdXyhr6Ugz4KzZ4EuuHkollwLSD96QTT0rV27NGRH3L31unfWIN
VaLAKPMPMLybN6nwUIdjw3J58oV85AdbJvwTrsGC4NIv0hyvPs52NVcxya3Ykynm
sG+vJquEPzgyA+CdE6ql10oET7OCvCcxqgwodZjn2VVv+iOzT8hZkrp/yZv/N+BE
QzWq+43OUV5kORwRCvJ3mldwlsmbTYPFL8PMdXNj4CeV8Yw5arxfBDrTrd/TtUYw
Z6dF5AClNYmrPd0DcVdS/IllVGMXBHA26l8MbokYjCzdkDzpKKXxW5/exI+Mn1LR
pDezJ3H3tRmu4CV11NWOOELin0taPewrxpBw/K9qR+RtzAVHhe4jESUn1zMjSTCM
hErhd6oowRnGVSeK55pW
=CVWt
-----END PGP SIGNATURE-----

--qPhbOctOI3h5o759--
