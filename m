Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3KGXiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:38:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33498 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3KGXiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:38:46 -0500
Date: Fri, 8 Nov 2013 10:38:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the gpio tree with the arm-soc and
 cortex trees
Message-Id: <20131108103829.0f485201de58f423c8dd3e7d@canb.auug.org.au>
In-Reply-To: <20131106084117.GT14892@pengutronix.de>
References: <20131106191454.5f45b0b5300f03e74a6a09eb@canb.auug.org.au>
	<20131106084117.GT14892@pengutronix.de>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_10_38_29_+1100_4ui.E0uy5K7IEDsQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_10_38_29_+1100_4ui.E0uy5K7IEDsQ
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

On Wed, 6 Nov 2013 09:41:17 +0100 Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pe=
ngutronix.de> wrote:
>
> BTW, "cortex" is a bit too general. My tree is only about Cortex-M. Also
> you can drop -2.6 from the URL.

Updated both, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_10_38_29_+1100_4ui.E0uy5K7IEDsQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfCR9AAoJEMDTa8Ir7ZwVZdIQAIUBAMDilemPCxPxe0Sx0EUu
R/YrIWLWD0SfxUpCeunszQwo8o7xt4I2i8y0ASzi3hJA/YgCJKCZR7J30ErGdsWr
VQyQtSsxPQ6ctmZtlfVdDMjKazkmHW0q/cLDlZh4bAv/R53SnXBYoOnQI6V7FlIH
vjdF1Z4KNOFaIbycN3yme2v1OJKbrxHZsZDuL7MYau1xrDAljozJW19PsIaVG39r
oDpsnlw8qG6U47F90aYlGZ4cHBq0MnsobX3QwqgDe/fNyU0jLqRq9TSRgcPH1Dvh
g2aMs4B3gPbGHsjc0t1Ih6/MZ57UmTGR5FjMMH+uBMNDeC52sujHsxFNBRfaejQA
xE5H+Ctw8RFSA8HO2wGa5h+ZFT9nK0vUaG36l2Y9uEKZjsJ2kAd0NhbVD6qvIesj
zL9Vyq3JkWjGKhHSXorhqm8/reT4dmWP50xavU/DcGDxib/8/t61tY6FqjTZ+LrK
3mNcAr/s7LmZueHuNmYXmnR0Iub/5dWmkNiaxwF5pgZ8okD3XjsgHzeOiWF0hO4T
7Wre4WYA4U/uLPioBk6S147Y04w0puYIoRkKacUC9DO2OUfmpLDtsIQZXsya6Pq9
ohkFJJDpxKCuXeHKxrbMANLUWIc6Y+HpAEERwQbJmQ9vrBq3+v4qb1a4Mc7AIWyd
K5sjNZnLVz4b1EInrUZ8
=Swhw
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_10_38_29_+1100_4ui.E0uy5K7IEDsQ--
