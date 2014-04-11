Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbaDKNKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:10:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46030 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752653AbaDKNKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:10:08 -0400
Date: Fri, 11 Apr 2014 15:05:52 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 1/7] pinctrl: sunxi: check clk_prepare_enable return
 value
Message-ID: <20140411130552.GX28585@lukather>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397137966-30818-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ycl1UgPPPgGZoSL"
Content-Disposition: inline
In-Reply-To: <1397137966-30818-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ycl1UgPPPgGZoSL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

On Thu, Apr 10, 2014 at 03:52:40PM +0200, Boris BREZILLON wrote:
> Check the clk_prepare_enable return value to avoid false positive probe.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--4Ycl1UgPPPgGZoSL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTR+iwAAoJEBx+YmzsjxAgYEgP/16FOUe/9zXLybKpfB/Z28pW
5+uDRKF+fBFKbJP0e7P4kAzaqOdlH/OzjP5w+UYPsMaMZb1ntRJgLr43yeVZ/eFY
Sdo34pTz7mNh4+jycisILLMJuPQD04yfEmxs0L8EyGlTfX6HM3o7JkAsT7uEiNDx
BxRe6FdiU8eCJiFF+L+Unj3rhHjLFwQyHoknNONLCc4s/gU21S1tyEj+qrtY4633
1OFiQifVuco3wDBsiMnPgdpoVNyd8T75kVzRbPAVu6z0FhfAxdshlCLgl+7xFB9Y
pJjS1lhqhmKkilsx1rq+BA05PnV7S1W+sARNmaoLFxY3oFmEaZOpv+fIMmUUKOVY
KUJiWnQZDVL6vKJsuWyMq5ZzNWwWp8EKHWfRID5VjwpzGEmr9DxLpNsGVNvHBsu6
fM2VmhHsGAxWu5yU8r3lrh0Y2HLeKtYjwkJvOCAMS8T/V55MdO6CXuJTkjCPlUMZ
u4KaOi22u7Eziw5LX7fOk28KHjrRHHgsMo8ZRNink8xcV8TOmy3Mvfn7dA/6fsU1
vEv+6c8uCrcyvqCTv6n07MWP1sUhf8YhLlyxe19nZJeBD/vODTzmYUo42uU9yJDf
edS3qJ8PtMqZLE8KarVF7r0O87C1r8MlGRX1k0PUTP8goK7oxavD+YADQZwsorxT
BY5mL3uN7ZAcObJ5EYJA
=ficV
-----END PGP SIGNATURE-----

--4Ycl1UgPPPgGZoSL--
