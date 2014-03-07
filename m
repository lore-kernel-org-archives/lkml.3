Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaCGSAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:00:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:40446 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753651AbaCGSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:00:03 -0500
Date: Fri, 7 Mar 2014 18:57:14 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Chen-Yu Tsai <wens@csie.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Barry Song <Baohua.Song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Pavel Machek <pavel@ucw.cz>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marex@denx.de>,
        Stephen Warren <swarren@nvidia.com>, kernel@pengutronix.de
Subject: Re: [PATCH] reset: Add optional resets and stubs
Message-ID: <20140307175714.GX607@lukather>
References: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jtEtYGE75hrP1CgP"
Content-Disposition: inline
In-Reply-To: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jtEtYGE75hrP1CgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,=20

On Fri, Mar 07, 2014 at 03:30:23PM +0100, Philipp Zabel wrote:
> This patch adds device_reset_optional and (devm_)reset_control_get_option=
al
> variants that drivers can use to indicate they can function without contr=
ol
> over the reset line. For those functions, stubs are added so the drivers =
can
> be compiled with CONFIG_RESET_CONTROLLER disabled.
> Also, device_reset is annotated with __must_check. Drivers ignoring the r=
eturn
> value should use device_reset_optional instead.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--jtEtYGE75hrP1CgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTGgh6AAoJEBx+YmzsjxAgRgkQAKmYcLlDgE1NhZSr/kjgITl7
5L23N2oxDiZOtJi0vRhBzbQALG3eohY6ifWqYhnvbiOQvS3ZePDlg3YOkXMeIJTH
8c6hpZ9XFlk0/UcPD3fg8zdZV0s+xRnIwafRCXf+vLv3R76QlZ9lxFLjE1N5r+lk
8xDE637RnriI8RsZbYDfNNb9T+c+o4npEmTpian+uWwWSf5Dx1IUOSp6crF3YkoW
K/slePhbnW85ww0PwvJl2V7HWXGQqLO+5QDPwtbtoV7Kd8Ucwfi/SFTyznr/IJYR
bYM1HCExB94tVSEMC0RpLACEfGK4F/dFLsRIoB6vvNgEe1FKPrqXnLXZCxEb2tsd
8i3lF1bnXcs4J3dGJ7dFnDDHisoOLq/my7H65/UbLR8GXVEZrwUSbKVgWX5BhxAf
IwJXykHEoN/kiwRy/samx4/xWV6lwO7ZwWH0w3q4h4QdyD7xYo0A7UmuyA3TAGVF
m4AwrbVxirXspqvGiy/CCfJvb58S/iX80a2+1+IHEgYqyKPMtsL4VHhdSfr4K0D1
1ObZPO1dNHY1JyMmdtHVzFhZfh8KmDPVT9t+A+tghsquJn48xkC98K5nOYBmoIA9
eeXPL1dtEJpaj7E/YnVvshKxxF6UHc28A30g1JPK789RexvhBS3Fge0uwykXz5oF
XpBPCIX3YwV8DGmheiLB
=Kp9q
-----END PGP SIGNATURE-----

--jtEtYGE75hrP1CgP--
