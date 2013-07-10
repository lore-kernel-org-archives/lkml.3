Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3GJVDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:03:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34504 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3GJVDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:03:13 -0400
Message-ID: <51DDCC01.1090104@pengutronix.de>
Date: Wed, 10 Jul 2013 23:02:57 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        AnilKumar Ch <anilkumar@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/12] drivers/net/can/c_can: don't use devm_pinctrl_get_select_default()
 in probe
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de> <1373471889-18107-7-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1373471889-18107-7-git-send-email-wsa@the-dreams.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2GEBQRHRHUWQHPQCAISEH"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2GEBQRHRHUWQHPQCAISEH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/10/2013 05:57 PM, Wolfram Sang wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device=
 core),
> we can rely on device core for setting the default pins. Compile tested=
 only.
>=20
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13=
)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Who takes care of this patch/patch series?

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2GEBQRHRHUWQHPQCAISEH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlHdzAEACgkQjTAFq1RaXHNxuwCfU22mQey9fGPWB0I1SWFaBJ7x
M70AnR9WXSzupvQ4/lraplY5fhqhJXl6
=7O5d
-----END PGP SIGNATURE-----

------enig2GEBQRHRHUWQHPQCAISEH--
