Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaANOgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:36:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54023 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaANOge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:36:34 -0500
Date: Tue, 14 Jan 2014 14:36:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140114143627.GO15567@sirena.org.uk>
References: <1389699296-28994-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w6U88vdWm8UqIXvc"
Content-Disposition: inline
In-Reply-To: <1389699296-28994-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Clarify (a)synchronous transfer_one()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w6U88vdWm8UqIXvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 12:34:56PM +0100, Geert Uytterhoeven wrote:

> + * @transfer_one: transfer a single spi_transfer.
> + *                Synchronous transfer methods must return 0 on success.
> + *                Asynchronous transfer methods must return a strict-positive
> + *                value on successful submission, and must call
> + *                spi_finalize_current_transfer() when the driver is finished
> + *                so the subsystem can issue the next transfer

This is hard to understand, I'd not expect people not comfortable with
English to readily follow what it means.  Things like "strict-positive"
aren't common outside of mathematics and I myself had to think what an
asynchronous transfer_one() meant.  Something along the lines of "return
0 if the trasfer is finished or a positive number if the transfer is in
progress and finalize will be called later" would be more readily
comprehensible.  If you're concerned about positive just specify 1.

--w6U88vdWm8UqIXvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1UtoAAoJELSic+t+oim9A/YP/0zcshejgXSMiSvA/bB72uL2
fBiow8H3vXf37JSsrsS82BmgAyg2vfA9qI/okw9C3sK5fYFWDbyw22NldFUhnS5Z
YUtBW8uI4SIzX2c99vsGVhdnME8eliqxK1ajcwP1wusa1YlkiBB1rxXM4IDlRH8w
LJdAwlc63aYcJNXcT1ia8b4+Wpkmz/InA99p2u9CJHE7IWoJokyv7GPQjdW/KEzi
R2lcBWDKsM4rcbABM3eOqB72O8y+HOJAgge31w/qhee1LEBQrtrYTzj0uqurq/Yb
VGbiqo9K/NVFby/LLPLieSsitBacbGw7tulu2jqqwBdvlWfm6743MSbRtvsb/9nz
WB9Qrw7YFQF6PKWKtIBz9cZgiZ1zYJfJhLu6xsjF1fYJ5oGsIO4Y8/5Ty6w4fJ17
u7hJWe4aORccfoZFw00K/nkxR+/Dg/+UuSQ9Ofi6Te3BzDrYfdyUpP4zWE6Fr6aT
bYySArKNhVeiC2GTt63RdLJW+HCkiUSODKGaOYfZInnlrTktF7gbZ8iIsgaAGpfu
uAFxsPPvpmNWW2cdGHLP44ogJ+ZXOCs1W1Zr1V3tBIZ2YWPl8MeaEX0cmxoIGBqc
yLgnIiXY4VZNAnI2Oa4X+RiBtbron+yUKoUdPObfZpIrK7Yf5cc7mDUGgiQi85VW
YupddW2S7Pt3XZRPyMFL
=6plw
-----END PGP SIGNATURE-----

--w6U88vdWm8UqIXvc--
