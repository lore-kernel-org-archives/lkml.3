Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaA1RxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:53:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60698 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaA1RxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:53:16 -0500
Date: Tue, 28 Jan 2014 17:53:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Daniel Santos <daniel.santos@pobox.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140128175303.GT11841@sirena.org.uk>
References: <1390901583-32359-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r3Mh/mGWsojp83Sz"
Content-Disposition: inline
In-Reply-To: <1390901583-32359-1-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Revert "spidev: fix hang when transfer_one_message fails"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r3Mh/mGWsojp83Sz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 28, 2014 at 10:33:03AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> This reverts commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d.
>=20
> It causes a NULL pointer dereference with drivers using the generic
> spi_transfer_one_message(), which always calls
> spi_finalize_current_message(), which zeroes master->cur_msg.

Applied, thanks.

--r3Mh/mGWsojp83Sz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5+58AAoJELSic+t+oim9y/cP/RTR1S8jHdE4lUjyYPyxNU4F
vqujjtGrEOo2YXKlOHsVhS2qF8fXpjTmfSs+mC5VUKo1M70aQZSiGO7k8qOBFGCA
tlkAxdZq0zrqrTzrLek88NslIA7pO/rkR/u3/IPB7ogL1cPSihCKM92tlUhVJ5qQ
DcE4jybP6UD3hstmA3VI694IivFmQQrvWDjPtEJCZsfcSllw8hWV+c7oFB8ZF1vJ
GrHy2RSSD6j5/pM5vUMXSsWtRpSKxpAefCdcwIuqiXjSXoK3NSYNTE6bGyq3sSAE
9CiNXgdtPp9PduxBAHmKPRXyItHlSP1Z4JVtZr4EQJFnpyGRjuTrBYocMpnFtSUQ
/M8+rHkxcWOjyIe/hUz9Qco/gunVY1WFNJ8mBR+Y7kGhVr2FjkxaiM47+I4/dZQ1
ej2m3SYY9em7MaCVSX6/It2JFhoiWvmvs+nHtW62HAUhgTaBiAinVRvUS6xy5J6f
tJaY1SSsO9Uv8WddqsBdX3bEvRF9nos/RQUg4YRq1wRNbhQqmvcp8tqQxJmcjrzH
Epsw4v84bMWHGk0s31F+gawQ3451kWD731iecLmzFlAAYsKhrJculnpqukbeaTTv
MWvzW6vCO1er4hTfao7YL+5R71vjES9QZs4dI3oeDVaSEib/GseNi3nH98p3NKLK
uPt6K2vyjM0uHlFDLfxf
=f4AT
-----END PGP SIGNATURE-----

--r3Mh/mGWsojp83Sz--
