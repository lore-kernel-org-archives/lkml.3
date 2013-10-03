Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3JCMwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:52:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60335 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab3JCMwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:52:44 -0400
Date: Thu, 3 Oct 2013 13:52:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20131003125228.GL27287@sirena.org.uk>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jtds+vpI57xq70EV"
Content-Disposition: inline
In-Reply-To: <1380292469-17347-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: Add a spi_w8r16be() helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Jtds+vpI57xq70EV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 04:34:27PM +0200, Lars-Peter Clausen wrote:
> This patch adds a new spi_w8r16be() helper, which is similar to spi_w8r16()
> except that it converts the read data word from big endian to native endianness
> before returning it. The reason for introducing this new helper is that for SPI

Applied, thanks.

--Jtds+vpI57xq70EV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTWiJAAoJELSic+t+oim9bPwP/RrYJ0fx0DxCE/+v/rkIgCi2
UaPa20NZVu1Vbv7s+UK/4tml865MHwzha9szl5bgILGYS1HR5Bj5krlSMU8U3LPX
n2umlJZpWQqXJXw+nkEBURF6ymchyyyiAehRXzOey4xOeF9JAJuRJPULHdgmhfm1
E4uXlcU4d7YU7bmXx11esHxmPPiNasgkr0KPx2Y6GnOewh9RBhguTQmfBLO937ti
1v+YzUf6WA/PeAQB5wUUddKDp4uT7kppHmc9ZRdCAFnJcW/SaQ6Pvqi5+JKRhglv
jy5FzSFyhaxZpuFMUbOasS0iqey/ONvdGxKCEhT7zXHog3TME2oxf4qpT/R/1y8L
248TrVMUcUOSOP7XR478twdOB1NCHxkve/G4Wf/9eheim5j/Qrtlmmqup++QaYxv
KmeD/4kN81gOa/7BBCiIvkGX/OjebsdwZbmOkP07N8hFsiCzXcS/iYADtjOG+1TO
9+XIxL3bi0sBxyltmE5mqiXGXJN9XnTT/OyNpkQdpjAGKx8XrvJJ6aKGRxS8Dx7c
j1FKlHvyFUXAfnDiC5OZqcdq7zYJjcetLaZ1IUD5NZV5i/bHqKYoEQBNEfkDyY35
9pPUimKbSediwf3sjTc71FCwvQ9cuTVeBubGgy4c3ZiHkzI8ubRRZKE8B/rSwrxM
vPY/nN8DH532aYEKmtP1
=GOAG
-----END PGP SIGNATURE-----

--Jtds+vpI57xq70EV--
