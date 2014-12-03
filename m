Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaLCRVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:21:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47254 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaLCRVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:21:39 -0500
Date: Wed, 3 Dec 2014 17:21:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Message-ID: <20141203172111.GB7712@sirena.org.uk>
References: <547F3C8C.5000607@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j6EEl49Pt0H+qza/"
Content-Disposition: inline
In-Reply-To: <547F3C8C.5000607@arm.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/5] ASoC: dwc: Add device tree support to designware I2S
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j6EEl49Pt0H+qza/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2014 at 04:38:36PM +0000, Andrew Jackson wrote:
> This patch set extends the DesignWare I2S driver to provide device
> tree support and fixes a couple of small faults.

If you're sending fixes the fixes should be the first things in the
series - the idea is that we should be able to send the fixes to Linus
and stable separate to any new features.

--j6EEl49Pt0H+qza/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf0aGAAoJECTWi3JdVIfQfKwH/RtNv82FcEtbyvq8UBKvs5GZ
Nq0l0EaimLGCjzZgN5KSWaT7zs5k2jr25u/EmWTfiCqjH6bnKfvEULXIVfxxML28
X2rd2R8KZDCzwwHRpBoKl2lTxi6yikYKZ7u8sjcwUBH4+h1SOmPKySmw7KxxhLnn
hLEfY/pKH4rFtl5g2cYcYdSSqMUvGNYgetxUuxYbT1e7zXWudrzeDS2ksA5nZIud
wSycPgUCa9pn8/qQCzw5Ngw2/fZLiydpEwoEvbhr2dKzJ9SG6xA9v72TIUGG+Vpt
RIX3gUbSCc5bv91Q5uO/jzLO1I0LQX7mekOeuVKCoom13eP/JdP824RyzssXcAQ=
=Yfsq
-----END PGP SIGNATURE-----

--j6EEl49Pt0H+qza/--
