Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaH3NL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 09:11:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41805 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaH3NLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 09:11:25 -0400
Date: Sat, 30 Aug 2014 14:11:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>
Message-ID: <20140830131103.GB29327@sirena.org.uk>
References: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
 <1409403026-28818-3-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q1SX3yAxAkj1z+aD"
Content-Disposition: inline
In-Reply-To: <1409403026-28818-3-git-send-email-b.galvani@gmail.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/4] regulator: add driver for Ricoh RN5T618 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q1SX3yAxAkj1z+aD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 30, 2014 at 02:50:24PM +0200, Beniamino Galvani wrote:
> This driver supports the 3 DCDC and 7 LDO regulators available on
> Ricoh RN5T618 PMIC.

Applied, thanks.

--q1SX3yAxAkj1z+aD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAc1kAAoJELSic+t+oim9G+oP/2c+Z9l8SOroMWXDipCQRY71
Hf97Yuruyvj61lO2sjx6MvgsK5iSUVDci+FieOcCvRSbeoItZ1ZXKvcKqHwHbJIK
MOq/fy0YQfAlJH0CFZx77iphsfq5fgJYu7DH7AM5eHPrhVuA2q5BZQzI4nTKl3x0
ozwYqvWivl/j5VG4KURP3kDkJRMcpDxXIB2n1Q6XaymqNLwDFHcwZD8y+JNEutwt
l+99i2276k5WmEQL/cs7t49km/4ADpJ2eLbDojDxuMi6qja3H3LVYoADrhbE7Sr9
C6x0V/nkzG4ERv4WYT4cPcHhCRjPb3dKM8lAVhcnVRbWygdmmieMglKv6B9xek5f
TpUB4DffP4TpAsjLtG9OVbwmd3Wrkf6zKuDxqFXunUF8T3OOvVD+69MCVyvNz8ga
e4dZWmXQ8HXrU1S9+uTXV2doniqu3JNABNLtUAKyuHBxPQzuf4Kt32GBk0B7Bsku
70jdXjD6Err3f/pj9k2TdO7yuBDcc/TaS/5I4qn5TmebL1DuhA4SGq3WSf+ayl13
YiIMDk5kwpFNIyOmZwJk83i9A+0d26avlNcBiuZpYwr30jQFE86psDwLvW4Km7MT
nDhJ8nZ9yK2/EE+Lgt6X/crLYo/OASkaa8xatShOgkbQiNstQaF2DR0LWv20NVdi
A67Nx+mqt1QaVsEBAQnM
=xo90
-----END PGP SIGNATURE-----

--q1SX3yAxAkj1z+aD--
