Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaEBROr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:14:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55361 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaEBROq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:14:46 -0400
Date: Fri, 2 May 2014 10:14:11 -0700
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140502171411.GS3245@sirena.org.uk>
References: <1399004974-19566-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JPmhzT54liBDmwDC"
Content-Disposition: inline
In-Reply-To: <1399004974-19566-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: Protect DMA code by #ifdef CONFIG_HAS_DMA
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JPmhzT54liBDmwDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 06:29:34AM +0200, Geert Uytterhoeven wrote:
> If NO_DMA=3Dy:
>=20
> drivers/built-in.o: In function `spi_map_buf':
> spi.c:(.text+0x21bc60): undefined reference to `dma_map_sg'
> drivers/built-in.o: In function `spi_unmap_buf.isra.33':
> spi.c:(.text+0x21c32e): undefined reference to `dma_unmap_sg'
> make[3]: *** [vmlinux] Error 1

Ugh.  It would seem better to have these functions stubbed out.  But
applied anyway.

--JPmhzT54liBDmwDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY9JgAAoJELSic+t+oim925YQAIx8ONzIEWzG7IB7HAXx5QC7
FR5RlQjCD8ZFJfaJ0QQB3QK7OrspE/WqVmUJAjJjDsW9o5EugOMGcP4qm4TUzHIk
MBjuf8uDkdTiPU0Wu9lkyk4B1H1TxD7VIjvE2Wue6BjI/HtPLEHRYbjYWPl5vpfc
69Eer+af7l2TKitQFoErnIouwMM0zfwPqmgeEqSKVBoVIdvug3D03RuKOD390t7m
cudvuxTVknckalehldiYZP89TCgiteG/uk+xlTVyyMiF6GyNN5gCDr6fuS6LK/ka
XUfne39qfyt5q7sbiKGlumWJQdAa1U6dv8KnfgPZVobF0Mf1f63lMr6MDhBbowu6
3rZWuzR2MfBU4owkaTjaruwK4LM0Zvl/8/vbVb9Su6ztNhi2X+iHq180ED+2Qzcp
lrL9LPQr6Bk9Uj4AMSS92sSqXR6imc5kdb4mDPu5Bez7j11W+WMqmyEZ2R6cKCCP
hgkwP3DLuElrcLHiHVQsYtRfQxu/XYm8jHKgdvYpGu+8kkuajOxdKReJucAq6ni7
3WLO+mFcEmyWznRRbovPhGEIVRyVzSLR2J1bO9sEjrmcAl2sAEhA/tnNJsKc2D5p
YexYr2pgY1cDYH/3+McQ00ht7BIn1x3YMLnNXoYj8HKZ3cmVdAFoiudmLKVt0N9r
D7Rop01lL/byTiMAsSaB
=fIqD
-----END PGP SIGNATURE-----

--JPmhzT54liBDmwDC--
