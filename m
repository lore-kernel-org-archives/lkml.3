Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaBJTuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:50:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60798 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753712AbaBJTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:50:04 -0500
Date: Mon, 10 Feb 2014 20:48:43 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/8] clk: sunxi: Add Allwinner A20/A31 GMAC clock unit
Message-ID: <20140210194843.GZ3192@lukather>
References: <1392028554-32545-1-git-send-email-wens@csie.org>
 <1392028554-32545-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I/+EtO164iqGPpU0"
Content-Disposition: inline
In-Reply-To: <1392028554-32545-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I/+EtO164iqGPpU0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 06:35:47PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A20/A31 clock module controls the transmit clock source
> and interface type of the GMAC ethernet controller. Model this as
> a single clock for GMAC drivers to use.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--I/+EtO164iqGPpU0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS+S0bAAoJEBx+YmzsjxAgl00QAKbDnkF9DK+f40GI5fLY1sUP
OaYqR8o7y4TqNFk3qk+ZOpqdptBNJKy9cBpa7vz3pXoBj7ldE2vmrIPIjuDvM0Xe
QjXs4sSO9SUTcm1jXtW+qRtxXndVqvcmqxRxyLJqp2UOteG/o8NgeWWtJjand/yv
RHOXvvQPPHMZkak6BciB91ba6tAU5IA5kwh3pF+0bjlX29EtfZcgP86JTCOyRqgE
yVlogFLxUbrdJZX0gguo0jjyi1lP6ikl2X+sGBFOkq2Dx0tMU8hCdmzBgNBZUL32
C/JwD3PI+aAnDOSTwxLQUm47EK0ZQr+LN8IWBMoM5eh9rdAl28Zz9V7EGpUZMhGs
02jiCmot9k2ywO4d1XQwJghKzFmAdD/ZRBfx6By0oZ/m0f1m/eaAqxh5l/LES944
cMxnusdEeVS1tl9AcPLR9RGtlauJR4iiG9zLi71ZcgTSM+P5l81SMXSTGZE4NNIT
+Q7/DELA+1bSueCd9MbiZJ9J71rShhkTfhfRm6m0z0vJaaThQRD+pDRGuUNenfJh
iJQv7Ceg7oXySE3E6qmyNbwcyK2FP+M/VWYR3NVpcsvxInQ69naWrwVNHpa/Cvnw
YumGo+Dv5EtsppRDxbDEt/2PCvctSIVS6ubE4cxCS7WwxJowZyFpq6W295OePoET
JycFkmnGyPDOdhVJr+sz
=QYQ0
-----END PGP SIGNATURE-----

--I/+EtO164iqGPpU0--
