Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaBXFed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:34:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50535 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXFeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:34:31 -0500
Date: Mon, 24 Feb 2014 10:35:42 +0900
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140224013542.GS25940@sirena.org.uk>
References: <1392999293-5015-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="omE/1KreAogPZIYx"
Content-Disposition: inline
In-Reply-To: <1392999293-5015-1-git-send-email-geert@linux-m68k.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] [RFC] spi: spidev: Add support for Dual/Quad SPI
 Transfers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--omE/1KreAogPZIYx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2014 at 05:14:53PM +0100, Geert Uytterhoeven wrote:

> The Kconfig entry for SPI_SPIDEV states:

>     Note that this application programming interface is EXPERIMENTAL
>     and hence SUBJECT TO CHANGE WITHOUT NOTICE while it stabilizes.

> So it's OK to break binary compatibility?
> Or should we introduce PI_IOC_RD_MODE16 and SPI_IOC_WR_MODE16 instead?

I think it's been experimental for so long that it has become a stable
interface I'm afraid - the new calls would be better.  Why not go for 32
bits instead of 16 bits for the new calls, that way it'll take longer to
fill up again?

--omE/1KreAogPZIYx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCqHrAAoJELSic+t+oim90wcP/RclwU+j+4jb+6svGjGbRkDW
i6cO1OU+bGBsrHUPzaqqpqi1nknpA4A4ZY9rduGB1+5kDD1YyBUa7Ia4AdQWG9B2
rJmBbyDBM8E1g0PinlcDkDQ9UMB9OQMGRrlmJHapH11Tl0TfoHY/oqACLOMD8yb8
mNnG43w3ZFRdsPvO9GRP+jw1cFEKI87GJsF8XoTPLa4CSUE4uhYbfn+VW+2uaHn3
pCSBOMW8gSEdinBkMaN2puRJCZMgpnSVSHyR9cNRfBfg/kl/dO6MDiT80ZjYJg8X
jYIcfHAe+vkSKXV738vzCM5fNq9MDJd/vnPIjLHNc5tXGzO2WAvzQ2hwOtkT67S8
gRnwu7gzPi5PJEBXHQWPAiicmwtkRc/cOAeG4iqb65/YNruAuGu0/hmR3glQuynV
v4aZQRPIL0g86zt2inLT87cKPuBwuM1m8PqxtDmPA6HUShdWTyZd6/u2jzgkpUWr
CGAzG5y5VHZvjLgHiRJn+Ae8X7cKnCESGpFrTFGCinFbElEE1+Ll9MdjSEgUmFFc
v7sMY+57ViTQXdgeN7nrmtBxLcZ/oag1O+rB6Hdpf7NVzGbtsreD/+/TBtKac0Q7
kWdq63JswcS5Oc7ZV8PowTIrKkMZfegk+48e2MC4DgTjAZrMsli/qfTvuJy9hVDn
XPUbsRXiRZGlC0fhlQlT
=2ceX
-----END PGP SIGNATURE-----

--omE/1KreAogPZIYx--
