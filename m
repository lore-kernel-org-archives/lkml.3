Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaIWAzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:55:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58043 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbaIWAyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:54:52 -0400
Date: Thu, 18 Sep 2014 10:59:32 -0700
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140918175932.GD7960@sirena.org.uk>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <53C675E4.4020502@samsung.com>
 <1409825105.5546.91.camel@x220>
 <201409041802.36466.arnd@arndb.de>
 <1411036935.2017.30.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2cZ01xMxx5MYbKUa"
Content-Disposition: inline
In-Reply-To: <1411036935.2017.30.camel@x220>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 166.170.38.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: samsung: Remove PCM support for WM8580 on SMDK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2cZ01xMxx5MYbKUa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 18, 2014 at 12:42:16PM +0200, Paul Bolle wrote:
> On Thu, 2014-09-04 at 18:02 +0200, Arnd Bergmann wrote:

> > I think it would be nice if you could submit a patch to remove the
> > drivers from ASoC, then we can see if anybody complains.

> Also the same thing for v3.17-rc5 and next-20140918. So let's see if we
> can remove this driver too.

> Done on top of next-20140918. Again untested.
> -------->8--------
> From: Paul Bolle <pebolle@tiscali.nl>

Again, please follow the patch submission process in SubmittingPatches.

--2cZ01xMxx5MYbKUa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGx2DAAoJECTWi3JdVIfQxgkH/2HKuI2DcgnSFgzoOcDbLz2A
RWJ1gjVUGiU/Ljgezk3hUJgMAhSG8DPL+J38RfS38sWiHd6VvZfXV11q9GU3NRuS
CLEl4t2f12iVWW+MXpv1YMCRZrMuRPRQNj4DJQiNLEuUcjhulzXaWPzT+0D62YBS
OlZmieJYLHVMsLd80jLmDLSRKTOifWXkVliJ5dmk7hPRhnh8jJy7lS6ZzlLbhdaE
nW70n+IZz07/LIBCTANmYAHxkdspJr8HY5j1nTaH1rEqd+jI11eBbpxuPkzTTGwf
/GWqoDr/420rhYsV31xjr4uNEXEUXqf3xJ1eRFaFbHNYKX61PTRbZhwuEnEB2lU=
=uRSf
-----END PGP SIGNATURE-----

--2cZ01xMxx5MYbKUa--
