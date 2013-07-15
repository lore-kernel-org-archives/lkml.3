Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab3GOQ6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:58:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58583 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab3GOQ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:58:00 -0400
Date: Mon, 15 Jul 2013 17:57:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20130715165735.GU11538@sirena.org.uk>
References: <201307151518.r6FFIve6031479@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FfX2iGK5t5ehHnsE"
Content-Disposition: inline
In-Reply-To: <201307151518.r6FFIve6031479@swsrvapps-01.diasemi.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] DA9210 driver files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FfX2iGK5t5ehHnsE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2013 at 03:06:59PM +0100, Steve Twiss wrote:
> From: Steve Twiss <stwiss.opensource@diasemi.com>
>=20
> This patch describes the regulator driver for the DA9210 Multi-phase Buck
> from Dialog Semiconductor Ltd. It has been made aginst kernel version
> linux-next next-20130715

To repeat *again* you should submit patches in the format covered in
SubmittingPatches.  This includes things like the commit message, if
your commit message doesn't look like other commit messages for the code
you're changing that's an issue.

> +struct da9210 {
> +	struct device *dev;

This is never used as far as I can tell.

> +MODULE_ALIAS("platform: da9210");

This is for a platform device but this is an I2C device so would never
match.  Also for a platform device the string should have no space in
it.

Otherwise this looks OK, though it'd be better to fill in the register
map information more (listing the valid registers for example).

--FfX2iGK5t5ehHnsE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5Cn8AAoJELSic+t+oim9TpwP/jTT02gyI8nD4GdBb0S531Q7
eh1jvHegWGbQjnta2iW1q/IgDanOLu03lvLWxD/WV9E1UXFezNpiRMwB/YbIjnni
CRPTI5GvBEXLh+yy6bYdXHuGv+/qI6jKmdVisJ8lKrsT5OHrtND11Sqz8xrTQ7Gy
4bwqDC3VMHrHFaBhv9vmD1saHe9Od6BPzAyXR+YVVWI2HOSqyJzumtI0EDErBfaN
PRoOZtySfxlp2zOTAj2dao1kOhzgbiR0Yds4M8Mg3o6PqevVGNfBjhjWzpFKR+kN
jcTN2nDnL6C+i9++jAbAJoYre2Pa8kTBWraY4OBCKaYmjrSyKK8JaRWyarIn0oxa
zW6/YigrbF8g3SVkSx9unZangMuX9YQk5UdcUFWvhuxoU0OOrXclZFcXk07WUtfn
O/KAwcylw6ngvnlM5AQ57NbeWQguup5xugGSRXmen3t9kCY459atK2ZEnZTbnCZ1
a+qGA3rerWOnqJcnSbpbVWbK15MH6pDUAyDxbfUkBfNkaGM8wIGgzvbTnuCZcD+V
irC/aB1ttQBShqXntwpzhau48Q116a38tGUJA+b6iAwoVZ4Hb6Ma6SPdZLyhZkiS
XVyeY/+PthcwbSS8jUx043WbacHk+spyFgI7eipmQOalSruqnU88eCgHMmolpYmC
ow+1qGPvy26C+Jc5Q2TX
=q199
-----END PGP SIGNATURE-----

--FfX2iGK5t5ehHnsE--
