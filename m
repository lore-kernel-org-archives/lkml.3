Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaBLRu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:50:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40950 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaBLRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:50:27 -0500
Date: Wed, 12 Feb 2014 17:50:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: lee.jones@linaro.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, k.kozlowski@samsung.com,
        sachin.kamat@linaro.org, jdelvare@suse.de, linux@roeck-us.net
Message-ID: <20140212175018.GJ28112@sirena.org.uk>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="21BR8y1c1zpF/Inb"
Content-Disposition: inline
In-Reply-To: <1392177760-17959-1-git-send-email-lpapp@kde.org>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--21BR8y1c1zpF/Inb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 12, 2014 at 04:02:40AM +0000, Laszlo Papp wrote:

> +const struct regmap_config max665x_regmap_config = {
> +	.reg_bits = 5,
> +};

This would normally be static too, and I'd *really* expect to see a
val_bits set here.  I'm a bit surprised this works without one.

> +	mutex_init(&max665x->iolock);

What is this needed for?

--21BR8y1c1zpF/Inb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+7RXAAoJELSic+t+oim9zFgP/RECCgoGcH5h05t86thaB3Bh
yQ/aJTPjmnGAX4GnwJIGJLRquhfeuDvF4zDtj6CEm/qWd9omAzTHjpRvo4Uza+J0
P8o+0NWdJtpQAnat+p409pIS2n5u8wgAXstp108Wx7w81oXduDq7wS01qKLJBAg5
bzc5sN0U9OVgBUOUL+g84DM0n5Tn9XXiggqOYqywHkL26vgB+Za/ot9VDccJg4AR
lIvvQLRrwUv1dv4m2htz08k4Cq64SUATP3IpPDqFX1po+AX4ireOG4DfBZimJ/yY
sFcLI+N5VFGN5fyuH5he5CMP7STmwXkE07etUNY5G8C3zEvfu0aZc8CSVDTLzlYY
kaBq/LH7JrmgVgtkQM6tvLAzCeQJZojMsg+klvRRHi2qBJXdj47YmLucGiLHQdVy
fpT4JWD86OHyJ/pNBZ93xhzhuYRFnifjsw47SpFmyyvxEdWiC0aJF8UExnWj4lhT
FTl7FJ+BcrBRNAJlCDD9q7FTYbyWdHvNVANEU/+WHW0dn09eMoZ91WdMOW+BFp9a
o6t/uOzd4egGyRfVklDx0q/YjqOkckKhsEMsNNOUQtaUhVUOhpqgMa2wwwhsRNK2
W8UnJxxHaB4KBkzse0CJlipA9fBhtm0L7wgX6AANSM7ppcxfrfGKiHaDT7q0poDb
yNxetIqEcxdsZ4QcSz8N
=x0Zw
-----END PGP SIGNATURE-----

--21BR8y1c1zpF/Inb--
