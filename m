Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818Ab3GaOAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:00:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53251 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab3GaOAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:00:19 -0400
Date: Wed, 31 Jul 2013 15:00:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        kuninori.morimoto.gx@renesas.com, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130731140011.GV9858@sirena.org.uk>
References: <CAPgLHd_0p56XkKjmtaD8J8OtTxPg-XY9xQRepsZYNtH-tY6uFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="diiB1pV/0M5IS+GS"
Content-Disposition: inline
In-Reply-To: <CAPgLHd_0p56XkKjmtaD8J8OtTxPg-XY9xQRepsZYNtH-tY6uFw@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: rcar: fix return value check in
 rsnd_gen1_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--diiB1pV/0M5IS+GS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2013 at 07:51:37AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> In case of error, the function devm_ioremap_resource() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should be
> replaced with IS_ERR(), and also remove the dev_err call to avoid redunda=
nt
> error message.

Applied, thanks.

--diiB1pV/0M5IS+GS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+RhoAAoJELSic+t+oim9JywQAISdmHcMOHn44JaTu9HRgGXo
dpDck6jttaHOGx42i27DfNUlqopufcK4p5O6scqJZS54r/Rf0N83m5RoAF1VL4Bf
h58PlyQOtlao+YMyWmVrDA8L3iEALwUMOCw7WlPgfqYOK3cTD1ekQxrT2IXP1cKf
It7r7YUNf9rTJ3/Z/eocNkL0C0hI0Kgqqwx2NO1GB6OAvKhU1mJ8KT8TfNck6qq3
6tFNewf/JD6m4DuucuNmo82Yf6MRbjFqU1MuWjYiBNp/cKUZtRSyEGvcG4FDE4gn
ARUNhrB5d/b0XEMOWlw6HplWIXSGoEgfMStTy9vtSqy4wbQ5jf1pUOc+f60uBRlB
tiSscnrfcxhIxOSIj6lmFU2Ro9kS+KNVu2bc/A8vDZ2g4o88PB0Aqau7o0/Fyw1E
4uy1t2yjThPtl+jquEeYK6rhAk5QawTuceIlDYe8u0Fkxu+wEpf63KEv5+Px/pTm
yrN0bP+4ZZMK7RcjGbyj6jnI3Pm0lL0YNUI6F1Ms5D6i6gSeG9hpnCLbhtiaR2Sm
hetUkwXZN93uS8DA9yBIF2C9AqRmEcd/K+bNcPYcbkYSQLUnvdEFXt+kT3o8iej9
X6pF7NPhUbZGjNvUOqsOf3GcGGTrbxmTx9sclYNZudy2W9uldWxX1zfQDPaL5OIq
SPL6tKskx32qefTWs7bS
=Q9FQ
-----END PGP SIGNATURE-----

--diiB1pV/0M5IS+GS--
