Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3LaRAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 12:00:14 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53405 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3LaRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:00:12 -0500
Date: Tue, 31 Dec 2013 16:59:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        kuninori.morimoto.gx@renesas.com, fabio.estevam@freescale.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131231165947.GL31886@sirena.org.uk>
References: <1387783538-5318-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jZUYryPdXB7p5neD"
Content-Disposition: inline
In-Reply-To: <1387783538-5318-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: Add device's module clock selection.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jZUYryPdXB7p5neD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 23, 2013 at 03:25:38PM +0800, Xiubo Li wrote:
> Try to get the device's module clock if the dt has no clocks and
> system-clock-frequency properties.

Applied, thanks.

--jZUYryPdXB7p5neD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwvgAAAoJELSic+t+oim971gP/iNO4EQCaDJNOubtELWS/Sy8
g8GaK49gHiS3Nv/rAkz+UvHSf5rWjOjIXjHHkf5iT79yg4SkHieIayA/rX3Pdii2
pPGbjrt6QRi1CvbkS0/RPH1SrtHdvtaybPynP9wnREgTHS0NhaOfiiPTIZggA3Ix
U6qEf5ev0dGzrqYG7uT5FTFlD0YpH5m6QVdUkvrPxF3Ukxjq147AlYKaZjGoRPgY
TyuD/om3oHCEj3hIcVyL/YBO75pkrZN+iAVXNTRt1gHX7YoYhPg7uy7zHClASsWb
W16lOG2Tg1A8WNvloFDZ+09YlvMLK5GS/k5ve5n9qtgYuS39g7JbetyB6ScVl+MX
y1zn3BAYoTfdCpr8M4X36kEsBOsGg6h3a2aIBJST67omzck4HwREHAvPh37d3eTe
6llP3rlbS4WNEPdsKXrFjEj+RI+pSysdn6DddqUQwFR4u/cXMQRo54lRdXAl45qt
doB+/7trt/gDCo7AmIYGGOcHlkG8OcddHZs7xBV81u5MMb1dZyVAW5RPt9rKlYIZ
qXBjlnXUulhrJC+mCjz+UM7ZqSyYLhZ5o/diKcJIg35GT79908C8qlLEfdWPQkt6
ItPUe8h74HSRtUS+wq225RKv8qsorLtIO3ILf61s++dMYpLah10BkW8qeYIFJE7h
BR/VTtmrj0XuLtpinqYY
=LoFk
-----END PGP SIGNATURE-----

--jZUYryPdXB7p5neD--
