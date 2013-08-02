Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab3HBKHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:07:51 -0400
Received: from up.free-electrons.com ([94.23.35.102]:58894 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758841Ab3HBKHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:07:49 -0400
Date: Fri, 2 Aug 2013 12:07:44 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 0/2] clk: sunxi: Add clock support for the A10s
Message-ID: <20130802100744.GS2911@lukather>
References: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3FC1ngOohd+pYSp"
Content-Disposition: inline
In-Reply-To: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w3FC1ngOohd+pYSp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike, Emilio,

On Wed, Jul 24, 2013 at 12:28:22AM +0200, Maxime Ripard wrote:
> Hi,
>=20
> This small patchset adds support for the gates found in the Allwinner A10=
s SoC.
> Since the gates are the only clock that differ from the other supported
> Allwinner SoCs so far, the two patches are quite trivial.

Could you take a look at this?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--w3FC1ngOohd+pYSp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+4TwAAoJEBx+YmzsjxAgKvYQAIk3ar+fdHQtJHAj8F4oObDH
uNpAO5cuP4EvSWrrYmw/icTQFilb4DUkIjRWeJLwnzSpXHxxiT+yI2OYFwhlP/7b
ukmhyUsyCQRI13lzVGpUSvQvkbzg6HhVx5AkfurjdOwxpVdywDbI2Mr1taz+8siT
fPMi/OZ7EjQFGE+nTtV3V5M7MLeo6UB6h9fgL4G2L+uctpl6u0Czu64DLiIl5vOv
kJrCyoAAqy3zI6a+PTA2BhP824ZUx7Xt5BhdBcW7rtI/pcIsHYmRMyX84KPdgXfN
a5VK9EeJ39eD+dPP5tB/wRVWxd2mkQIwmPV93/3U2toDpiEN4NgCm+18THzRw+YO
XgaLpz3BGUq9b7FRStHNK2HoNmaqbmL2YzpRJt/FuAics2D/XUykVUl2JII8AbCq
YE6JFjb0sHYtc+q34e3rsQCLgvcYi+s1O5Fc4UffWEba5AweA2GVUAjru1roph6D
dCaIJXKtqp85F9+f1Y4Hd6h33SseJuETA5cbIZemf+/P2ybytLpsNKGBGg0Q0DLn
uANJOiwhgGsB4qPqVLI+cBU8IwIPdmoAjFGcXKacC6TSO+Cx2rwKSjFv8+dUFcQj
AxhUxK7/XN54WxiEn2ODF2xrsqpLRh1t7/BGfZWpIatiYAcl0WvriiZO1QRG4kC0
5OLKgNQEdQ7i091jiCWe
=86VJ
-----END PGP SIGNATURE-----

--w3FC1ngOohd+pYSp--
