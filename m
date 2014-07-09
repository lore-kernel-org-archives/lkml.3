Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaGIJ1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:27:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54682 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaGIJ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:27:05 -0400
Date: Wed, 9 Jul 2014 11:25:11 +0200
From: Mark Brown <broonie@kernel.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140709092511.GP30458@sirena.org.uk>
References: <1404822480-31525-1-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dngyMJhgXGAL5Gb8"
Content-Disposition: inline
In-Reply-To: <1404822480-31525-1-git-send-email-amit.daniel@samsung.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: s2mpxxx: Move regulator min/step voltages
 in common place
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dngyMJhgXGAL5Gb8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 05:57:58PM +0530, Amit Daniel Kachhap wrote:

>  include/linux/mfd/samsung/core.h    | 21 ++++++++++++++++
>  include/linux/mfd/samsung/s2mpa01.h | 12 ---------
>  include/linux/mfd/samsung/s2mps11.h |  9 -------
>  include/linux/mfd/samsung/s2mps14.h | 10 --------

You need to send patches to the MFD subsystem to the MFD maintainers as
well.

--dngyMJhgXGAL5Gb8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvQp0AAoJELSic+t+oim9nW0P/Rmn24r8W6qWMkt0AyiAgN+T
1uZl8GaHsyyOevbE2qUKIco/flZ60Q6shvBcVXA7Jm+Raq8YJOPtOk+9iU8aG3yF
Uiqk3fx1H1UQZl9eSW81VApr8K7i0C0DUreDOT3z8qtG+N1UaQl5gwv2oYIHBW6w
+Ipd5iQ3JeNZ630LY2Cc5eQvZc+mXPiiAS72RtrQH7eoeYgBGgH32K71EgSiM1lB
QGbBBpe139m9TX42vzK/vcYKOWv7oRfJVS87w3Yb/XmiZx8tkXRSOe/T8l0bsa/O
2pkEpoX21FuWN5daMUv85C1ZWHd7DYtfVUJ9D7vwD+yx3W7AVUHCS2kX/QEBzGcW
Ix9SRp3KBkWZxyrk1Ec47+ERT07lsUCZibLpRtQH0OMXVgiekId4A1fph4OtzjHa
UH5wrmhBK8QymWiKC8XVO83QYNMi/EyECH4467MyhhD3mRlWo6uVcTZ7byS+uXAZ
tvph/AuH3utHF+Gpgt7ijQIRjEdLHQeMaCOm53t64mvybZFknSyNAFan+fdr+TGb
ui1B/p5xmunj+aXBm5wnZRLi8rnUCzLmBpabHHFqQJNAtQixLFRNSshmI/Na2GKH
9xxglRmCZlXEdx3RP4Y5CE1kIj2063JfZjmt8E+brM3T1wARGN/FtFfWkLnfEHOI
9OxgCdI6QKIhlokN9iJs
=X8i/
-----END PGP SIGNATURE-----

--dngyMJhgXGAL5Gb8--
