Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030585AbaDJMkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:40:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38731 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030279AbaDJMkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:40:06 -0400
Date: Thu, 10 Apr 2014 14:39:41 +0200
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
Subject: Re: [PATCH v2 2/5] pinctrl: sunxi: support multiple pin controller
Message-ID: <20140410123941.GQ28585@lukather>
References: <1397132747-13917-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397132747-13917-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yPSgZSQ6mfPWgZ9n"
Content-Disposition: inline
In-Reply-To: <1397132747-13917-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yPSgZSQ6mfPWgZ9n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 02:25:44PM +0200, Boris BREZILLON wrote:
> Add support for multiple pin controller instances.
>=20
> First remove the static definition of the sunxi gpio chip struct and fill
> the dynamically struct instead.
> Then define a new pin_base field in the sunxi_pinctrl_desc which will be
> used to specify the gpiochip base pin.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--yPSgZSQ6mfPWgZ9n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRpENAAoJEBx+YmzsjxAgy5QQAI80bjZO5b6sxx7WDONnKdjJ
SpgJByOBUXqKeRcXAFrs35g/D+d0xT/ryIFEv0aLIzZwO+7w+bilXkLgNI3CppQX
UL8OoCL5fU3WtHpbC51GVWseVZqTkisQJal6CzsAk/YoJzb7+T7tWSg9D92OKT0z
HzI7oLNy6QMQGqXX4nMvu9Z2pa1V+BT4wX5zsP3KujOes+Xg2ZPsoMwsRbiwOIOS
+YyxkxjEqCqkd/jofxXhyNQTd0H2Z+B9hizYPRML1mUDUYJwyFHTRqFdOPkG8DEM
yNy/+a+ObrxTgKrJJlrCMlmKAD7XWP9y29zFRtNg43+mMb8vTLja1ZH9tcoms9MO
S1PcfZAomnkWV20z/wVYSS195jDL1RZ92Ms9Cjgqm3kyFDzR/kpyglwI9iwk+AiT
B54zV7fxq/nnV0A38JJzBHqOVNYJMzH57Kj+zzfoY89I6Rczj69AsbPn+6H+TAC/
D44P90Aqnj7ATjofFHz4eqzoDgfYJWKiiFpwRGF8dqVmx5LkL1JhPBlJQEanyXLe
Rn6W5Rj5OB8fSf5nv/l0XVHH+IXoz6BJiNR1beZOrHd2OOJOpRCOg/yubk82J4eD
b4hPWCgkFZytEh8NSU81liYwquEEL4sjZcIt3i89WfRKlbQVPWRRrszfd6ismGe5
mCru6qEshRxVp8Um0m7I
=gNYv
-----END PGP SIGNATURE-----

--yPSgZSQ6mfPWgZ9n--
