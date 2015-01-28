Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbbA2Be7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:34:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38403 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbbA2BZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:47 -0500
Date: Wed, 28 Jan 2015 19:57:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150128195748.GQ21293@sirena.org.uk>
References: <1422474819-22689-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5j9EWX0zxF50a1Bm"
Content-Disposition: inline
In-Reply-To: <1422474819-22689-1-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/xilinx: Check number of slaves range
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5j9EWX0zxF50a1Bm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2015 at 08:53:39PM +0100, Ricardo Ribalda Delgado wrote:
> From: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>=20
> The core only supports up to 32 slaves, and the chipselect function
> expects the same.

Applied, thanks.

--5j9EWX0zxF50a1Bm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyT87AAoJECTWi3JdVIfQiHoH/j4TmPHpDKBCuyxNQ5mYqJei
J0ffaP0OLVnhH3UUff8omaQpkVIvY5anTuvKJtLHsRUmqp3d8+LYKmcS/GjUWrEY
cCK7L1B/tmV9oH5JKKbodjuSV5g8MHy3G2ayBNuOz/uTo5K0xfjnJj5a3QI12sDI
vxKHCSfrXxzIf0SfKjOfEprHWyjNQMljM+4xjvAM7q/cuyFnojc35vs/nT78lC6c
IPA16HMeHgBOf7xqb07DifMI+w0naAO17CVjL2PgYMZyPMncgVaM/WSp4wE0TxXi
jv00oL6LdNln5MYaUW9ezuGYaWdngLNIOcWidBbXRUgtCVPkmkyivRhYjnwen7Q=
=8ucE
-----END PGP SIGNATURE-----

--5j9EWX0zxF50a1Bm--
