Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab3EBNmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:42:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33024 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691Ab3EBNmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:42:01 -0400
Date: Thu, 2 May 2013 14:41:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@linaro.org,
        nicolas.ferre@atmel.com, richard.genoud@gmail.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20130502134123.GA4945@sirena.org.uk>
References: <1367493801-3037-1-git-send-email-wenyou.yang@atmel.com>
 <1367493911-3182-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1367493911-3182-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/spi-atmel: BUG: fix doesn' support 16 bits transfers
 using PIO
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 02, 2013 at 07:25:11PM +0800, Wenyou Yang wrote:
> From: Richard Genoud <richard.genoud@gmail.com>
>=20
> Fix using PIO transfer mode only support 8 bits transfer, doesn't support=
 16 bits.

Applied, thanks.

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgm0AAAoJELSic+t+oim9hJMP/158Xv3e6C0rX4GId53c5WNx
uLngPy4hiuZhf3MR99VnAi3Tq27P2aWeHMJvVVygJG77QELElxSTa9myTaf0GvIF
Its05vOBpbQVe84nNF3ANNOjv7A/CANXC6XI3YQVZUuVQm7h7BpXaWHU9yQU6Dyn
oizs6eAGRa3vxVz2L+nF8helMGjFE1GuhH1BUV7QWY89freJARAy47MSLtS1K4ku
S7GIktn2YoLDeWS2F1U9Dv2JBIua2SMlXDx1tUdVxHm5R+Zlhn4lP+lRSuDhY1P7
EFEhix7RNDQbk3JexYVIf5burG7hoL9/3roHrO2Dqp5XviXF3i3YTX0URhzIUhFm
obDDGEbueENCdQ0KUWsqCsW/vadsbM7tVXbksXRcWJlNHHCZkS/eqG1jD/uRJMFm
33YSiqtsYmDXuuBodO3qPGf2b5yQIFsm4JUuFKCAtp3s32pUcvPwPLxxWyv/+iyv
0mB6IG1CWp84vQGjG5rfY0cU8db27C2Qvq1S7nDE878By5Td8xJJbgJ7Rdt98NuG
tlSk1J/QUxCiVSAsrQCTblXCrMaxFu3lLQ38VHbaEGz8YygX/LhZ1ZVo/3dcXliH
aR2/G0hNmbbXDqjM7saf7BERXFvASAkaIeN4OjT3K9pB5RbzNWd2+e3IwD/JqNZc
8I+fk81kAdxFV7yv5I9G
=g3xg
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
