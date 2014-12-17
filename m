Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaLQS3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:29:19 -0500
Received: from sauhun.de ([89.238.76.85]:49464 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaLQS3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:29:17 -0500
Date: Wed, 17 Dec 2014 19:29:15 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: sh_mobile: I2C_SH_MOBILE should depend on HAS_DMA
Message-ID: <20141217182915.GE3981@katana>
References: <1418650624-28174-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mR8QP4gmHujQHb1c"
Content-Disposition: inline
In-Reply-To: <1418650624-28174-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mR8QP4gmHujQHb1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2014 at 02:37:04PM +0100, Geert Uytterhoeven wrote:
> If NO_DMA=3Dy:
>=20
> drivers/built-in.o: In function `sh_mobile_i2c_dma_unmap':
> i2c-sh_mobile.c:(.text+0x60de42): undefined reference to `dma_unmap_singl=
e'
> drivers/built-in.o: In function `sh_mobile_i2c_xfer_dma':
> i2c-sh_mobile.c:(.text+0x60df22): undefined reference to `dma_map_single'
> i2c-sh_mobile.c:(.text+0x60df2e): undefined reference to `dma_mapping_err=
or'
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied to for-current, thanks!


--mR8QP4gmHujQHb1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUkct7AAoJEBQN5MwUoCm2kHIP/08aq8IEDCGmfnuAn5A+3a6t
C1fspkLXZ5MXGVM2Pygtu24CT5cmJ+CLGBQrNDu6zIShq1nRCtZOrXAqaNTWCadO
vzQyE1RRXIeh9dlQdKx3q75P+4KB8c5C1AL7OEwqNMM6W90vARmZf8NAwMSi4scC
lLDUqZttEdyL+CQ7bUcVjyYvUhPIbFFQ10daPo/71xC2VyB/EyP+AkOL5MiCbKQW
i9AhKSKoK321VTB7c+9BPJTvSty/lA6mJ93PDVlhuGQ7iF3b5/0Omnv34o9FNBRh
8bfjehmfnJAZ8JvJut4Ptf2m20TzQ5CQj9oiop3lHqaXTH2DGPebNvaHrJPUzX38
7ndwUEkt9vOAI48d7dY2fIqCJE/xKJNL71j1kqSzDIUkq7tDn0vWfat3A0Yqdnf/
IP8aIRFmEhHhROF8aym5mcmkBRBwj5COAQEyDB/oHwyIomaVOcYK9TzmWaGnw8lQ
xV7EqLziKOxrepLm3DC8a3Xid3uZ8G8UqrcrR1lUlehNRUNlqpjwrhhlXL/kvrGs
mYMaahW7efwdjWThkAY4Dh8mnJQPY9RUz6wWKUzel5vP+agChxdfhzV0CEswdeFG
4+83E7H0djKVIGj1ydS/ETxPkrZ2+/DKZZSVABTgEhDVeQ2mYRME94R0uPcq5pm0
BcwOzvy3pJp3y1wQeGm+
=ilcy
-----END PGP SIGNATURE-----

--mR8QP4gmHujQHb1c--
