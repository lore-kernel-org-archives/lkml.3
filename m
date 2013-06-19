Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab3FSTW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:22:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44021 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935068Ab3FSTW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:22:26 -0400
Date: Wed, 19 Jun 2013 20:22:11 +0100
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
Message-ID: <20130619192211.GH1403@sirena.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
 <20130619174047.GB1403@sirena.org.uk>
 <3697657.tZFV7pR81Q@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="55pgo4yTr53jOkhk"
Content-Disposition: inline
In-Reply-To: <3697657.tZFV7pR81Q@flatron>
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


--55pgo4yTr53jOkhk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 08:26:12PM +0200, Tomasz Figa wrote:
> On Wednesday 19 of June 2013 18:40:47 Mark Brown wrote:

> > -		ret =3D pd->get_signal(plchan->cd);
> > +		ret =3D (pd->get_signal)(plchan->cd);

> Hmm, that's strange. The former is a completely valid piece of code...

I know, hence...

> > to get it to build which makes me suspect the compiler a bit as well...

=2E..my comment about suspecting the compiler.

> > I was applying this to -next, are there any other dependencies I need or
> > anything?

> Hmm, I've been testing this on top of my common clock framework and devic=
e=20
> tree patches, but I don't think this had any effect. Did you add necessar=
y=20
> clkdev lookups to the clock driver?

No, I didn't - that's most likely it, I didn't really investigate.  I
didn't test the watchdog stuff as the clocks didn't get sent to me.

> In Samsung CCF alias notation it looks like this:

> +       ALIAS(HCLK_DMA1, "dma-pl080s.1", "apb_pclk"),
> +       ALIAS(HCLK_DMA0, "dma-pl080s.0", "apb_pclk"),

> Not sure how hard it will be to add such lookups to the old clock driver,=
=20
> though.

It's pretty much the same providing you know which clock needs to be
used.

> I will test this applied directly on top of current linux-next when I fin=
d=20
> some time, but for now you might check out my v3.11-devel branch on my=20
> github:

> https://github.com/tom3q/linux.git

Will try to get round to it.

--55pgo4yTr53jOkhk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwgTWAAoJELSic+t+oim9SHsP/3rtb/vM8kH1D/8ZuF7xSvlm
NGS052Epjn2S0dOb19ZzZVDyPK0/P/sbGcsDFJ5xwdpg3dpE0b62+fSrFdEcCR82
GGTYSIHGeJlg1A8HsTIv6jY/FBGnvJk7Jzg8XkQvvy9Xz30FdVRfKsBiK6tUC1tB
ryaHlaJXOxh1dTXjvC831nywQOvw8XniapdpTm8TelQ5tnQ4BtfWOyDnbwqza/La
Ss7DZXS2jFA9heiVk6rInQv42+iH+NBmY3R9TuXPkmZqqaliIS7M8JyIbGAZ1App
tmeQ5WusTKjsp1G1PQiSRtPT/5c9em9/4D7vH9MEjCuvOC5qzhhnIGo5wXJywRYr
pSz4cd0dV9M78GG07QLrisEL+fAG2R8yVxKeODdVCI2asJdAR2VxZwbpBqqEkzl5
/AVH47KH9rlDwKCZvesMfDooRVuyQCVxHmECBSEs2fVqyFjmmaJ8vaPzx4ew5dC8
d6TciTlBXFBRNGS7DKGxBmO7djHyY/L9T3YzoX6E1OSoiI5NxzjQM/uEtaNlbyUn
0ug6b0+OUJsAzRNWY6DE69h2oN+MUAz5AQEHdWy7mvIzDgOvc20xCbTKaW5PNb5/
GUafBgiBeJMjEuae8qq2C/+v2plZDivZJvp+g9JSrucEAo0klN3kBLDVSQ5HTo6G
vHTm4CMCkKKzVJyGZtT/
=m0Kg
-----END PGP SIGNATURE-----

--55pgo4yTr53jOkhk--
