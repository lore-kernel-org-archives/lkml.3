Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaBJKUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:20:24 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:60050 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBJKUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:20:22 -0500
Date: Mon, 10 Feb 2014 11:20:18 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.orig,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH resend] pwm: Remove obsolete HAVE_PWM Kconfig symbol
Message-ID: <20140210102017.GA20143@ulmo.nvidia.com>
References: <1390550056-5924-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1390550056-5924-1-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 08:54:16AM +0100, Sascha Hauer wrote:
> Before we had the PWM framework we used to have a barebone PWM api. The
> HAVE_PWM Kconfig symbol used to be selected by the PWM drivers to specify
> the PWM API is present in the kernel. Since the last legacy driver is gone
> the HAVE_PWM symbol can go aswell.
>=20
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: linux-pwm@vger.kernel.orig
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> ---
>=20
> Thierry as PWM maintainer has agreed to take this patch. Would be nice
> to get some Acks from affected architectures. Russell, Ralf?

No replies for over two weeks and this looks simple enough, so I just
went ahead and applied it. Thanks,

Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+KfhAAoJEN0jrNd/PrOhoqYP/j7Jp8PGk+gegMSCFQY3txy4
ns4SJQT7DoSP/ac/7SYtovjuxPgzZ1t2WhTmM+ZALtJ5vy3t0LHr+IUFRp28f0Mu
P1/rqxyy/sb8dUVMIfhEx/CcR7CZ1i3LFbQkIc7gev7wqWcAGckRqtpmvtrZboTH
g2eE/NkQBWdf++YliUV9IrH2tsSGhsfjFIq6yWjcVpdrdaQ8BKSQne5ueoarfAQi
oAHb+YBUVW4P4gEyVOw2+73QDwcfliHObSQ9ruo9ti/dexnjsJ9Zosi1ECIOncN3
/PvRyentTYCDI/wQQC+VuRh/Xylj4qSIlmolWsQllqV1uT4kOVtQJ848B7eFnKFk
58blQakQrYwkGri7UY+h8BBxEqd8Bt4hAFvuSltlv2P9wqtvEz9FBmpQ9w+oWF+3
YJSCGbOi6L8ZQu603UF4j0HWmHjCzfDWcBFMluKz2z1ZKJkfchAdETB06siSCyjo
7oekCWy+PthnhxI8sk+yYWQ5Yy1QJCtW/ZOOlhsCIbhW++2OzmZTRQwMGTkiQypR
tBN63KLqnptBjciwWAcXDiv78UZdhPX8GklyYdEtDDA1KATEJcEYyNy8C4/1X04P
R40+jUw3HLEtPCeVTmIrSuCbWgX8KSvAvDB3r71/qzBw6SoNEvQdAxjpYpMln4Hk
/XKd2tzGvG24UAeXnufg
=LTka
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
