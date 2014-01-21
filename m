Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaAUSXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:23:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57670 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaAUSXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:23:08 -0500
Date: Tue, 21 Jan 2014 18:23:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140121182303.GN17314@sirena.org.uk>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
 <1390317009-8292-5-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oAc0I54T8xuiKiNG"
Content-Disposition: inline
In-Reply-To: <1390317009-8292-5-git-send-email-geert@linux-m68k.org>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] spi: rspi: Document support for Renesas QSPI in
 Kconfig
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oAc0I54T8xuiKiNG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 04:10:09PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> As of commit 5ce0ba88650f2606244a761d92e2b725f4ab3583 ("spi: rcar: add
> Renesas QSPI support on RSPI") the rspi driver handles Renesas QSPI, too,
> but this was not reflected in the Kconfig help text.

Applied, thanks.

--oAc0I54T8xuiKiNG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3rsDAAoJELSic+t+oim93usP/3PhJA4lgqZeq7TDtlJwB7FI
IX/1fV9wsOG78BjLbFcfoF/TRcj6kV2PDBJWLWRrOduKqZrLF+4wRxQKcKhVCgCg
BiPD33BUZZVCUWuh3p/f4KoYaFQF+nJNw97R1spdVTaoBgGdIALRXsy334i9cvTz
QJ1bbDLmzEx8LaRkUKtkjTGMKw1LSRTRaK2MF+1yRiS4FP+cz0hnBExxKj+hkLw3
tvvZr/ZRXypDrmq6LU8+XyI/Tjt+RtEwgQCEl4ZgVyF69WSPYu4wfdLzhZSIw7b6
EDIC3A1wAe1YdW7AYxL6FCT1WUXP9xdKmsJgvLl6bRmhON/ti8sN9pJh+QHz3+iR
uTOAigfBSwnxRNP/h0vAcMQztvwumkxz/NWo8O8aWETmsIVO6dfoZyCR4eRPkMAb
oLZuLYeqgS55toyVGDhlwrI9bnk/gDukGIqI5yTE64IsT4TsuNB8hDfYHgP9p11y
JxeiH8QNs1NSVWsM9lIseY8Y6m5OseqFOb97rPlJy1VwJR2tCFFpqWm63QLuas6p
VHd4PC3rDO61gFLCBfc6+kqsLfJhyLcy1G6zcMfg74ArUEyCbVHF7t/o14npKfi5
u4g7+nj/Ful9N/l4KAXK53RaNZ76+YM1BQbLsX3nz13kPSLufvK+uwcUjrw9VmEE
vUHQckWYpAkSTou0dl6T
=9iwf
-----END PGP SIGNATURE-----

--oAc0I54T8xuiKiNG--
