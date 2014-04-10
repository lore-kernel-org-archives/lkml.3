Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030671AbaDJMpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:45:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38773 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030651AbaDJMpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:45:07 -0400
Date: Thu, 10 Apr 2014 14:43:42 +0200
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
Subject: Re: [PATCH v2 3/5] pinctrl: sunxi: define A31 R_PIO pin functions
Message-ID: <20140410124342.GR28585@lukather>
References: <1397132747-13917-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397132747-13917-4-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wc6dtGz1CZgs+5WP"
Content-Disposition: inline
In-Reply-To: <1397132747-13917-4-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wc6dtGz1CZgs+5WP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 02:25:45PM +0200, Boris BREZILLON wrote:
> The A31 SoC provides both PL and PM pio bank through the R_PIO block.
>=20
> These pins all support gpio function and can bbe assigned to system
> peripherals (like TWI, P2WI, JTAG, ...)
>=20
> Add new compatible string to the DT bindings doc.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wc6dtGz1CZgs+5WP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRpH+AAoJEBx+YmzsjxAgCukP/RZcU9ThheeXn/GkqneCMQTf
j2XHiCHeE+ysDjzHPAhOTKjB2k99/feWtpM0kvQD8P16e1Lods6e7EY2anleOX9B
2Tlke1E6IeZoTkGJuaYDnge2zJkhNNgEfJovzbmAerxidsbMJdXUEQUI3CmeYlyu
BY7V77DoZrD76GQYFX98ZZG3dbLpMmcbt12DpbZdFnR03B7obw3sVlZBI0cVz3CO
KOjOcWKdlSf/BOaRL02XQ3E3PUYWhNeQgx/aZlelCuolUcy90YCpB8yHLZe7G9tn
b0h/gXrBpeS/ik7qMRSLS8Ha+pNwmuLDxmpYbUFB+elwDzBSs978XMEePJ7+eiGK
QhioEpPuVAWDFSCjKqBgFO5SflJJXcruVv1QQbGppYoMOzOifzpsfxJRLz8WzHDm
gkZkik9pUkDx5UUTJON688olx6AbEnbs1hebfVSPHD7zm0zHCofKGQxPyCNtREzO
xsSOjtD2kDV6KBkD/jdjpkUgHg5dko9/K8jL7LFjMJF0oPCzAi2mnQpa2y0cdVWy
eydq6+NUKpvETmpGrnF4njmaFyjTHOSMrlkujOFt/bWVs2Zi25r0V9Nnsy28njX4
a70DqFtbQN1KQwEnQPYLRcucGePEo6UEl3jio3KNgXFcIKb1hJUox+wAT487rGyz
5fXS6JxGhDr3D2MGHvfr
=5zeC
-----END PGP SIGNATURE-----

--wc6dtGz1CZgs+5WP--
