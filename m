Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaEUL3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:29:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52305 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaEUL3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:29:20 -0400
Message-ID: <537C8E00.404@pengutronix.de>
Date: Wed, 21 May 2014 13:29:04 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, wg@grandegger.com,
        michal.simek@xilinx.com, grant.likely@linaro.org, robh+dt@kernel.org
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v8 2/2] can: xilinx CAN controller support.
References: <30fc07d6-4404-4745-8c03-1c5ae775e4f1@BY2FFO11FD047.protection.gbl>
In-Reply-To: <30fc07d6-4404-4745-8c03-1c5ae775e4f1@BY2FFO11FD047.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="XbqnbFrXuRAFJqHPfdWwNjKMWxKu6HM4J"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XbqnbFrXuRAFJqHPfdWwNjKMWxKu6HM4J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/21/2014 09:00 AM, Kedareswara rao Appana wrote:
> This patch adds xilinx CAN controller support.
> This driver supports both ZYNQ CANPS and Soft IP
> AXI CAN controller.
>=20
> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>

Looks good, do you already have an Ack for the DT-bindings?

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--XbqnbFrXuRAFJqHPfdWwNjKMWxKu6HM4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlN8jgAACgkQjTAFq1RaXHMDvgCgkOiAReRprBnoYURD+77SMiol
j8sAnjndVK/u7hAG5cVAFjyYQ36M+cK7
=Dm2h
-----END PGP SIGNATURE-----

--XbqnbFrXuRAFJqHPfdWwNjKMWxKu6HM4J--
