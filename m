Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbbAEURD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:17:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36766 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbAEURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:17:01 -0500
Date: Mon, 5 Jan 2015 20:16:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20150105201638.GN2634@sirena.org.uk>
References: <1420042837-3337-1-git-send-email-andrew.jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rFUhhEVnhEf/dYhU"
Content-Disposition: inline
In-Reply-To: <1420042837-3337-1-git-send-email-andrew.jackson@arm.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: adi: Add missing return statement.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rFUhhEVnhEf/dYhU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 31, 2014 at 04:20:37PM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> The probe routine was disabling the clock even
> if the system was configured successfully.  Add
> a return statement to leave clocks enabled.

Applied, thanks.

--rFUhhEVnhEf/dYhU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqvElAAoJECTWi3JdVIfQPEEH/ieQEkbZOfcO7WAkKX+rY2A2
Enoyz591qB2CM3uJNV7icbhuSsRGgPw+kbKBr2UEuSyyB5PN+O6V4Bbi7xYnFuV3
ufObEQBPmNku2ly4A/ZZEJUGWlLbuAcIR+AFIkooiFG9t7JIM/EIv5xR/10yJQz9
O2Bl6Rhpa7ChiHV4OTJeKfWtuJX7AvxhcWqH4k3AcRwcMkyID0Ld0LKIzkKvsaTi
ArXcgdwbUzcB5a/pfmKhkO0M63ML5VFidcUwCl6+ss/9pA93I+JOUP9AoHAOxoN2
BT7UH6oYKALlj5+1FTkw5Z/JnpTPz+kd+9RKsOB7bfLoSibNInIGhFbYlV0u320=
=8FVh
-----END PGP SIGNATURE-----

--rFUhhEVnhEf/dYhU--
