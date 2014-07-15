Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaGONzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:55:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56511 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaGONzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:55:07 -0400
Message-ID: <53C532B0.9020507@pengutronix.de>
Date: Tue, 15 Jul 2014 15:54:56 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, shawn.guo@freescale.com
CC: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] ARM: vf610: add FlexCAN support
References: <cover.1405428166.git.stefan@agner.ch>
In-Reply-To: <cover.1405428166.git.stefan@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3p3Aj7lESUqiFctGN3jndIjNFIEodj6uG"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3p3Aj7lESUqiFctGN3jndIjNFIEodj6uG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/15/2014 02:56 PM, Stefan Agner wrote:
> This series adds support for Vybrid (aka vf610) to the FlexCAN
> controller and extends the device tree accordingly.
>=20
> Changes in v3:
> - Return error number in flexcan_get_berr_counter if clock enabling fai=
ls
> - Add the FLEXCANX_EN clocks as new clocks
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
>  arch/arm/boot/dts/vf610.dtsi            | 23 +++++++++
>  arch/arm/mach-imx/clk-vf610.c           |  6 ++-
>  drivers/net/can/flexcan.c               | 91 +++++++++++++++++++++++++=
++++----
>  include/dt-bindings/clock/vf610-clock.h |  4 +-
>  4 files changed, 110 insertions(+), 14 deletions(-)

I'm taking patch 3+4 via the linux-can-next tree.

Thanks,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--3p3Aj7lESUqiFctGN3jndIjNFIEodj6uG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPFMrEACgkQjTAFq1RaXHMzGwCeMJbd8RVaR6nkWCs4T2d0P7Id
RSEAn3YG7KRtbavEevjfLNdSrIqEKyf9
=zGa4
-----END PGP SIGNATURE-----

--3p3Aj7lESUqiFctGN3jndIjNFIEodj6uG--
