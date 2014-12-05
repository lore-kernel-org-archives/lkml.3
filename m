Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaLESei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:34:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49541 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLESeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:34:36 -0500
Date: Fri, 5 Dec 2014 18:34:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141205183413.GP11764@sirena.org.uk>
References: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
 <1417180198-9393-1-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24/piotZLKF/SXqU"
Content-Disposition: inline
In-Reply-To: <1417180198-9393-1-git-send-email-laurentiu.palcu@intel.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7 1/2] spi: add support for DLN-2 USB-SPI adapter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24/piotZLKF/SXqU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 03:09:58PM +0200, Laurentiu Palcu wrote:
> This adds support for Diolan DLN2 USB-SPI adapter.
>=20
> Information about the USB protocol interface can be found in the
> Programmer's Reference Manual [1], see section 5.4.6 for the SPI
> master module commands and responses.

Applied, thanks.

--24/piotZLKF/SXqU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgfqlAAoJECTWi3JdVIfQoPcH/36gOr96m4Ssyqo8jQXj0OOG
YZ7vlVUcKK1omcpZfpHyxgSqOV/xh44BmXGqx2kpDYmlD7xNvGndI/oDRCATRDMq
NUUQA/AYykCzud8T7SJ5cCW2tYLOV9uoy/87Fby4pR58ODCYKRSA3j+vGASUpLRA
alL1tVso5Vj8ZRGuKrCBEFzFogkBrsMQ2qNg1DtbSzOBrJewpt38kZrwxXo1vx86
pWRWau6aNZmd7zuvUR/axXoSma8qtbguKFaAGct3TRDv22pwwDtyn/SL9ArVthEj
P7ugfnEQ6SVnD74gzTSosUkzS3q12HM9xJSM9e7j+AlVmbeaB/vjFAbn3pGtB4U=
=9Q2g
-----END PGP SIGNATURE-----

--24/piotZLKF/SXqU--
