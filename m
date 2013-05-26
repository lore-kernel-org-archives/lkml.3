Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3EZVXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:23:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:23:30 -0400
Date: Sun, 26 May 2013 23:23:25 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] pwm: pwm-mxs: Let device core handle pinctrl
Message-ID: <20130526212325.GA15094@avionic-0098.adnet.avionic-design.de>
References: <1367863561-11534-1-git-send-email-fabio.estevam@freescale.com>
 <1367863561-11534-6-git-send-email-fabio.estevam@freescale.com>
 <CAOMZO5AACbyUbhhoMVM9zf=tTWsFJ0HcmFCfMW048JWKprEJjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <CAOMZO5AACbyUbhhoMVM9zf=tTWsFJ0HcmFCfMW048JWKprEJjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:uT/RcifNjcCGu3jgf8TgC6cTl/bezAAHHi025JtijRa
 fiuhNe0Xw56gDwTwquE8s7WuV0NofzBP+Vd1zddGRU8MIRYYmZ
 8ec5/TsY+qozQCA+3RzmmQj4gtjcsjT0gMh+mp+Pvo71FycU+u
 BZeYARMtscSF38/Y7IJLCioBoJLYJLSe794m6G5+eOKmHQ/Xti
 GlvUH1mH8iZr1Xsgzg3bSA548K9j+nQq2JpyCPp9Lntms1RxkU
 ZFg5TL9AsdUS7IV8LySj6BnV+ZFV5JrZnvtmtL6BQHNKrTIZZS
 vnwPJQ4vbg8E9sqdGdyt5y/G+FXvpE8QHCKAWD7yfaqUkZ/hzE
 jBgG2SoMw6+ij5Lm0Zbb9VCxy2W5Iiw60+PGAOYEcgMR3nViVu
 athZ9lT4Nq0Ksoc0khEvYcpVHXLHvnF+/s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 26, 2013 at 06:02:16PM -0300, Fabio Estevam wrote:
> Hi Thierry,
>=20
> On Mon, May 6, 2013 at 3:05 PM, Fabio Estevam
> <fabio.estevam@freescale.com> wrote:
> > Since commit ab78029 (drivers/pinctrl: grab default handles from device=
 core),
> > we can rely on device core for handling pinctrl.
> >
> > So remove devm_pinctrl_get_select_default() from the driver.
> >
> > Cc: Thierry Reding <thierry.reding@avionic-design.de>
> > Cc: <linux-kernel@vger.kernel.org>
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> Any comments on this one?

Looks good. I've applied it to my for-next branch. Thanks for pinging
me.

Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRon1NAAoJEN0jrNd/PrOhe7gP/0MCR/6LnjpFGiPzQ11LIBCH
G9k1p5Hb09olb3onJ+Gvx0sx1MNK+DM0Ll8EhDiASc7qnf8qePZZHibCVXgbrcfU
1ewrUo3XEkZAk29nqBo1huirOK1zSSoJr1nABh3ZCHRQmY+DVO94jvcuW8F8sGLI
065Ech1zNSIza8CmxRtfEzBxxhNI8mDZMp8GXB4oSFmcfhOXAAJNgTUlteTQVEmc
Qm2UUYjcJ2gDA4ZetZ/5DlI2PR8SlesM60uzreUhk1b7qERTlaZndKMbEwpRsU4r
jpkgxSMpFG2JlQX+cpMvNi9pqFmXTAHPB06JuJFS6I6qhBm7JuTSClSufS/bakMj
apJlTNmZpBku9BfAn3Bym0xG6EwUV+actm0EYM989W1p8vzGsm2ttO9/O14I00Z5
JMx5S2ajjGMnjP/MBJzb2nMjTPfxptIjtS9aJmqKr2blONY2prbF9rHBg+xL/Xod
KYZ3Mkqt5USLVHFyjoun/jFwaxTz4Izwu3l5T5DZGLxYDY/1NeBGiYsjSAslVt1b
nqQZt963tYLACO/gvwGnX1aEQ+ryeSm8u2nMv1Eoa4AhnOiZhvCaYsjEQ2vcyf3r
KwzoIqQRssL8bYu5W95SwPKEZyIZdwcH2lenKf8aDi3Ie4Q6fysIAR0FfLVI5nef
+pqfLFcZoBqBzK2dlonI
=ZA0f
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
