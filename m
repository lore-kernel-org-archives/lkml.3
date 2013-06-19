Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935342Ab3FSWsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:48:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58606 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935028Ab3FSWsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:48:12 -0400
Date: Wed, 19 Jun 2013 23:48:00 +0100
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
Message-ID: <20130619224800.GL1403@sirena.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
 <3697657.tZFV7pR81Q@flatron>
 <20130619192211.GH1403@sirena.org.uk>
 <5443580.A5iCQBtp1T@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JTJq4mKM0qXghaEa"
Content-Disposition: inline
In-Reply-To: <5443580.A5iCQBtp1T@flatron>
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


--JTJq4mKM0qXghaEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 09:32:44PM +0200, Tomasz Figa wrote:
> On Wednesday 19 of June 2013 20:22:11 Mark Brown wrote:

> > No, I didn't - that's most likely it, I didn't really investigate.  I
> > didn't test the watchdog stuff as the clocks didn't get sent to me.

> I always try to keep you on Cc of my patches for s3c64xx, as you are the=
=20
> most active user of this platform (if not the only one other than me) and=
=20
> this was the case for clock patches as well, just checked that.

Yes, I had the clock patches but they depended on something or other I
think.  I did test a previous verion IIRC.  There are other users I'm
aware of (you can probably take a wild guess where from the board)
though they tend not to be terribly active upstream.

--JTJq4mKM0qXghaEa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwjUcAAoJELSic+t+oim9kNwP/A8TYOSfIfkfYArTyVm654EJ
pSbqwwY7w72M3w9i+61HY0F9gDrnX63TpMG4d+us5qwvCay3aarGAgSDG3TFqcWC
6YOungF7u3mZ14O5y4bFXA77+kye+OmtVQML0oh0flnON1pkqpS/By1tjpgCddNE
8rxuD5i5dC9kMwWXAeHAdDg5K+WZLdA2w8aPcqcbjBFhW77yH0740B6yXGgTmL/r
UGs1qpYzXwLYJCe1U5WyJ4pUMf1Ts6suQC9enLdjRRv3Tyu5WsdpJjc+ADiYXAFk
Rtdp3KHnX8zL4sUhXr7cN+8BKgTnEeF5V6NUL9UqkgW0fBJ4fE5t8ybPBmlciXuV
jmF730FUp4c1c6cCo9fM1AXyu4A4HXflDyrdd9SMu/faQCnTOLLCqYUTUBabNXiz
3AlfJhyFXbcvlEbioBsxS2mr6N1P5W/b1wUbcEtX36wLGRl5GaDNGGxqUsMV64wF
/BFsfjb0nDd0cy+KVDqfuhQgS2R7E2QidW+bOwSxAG9yedpOrqjFsjMSBSN1GgNo
N2sSqkdRhKSs99/ymDoSFLYn4nF8bF5JnXl5yFafurv6gx3gCGYSEAUasR3vE6QB
yKqGOqhsYuvEQfDBGPUVuArHnJaFAZT1Q2hZeANw0pU3Z+1eVmALK9Tq5jtVtqow
w6vUDi9WeAnpu0N6cXBT
=JMXm
-----END PGP SIGNATURE-----

--JTJq4mKM0qXghaEa--
