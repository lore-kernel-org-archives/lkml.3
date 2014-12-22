Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaLVOAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:00:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43960 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbaLVOAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:00:43 -0500
Date: Mon, 22 Dec 2014 14:00:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222140015.GR17800@sirena.org.uk>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
 <cc0f212c245beaefa542194cabe5cf5ebfc81fd3.1418826016.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWsnvgFfkTS2ATo5"
Content-Disposition: inline
In-Reply-To: <cc0f212c245beaefa542194cabe5cf5ebfc81fd3.1418826016.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] ASoC: dwc: Reorder code in preparation for DT
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SWsnvgFfkTS2ATo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2014 at 04:18:07PM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> Move code that configures the DAI and DMA into a separate function.  This
> reduces the size of the dw_i2s_probe function and will make it easier to
> add support for device tree to the driver.

Applied, thanks.

--SWsnvgFfkTS2ATo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmCPvAAoJECTWi3JdVIfQhqkH/0oiWI5b82TVFq8EIDAonIDa
8wcbexfQdaT8i9F6xTTMa6TSByYnvUIk7nsTFOF9n2tz7UpLLY4qEax4KR1VoVBD
LhY2RxbXdIB6ZvfRupw/BFm65zMNExcy+1QG54gF9KkQKRuvQT25FnTDUepL/KfP
X9LJ20eXOXmOW0O7HZGWmvjyWu8VVLeEztaQCQMC1cvx784JUlmaVGfAk86RGlJu
UnlOmo9OWkDR2N4La6Qn8fOQejJrt6uHwX68ylIUfspnJGZzkD5uHlplFhk5PF44
NPk/vomxEGZD72P515FBbifO5Yj+rPpk78pJNT2Pr9wC0o1ofjzZva+9G72SgkA=
=mVQn
-----END PGP SIGNATURE-----

--SWsnvgFfkTS2ATo5--
