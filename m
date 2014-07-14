Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaGNMO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:14:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56366 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbaGNMOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:14:41 -0400
Message-ID: <53C39052.7040400@pengutronix.de>
Date: Mon, 14 Jul 2014 10:09:54 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, shawn.guo@freescale.com
CC: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] ARM: vf610: add FlexCAN support
References: <cover.1405322992.git.stefan@agner.ch>
In-Reply-To: <cover.1405322992.git.stefan@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Q58wVAQl8kOQJqEpSQh4Qw0UaTlVQO0cl"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q58wVAQl8kOQJqEpSQh4Qw0UaTlVQO0cl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/14/2014 09:48 AM, Stefan Agner wrote:
> This series adds support for Vybrid (aka vf610) to the FlexCAN
> controller and extends the device tree accordingly.
>=20
> Changes in v2:
> - Split out patch (seperate dt, clocks and driver changes)
> - Use spaces for hardware feature flags table
> - Remove drive-by change of esdhc register length
> - Added related fix which enables clock in berr_counter
>=20
> Stefan Agner (4):
>   ARM: dts: vf610: add FlexCAN node
>   ARM: imx: clk-vf610: fix FlexCAN clock gating
>   can: flexcan: switch on clocks before accessing ecr register
>   can: flexcan: add vf610 support for FlexCAN
>=20
>  arch/arm/boot/dts/vf610.dtsi  | 23 +++++++++++
>  arch/arm/mach-imx/clk-vf610.c |  6 ++-
>  drivers/net/can/flexcan.c     | 89 +++++++++++++++++++++++++++++++++++=
+++-----
>  3 files changed, 106 insertions(+), 12 deletions(-)

Shawn, what's the best way to upstream this? With your Ack, I can take
everything via linux-can-next.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--Q58wVAQl8kOQJqEpSQh4Qw0UaTlVQO0cl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPDkFIACgkQjTAFq1RaXHOcdQCbBXloG3KL7l7b9IZj1dNjm3nr
XGYAnRu6IIyC3DQcwMv8eD/AmHeNmgE9
=Zyob
-----END PGP SIGNATURE-----

--Q58wVAQl8kOQJqEpSQh4Qw0UaTlVQO0cl--
