Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaD1XZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:25:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54083 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752974AbaD1XZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:25:06 -0400
Date: Mon, 28 Apr 2014 16:22:32 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH 1/7] reset: sunxi: document sunxi's reset controllers
 bindings
Message-ID: <20140428232232.GP3134@lukather>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
 <1398697130-8338-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PT0wT86ZVVq2zanE"
Content-Disposition: inline
In-Reply-To: <1398697130-8338-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PT0wT86ZVVq2zanE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Mon, Apr 28, 2014 at 04:58:44PM +0200, Boris BREZILLON wrote:
> Add DT bindings documentation for sunxi's reset controllers.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  .../bindings/reset/allwinner,sunxi-clock-reset.txt  | 21 +++++++++++++++=
++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reset/allwinner,sun=
xi-clock-reset.txt
>=20
> diff --git a/Documentation/devicetree/bindings/reset/allwinner,sunxi-cloc=
k-reset.txt b/Documentation/devicetree/bindings/reset/allwinner,sunxi-clock=
-reset.txt
> new file mode 100644
> index 0000000..a582804
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reset/allwinner,sunxi-clock-reset=
=2Etxt
> @@ -0,0 +1,21 @@
> +Allwinner sunxi Peripheral Reset Controller
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Please also refer to reset.txt in this directory for common reset
> +controller binding usage.
> +
> +Required properties:
> +- compatible: Should be one of the following depending on your SoC:

It doesn't really depend on the SoC.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--PT0wT86ZVVq2zanE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXuK3AAoJEBx+YmzsjxAgXm0QAJJ6/VEJWiU+QTD8r/JkX2Ie
4/K2KEmVjNw5VgE7BeNaeAp7hHLS259J6+PRh5In3TPJpWeoC67EGRG9fnNy9pln
midbq9eQ4hOYXAfad0XqNJm9vwvEV1Hl8eMSvYgQJiDkpZ91/iiL1xNGtOXKv7AK
OZQOL9oAb23lCsSMaSPvBfSRkHG8rlPIEXcOWrLMloyQjxQKwb+K4egA5vRftM5k
g1D/lMKihQ9eE0niI3sM8vZy9EISbhEq0Z9NRgWeKsw80D01CYeZEVzeekBYZIv0
Sib4GGnjjI8v7QFwH+5uD5otLxwdW04C+REMIk/xSEzcWnCn5+u8+lBr7g0xmkOe
oL2Z6oaESD9/jXcDhV5z7/YDMlIArcWROFa8eD0yEdwYp6gtVKrzRGIHs+7NkkcH
fi44tGE/6vO7XeaKkNBeohDIjpvSz/ubhjXwtIEDiFI2Lsk64zm3z0jPoJZod5Gz
N9VF1hLskt+7VsiYNKn5KY4mNrDVcIWrxDDxoi2teIqiRuzTPSE1ae/1NRcSA2Lt
mwN/z7S1YQdg7By2EIwMP0rccIJ1Nx1dlWFCL8eH1PGBqdnHuSTVaOyHjL4kC5w7
fH1uvifczRwXb21jaOOoZEtqZloZiONEVQZ3VpI4zpWq8Z59w/wcYk63clY9tPlg
p4RW1Te91K6BJOptQEqV
=aZ/j
-----END PGP SIGNATURE-----

--PT0wT86ZVVq2zanE--
